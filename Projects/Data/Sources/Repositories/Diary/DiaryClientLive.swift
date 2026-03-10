import ComposableArchitecture
import Core
import Domain
import Foundation

// MARK: - JSON 기반 Mock 로더 (Bundle - 읽기 전용)
private func loadMockResponse<T: Decodable>(fileName: String, type: T.Type) throws -> APIResponse<T> {
  guard let url = Bundle.module.url(forResource: fileName, withExtension: "json", subdirectory: "Mock") else {
    throw APIError.invalidURL
  }
  let data = try Data(contentsOf: url)
  let decoder = JSONDecoder()
  decoder.dateDecodingStrategy = .iso8601
  return try decoder.decode(APIResponse<T>.self, from: data)
}

// MARK: - Documents 디렉토리 기반 Mutable Mock (읽기/쓰기)
private let documentsDirectory: URL = FileManager.default
  .urls(for: .documentDirectory, in: .userDomainMask)[0]

/// Documents에 파일이 없으면 Bundle에서 복사한 뒤 URL 반환
private func mutableMockURL(fileName: String) throws -> URL {
  let dest = documentsDirectory.appendingPathComponent("\(fileName).json")
  if !FileManager.default.fileExists(atPath: dest.path) {
    guard let src = Bundle.module.url(forResource: fileName, withExtension: "json", subdirectory: "Mock") else {
      throw APIError.invalidURL
    }
    try FileManager.default.copyItem(at: src, to: dest)
  }
  return dest
}

private func loadMutableMockResponse<T: Decodable>(fileName: String, type: T.Type) throws -> APIResponse<T> {
  let url = try mutableMockURL(fileName: fileName)
  let data = try Data(contentsOf: url)
  let decoder = JSONDecoder()
  decoder.dateDecodingStrategy = .iso8601
  return try decoder.decode(APIResponse<T>.self, from: data)
}

private func saveMutableMockResponse<T: Encodable>(_ response: APIResponse<T>, fileName: String) throws {
  let url = try mutableMockURL(fileName: fileName)
  let encoder = JSONEncoder()
  encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
  encoder.dateEncodingStrategy = .iso8601
  let data = try encoder.encode(response)
  try data.write(to: url, options: .atomic)
}

extension DiaryClient: @retroactive DependencyKey {
  public static let liveValue: DiaryClient = {
    return Self(
      createDiary: { date, title, content in
        // 날짜를 "yyyy-MM-dd" 문자열로 변환
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let dateString = formatter.string(from: date)

        // 새 DTO 생성 (id는 UUID 생성)
        let newDTO = DiaryDTO(
          id: UUID().uuidString,
          date: dateString,
          title: title,
          content: content
        )

        // diaries_response.json 에 새 항목 추가
        var listResponse = try loadMutableMockResponse(fileName: "diaries_response", type: [DiaryDTO].self)
        var dtos = listResponse.data ?? []
        dtos.insert(newDTO, at: 0)
        let updatedResponse = APIResponse(data: dtos, code: listResponse.code, message: listResponse.message)
        try saveMutableMockResponse(updatedResponse, fileName: "diaries_response")

        return newDTO.toDomain()
      },
      deleteDiary: { id in
        // Mock: JSON 파일에서 APIResponse<EmptyResponse> 로드
        _ = try loadMockResponse(fileName: "diary_delete_response", type: EmptyResponse.self)
      },
      fetchDiaries: { date in
        // Mock: diaries_response.json (Documents 우선, 없으면 Bundle) 로드
        let response = try loadMutableMockResponse(fileName: "diaries_response", type: [DiaryDTO].self)
        guard let dtos = response.data else {
          throw APIError.invalidData
        }
        return dtos.map { $0.toDomain() }
      },
      updateDiary: { id, date, title, content in
        // Mock: JSON 파일에서 APIResponse<DiaryDTO> 로드
        let response = try loadMockResponse(fileName: "diary_single_response", type: DiaryDTO.self)
        guard let dto = response.data else {
          throw APIError.invalidData
        }
        return dto.toDomain()
      }
    )
  }()
}

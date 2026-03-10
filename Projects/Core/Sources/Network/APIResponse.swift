import Foundation

public struct APIResponse<Data: Codable>: Codable {
  public let data: Data?
  public let code: Int
  public let message: String?
  
  public init(data: Data?, code: Int, message: String?) {
    self.data = data
    self.code = code
    self.message = message
  }
  
  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<APIResponse<Data>.CodingKeys> = try decoder.container(keyedBy: APIResponse<Data>.CodingKeys.self)
    self.data = try container.decodeIfPresent(Data.self, forKey: APIResponse<Data>.CodingKeys.data)
    self.code = try container.decode(Int.self, forKey: APIResponse<Data>.CodingKeys.code)
    self.message = try container.decodeIfPresent(String.self, forKey: APIResponse<Data>.CodingKeys.message)
  }
}

// MARK: - EmptyResponse
public struct EmptyResponse: Codable {}

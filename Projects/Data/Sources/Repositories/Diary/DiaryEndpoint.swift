import Foundation
import Alamofire
import Core

public enum DiaryEndpoint: Endpoint {
  case createDiary(date: Date, title: String, content: String)
  case deleteDiary(id: String)
  case fetchDiaries(date: Date)
  case updateDiary(id: String, date: Date, title: String, content: String)
  
  public var baseURL: String { "https://jsonplaceholder.typicode.com" }
  public var path: String {
    switch self {
    case .createDiary: return "/posts"
    case .deleteDiary(let id): return "/posts/\(id)"
    case .fetchDiaries(let date): return "/posts"
    case .updateDiary(let id, _, _, _): return "/posts/\(id)"
    }
  }
  public var method: HTTPMethod {
    switch self {
    case .createDiary: return .post
    case .deleteDiary: return .delete
    case .fetchDiaries: return .get
    case .updateDiary: return .put
    }
  }
  
  public var headers: [String: String]? {
    return nil
  }
  
  public var parameters: [String: Any]? {
    switch self {
    case .createDiary(let date, let title, let content):
      return [
        "date": date,
        "title": title,
        "content": content
      ]
    case .deleteDiary(let id): return nil
    case .fetchDiaries(let date): return nil
    case .updateDiary(let id, let date, let title, let content):
      return [
        "date": date,
        "title": title,
        "content": content
      ]
    }
  }
}

import Alamofire

public protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
}
extension Endpoint {
    var encoding: ParameterEncoding {
        switch method {
        case .get, .head, .delete:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
}

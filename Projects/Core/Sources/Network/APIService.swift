import Foundation
import Alamofire
import Dependencies

public struct APIService: Sendable {
    public init() {}
    
    public func request<T: Decodable>(_ endpoint: Endpoint, type: T.Type) async throws -> APIResponse<T> {
        let urlString = endpoint.baseURL + endpoint.path
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        var headers: HTTPHeaders?
        if let endpointHeaders = endpoint.headers {
            headers = HTTPHeaders(endpointHeaders)
        }
        
        let dataTask = AF.request(
            url,
            method: endpoint.method,
            parameters: endpoint.parameters,
            encoding: endpoint.encoding,
            headers: headers
        ).serializingDecodable(APIResponse<T>.self)
        
        let response = await dataTask.response
        
        switch response.result {
        case .success(let value):
            return value
        case .failure(let error):
            if let statusCode = response.response?.statusCode {
                switch statusCode {
                case 400, 401, 404, 500:
                    throw APIError.invalidData
                default:
                    throw APIError.invalidResponse
                }
            }
            throw error
        }
    }
}

extension APIService: DependencyKey {
    public static let liveValue = APIService()
}

public extension DependencyValues {
    var apiService: APIService {
        get { self[APIService.self] }
        set { self[APIService.self] = newValue }
    }
}

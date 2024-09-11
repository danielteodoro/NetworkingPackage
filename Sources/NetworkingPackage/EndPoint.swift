import Foundation

public typealias Headers = [String: String]

public typealias RequestBody = [String: Any]

public protocol EndPoint {
    var api: APIEnvironment.Type { get }
    var path: String { get }
    var requestMethod: RequestMethod { get }
    var headers: Headers { get }
    var body: RequestBody? { get }
    var queryParams: [URLQueryItem]? { get }
}

extension EndPoint {
    var headers: Headers {
        [ "Content-Type": "application/json" ]
    }
    
    var url: URL? {
        var url = api.baseURL()?.appendingPathComponent(path)
        
        if let query = queryParams {
            url = url?.appending(queryItems: query)
        }
        
        return url
    }
    
    var body: RequestBody? {
        return nil
    }
}

extension URLRequest {
    mutating func addHeaders(_ headers: Headers) {
        headers.forEach { header, value in
            addValue(value, forHTTPHeaderField: header)
        }
    }
}

import Foundation

let validStatus = 200...299

public protocol HTTPDataDownloader {
    func httpData(for urlRequest: URLRequest) async throws -> Data
}

extension URLSession: HTTPDataDownloader {
    public func httpData(for urlRequest: URLRequest) async throws -> Data {
        let (data, response) = try await self.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.responseError
        }
        switch httpResponse.statusCode {
        case validStatus:
            return data
        default:
            throw NetworkError.statusCode(code: httpResponse.statusCode)
        }
//              validStatus.contains(response.statusCode) else {
//            throw NetworkError
//        }
    }
}

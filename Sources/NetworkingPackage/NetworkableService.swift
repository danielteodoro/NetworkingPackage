import Foundation
import Combine

public protocol Networkable {
    static func sendRequest<T: Decodable>(type: T.Type, endpoint: EndPoint, headers: Headers?) async throws -> T
}

public extension Networkable {
    static func sendRequest<T: Decodable>(type: T.Type, endpoint: EndPoint, headers: Headers? = nil) async throws -> T  {
        guard let requestURL = endpoint.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = endpoint.requestMethod.rawValue
        
        if let headers = headers {
            request.addHeaders(headers)
        }
        
        if let body = endpoint.body {
            if let jsonData = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted) {
                request.httpBody = jsonData
            }
        }
        let downloader: HTTPDataDownloader = URLSession.shared
        let data = try await downloader.httpData(for: request)
        let decoder = JSONDecoder()
        
        return try decoder.decode(T.self, from: data)
        
//        let config = URLSessionConfiguration.default
//        let session = URLSession(configuration: config)
//        session.dataTask(with: request) { (responseData, response, responseError) in
//            if let error = responseError {
//                DispatchQueue.main.async {
//                    resultHandler(.failure(.responseError))
//                }
//            } else if let jsonData = responseData {
//                let decoder = JSONDecoder()
//                
//                do {
//                    let response = try decoder.decode(T.self, from: jsonData)
//                    DispatchQueue.main.async {
//                        resultHandler(.success(response))
//                    }
//                } catch {
//                    DispatchQueue.main.async {
//                        resultHandler(.failure(.decoderError(error: error)))
//                    }
//                }
//            } else {
//                DispatchQueue.main.async {
//                    resultHandler(.failure(.emptyData))
//                }
//            }
//            
//        }.resume()
    }
}

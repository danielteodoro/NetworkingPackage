import Foundation
import Combine

protocol Networkable {
    static func sendRequest<T: Decodable>(endpoint: EndPoint, headers: Headers?, with class: T.Type, resultHandler: @escaping (Result<T, NetworkError>) -> Void)
}

class NetworkableService: Networkable {
    static func sendRequest<T: Decodable>(endpoint: EndPoint, headers: Headers? = nil, with class: T.Type, resultHandler: @escaping (Result<T, NetworkError>) -> Void) {
        guard let requestURL = endpoint.url else {
            resultHandler(.failure(.invalidURL))
            return
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
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        session.dataTask(with: request) { (responseData, response, responseError) in
            if let error = responseError {
                DispatchQueue.main.async {
                    resultHandler(.failure(.responseError(error: error)))
                }
            } else if let jsonData = responseData {
                let decoder = JSONDecoder()
                
                do {
                    let response = try decoder.decode(T.self, from: jsonData)
                    DispatchQueue.main.async {
                        resultHandler(.success(response))
                    }
                } catch {
                    DispatchQueue.main.async {
                        resultHandler(.failure(.decoderError(error: error)))
                    }
                }
            } else {
                DispatchQueue.main.async {
                    resultHandler(.failure(.emptyData))
                }
            }
            
        }.resume()
    }
}

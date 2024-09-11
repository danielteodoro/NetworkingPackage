import Foundation

public protocol APIEnvironment {
    static var baseURLString: String { get }
    
    static func baseURL() -> URL? 
}

public extension APIEnvironment {
    static func baseURL() -> URL? {
        URL(string: Self.baseURLString)
    }
}

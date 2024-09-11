enum NetworkError: Error {
    case invalidURL
    case emptyData
    case decoderError(error: Error)
    case responseError(error: Error)
}

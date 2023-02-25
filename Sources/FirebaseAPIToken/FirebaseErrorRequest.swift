import Foundation

// MARK: - API Error

public enum FirebaseErrorRequest: Error {
    case decodingError(string: String)
    case apiError(string: String)
    case noData
    case badURL
}

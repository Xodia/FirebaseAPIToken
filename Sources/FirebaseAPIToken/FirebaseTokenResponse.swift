import Foundation

public struct FirebaseTokenResponse: Codable {
    public let kind: String
    public let localId: String
    public let email: String
    public let displayName: String
    public let idToken: String
    public let registered: Bool
    public let refreshToken: String
    public let expiresIn: String
}

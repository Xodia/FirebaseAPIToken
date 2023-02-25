import Foundation

extension URL {
    
    public func withAuth(token: String) -> URL? {
        var urlComponents = URLComponents(string: self.absoluteString)
        urlComponents?.queryItems = [
            URLQueryItem(name: "auth", value: token)
        ]
        return urlComponents?.url
    }
}

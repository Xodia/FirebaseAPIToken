import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

// MARK: - Token response

public class FirebaseTokenAPI {
    
    private let apiKey: String
    private let session: URLSession
    private let jsonDecoder = JSONDecoder()
    
    public init(
        apiKey: String,
        session: URLSession = .shared
    ) {
        self.apiKey = apiKey
        self.session = session
    }
    
    public func firebaseEndpointURL(
        apiKey: String,
        email: String,
        password: String,
        returnSecureToken: Bool = true
    ) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.googleapis.com"
        components.path = "/identitytoolkit/v3/relyingparty/verifyPassword"
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "email", value: email),
            URLQueryItem(name: "password", value: password),
            URLQueryItem(name: "returnSecureToken", value: returnSecureToken ? "true" : "false")
        ]
        return components.url
    }
    
    public func fetchFirebaseIdToken(
        email: String,
        password: String,
        completion: ((Result<FirebaseTokenResponse, FirebaseErrorRequest>) -> Void)?
    ) throws {
        guard let url = firebaseEndpointURL(apiKey: apiKey, email: email, password: password) else {
            completion?(.failure(.badURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        session.dataTask(with: request) { [weak self] data, reponse, error in
            guard let self else {
                return
            }
            
            if let error {
                completion?(.failure(.apiError(string: error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion?(.failure(.noData))
                return
            }
            
            do {
                let tokenResponse = try self.jsonDecoder.decode(FirebaseTokenResponse.self, from: data)
                completion?(.success(tokenResponse))
            } catch {
                completion?(.failure(.decodingError(string: error.localizedDescription)))
            }
        }.resume()
    }
    
    @available(macOS 12.0, *)
    public func asyncFetchFirebaseIdToken(
        email: String,
        password: String
    ) async throws -> Result<FirebaseTokenResponse, FirebaseErrorRequest>  {
        guard let url = firebaseEndpointURL(apiKey: apiKey, email: email, password: password) else {
            return .failure(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await session.data(for: request)
            let tokenResponse = try self.jsonDecoder.decode(FirebaseTokenResponse.self, from: data)
            return .success(tokenResponse)
        } catch {
            return .failure(.apiError(string: error.localizedDescription))
        }
    }
}

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

// MARK: - Firebase Realtime database set/get methods
// URL format: https://DATABASE-NAME.firebaseio.com/KEY.json?auth=

public class FirebaseDatabaseAPI {
    
    private let session: URLSession
    
    public init(
        session: URLSession = .shared
    ) {
        self.session = session
    }
    
    public func setJson(
        to url: URL,
        authToken: String,
        body: Data,
        completion: ((Result<Data, FirebaseErrorRequest>) -> Void)?
    ) {
        guard let url = url.withAuth(token: authToken) else {
            completion?(.failure(.badURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = body
        session.dataTask(with: request) { data, reponse, error in
            if let error {
                completion?(.failure(.apiError(string: error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion?(.failure(.noData))
                return
            }

            completion?(.success(data))
        }
        .resume()
    }
    
    public func getJson(
        from url: URL,
        authToken: String,
        completion: ((Result<Data, FirebaseErrorRequest>) -> Void)?
    ) {
        guard let url = url.withAuth(token: authToken) else {
            completion?(.failure(.badURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        session.dataTask(with: request) { data, reponse, error in
            if let error {
                completion?(.failure(.apiError(string: error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion?(.failure(.noData))
                return
            }
            completion?(.success(data))
        }
        .resume()
    }
    
    @available(macOS 12.0, *)
    public func asyncSetJson(
        to url: URL,
        authToken: String,
        body: Data
    ) async -> Result<Data, FirebaseErrorRequest> {
        guard let url = url.withAuth(token: authToken) else {
            return .failure(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = body
        
        do {
            let (data, _) = try await session.data(for: request)
            return .success(data)

        } catch {
            return .failure(.apiError(string: error.localizedDescription))
        }
    }
    
    @available(macOS 12.0, *)
    public func asyncGetJson(
        from url: URL,
        authToken: String
    ) async -> Result<Data, FirebaseErrorRequest> {
        guard let url = url.withAuth(token: authToken) else {
            return .failure(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let (data, _) = try await session.data(for: request)
            return .success(data)

        } catch {
            return .failure(.apiError(string: error.localizedDescription))
        }
    }
}

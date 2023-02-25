# FirebaseAPIToken

FirebaseAPIToken is a Swift package available for iOS / MacOS to help you interact with Firebase API such as Auth and RealTime Database.

This dependency works with Command lines project.

You can add FirebaseAPIToken by adding the https://github.com/Xodia/FirebaseAPIToken repository as a Swift Package.

## FirebaseTokenAPI

Get Firebase auth token via an APP call. Lightweight version of the official Firebase dependency. 

## FirebaseDatabaseAPI

Firebase RealTime Database setter / getter API calls. The auth token passed is the result of what you would get from the FirebaseTokenAPI. (idToken property)

## FirebaseTokenResponse

Data structure of the Firebase Auth API response


## Examples

```
import FirebaseAPIToken
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

let session = URLSession.shared
let tokenAPI = FirebaseTokenAPI(apiKey: "API_KEY", session: session)
let realtimeDatabaseAPI = FirebaseDatabaseAPI(session: session)

do {
    let response = try await tokenAPI.asyncFetchFirebaseIdToken(
        email: "EMAIL",
        password: "PASSWORD"
    )
    switch response {
    case let .success(tokenResponse):
        let getResult = await realtimeDatabaseAPI.asyncGetJson(
            from: URL(string: "https://DATABASE-NAME-default-rtdb.firebaseio.com/KEY.json")!,
            authToken: tokenResponse.idToken
        )
        
        switch getResult {
        case let .success(data):
            let dataString = String(data: data, encoding: .utf8)
            print(dataString)
        case .failure:
            print("Failure")
        }
    case .failure:
        print("Failure")
    }
} catch {
    print(error.localizedDescription)
}
```

## Contributors

Morgan Collino, morgan.collino@gmail.com

## License

FirebaseAPIToken is available under the MIT license. See the LICENSE file for more info.

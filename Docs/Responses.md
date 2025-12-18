## **Data responses**
- Use QuickHatchHTTP to parse your request responses into the standard types
- Handle the response however you want to do it

Remember the Base protocol....
```swift
public protocol NetworkRequestFactory {
        func data(request: URLRequest,
              dispatchQueue: DispatchQueue,
              completionHandler completion: @Sendable @escaping (Result<HTTPResponse, Error>) -> Void) -> DataTask
        func data(request: URLRequest) async throws -> HTTPResponse
}	

```
If we want to handle our login response back as **Data** Type....

```swift
import QuickHatch

class LoginViewPresenter {
    private let networkRequestFactory: NetworkRequestFactory
    private var view: LoginView

    init(requestFactory: NetworkRequestFactory, view: LoginView) {
        self.networkRequestFactory = requestFactory
        self.view = view
    }

    func login(user: String, password: String) {
        let request = URLRequest("getimage.com/user=\(user)&password=\(password)")
        networkRequestFactory.data(request: request) { result in
        switch result {
            case .success(let response):
                // show error messsage
                view.showSuccessMessage(response.data)
            case .failure(let error):
                //show message or nothing
                view.showErrorMessage("Error downloading profile image")
        }
    }
}	
```

```swift
import QuickHatch

class LoginViewPresenter {
    private let networkRequestFactory: NetworkRequestFactory
    private var view: LoginView

    init(requestFactory: NetworkRequestFactory, view: LoginView) {
        self.networkRequestFactory = requestFactory
        self.view = view
    }

    func login(user: String, password: String) {
        let request = URLRequest("getimage.com/user=\(user)&password=\(password)")
        networkRequestFactory.data(request: request) { result in
        switch result {
            case .success(let response):
                // show error messsage
                view.showSuccessMessage(response.data)
            case .failure(let error):
                //show message or nothing
                view.showErrorMessage("Error downloading profile image")
        }
    }
}	
```
This is an alternative for handling the responses, you can also check the Codable Extension to parse the response into a Codable Object of your own

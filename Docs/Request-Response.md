## **Request/Response Pattern**
- QuickHatchHTTP provides an easy way to create a request and fetch the response like Python Requests does
```swift
public protocol HTTPRequest {
    var headers: [String: String] { get }
    var body: Data? { get }
    var url: String { get }
    var method: HTTPMethod { get }
}

public protocol HTTPRequestActionable {
    func response() async throws -> HTTPResponse
    var responsePublisher: any Publisher<HTTPResponse, Error> { get }
}

public protocol HTTPRequestDecodedActionable {
    associatedtype ResponseType: Codable
    func responseDecoded() async throws -> Response<ResponseType>
    var responseDecodedPublisher: any Publisher<ResponseType, Error> { get }
}

public protocol HTTPResponse {
    var statusCode: HTTPStatusCode { get }
    var headers: [AnyHashable: Any] { get }
    var body: Data? { get }
}
```

Now Some samples...


```swift
let getUsersRequest = QHHTTPRequest<DataModel>(url: "quickhatch", method: .get, headers: ["Authorization": "token1234"])
do {
let response = try await getUsers.responseDecoded()
} catch let error as RequestError {
  //do something with error
}
```

Building a request is so easy now!

func getResponse<C, T>(
    to path: String, 
    method: HTTPMethod = .GET, 
    headers: HTTPHeaders = .init(), 
    data: C? = nil, 
    decodeTo type: T.Type
    ) throws -> T where C: Content, T: Decodable {
    
    let response = try self.sendRequest(to: path, method: method, headers: headers, body: data)
    return try response.content.decode(type).wait()
}

func getResponse<T>(
    to path: String, 
    method: HTTPMethod = .GET, 
    headers: HTTPHeaders = .init(), 
    decodeTo type: T.Type
    ) throws -> T where T: Content {
    
    let emptyContent: EmptyContent? = nil
    return try self.getResponse(to: path, method: method, headers: headers, data: emptyContent, decodeTo: type)
}


///////////////////////////////////////////////////////////////////

func sendRequest<T>(
    to path: String, 
    method: HTTPMethod, 
    headers: HTTPHeaders = .init(), 
    body: T? = nil, 
    ) throws -> Response where T: Content {
    var headers = headers

    let responder = try self.make(Responder.self)
    let request = HTTPRequest(method: method, url: URL(string: path)!, headers: headers)
    let wrappedRequest = Request(http: request, using: self)
    if let body = body {
        try wrappedRequest.content.encode(body)
    }
    return try responder.respond(to: wrappedRequest).wait()
}

func sendRequest(
    to path: String, 
    method: HTTPMethod, 
    headers: HTTPHeaders = .init(), 
    // body: T? = nil <-- no body
    loggedInRequest: Bool = false, 
    loggedInUser: User? = nil
    ) throws -> Response {
    let emptyContent: EmptyContent? = nil
    return try sendRequest(
        to: path, 
        method: method, 
        headers: headers, 
        body: emptyContent, 
        loggedInRequest: 
        loggedInRequest, 
        loggedInUser: loggedInUser
    )
}

/// ignores response
func sendRequest<T>(
    to path: String, 
    method: HTTPMethod, 
    headers: HTTPHeaders, 
    data: T, 
    loggedInRequest: Bool = false, 
    loggedInUser: User? = nil
    ) throws where T: Content {
        
    _ = try self.sendRequest(…)
}

/////////////////////////////////////////////////////////////////////

final class AcronymTests : XCTestCase {
    
    let acronymsURI = "/api/acronyms/"
    let acronymShort = "OMG"
    let acronymLong = "Oh My God"
    
    var app: Application!
    var conn: SQLiteConnection!

final class CategoryTests : XCTestCase {
    
    let categoriesURI = "/api/categories/"
    let categoryName = "Teenager"
    
    var app: Application!
    var conn: SQLiteConnection!
    
final class UserTests : XCTestCase {
    
    let usersURI = "/api/users/"
    let usersName = "Alice"
    let usersUsername = "alicea"
    
    var app: Application!
    var conn: SQLiteConnection!
    
/////////////////////////////////////////////////////////////////////

app.getResponse(
//  to: "\(acronymsURI)?term=OMG"
//  to: "\(acronymsURI)\(acronym.id!)"
    to: acronymsURI,
    decodeTo: [Acronym].self
)

app.getResponse(
    to: acronymsURI, 
    method: .POST, 
    headers: ["Content-Type": "application/json"], 
    data: acronym, 
    decodeTo: Acronym.self, 
    loggedInRequest: true
)

app.sendRequest(
    to: "\(acronymsURI)\(acronym.id!)", 
//  method: .POST,
    method: .DELETE, 
    loggedInRequest: true
)

app.sendRequest(
    to: "\(acronymsURI)\(acronym.id!)", 
    method: .PUT, 
    headers: ["Content-Type": "application/json"], 
    data: updatedAcronym, 
    loggedInUser: newUser
)
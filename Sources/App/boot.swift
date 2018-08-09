import Vapor

/// boot is called after `app: Application` initializion and before `app.run()`.
public func boot(_ app: Application) throws {
    // your code here
    
    //// :EXAMPLE: use of `Client` during boot
    //let client = try app.make(Client.self)
    //// OK to `.wait()` since NOT inside a route closure
    //let response: Response = try client.get("http://vapor.codes").wait()
    //print("Boot http://vapor.codes response:\n\(response)") // Response from vapor.codes
}

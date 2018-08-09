import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    /// GET /hello "Hello, world!" example
    router.get("hello") { 
        (request: Request) -> String in
        return "Hello, world!"
    }
    
    /// GET /hellojson
    router.get("hellojson") { 
        (request: Request) throws -> String in
        let dictionary: Dictionary = ["hello":"world"]
        let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        guard let jsonStr = String(data: jsonData, encoding: String.Encoding.utf8) else {
            return "error creating json"
        }
        return jsonStr
    }
    
    /// GET /info returns a description of the request
    router.get("info") { 
        (request: Request) in
        return request.description
    }
    
    // Configure controllers
    let helloController = LeafWebController()
    try router.register(collection: helloController)
    
    let postController = TextpostApiController()
    try router.register(collection: postController)
}

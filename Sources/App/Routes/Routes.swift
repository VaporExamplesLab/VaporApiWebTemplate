import Vapor

extension Droplet {
    func setupRoutes() throws {
        // extension Droplet: RouteBuilder
        // RouteBuilder.get(segments: String … ) { 
        //    (Request) -> ResponseRepresentable in
        self.get("hello_api") { (req: Request) in
            var json = JSON()
            try json.set("hello", "world")
            return json
        }
        
        self.get("plaintext_api") { (req: Request) in
            return "Hello, world!"
        }
        
        // response to requests to /info_api domain
        // with a description of the request
        self.get("info_api") { (req: Request) in
            return req.description
        }
        
        self.get("description_api") { (req: Request) in return req.description }
        
        // extension Droplet: RouteBuilder
        try self.resource("posts_api", PostController.self)
        
        // setup web routes collection
        let routes = Routes(view)
        try self.collection(routes)
        
    }
}

final class Routes: RouteCollection {
    let view: ViewRenderer
    init(_ view: ViewRenderer) {
        self.view = view
    }
    
    func build(_ builder: RouteBuilder) throws {
        /// GET /
        builder.get { req in
            return try self.view.make("welcome_web")
        }
        
        /// GET /hello_web/...
        builder.resource("hello_web", HelloController(view))
        
        // response to requests to /info domain
        // with a description of the request
        builder.get("info_web") { req in
            return req.description
        }
        
    }
}


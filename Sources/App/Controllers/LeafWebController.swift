import Leaf
import Vapor

/// LeafWebController provides an WEB controller
/// with some basic `leaf` templates.
struct LeafWebController: RouteCollection {
    func boot(router: Router) throws {
        
        // GET /
        router.get { 
            (request: Request) -> Response in
            return request.redirect(to: "/index.html")
        }
        
        // GET /leaf --> /leaf/hello
        router.get("leaf") { 
            (request: Request) -> Response in
            return request.redirect(to: "/leaf/hello")
        }
        
        // GET /leaf/bootstrap
        router.get("leaf", "bootstrap", use: bootstrapExampleHandler)
        
        /// GET /leaf/hello
        router.get("leaf", "hello") {
            (request: Request) -> Future<View> in
            var context = [String: String]()
            context["keyWindowTitle"] = "Hello, …"
            context["keyName"] = ".. hmm. Have we meet before?"
            return try request.view().render("web_hello", context)
        }
        
        /// GET /leaf/hello/:string
        router.get("leaf", "hello", String.parameter) {
            (request: Request) -> Future<View> in
            var context = [String: String]()
            var name = try request.parameters.next(String.self)
            if let s = name.removingPercentEncoding {
                name = s
            }
            context["keyWindowTitle"] = "Howdy, \(name)!"
            context["keyName"] = name
            return try request.view().render("web_hello", context)
        }
        
        // GET /leaf/info response contains a description of the request
        router.get("leaf", "info") { 
            (request: Request) -> String in
            return request.description
        }
    }

    /// GET / returns the welcome page
    func bootstrapExampleHandler(_ request: Request) throws -> Future<View> {
        // setup data for Leaf `#windowtitle` placeholder
        var wildlife = [Wildlife]()
        wildlife.append(Wildlife(name: "Guppie", species: "fish"))
        wildlife.append(Wildlife(name: "Joey", species: "kangaroo"))
        wildlife.append(Wildlife(name: "Ruff-Ruff", species: "dog"))
        let leafContext = IndexContext(
            keyWindowTitle: "Welcome Traveler",
            keyEpochTime: Date().timeIntervalSinceReferenceDate, // now
            keyIntArray: [22, 88, 99],
            keyStrArray: ["element one", "element two", "Elementary my dear Watson."],
            keyWildlifeArray: wildlife
        )
        return try request.view().render("bootstrap_welcome", leafContext)
    }
}

// Leaf Data Holder
// `Encodable` is sufficient for one-way send to leaf page
// A struct provides more type safety than a generic [String: String] dictionary.
struct IndexContext: Encodable {
    let keyWindowTitle: String // Leaf `#(keyWindowTitle)`
    let keyEpochTime: Double   
    let keyIntArray: [Int]
    let keyStrArray: [String]
    let keyWildlifeArray: [Wildlife]
}

struct Wildlife: Codable {
    let name: String
    let species: String
}


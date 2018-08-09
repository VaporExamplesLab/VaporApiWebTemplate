import FluentSQLite
import Vapor

/// TextpostApiController provides an API controller
/// with some basic RESTful pattern examples.
///
/// TextpostApiController interactions with the `Textpost` SQLite table.
struct TextpostApiController: RouteCollection {
    
    func boot(router: Router) throws {

        let textpostsRoutes = router.grouped("api", "textposts")
        
        // POST CREATE ONE /api/textposts create database entry for valid JSON `Textpost`
        textpostsRoutes.post(Textpost.self, use: createHandler)
        
        // GET READ ALL /api/textposts returns array of all available `Textpost`
        textpostsRoutes.get(use: readAllHandler)
        
        // GET READ ONE /api/textposts/uuid returns one specific `Textpost`
        textpostsRoutes.get(Textpost.parameter, use: readOneHandler)
        
        // PUT UPDATE or CREATE /api/textposts
        // PUT requests that the enclosed entity be stored under the supplied URI. 
        // If the URI refers to an already existing resource, it is modified; 
        // If the URI does not point to an existing resource, 
        // then the server can create the resource with that URI.
        textpostsRoutes.put(Textpost.self, at: "", use: updateOrCreateHandler)
        
        // PATCH "PARTIAL" UPDATE /api/textposts/uuid partial modifications to specific `Textpost`
        textpostsRoutes.patch(Textpost.self, at: Textpost.parameter, use: updateOneHandler)        
        
        // DELETE ONE /api/textposts/uuid removes a specific `Textpost`
        textpostsRoutes.delete(Textpost.parameter, use: deleteOneHandler)
        
        // DELETE ALL /api/textposts removes ENTIRE table of `Textpost`
        textpostsRoutes.delete(use: deleteAllHandler)
        
    }
    
    /// POST CREATE ONE /api/textposts create database entry for valid JSON `Textpost`
    func createHandler(_ request: Request, textpost: Textpost) throws -> Future<Textpost> {
        return textpost.create(on: request) // -> ResponseEncodable
    }
    
    /// GET READ ALL /api/textposts returns array of all available `Textpost` db entries
    func readAllHandler(_ request: Request) throws -> Future<[Textpost]> {
        let futurePostArray: Future<[Textpost]> = Textpost.query(on: request).all() 
        return futurePostArray
    }
    
    /// GET READ ONE /api/textposts/uuid returns one specific `Textpost`
    func readOneHandler(_ request: Request) throws -> Future<Textpost> { 
        return try request.parameters.next(Textpost.self)
    }
    
    /// PUT UPDATE or CREATE /api/textposts
    func updateOrCreateHandler(_ request: Request, textpost: Textpost) throws -> Future<HTTPStatus> {
        if let textpostId = textpost.id {
            // alternately, .filter(\Textpost.id, SQLiteBinaryOperator.equal, textpostId)
            let textpostQuery = Textpost.query(on: request).filter(\Textpost.id == textpostId)
            let futureTextpost: Future<Textpost?> = textpostQuery.first()
            return futureTextpost.flatMap { 
                (textpostOptional: Textpost?) -> Future<HTTPStatus> in
                if let textpostExisting = textpostOptional {
                    let updatedTextpostFuture: Future<Textpost> = textpostExisting.update(on: request)
                    return updatedTextpostFuture.map { 
                        (textpost: Textpost) -> HTTPStatus in
                        return HTTPStatus.ok
                    }
                }
                else {
                    let newTextpostFuture: Future<Textpost> = textpost.create(on: request)
                    return newTextpostFuture.map { 
                        (textpost: Textpost) -> HTTPStatus in
                        return HTTPStatus.created
                    }
                }
            }
        }
        else { // if id is nil then create a new instance in databae
            let newTextpostFuture: Future<Textpost> = textpost.create(on: request)
            return newTextpostFuture.map { 
                (textpost: Textpost) -> HTTPStatus in
                return HTTPStatus.created
            }
        }
    }
    
    /// PATCH "PARTIAL" UPDATE /api/textposts/uuid partial modifications to specific `Textpost`
    func updateOneHandler(_ request: Request, body: Textpost) throws -> Future<Textpost> {
        let textpost: Future<Textpost> = try request.parameters.next(Textpost.self)
        return textpost.map(to: Textpost.self, { 
            (textpost: Textpost) in
            var textpost = textpost
            // "partial" update has only 1 field to consider
            textpost.content = body.content
            return textpost
        }).update(on: request)
    }
    
    /// DELETE ONE /api/textposts/uuid removes a specific `Textpost`
    func deleteOneHandler(_ request: Request) throws -> Future<HTTPStatus> {
        return try request.parameters.next(Textpost.self).delete(on: request).transform(to: HTTPStatus.noContent)
    }
    
    /// DELETE ALL /api/textposts removes ENTIRE table of `Textpost`
    func deleteAllHandler(_ request: Request) throws -> Future<HTTPStatus> {
        return Textpost.query(on: request).delete().transform(to: HTTPStatus.ok)
    }
    
}


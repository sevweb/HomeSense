import Crypto
import Vapor
import FluentSQLite

/// Creates new users and logs them in.
final class UserController {
    /// Logs a user in, returning a token for accessing protected endpoints.
    func renderRegister(_ req: Request) throws -> Future<View> {
      return try req.view().render("register",["name": "Leaf"])
    }
    
    func renderLogin(_ req: Request) throws -> Future<View> {
       return try req.view().render("login")
    }
    
    func renderProfile(_ req: Request) throws -> Future<View> {
      let user = try req.requireAuthenticated(User.self)
      return try req.view().render("profile", ["user": user])
    }
    func basicLogin(_ req: Request) throws -> Future<UserToken> {
        // get user auth'd by basic auth middleware
        let user = try req.requireAuthenticated(User.self)
        
        // create new token for this user
        let token = try UserToken.create(userID: user.requireID())
        
        // save and return token
        return token.save(on: req)
    }
    
    func login(_ req: Request) throws -> Future<Response> {
      return try req.content.decode(User.self).flatMap { user in
        return User.authenticate(
          username: user.email,
          password: user.passwordHash,
          using: BCryptDigest(),
          on: req
        ).map { user in
          guard let user = user else {
            return req.redirect(to: "/login")
          }
          try req.authenticateSession(user)
          return req.redirect(to: "/profile")
        }
      }
    }
    /// Creates a new user. //
    func create(_ req: Request) throws -> Future<Response> {
        // decode request content
        return try req.content.decode(CreateUserRequest.self).flatMap { user -> Future<User> in
            // verify that passwords match
            guard user.password == user.verifyPassword else {
                throw Abort(.badRequest, reason: "Password and verification must match.")
            }
            
            // hash user's password using BCrypt
            let hash = try BCrypt.hash(user.password)
            // save new user
            return User(id: nil, name: user.name, email: user.email, passwordHash: hash)
                .save(on: req)
        }.map {  _ in
                 return req.redirect(to: "/login")
            
//            user in
//            return try UserResponse(id: user.requireID(), name: user.name, email: user.email)
        }
    }
}

// MARK: Content

/// Data required to create a user.
struct CreateUserRequest: Content {
    /// User's full name.
    var name: String
    
    /// User's email address.
    var email: String
    
    /// User's desired password.
    var password: String
    
    /// User's password repeated to ensure they typed it correctly.
    var verifyPassword: String
}

/// Public representation of user data.
struct UserResponse: Content {
    /// User's unique identifier.
    /// Not optional since we only return users that exist in the DB.
    var id: UUID
    
    /// User's full name.
    var name: String
    
    /// User's email address.
    var email: String
}

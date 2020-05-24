//
//  HomeController.swift
//  
//
//  Created by Severin Weber on 24.05.20.
//

import Vapor
import FluentSQLite

final class HomeController{
    
    func index(_ req: Request) throws -> Future<[Home]> {
        // fetch auth'd user
        let user = try req.requireAuthenticated(User.self)
        
        // query all todo's belonging to user
        return try Home.query(on: req)
            .filter(\.userID == user.requireID()).all()
    }
    
    func create(_ req: Request) throws -> Future<Home> {
        let user = try req.requireAuthenticated(User.self)
        
        // decode request content
        return try req.content.decode(CreateHomeRequest.self).flatMap { home in
            return try Home(name: home.name,roomCount:home.roomCount, userID: user.requireID())
                .save(on: req)
        }
    }
}
struct CreateHomeRequest: Content {
    var name: String
    var roomCount: Int
}


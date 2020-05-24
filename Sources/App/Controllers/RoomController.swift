//
//  RoomController.swift
//  
//
//  Created by Severin Weber on 24.05.20.
//

import Vapor
import FluentSQLite

final class RoomController {
     
        func index(_ req: Request) throws -> Future<[Room]> {
            // fetch auth'd user
            let user = try req.requireAuthenticated(User.self)
            
            // query all todo's belonging to user
            return try Room.query(on: req)
                .filter(\.userID == user.requireID()).all()
        }
        
        func create(_ req: Request) throws -> Future<Room> {
            let user = try req.requireAuthenticated(User.self)
            
            // decode request content
            return try req.content.decode(CreateRoomRequest.self).flatMap { room in
                return try Room(userID: user.requireID(), roomName: room.roomName, homeID:room.homeID)
                    .save(on: req)
            }
        }
    }
struct CreateRoomRequest: Content {
    var roomName: String
    var homeID: UUID
}

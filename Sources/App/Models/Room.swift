//
//  Room.swift
//  
//
//  Created by Severin Weber on 22.05.20.
//

import Vapor
import FluentSQLite

final class Room: SQLiteUUIDModel {
    typealias Database = SQLiteDatabase
    var id: UUID?
    var userID: User.ID
    var homeID: Home.ID
    var roomName: String
    
    init(id: UUID? = nil, userID:User.ID, roomName:String, homeID:Home.ID){
        self.id = id
        self.userID = userID
        self.roomName = roomName
        self.homeID = homeID
    }
}
extension Room {
    var user: Parent<Room, User> {
        return parent(\.userID)
    }
}
extension Room {
    var home: Parent<Room, Home> {
        return parent(\.homeID)
    }
}
extension Room: Migration {
    static func prepare(on conn: SQLiteConnection) -> Future<Void> {
        return SQLiteDatabase.create(Room.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.roomName)
            builder.field(for: \.userID)
            builder.field(for: \.homeID)
            builder.reference(from: \.userID, to: \User.id)
            builder.reference(from: \.homeID, to: \Home.id)
        }
    }
}
extension Room: Content { }
extension Room: Parameter { }

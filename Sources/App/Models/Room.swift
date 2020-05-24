//
//  Room.swift
//  
//
//  Created by Severin Weber on 22.05.20.
//

import Vapor
import FluentSQLite

final class Room: SQLiteModel {
    typealias Database = SQLiteDatabase
    var id: Int?
    var userID: User.ID
    var roomName: String?
    
    init(id: Int? = nil, userID:User.ID, roomName:String?){
        self.id = id
        self.userID = userID
        self.roomName = roomName
    }
}
extension Room: Migration {
    static func prepare(on conn: SQLiteConnection) -> Future<Void> {
        return SQLiteDatabase.create(Room.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.roomName)
            builder.reference(from: \.userID, to: \User.id)
        }
    }
}
extension Room: Content { }
extension Room: Parameter { }

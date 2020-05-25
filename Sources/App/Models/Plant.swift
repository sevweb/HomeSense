//
//  Plant.swift
//  
//
//  Created by Severin Weber on 23.05.20.
//

import Vapor
import FluentSQLite

final class Plant: SQLiteUUIDModel {
    typealias Database = SQLiteDatabase
    var id: UUID?
    var kind: String
    var roomID: Room.ID
    var userID: User.ID
    
    init(id: UUID? = nil, kind: String, roomID: Room.ID, userID: User.ID) {
        self.id = id
        self.kind = kind
        self.roomID = roomID
        self.userID = userID
    }
}

extension Plant {
    /// Fluent relation to user that owns this todo.
    var user: Parent<Plant, User> {
        return parent(\.userID)
    }
}

extension Plant: Migration {
    static func prepare(on conn: SQLiteConnection) -> Future<Void> {
        return SQLiteDatabase.create(Plant.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.kind)
            builder.field(for: \.userID)
            builder.field(for: \.roomID)
            builder.reference(from: \.userID, to: \User.id)
            builder.reference(from: \.roomID, to:  \User.id)
        }
    }
}
extension Plant: Content { }
extension Plant: Parameter { }

//
//  Home.swift
//  App
//
//  Created by Severin Weber on 22.05.20.
//

import FluentSQLite
import Vapor

final class Home: SQLiteModel {
    typealias Database = SQLiteDatabase
    var id: Int?
    var name: String
    var roomCount: Int
    var userID: User.ID
    
    init(id: Int? = nil, name: String, roomCount:Int, userID:User.ID){
        self.id = id
        self.name = name
        self.roomCount = roomCount
        self.userID = userID
    }
}

extension Home: Migration {
    static func prepare(on conn: SQLiteConnection) -> Future<Void> {
        return SQLiteDatabase.create(Home.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.name)
            builder.field(for: \.roomCount)
            builder.reference(from: \.userID, to: \User.id)
        }
    }
}
extension Home: Content { }
extension Home: Parameter { }

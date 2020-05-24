//
//  Sensor.swift
//  
//
//  Created by Severin Weber on 23.05.20.
//

import Vapor
import FluentSQLite

enum SensorType:Int, Codable {
    typealias Database = SQLiteDatabase
    case temperatur
    case humidity
    case moisture
}

final class Sensor: SQLiteModel {
    var id: Int?
    var userID: User.ID
    var type: SensorType
    
    init(id:Int? = nil, userID:User.ID, type:SensorType = .moisture) {
        self.id = id
        self.userID = userID
        self.type = type
    }
}

extension Sensor: Migration {
    static func prepare(on conn: SQLiteConnection) -> Future<Void> {
        return SQLiteDatabase.create(Sensor.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.type)
            builder.reference(from: \.userID, to: \User.id)
        }
    }
}
extension Sensor: Content { }
extension Sensor: Parameter { }

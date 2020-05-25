//
//  Sensor.swift
//  
//
//  Created by Severin Weber on 23.05.20.
//

import Vapor
import FluentSQLite

enum SensorType:Int, ReflectionDecodable, SQLiteType {
    static func reflectDecoded() throws -> (SensorType, SensorType) {
        return (.moisture, .humidity)
    }
    
    typealias Database = SQLiteDatabase
    case temperatur=1
    case humidity=2
    case moisture=3
}

final class Sensor: SQLiteUUIDModel {
    typealias Database = SQLiteDatabase
    var id: UUID?
    var userID: User.ID
    var plantID: Plant.ID
    var type: SensorType
    
    init(id:UUID? = nil, userID:User.ID, plantID:Plant.ID, type:SensorType) {
        self.id = id
        self.userID = userID
        self.plantID = plantID
        self.type = type
    }
}

extension Sensor {
    var user: Parent<Sensor, User> {
        return parent(\.userID)
    }
}
extension Sensor {
    var room: Parent<Sensor, Plant> {
        return parent(\.plantID)
    }
}

extension Sensor: Migration {
    static func prepare(on conn: SQLiteConnection) -> Future<Void> {
        return SQLiteDatabase.create(Sensor.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.type)
            builder.field(for: \.userID)
            builder.field(for: \.plantID)
            builder.reference(from: \.userID, to: \User.id)
            builder.reference(from: \.plantID, to: \Plant.id)
        }
    }
}
extension Sensor: Content { }
extension Sensor: Parameter { }

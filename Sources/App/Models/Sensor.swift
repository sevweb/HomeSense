//
//  Sensor.swift
//  
//
//  Created by Severin Weber on 23.05.20.
//

import Vapor
import FluentSQLite

enum SensorType:Int,Codable, ReflectionDecodable {
    static func reflectDecoded() throws -> (SensorType, SensorType) {
        return (.moisture, .humidity)
    }
    
    typealias Database = SQLiteDatabase
    case temperatur
    case humidity
    case moisture
}

final class Sensor: SQLiteUUIDModel {
    typealias Database = SQLiteDatabase
    var id: UUID?
    var userID: User.ID
    var roomID: Room.ID
    var type: SensorType
    
    init(id:UUID? = nil, userID:User.ID, roomID:Room.ID, type:SensorType = .moisture) {
        self.id = id
        self.userID = userID
        self.roomID = roomID
        self.type = type
    }
}

extension Sensor {
    var user: Parent<Sensor, User> {
        return parent(\.userID)
    }
}
extension Sensor {
    var room: Parent<Sensor, Room> {
        return parent(\.roomID)
    }
}

extension Sensor: Migration {
    static func prepare(on conn: SQLiteConnection) -> Future<Void> {
        return SQLiteDatabase.create(Sensor.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.type)
            builder.field(for: \.userID)
            builder.field(for: \.roomID)
            builder.reference(from: \.userID, to: \User.id)
            builder.reference(from: \.roomID, to: \Room.id)
        }
    }
}
extension Sensor: Content { }
extension Sensor: Parameter { }

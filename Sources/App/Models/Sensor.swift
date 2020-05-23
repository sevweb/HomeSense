//
//  Sensor.swift
//  
//
//  Created by Severin Weber on 23.05.20.
//

import Vapor
import FluentSQLite



final class Sensor: SQLiteModel {
    
    enum SensorType {
        case temperatur(Int)
        case humidity(Int)
        case moisture(Int)
    }

    var id: Int?
    var userID: User.ID
    var type: SensorType
    
    init(id:Int? = nil, userID:User.ID, type:SensorType = .moisture(0)) {
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

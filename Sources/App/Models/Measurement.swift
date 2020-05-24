//
//  Measurement.swift
//  
//
//  Created by Severin Weber on 24.05.20.
//

import Vapor
import FluentSQLite

final class Measurement: SQLiteUUIDModel {
    typealias Database = SQLiteDatabase
    
    var id: UUID?
    var value: Int
    var sensorID: Sensor.ID
    var userID: User.ID
    
    init(id:UUID? = nil, value:Int, userID:User.ID, sensorID: Sensor.ID){
        self.id = id
        self.value = value
        self.sensorID = sensorID
        self.userID = userID
    }
}
extension Measurement {
    /// Fluent relation to user that owns this todo.
    var user: Parent<Measurement, User> {
        return parent(\.userID)
    }
}
extension Measurement: Migration {
    static func prepare(on conn: SQLiteConnection) -> Future<Void> {
        return SQLiteDatabase.create(Measurement.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.value)
            builder.field(for: \.userID)
            builder.field(for: \.sensorID)
            builder.reference(from: \.sensorID, to: \Sensor.id)
            builder.reference(from: \.userID, to: \User.id)
        }
    }
}

extension Measurement: Content { }

extension Measurement: Parameter { }

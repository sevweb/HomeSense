//
//  Measurement.swift
//  
//
//  Created by Severin Weber on 24.05.20.
//

import Vapor
import FluentSQLite

final class Measurement: SQLiteModel {
    typealias Database = SQLiteDatabase
    
    var id: Int?
    var value: Int
    var sensorID: Sensor.ID
    var userID: User.ID
    
    init(id:Int? = nil, value:Int, userID:User.ID, sensorID: Sensor.ID){
        self.id = id
        self.value = value
        self.sensorID = Sensor.ID
        self.userID = userID
    }
    
}

extension Measurement: Migration {
    static func prepare(on conn: SQLiteConnection) -> Future<Void> {
        return SQLiteDatabase.create(Measurement.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.value)
            builder.field(for: \.userID)
            builder.field(for: \.sensorID)
            builder.reference(from: \.userID, to: \User.id)
        }
    }
}

extension Measurement: Content { }

extension Measurement: Parameter { }

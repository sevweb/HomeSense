//
//  MeasurementController.swift
//  
//
//  Created by Severin Weber on 24.05.20.
//

import Vapor
import FluentSQLite

final class MeasurementController {
    func index(_ req: Request) throws -> Future<[Measurement]> {
        // fetch auth'd user
        let user = try req.requireAuthenticated(User.self)
        
        // query all todo's belonging to user
        return try Measurement.query(on: req)
            .filter(\.userID == user.requireID()).all()
    }
    
    func create(_ req: Request) throws -> Future<Measurement> {
        let user = try req.requireAuthenticated(User.self)
        
        // decode request content
        return try req.content.decode(CreateMeasurementRequest.self).flatMap { measurement in
            return try Measurement(value: measurement.value, userID: user.requireID(), sensorID: measurement.sensorID)
                .save(on: req)
        }
    }
}

struct CreateMeasurementRequest: Content {
    var value: Int
    var sensorID: Sensor.ID
//    var userID: User.ID
}

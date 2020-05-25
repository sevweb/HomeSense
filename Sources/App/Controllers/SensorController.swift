//
//  SensorController.swift
//  
//
//  Created by Severin Weber on 24.05.20.
//

import Vapor
import FluentSQLite

final class SensorController {
     
        func index(_ req: Request) throws -> Future<[Sensor]> {
            // fetch auth'd user
            let user = try req.requireAuthenticated(User.self)
            
            // query all todo's belonging to user
            return try Sensor.query(on: req)
                .filter(\.userID == user.requireID()).all()
        }
        
        func create(_ req: Request) throws -> Future<Sensor> {
            let user = try req.requireAuthenticated(User.self)
            return try req.content.decode(CreateSensorRequest.self).flatMap { sensor in
                return try Sensor(userID: user.requireID(), plantID: sensor.plantID, type: sensor.type)
                    .save(on: req)
            }
        }
    }

struct CreateSensorRequest: Content {
    var plantID: UUID
    var type: SensorType
}

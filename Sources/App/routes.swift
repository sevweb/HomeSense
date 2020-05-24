import Crypto
import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // public routes
    let userController = UserController()
    router.post("users", use: userController.create)
    
    // basic / password auth protected routes
    let basic = router.grouped(User.basicAuthMiddleware(using: BCryptDigest()))
    basic.post("login", use: userController.login)
    
    // bearer / token auth protected routes
    let bearer = router.grouped(User.tokenAuthMiddleware())
    let todoController = TodoController()
    bearer.get("todos", use: todoController.index)
    bearer.post("todos", use: todoController.create)
    bearer.delete("todos", Todo.parameter, use: todoController.delete)
    let homeController = HomeController()
    bearer.get("homes", use: homeController.index)
    bearer.post("homes", use: homeController.create)
    let roomController = RoomController()
    bearer.get("rooms", use: roomController.index)
    bearer.post("rooms", use: roomController.create)
    let sensorController = SensorController()
    bearer.get("sensors", use: sensorController.index)
//    bearer.post("sensors", use: sensorController.create)
}

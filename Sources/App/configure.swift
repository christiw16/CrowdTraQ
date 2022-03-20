import Vapor
// configures your application
public func configure(_ app: Application) throws {
    let wsc = WebSocketController()
    
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.webSocket("connection") { req, ws in
        await wsc.add(ws)
    }
    app.get { req in
        req.view.render("index.html")
    }
}

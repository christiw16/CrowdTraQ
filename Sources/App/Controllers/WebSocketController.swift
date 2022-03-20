//
//  WebSocketController.swift
//
//
//  Created by Will Christiansen on 3/20/22.
//

import Foundation
import Vapor

public class WebSocketController{
    var clients: [UUID: WebSocket] = [:]
    
    public func add(_ ws: WebSocket) async{
        let uuid = UUID()
        clients[uuid] = ws
        try! await ws.send([UInt8](try! JSONEncoder().encode(WSInfo(uuid))))
    }
        
    public func get(_ uuid: UUID) -> WebSocket? {
        return clients[uuid]
    }
    public func remove(_ uuid: UUID) async {
        guard clients[uuid] == nil else{
            try! await clients[uuid]!.close()
            clients[uuid] = nil
            return
        }
    }
    
    deinit {
         _ = clients.values.map { $0.close() }
    }
}

struct WSInfo : Encodable{
    let UserId: UUID
    init(_ uuid: UUID){
        UserId = uuid
    }
}

extension Sequence {
    func asyncMap<T>(
        _ transform: (Element) async throws -> T
    ) async rethrows -> [T] {
        var values = [T]()

        for element in self {
            try await values.append(transform(element))
        }

        return values
    }
}

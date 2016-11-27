//
//  MenuCategory.swift
//  AppServer
//
//  Created by Anton Poltoratskyi on 27.11.16.
//
//

import Foundation
import Vapor

final class MenuCategory: Model {
    
    var id: Node?
    var name: String
    var description: String
    var photoUrl: String?
    
    //Foreign key
    var merchantId: Node
    
    var exists: Bool = false
    
    
    //MARK: - NodeConvertible
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("_id")
        name = try node.extract("name")
        description = try node.extract("description")
        photoUrl = try node.extract("photo_url")
        merchantId = try node.extract("merchant_id")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "_id": id,
            "name": name,
            "description": description,
            "photo_url": photoUrl,
            "merchant_id": merchantId
            ])
    }
}


//MARK: - Preparation
extension MenuCategory {
    
    static func prepare(_ database: Database) throws {
        try database.create("custMenuCategoryomers") { users in
            users.id()
            users.string("name")
            users.string("login")
            users.string("hash")
            users.string("access_token")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("customers")
    }
}

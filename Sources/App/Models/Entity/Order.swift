//
//  Order.swift
//  AppServer
//
//  Created by Anton Poltoratskyi on 27.11.16.
//
//

import Foundation
import Vapor
import Fluent

final class Order: Model {
    
    var id: Node?
    var customerId: Node
    var merchantId: Node
    var createdDate: Int        //Time from 1970
    var availabilityDate: Int   //Time from 1970
    var state: State
    
    var exists: Bool = false
    
    enum State: String {
        case unconfirmed = "unconfirmed"
        case approved = "approved"
        case declined = "declined"
    }
    
    init(customerId: Node, merchantId: Node, createdDate: Int, availabilityDate: Int, state: State = .unconfirmed) {
        self.customerId = customerId
        self.merchantId = merchantId
        self.createdDate = createdDate
        self.availabilityDate = availabilityDate
        self.state = state
    }
    
    
    //MARK: - NodeConvertible
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("_id")
        customerId = try node.extract("customer_id")
        merchantId = try node.extract("merchant_id")
        createdDate = try node.extract("created_date")
        availabilityDate = try node.extract("availability_date")
        state = State(rawValue: try node.extract("state"))!
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "_id": id,
            "customer_id": customerId,
            "merchant_id": merchantId,
            "created_date": createdDate,
            "availability_date": availabilityDate,
            "state": state.rawValue
            ])
    }
}


//MARK: - Preparation
extension Order {
    
    static func prepare(_ database: Database) throws {
        try database.create("orders") { users in
            users.id("_id")
            users.id("customer_id")
            users.id("merchant_id")
            users.int("created_date")
            users.int("availability_date")
            users.string("state")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("orders")
    }
}


//MARK: - DB Relation
extension Order {
    
    func orderItems() -> Children<OrderItem> {
        return children("order_id", OrderItem.self)
    }
}



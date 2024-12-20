//
//  UserModel.swift
//  BankingSystem
//
//  Created by АА on 16.10.24.
//

import Foundation

struct User{
    let _id : String?
    let number: String?
    let name: String
    let password: String
}

struct UserJson: Decodable,Encodable{
    let id : String?
    let number: String?
    let name: String?
    let password: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case password
        case number
    }
}
struct Card: Decodable,Encodable{
    let id: String?
    let number:String?
    let username:String?
    let cardname:String?
    let cvv:String?
    let date:String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case number
        case username
        case cardname
        case cvv
        case date
    }
}
struct CardForBalance: Decodable,Encodable{
    let id: String?
    let number:String?
    let username:String?
    let cardname:String?
    let cvv:String?
    let date:String?
    let balance:Float?
    let key:String?
    let status:String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case number
        case username
        case cardname
        case cvv
        case date
        case balance
        case key
        case status
    }
}

struct AddData:Decodable,Encodable{
    let username:String?
    let amount:Double?
    
    enum CodingKeys:String,CodingKey{
        case username
        case amount
    }
}

struct SendMoney:Decodable,Encodable{
    let username:String?
    let amount:Double?
    let senduserkey:String?
    
    enum CodingKeys:String,CodingKey{
        case username
        case amount
        case senduserkey
    }
}

struct Transaction:Decodable,Encodable{
    let id:String?
    let sendername:String?
    let recipient:String?
    let amount:Double?
    
    enum CodingKeys:String,CodingKey{
        case id = "_id"
        case sendername
        case recipient
        case amount
    }
}

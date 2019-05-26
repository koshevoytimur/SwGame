//
//  Users.swift
//  SwGame
//
//  Created by Тимур Кошевой on 1/4/19.
//  Copyright © 2019 Тимур Кошевой. All rights reserved.
//

import Foundation
import RealmSwift

class Users: Object {
    
    @objc dynamic var userName: String?
    @objc dynamic var email: String?
    @objc dynamic var password: String?
   
}

//@objc dynamic var id: Int64 = 0
//@objc dynamic var userName: String?
//@objc dynamic var email: String?
//@objc dynamic var password: String?
//@objc dynamic var score = TopScores()


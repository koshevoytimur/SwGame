//
//  TopScores.swift
//  SwGame
//
//  Created by Тимур Кошевой on 1/4/19.
//  Copyright © 2019 Тимур Кошевой. All rights reserved.
//

import Foundation
import RealmSwift

class TopScores: Object {
    
    @objc dynamic var userName: String?
    @objc dynamic var score: String?
    
}

//@objc dynamic var userId: Int64 = 0
//@objc dynamic var userName: String?
//@objc dynamic var score: String?
//
//override static func primaryKey() -> String? {
//    return "userId"
//}

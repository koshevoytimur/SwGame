////
////  Ship.swift
////  SwGame
////
////  Created by Faris Sbahi on 6/6/17.
////  Copyright © 2017 Faris Sbahi. All rights reserved.
////
//
//import UIKit
//import SceneKit
//
//// Floating boxes that appear around you
//class Enemy: SCNNode {
//
//    override init() {
//        super.init()
//
//        var node = SCNNode()
//
//        let scene = SCNScene(named: "Art.scnassets/mouthshark.dae")
//        node = (scene?.rootNode.childNode(withName: "shark", recursively: true)!)!
//        node.scale = SCNVector3(0.3,0.3,0.3)
//        node.name = "shark"
//
//        node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
//        node.physicsBody?.isAffectedByGravity = false
//
//        //rotate
//        let action : SCNAction = SCNAction.rotate(by: .pi, around: SCNVector3(0, 1, 0), duration: 1.0)
//        let forever = SCNAction.repeatForever(action)
//        node.runAction(forever)
//
//        //for the collision detection
//        node.physicsBody?.categoryBitMask = CollisionCategory.enemy.rawValue
//        node.physicsBody?.contactTestBitMask = CollisionCategory.bullets.rawValue
//
////        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
////        self.geometry = box
////        let shape = SCNPhysicsShape(geometry: box, options: nil)
////        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
////        self.physicsBody?.isAffectedByGravity = false
////
////        // see http://texnotes.me/post/5/ for details on collisions and bit masks
////        self.physicsBody?.categoryBitMask = CollisionCategory.enemy.rawValue
////        self.physicsBody?.contactTestBitMask = CollisionCategory.bullets.rawValue
////
////        // add texture
////        let material = SCNMaterial()
////        material.diffuse.contents = UIImage(named: "galaxy")
////        self.geometry?.materials  = [material, material, material, material, material, material]
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}

//
//  Enemy.swift
//  SwGame
//
//  Created by Тимур Кошевой on 1/4/19.
//  Copyright © 2019 Тимур Кошевой. All rights reserved.
//

import UIKit
import SceneKit

class Enemy: SCNNode {
    
//    let shape = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
//    let material = SCNMaterial()
//    let texture = UIImage(named: "enemy_texture")
    
    let texture = UIImage(named: "enemy")
    let shape = SCNSphere(radius: 0.05)
    let material = SCNMaterial()
    
    override init() {
        super.init()
    
        self.geometry = shape
        let shape = SCNPhysicsShape(geometry: self.shape, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        self.physicsBody?.isAffectedByGravity = false

        self.physicsBody?.categoryBitMask = CollisionCategory.enemy.rawValue
        self.physicsBody?.contactTestBitMask = CollisionCategory.bullets.rawValue

        // Додавання текстури на об'єкт
        material.diffuse.contents = texture
        self.geometry?.materials  = [material, material, material, material, material, material]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

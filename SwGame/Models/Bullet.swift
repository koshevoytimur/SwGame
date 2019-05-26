//
//  Bullet.swift
//  SwGame
//
//  Created by Тимур Кошевой on 1/4/19.
//  Copyright © 2019 Тимур Кошевой. All rights reserved.
//

import UIKit
import SceneKit

class Bullet: SCNNode {
    
    let texture = UIImage(named: "bullet_texture")
    let sphere = SCNSphere(radius: 0.005)
    let material = SCNMaterial()
    
    override init () {
        super.init()
        
        self.geometry = sphere
        let shape = SCNPhysicsShape(geometry: sphere, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        self.physicsBody?.isAffectedByGravity = false
        
        self.physicsBody?.categoryBitMask = CollisionCategory.bullets.rawValue
        self.physicsBody?.contactTestBitMask = CollisionCategory.enemy.rawValue
        
        // add texture
        material.diffuse.contents = texture
        self.geometry?.materials  = [material]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

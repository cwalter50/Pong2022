//
//  GameScene.swift
//  Pong2022
//
//  Created by Christopher Walter on 5/16/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene
{
    
    // didMove is similar to viewDidLoad
    override func didMove(to view: SKView)
    {
        
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 0
        
        self.physicsBody = borderBody
        
    }
    
}

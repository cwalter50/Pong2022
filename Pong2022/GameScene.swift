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
    
    // this method gets called everytime i touch my screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let location = touches.first!.location(in: self)
        makeNewBall(touchLocation: location)
    }
    
    func makeNewBall(touchLocation: CGPoint)
    {
        var newBall = SKSpriteNode(imageNamed: "walter")
        newBall.size = CGSize(width: 100, height: 100)
        newBall.position = touchLocation
        
        addChild(newBall)
        
        // give the object physics
        newBall.physicsBody = SKPhysicsBody(circleOfRadius: 50)
        
    }
    
}

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
    
    var ball = SKSpriteNode()
    var paddle = SKSpriteNode()
    
    // didMove is similar to viewDidLoad
    override func didMove(to view: SKView)
    {
        
        ball = childNode(withName: "ball") as! SKSpriteNode
        paddle = childNode(withName: "paddle") as! SKSpriteNode
        
        
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 0
        
        
        self.physicsBody = borderBody
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        
        
    }
    
    var isTouchingPaddle = false
    // this method gets called everytime i touch my screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let location = touches.first!.location(in: self)
        if paddle.frame.contains(location) {
            isTouchingPaddle = true
        }
        if isTouchingPaddle == true {
            paddle.position = CGPoint(x: location.x, y: paddle.position.y)
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        if isTouchingPaddle == true {
            paddle.position = CGPoint(x: location.x, y: paddle.position.y)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouchingPaddle = false
    }
    
    func makeNewBall(touchLocation: CGPoint)
    {
        var newBall = SKSpriteNode(imageNamed: "walter")
        newBall.size = CGSize(width: 100, height: 100)
        newBall.position = touchLocation
        
        addChild(newBall)
        
        // give the object physics
        newBall.physicsBody = SKPhysicsBody(circleOfRadius: 50)
        
        newBall.physicsBody?.restitution = 1
        newBall.physicsBody?.allowsRotation = false
        newBall.physicsBody?.affectedByGravity = false
        newBall.physicsBody?.applyImpulse(CGVector(dx: 500, dy: 500))
        
    }
    
}

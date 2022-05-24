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
    var compPaddle = SKSpriteNode()
    
    // didMove is similar to viewDidLoad
    override func didMove(to view: SKView)
    {
        
        ball = childNode(withName: "ball") as! SKSpriteNode
        paddle = childNode(withName: "paddle") as! SKSpriteNode
        createComputerPaddle()
        
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 0
        
        
        self.physicsBody = borderBody
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        
        
    }
    
    
    func createComputerPaddle()
    {
        compPaddle = SKSpriteNode(color: UIColor.systemPurple, size: CGSize(width: 150, height: 50))
        compPaddle.position = CGPoint(x: frame.width/2, y: frame.height*0.9)
        addChild(compPaddle)
        
        // add physics
        compPaddle.physicsBody = SKPhysicsBody(rectangleOf: compPaddle.frame.size)
        compPaddle.physicsBody?.allowsRotation = false
        compPaddle.physicsBody?.friction = 0
        compPaddle.physicsBody?.affectedByGravity = false
        compPaddle.physicsBody?.isDynamic = false
        
        let follow = SKAction.repeatForever(SKAction.sequence([
            SKAction.run(followBall),
            SKAction.wait(forDuration: 0.2)
        ]))
        
        run(follow)
        
    }
    
    func followBall()
    {
        let move = SKAction.moveTo(x: ball.position.x, duration: 0.2)
        compPaddle.run(move)
    }
    
//    override func update(_ currentTime: TimeInterval) {
//        compPaddle.position = CGPoint(x: ball.position.x, y: compPaddle.position.y)
//    }
    
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

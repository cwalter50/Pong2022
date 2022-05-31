//
//  GameScene.swift
//  Pong2022
//
//  Created by Christopher Walter on 5/16/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate
{
    
    var ball = SKSpriteNode()
    var paddle = SKSpriteNode()
    var compPaddle = SKSpriteNode()
    var top = SKSpriteNode()
    var bottom = SKSpriteNode()
    var scoreLabel = SKLabelNode()
    var playerScore = 0
    var computerScore = 0
    
    // didMove is similar to viewDidLoad
    override func didMove(to view: SKView)
    {
        
        ball = childNode(withName: "ball") as! SKSpriteNode
        paddle = childNode(withName: "paddle") as! SKSpriteNode
        createComputerPaddle()
        createTopAndBottom()
        createScoreLabels()
        
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 0
        
        self.physicsBody = borderBody
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.contactDelegate = self
        
        ball.physicsBody?.categoryBitMask = 1
        paddle.physicsBody?.categoryBitMask = 2
        compPaddle.physicsBody?.categoryBitMask = 3
        top.physicsBody?.categoryBitMask = 4
        bottom.physicsBody?.categoryBitMask = 5
        
        ball.physicsBody?.contactTestBitMask = 2 | 3 | 4 | 5
        
    }
    
    
    func createScoreLabels()
    {
        scoreLabel = SKLabelNode(text: "0 - 0")
        scoreLabel.fontName = "Arial"
        scoreLabel.fontSize = 75
        scoreLabel.position = CGPoint(x: frame.width * 0.10, y: frame.height/2)
        scoreLabel.fontColor = UIColor.white
        scoreLabel.zRotation = .pi/2
        
        addChild(scoreLabel)
        
    }
    
    func updateScore()
    {
        scoreLabel.text = "\(playerScore) - \(computerScore)"
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let location = contact.contactPoint
        print(location)
        
        if contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 4
        {
            // ball hit the top
            print("Ball hit top. Player scored!!!")
            resetBall()
            playerScore += 1
            updateScore()
        }
        if contact.bodyA.categoryBitMask == 4 && contact.bodyB.categoryBitMask == 1
        {
            // ball hit the top
            print("Ball hit top. Player scored!!!")
            resetBall()
            playerScore += 1
            updateScore()
        }
        
        if contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 5
        {
            // ball hit the bottom
            print("Ball hit bottom. computer scored!!!")
            resetBall()
            computerScore += 1
            updateScore()
        }
        if contact.bodyA.categoryBitMask == 5 && contact.bodyB.categoryBitMask == 1
        {
            // ball hit the bottom
            print("Ball hit bottom. computer scored!!!")
            resetBall()
            computerScore += 1
            updateScore()
        }
    }
    
    func bringBallToCenter()
    {
        ball.position = CGPoint(x: frame.width/2, y: frame.height/2)
    }
    
    func resetBall()
    {
        // stop ball
        ball.physicsBody?.velocity = .zero
        // pause
        let pause = SKAction.wait(forDuration: 3)
        // move ball
        let move = SKAction.run(bringBallToCenter)
        // pause
        // push ball
        let push = SKAction.run(pushBall)
        let sequence = SKAction.sequence([pause, move, pause, push])
        run(sequence)
    }
    
    func pushBall()
    {
        ball.physicsBody?.applyImpulse(CGVector(dx: 50, dy: 50)) // maybe change these numbers and make them random
    }
    
    func createTopAndBottom()
    {
        top = SKSpriteNode(color: UIColor.red, size: CGSize(width: self.frame.width, height: 10))
        top.position = CGPoint(x: self.frame.width/2, y: self.frame.height*0.98)
        addChild(top)
        top.physicsBody = SKPhysicsBody(rectangleOf: top.frame.size)
        top.physicsBody?.isDynamic = false
        
        bottom = SKSpriteNode(color: UIColor.red, size: CGSize(width: self.frame.width, height: 10))
        bottom.position = CGPoint(x: self.frame.width/2, y: self.frame.height*0.02)
        addChild(bottom)
        bottom.physicsBody = SKPhysicsBody(rectangleOf: bottom.frame.size)
        bottom.physicsBody?.isDynamic = false
        
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

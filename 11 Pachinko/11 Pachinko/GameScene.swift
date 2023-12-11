//
//  GameScene.swift
//  11 Pachinko
//
//  Created by Taha Saleh on 8/20/22.
//

import SpriteKit

class GameScene: SKScene , SKPhysicsContactDelegate
{
    var scoreLabel = SKLabelNode(fontNamed: "chalkduster")
    var score : Int = 0 {
        didSet
        {
            scoreLabel.text = "score = \(score)"
        }
    }
    
    var editLabel = SKLabelNode(fontNamed: "chalkduster")
    var editingMode  = false{
        didSet
        {
            if oldValue == false
            {
                editLabel.text = "done"
            }else
            {
                editLabel.text = "edit"
            }
        }
    }
    let ballColors = ["Red","Cyan","Yellow","Green","Grey","Purple"]
    var ballLimit = 0
    override func didMove(to view: SKView)
    {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 667, y: 400)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel.text = "score = \(score)"
        scoreLabel.fontSize = 25.0
        scoreLabel.position =  CGPoint(x: 950 , y: 750)
        scoreLabel.horizontalAlignmentMode = .right
        addChild(scoreLabel)
        
        editLabel.text = "edit"
        editLabel.fontSize = 25.0
        editLabel.position = CGPoint(x: 80, y: 750)
        editLabel.horizontalAlignmentMode = .right
        addChild(editLabel)
        
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        createBouncerAndSlots()
    }
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{return}
        let location = touch.location(in: self)
        
        let objects = nodes(at: location)
        if objects.contains(editLabel)
        {
            editingMode.toggle()
        }
        else if editingMode
        {
            let size = CGSize(width: Int.random(in: 16...128), height: 16)
            let obstacleNode = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0.0...1.0), green: CGFloat.random(in: 0.0...1.0), blue: CGFloat.random(in: 0.0...1.0), alpha: 1), size: size)
            obstacleNode.zRotation = .random(in: 0.0...9.0)
            obstacleNode.position = location
            obstacleNode.physicsBody = SKPhysicsBody(rectangleOf: size)
            obstacleNode.physicsBody?.isDynamic = false
            obstacleNode.name = "obstacle"
            addChild(obstacleNode)
        }
        else
        {
            
            if location.y > 600 && location.y < 700 && ballLimit < 5
            {
                guard let color = ballColors.shuffled().first else {return}
                let ball = SKSpriteNode(imageNamed: "ball\(color)")
                ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
                ball.physicsBody?.restitution = 0.5
                ball.position = location
                ball.name = "ball"
                addChild(ball)
                ballLimit += 1
            }
           
        }
        
        
        
    }
    
    func createBouncerAndSlots()
    {
        var xValue : CGFloat = 0
        var slotXVAlue :CGFloat = 135
        let increment : CGFloat = 270
        var isGood = true
        for n in 0..<5
        {
            if n < 4
            {
                makeSlots(at: slotXVAlue, isGood: isGood)
            }
            makeBouncers(at: xValue)
           
            xValue += increment
            slotXVAlue += increment
            isGood.toggle()
        }
    }
    
    func makeBouncers(at XPoint:CGFloat)
    {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = CGPoint(x: XPoint, y: 0)
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width/2)
        bouncer.physicsBody?.isDynamic = false
       
        addChild(bouncer)
    }
    
    func makeSlots(at xValue:CGFloat,isGood:Bool)
    {
        var slot : SKSpriteNode
        var slotGlow : SKSpriteNode
        if isGood
        {
            slot = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slot.name = "good"
            
        }else
        {
            slot = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slot.name = "bad"
        }
        
        slot.position = CGPoint(x: xValue, y: 0)
        slotGlow.position = CGPoint(x: xValue, y: 0)
        
        slot.physicsBody = SKPhysicsBody(rectangleOf: slot.size)
        slot.physicsBody?.isDynamic = false
        slot.physicsBody?.contactTestBitMask = slot.physicsBody?.collisionBitMask ?? 0
        
        addChild(slot)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let repeatedSpin = SKAction.repeatForever(spin)
        slotGlow.run(repeatedSpin)
    }
   
    func destroy(ball:SKNode)
    {
        if let fire = SKEmitterNode(fileNamed: "FireParticles")
        {
            
            fire.position = ball.position
            addChild(fire)
        }
        ball.removeFromParent()
    }
    
    func collision(between ball:SKNode, and object:SKNode)
    {
        if object.name == "good" 
        {
            destroy(ball: ball)
            score += 1
            ballLimit -= 1
        }else if object.name == "bad"
        {
            destroy(ball: ball)
            score -= 1
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else{return}
        guard let nodeB = contact.bodyB.node else{return}
        if nodeA.name == "ball"
        {
            
            collision(between: nodeA, and: nodeB)
        }
        else if nodeB.name == "ball"
        {
          
            collision(between:nodeB, and: nodeA)
        }
    }
}

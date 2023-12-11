//
//  GameScene.swift
//  26 Marble Maze
//
//  Created by Taha Saleh on 1/5/23.
//
import CoreMotion
import SpriteKit

enum CollisionTypes:UInt32
{
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case finish = 16
}

class GameScene: SKScene, SKPhysicsContactDelegate
{
 
    var player : SKSpriteNode!
    var motionManager = CMMotionManager()
    var scoreLabel = SKLabelNode()
    var score = 0 {
        didSet
        {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var isGameOver = false
    override func didMove(to view: SKView)
    {
        let background = SKSpriteNode(imageNamed: "background")
        background.zPosition = -1
        background.position = .init(x: 540, y: 405)
        background.blendMode = .replace
        addChild(background)
        
        scoreLabel.position = .init(x: 1040, y: 760)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.text = "Score: \(score)"
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        motionManager.startAccelerometerUpdates()
        // start collecting tilt information
        
        loadLevel()
        createPlayer()
    }
  
    func loadLevel()
    {
        if let url = Bundle.main.url(forResource: "level1", withExtension: "txt")
        {
            if let string = try? String(contentsOf: url)
            {
                let lines = string.components(separatedBy: "\n")
                for (row, line) in lines.reversed().enumerated()
                {
                    for(col, letter) in line.enumerated()
                    {
                        let position = CGPoint(x: (col * 64) + 32 , y: (row * 64) + 32)
                        
                        if letter == "x"
                        {
                            let wall = SKSpriteNode(imageNamed: "block")
                            wall.position = position
                            wall.physicsBody = SKPhysicsBody(rectangleOf: wall.size)
                            wall.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
                            wall.physicsBody?.isDynamic = false
                            addChild(wall)
                        }
                        else if letter == "v"
                        {
                            let vortex = SKSpriteNode(imageNamed: "vortex")
                            vortex.name = "vortex"
                            vortex.position = position
                            vortex.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi * 2, duration: 1)))
                            vortex.physicsBody = .init(circleOfRadius: vortex.size.width/2)
                            vortex.physicsBody?.isDynamic = false
                            vortex.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
                            vortex.physicsBody?.collisionBitMask = 0
                            //bounce off nothing
                            vortex.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
                            // notify when a player come in contact
                            addChild(vortex)
                        }
                        else if letter == "s"
                        {
                            let star = SKSpriteNode(imageNamed: "star")
                            star.position = position
                            star.name = "star"
                            star.physicsBody = .init(circleOfRadius: star.size.width/2)
                            star.physicsBody?.isDynamic = false
                            
                            star.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
                            star.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
                            star.physicsBody?.collisionBitMask = 0
                            addChild(star)
                        }
                        else if letter == "f"
                        {
                            let finish = SKSpriteNode(imageNamed: "finish")
                            finish.position = position
                            finish.name = "finish"
                            finish.physicsBody = .init(circleOfRadius: finish.size.width/2)
                            finish.physicsBody?.isDynamic = false
                            
                            finish.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
                            finish.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
                            finish.physicsBody?.collisionBitMask = 0
                            addChild(finish)
                        }
                        else if letter == " "
                        {
                            // space
                        }
                        else
                        {
                            fatalError("unknown level letter \(letter)")
                        }
                    }
                }
            }else
            {
                fatalError("unable to decode file")
            }
            
        }else
        {
            fatalError("can't find the file")
        }
    }
    
    func createPlayer()
    {
        player = SKSpriteNode(imageNamed: "player")
        player.position = .init(x: 100, y: 690)
        player.physicsBody = .init(circleOfRadius: player.size.width/2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue |
        CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue
      
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        player.zPosition = 1
       
        
        addChild(player)
        
    }
    override func update(_ currentTime: TimeInterval)
    {
        guard isGameOver == false else {return}
        #if targetEnvironment(simulator)
        print("we are in a simulator")
        #else
        if let accelerometerData = motionManager.accelerometerData
        {
           
            physicsWorld.gravity = .init(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
           
            
        }
        #endif
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        guard let nodeA = contact.bodyA.node else {return}
        guard let nodeB = contact.bodyB.node else {return}
        
        if nodeA == player
        {
            playerCollided(with: nodeB)
        }
        else if nodeB == player
        {
            playerCollided(with: nodeA)
        }
    }
    
    func playerCollided(with node:SKNode)
    {
        if node.name == "vortex"
        {
            player.physicsBody?.isDynamic = false
            isGameOver = true
            score -= 1
            let move = SKAction.move(to: node.position, duration: 1.00)
            let scale = SKAction.scale(by: 0.01, duration: 1.00)
            let remove = SKAction.removeFromParent()
            let seq  = SKAction.sequence([move,scale,remove])
            player.run(seq, completion: { [weak self] in
                self?.createPlayer()
                
                self?.isGameOver = false
            })
        }
        else if node.name == "star"
        {
            node.removeFromParent()
            score += 1
            
        }else if node.name == "finish"
        {
            isGameOver = true
        }
        
    }
}



/*
 we get the data of Accelerometers in  update method. but there is a complication if
 we using a simulator. we need to write two codes one for the simulator and one
 for a device and we need to add a compiler driective so when we are in simulator
 xcode won't even see the code for the device and same thing when we are in the
 device.
 
 
 */

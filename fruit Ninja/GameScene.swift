//
//  GameScene.swift
//  23 Ninja
//
//  Created by Taha Saleh on 12/29/22.
//

import SpriteKit
import AVFoundation

enum ForceBomb
{
    case never,always,random
}
enum SequenceType : CaseIterable
{
    case oneNoBomb, one, twoWithOneBomb, two,three, four, chain, fastChain
}

class GameScene: SKScene
{
    var gameScore : SKLabelNode!
    var score = 0 {
        didSet
        {
            gameScore.text = "score: \(score)"
        }
    }
    var livesImages = [SKSpriteNode]()
    var lives = 3.0
    
    let activeSliceBackground = SKShapeNode()
    let activeSliceForeground = SKShapeNode()
    
    var activeSlicePoints = [CGPoint]()
    
    var activeEnemies = [SKSpriteNode]()
    
    var isSwooshSoundActive = false
    
    var bombSoundEffect : AVAudioPlayer?
    
    var popTime = 0.9
    var sequence = [SequenceType]()
    var sequencePosition = 0
    var chainDelay = 3.0
    var nextSequneceQueued = true
    
    var isGameOVer = false
    override func didMove(to view: SKView)
    {
        super.didMove(to: view)
        
        let background  = SKSpriteNode(imageNamed: "sliceBackground")
        background.position = .init(x: 540, y: 405)
        background.zPosition = -1
        background.blendMode = .replace
        addChild(background)
        
        physicsWorld.gravity = .init(dx: 0, dy: -6)
       
        physicsWorld.speed = 0.85
       
        
        createScore()
        createLife()
        createSlices()
        
        sequence = [.oneNoBomb, .oneNoBomb,.twoWithOneBomb, .twoWithOneBomb, .three,.one,.chain]

        for _ in 0...1000
        {
            if let nextSequence = SequenceType.allCases.randomElement(){
                sequence.append(nextSequence)
            }
        }

        tossEnemies()
    }
    
    func createScore()
    {
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        gameScore.position = .init(x: 20, y: 20)
        score = 0
        addChild(gameScore)
        
        
    }
    func createLife()
    {
        for i in 0..<3
        {
            let lifeX = SKSpriteNode(imageNamed: "sliceLife")
            lifeX.position = .init(x: 800 + (i * 70), y: 720)
            addChild(lifeX)
            livesImages.append(lifeX)
        }
    }
    func createSlices()
    {
        activeSliceBackground.zPosition = 2
        activeSliceForeground.zPosition = 3
        
        activeSliceBackground.strokeColor = UIColor(red: 1, green: 0.9, blue: 0, alpha: 1.0)
        activeSliceBackground.lineWidth = 9
        activeSliceForeground.strokeColor = .white
        activeSliceForeground.lineWidth = 5
        
        addChild(activeSliceForeground)
        addChild(activeSliceBackground)
        
        
    }
    
    func redrawActiveSlice()
    {

        
        if activeSlicePoints.count > 12
        {
            activeSlicePoints.removeFirst(activeSlicePoints.count - 12)

        }
        
        let path = UIBezierPath()
        path.move(to: activeSlicePoints[0])
        
        for i in 1..<activeSlicePoints.count
        {
            path.addLine(to: activeSlicePoints[i])
        }
        
        activeSliceBackground.path = path.cgPath
        activeSliceForeground.path = path.cgPath
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let touch = touches.first else {return}
        activeSlicePoints.removeAll(keepingCapacity: true)
        let location = touch.location(in: self)
        activeSlicePoints.append(location)
        activeSliceBackground.path = nil
        activeSliceForeground.path = nil
        redrawActiveSlice()
        
        activeSliceForeground.removeAllActions()
        activeSliceBackground.removeAllActions()
        
        activeSliceBackground.alpha = 1
        activeSliceForeground.alpha = 1
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard  isGameOVer == false else {return}
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        activeSlicePoints.append(location)
        redrawActiveSlice()
        
        
        if !isSwooshSoundActive
        {
            playSwooshSound()
        }
        
        // how to slice the enemies
        let nodesAtPoint = nodes(at: location)
        
        for case let node as SKSpriteNode in nodesAtPoint
        {
            
            if node.name == "enemy"
            {
               
                if let emitter = SKEmitterNode(fileNamed: "sliceHitEnemy")
                {
                    emitter.position = node.position
                    addChild(emitter)
                }
                //original code has animation
                score += 1
                if let index = activeEnemies.firstIndex(of: node)
                {
                    activeEnemies.remove(at: index)
                }
                node.removeFromParent()
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            
            }else if node.name == "bombContainer"
            {
     
                if let emitter = SKEmitterNode(fileNamed: "sliceHitBomb")
                {
                    emitter.position = node.position
                    addChild(emitter)
                }
                
                // original code has animation
                
                if let index = activeEnemies.firstIndex(of: node)
                {
                    activeEnemies.remove(at: index)
                }
                node.removeFromParent()
                run(SKAction.playSoundFileNamed("explosion.caf", waitForCompletion: false))
                endGame(triggeredByBomb: true)
            }
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        activeSliceBackground.run(SKAction.fadeOut(withDuration: 0.25))
        activeSliceForeground.run(SKAction.fadeOut(withDuration: 0.25))
    }
    func endGame(triggeredByBomb: Bool)
    {
        guard  isGameOVer == false else {return}
        physicsWorld.speed = 1
        isUserInteractionEnabled = false
        bombSoundEffect?.stop()
        bombSoundEffect = nil
        
        if triggeredByBomb
        {
            livesImages[0].texture = SKTexture(imageNamed: "sliceLifeGone")
            livesImages[1].texture = SKTexture(imageNamed: "sliceLifeGone")
            livesImages[2].texture = SKTexture(imageNamed: "sliceLifeGone")
        }
        nextSequneceQueued = true
    }
    
     
    
    
    func playSwooshSound()
    {
        
        isSwooshSoundActive = true
        
        let randomNumber = Int.random(in: 1...3)
        let soundName = "swoosh\(randomNumber).caf"
        
        let swooshSound = SKAction.playSoundFileNamed(soundName, waitForCompletion: true)
        run(swooshSound){[weak self] in

            self?.isSwooshSoundActive = false
        }
    }
    func substractLife()
    {
        lives -= 1
        run(SKAction.playSoundFileNamed("wrong.caf", waitForCompletion: false))
        let life  : SKSpriteNode
        if lives == 2
        {
            life = livesImages[0]
        }else if lives == 1
        {
            life = livesImages[1]
        }else
        {
            life = livesImages[2]
            endGame(triggeredByBomb: false)
        }
        
        life.texture = SKTexture(imageNamed: "sliceLifeGone")
        life.xScale = 1.3
        life.yScale = 1.3
        life.run(SKAction.scale(to: 1, duration: 0.1))
        
    }
    
    override func update(_ currentTime: TimeInterval) {
          
            if !activeEnemies.isEmpty
            {
                
                for (index,node) in activeEnemies.enumerated().reversed()
                {
                    if node.position.y < -140
                    {
                        node.removeAllActions()
                        if node.name == "enemy"
                        {
                            node.name = ""
                            node.removeFromParent()
                            activeEnemies.remove(at: index)
                            substractLife()
                        }else if node.name == "bombContainer"
                        {
                            node.name = ""
                            node.removeFromParent()
                            activeEnemies.remove(at: index)
                            bombSoundEffect?.stop()
                            bombSoundEffect = nil
                            
                        }
                    }
                }
            }else{
                
                if !nextSequneceQueued{
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + popTime){
                        [weak self] in
                        self?.tossEnemies()
                        
                    }
                    nextSequneceQueued = true
                }
            }
        
    }
    func createEnemey(forcedBomb: ForceBomb = .random)
    {
        let enemy : SKSpriteNode
        
        
        var enemyType = Int.random(in: 0...1)
        
        if forcedBomb == .never
        {
            enemyType = 1
        }
        else if forcedBomb == .always{
            enemyType = 0
        }
        
        if enemyType == 0
        {
            enemy = SKSpriteNode()
            enemy.zPosition = 1
            enemy.name = "bombContainer"
            let bombImage = SKSpriteNode(imageNamed: "sliceBomb")
            bombImage.name = "bomb"
            enemy.addChild(bombImage)

            if let path = Bundle.main.url(forResource: "sliceBombFuse", withExtension: "caf")
            {
                if let sound = try? AVAudioPlayer(contentsOf: path)
                {
                    bombSoundEffect = sound
                    sound.play()
                }
                
            }
            
            if let emitter = SKEmitterNode(fileNamed: "sliceFuse")
            {
                emitter.position = .init(x: 76, y: 64)
                enemy.addChild(emitter)
            }
        }
        else
        {
            enemy = SKSpriteNode(imageNamed: "penguin")
            run(SKAction.playSoundFileNamed("launch.caf", waitForCompletion: false))
            enemy.name = "enemy"
        }
        let randomPosition = CGPoint(x: Int.random(in: 64...960), y: -128)
        enemy.position = randomPosition
        
        let randomAngularVelocity = CGFloat.random(in: -3...3)
        let randomXVelocity : Int
        
        if randomPosition.x < 256
        {
            randomXVelocity = Int.random(in: 8...15)
        }
        else if randomPosition.x < 512
        {
            randomXVelocity = Int.random(in: 3...5)
        }
        else if randomPosition.x < 768
        {
            randomXVelocity = -Int.random(in: 3...5)
        }
        else
        {
            randomXVelocity = -Int.random(in: 8...15)
        }
        
        let randomYVelocity = Int.random(in: 24...32)
        
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: 64)
        enemy.physicsBody?.velocity = CGVector(dx:randomXVelocity * 40, dy: randomYVelocity * 40)
        
        enemy.physicsBody?.angularVelocity = randomAngularVelocity
        enemy.physicsBody?.collisionBitMask = 0
        
        addChild(enemy)
        activeEnemies.append(enemy)
        
    }
    func tossEnemies()
    {
        guard  isGameOVer == false else {return}
        popTime *= 0.991
        chainDelay *= 0.99
        physicsWorld.speed *= 1.02
        
        let sequenceType = sequence[sequencePosition]
        
        switch sequenceType
        {
        case .oneNoBomb:
            createEnemey(forcedBomb: .never)
            
        case .one:
            createEnemey()
            
        case .twoWithOneBomb:
            createEnemey(forcedBomb: .never)
            createEnemey(forcedBomb: .always)
            
        case .two:
            createEnemey()
            createEnemey()
            
        case .three:
            createEnemey()
            createEnemey()
            createEnemey()
            
        case .four:
            createEnemey()
            createEnemey()
            createEnemey()
            createEnemey()
            
        case .chain:
            createEnemey()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0))
            {
                [weak self] in
                self?.createEnemey()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0  * 2))
            {
                [weak self] in
                self?.createEnemey()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 3))
            {
                [weak self] in
                self?.createEnemey()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 4))
            {
                [weak self] in
                self?.createEnemey()
            }
            
        case .fastChain:
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0))
            {
                [weak self] in
                self?.createEnemey()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0  * 2))
            {
                [weak self] in
                self?.createEnemey()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 3))
            {
                [weak self] in
                self?.createEnemey()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 4))
            {
                [weak self] in
                self?.createEnemey()
            }
           
        }
        
        sequencePosition += 1
        nextSequneceQueued = false
    }
}

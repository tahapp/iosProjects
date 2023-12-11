//
//  GameScene.swift
//  14 Penguin
//
//  Created by Taha Saleh on 9/16/22.
//

import SpriteKit

class GameScene: SKScene
{
    var slots = [WhackSlot]()
    var gameScore : SKLabelNode!
    
    var popupTime : Double = 0.85
    var gameLimit = 0
    var score: Int = 0
    {
        didSet
        {
            gameScore.text = "score = \(score)"
        }
    }
    override func didMove(to view: SKView)
    {
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.size = CGSize(width: 1080, height: 810)
        background.position = CGPoint(x: 540, y: 405)
        background.zPosition = -1
        background.blendMode = .replace
        addChild(background)
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "score = \(score)"
        gameScore.fontSize = 43.0
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .left
        addChild(gameScore)
        
        
        for i in 0..<5{createSlot(at: CGPoint(x: 100 + (i * 170), y: 410))}
        for i in 0..<4{createSlot(at: CGPoint(x: 180 + (i * 170), y: 330))}
        for i in 0..<5{createSlot(at: CGPoint(x: 100 + (i * 170), y: 240))}
        for i in 0..<4{createSlot(at: CGPoint(x: 180 + (i * 170), y: 150))}
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            [weak self] in
            self?.createEnemy()
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{return}
        let location = touch.location(in: self)
        let nodes = nodes(at: location)
        
        for node in nodes
        {
            guard let whackSlot = node.parent?.parent as? WhackSlot else{return}
            
            if !whackSlot.isVisible{continue}
            if whackSlot.isHit{continue}
            
            whackSlot.hit()
            
            if node.name == "charGood"
            {
                score -= 3
                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
            }
            if node.name == "charBad"
            {
                score += 1
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
                node.xScale = 0.85
                node.yScale = 0.85
            }
        }
    }
    
    func createSlot(at position:CGPoint)
    {
        let slot = WhackSlot()
        slot.configure(at: position)
        slots.append(slot)
        addChild(slot)
    }
    
    func createEnemy()
    {
        gameLimit += 1
        
        if gameLimit == 100
        {
            for slot in slots {
                slot.hide()
                
            }
            
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 400, y: 300)
            gameOver.zPosition = 1
            addChild(gameOver)
            return
        }
        popupTime *= 0.991
        
        slots.shuffle()
        
        //slots[0].show(hideTime: popupTime)
        
        if Int.random(in: 0...12) > 3{slots[1].show(hideTime: popupTime)}
        if Int.random(in: 0...12) > 6{slots[2].show(hideTime: popupTime)}
        if Int.random(in: 0...12) > 9{slots[3].show(hideTime: popupTime)}
        if Int.random(in: 0...12) > 11{slots[4].show(hideTime: popupTime)}
        
        let minimumDelay = popupTime / 2.0
        let maximumDelay = popupTime * 2.0
        let delay = Double.random(in: minimumDelay...maximumDelay)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay){
            [weak self] in
            self?.createEnemy()
        }
    }
}

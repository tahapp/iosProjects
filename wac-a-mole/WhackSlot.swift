//
//  WhackSlot.swift
//  14 Penguin
//
//  Created by Taha Saleh on 9/26/22.
//

import SpriteKit

class WhackSlot : SKNode
{
    var charNode : SKSpriteNode!
    
    var isVisible = false
    var isHit = false
    
    func configure(at position:CGPoint)
    {
        self.position = position
        
        let hole = SKSpriteNode(imageNamed: "whackHole")
        
       
        addChild(hole)
        
        
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = .init(x: 0, y: -90)
        charNode.name = "character"
        
        let cropNode = SKCropNode()
        cropNode.position = .init(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        cropNode.addChild(charNode)
      
        
        addChild(cropNode)
    }
    
    func show(hideTime:Double)
    {
        if isVisible{return}
        
        charNode.xScale = 1.0
        charNode.yScale = 1.0
        
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        
        isVisible = true
        isHit = false
        
        if Int.random(in: 0...2) == 0
        {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charGood"
        }else
        {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charBad"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)){
            [weak self] in
            self?.hide()
        }
        
    }
    
    func hide()
    {
        if !isVisible{return}
        
        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        isVisible = false
    }
    
    func hit()
    {
        isHit = true
        let wait = SKAction.wait(forDuration: 0.25)
        let move = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let noVisible = SKAction.run {
            [weak self] in
            self?.isVisible = false
        }
        
        let sequenceOfActions = SKAction.sequence([wait,move,noVisible])
        charNode.run(sequenceOfActions)
    }
}

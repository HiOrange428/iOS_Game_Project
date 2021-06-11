//
//  GameUI.swift
//  pj
//
//  Created by mac13 on 2021/6/11.
//  Copyright © 2021 mac11. All rights reserved.
//

import Foundation
import SpriteKit

class GameUI {
    let sheet = Asset()
    let toRender: GameScene
    let player: Player
    let healthPointMaxValue: CGFloat
    var healthPoint: CGFloat
    let healthBarFrame = SKSpriteNode()
    let healthBarRemaining = SKShapeNode()
    
    init(forScene scene: SKScene, forPlayer player: Player){
        self.toRender = scene as! GameScene
        self.player = player
        self.healthPointMaxValue = player.healthPointMaxValue
        self.healthPoint = player.healthPoint
        healthBarRendering()
    }
    
    func healthBarRendering(){
        let width = (self.toRender.frame.maxX-self.toRender.frame.minX)/3
        let height = CGFloat(50.0)
        self.healthBarFrame.texture = self.sheet.UI_healthBarFrame()
        //self.healthBarFrame.anchorPoint = CGPoint(x: 1, y:0)
        self.healthBarFrame.size = CGSize(width: width+16, height: height)
        self.healthBarFrame.name = "healthBarFrame"
        self.healthBarFrame.position = CGPoint(x: self.toRender.frame.minX + 22 + (width/2), y: self.toRender.frame.maxY - 15)
        //self.healthBarFrame.position = CGPoint(x: self.toRender.frame.midX, y: self.toRender.frame.midY)
        self.healthBarRemaining.path = CGPath(rect: CGRect(x: 0, y: CGFloat(-10), width: width, height: 10), transform: nil)
        self.healthBarRemaining.strokeColor = UIColor.clear
        self.healthBarRemaining.fillColor = UIColor.systemGreen
        self.healthBarRemaining.name = "healthBarRemaining"
        self.healthBarRemaining.position = CGPoint(x: self.toRender.frame.minX + 21, y: self.toRender.frame.maxY - 10)
        self.healthBarRemaining.zPosition = 20
        self.healthBarFrame.zPosition = 20
        self.toRender.addChild(healthBarFrame)
        self.toRender.addChild(healthBarRemaining)
    }
    func healthBarChanging(newHP: CGFloat){
        if (newHP > 0) {
            let width = (self.toRender.frame.maxX-self.toRender.frame.minX)/3
            let height = CGFloat(10.0)
            self.healthBarRemaining.path = CGPath(rect: CGRect(x: 0, y: CGFloat(-height), width: width * (newHP / healthPointMaxValue), height: height), transform: nil)
            self.healthPoint = newHP
        } else {
            healthBarRemaining.isHidden = true
        }
    }
}

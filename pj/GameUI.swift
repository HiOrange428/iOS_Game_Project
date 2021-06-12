//
//  GameUI.swift
//  pj
//
//  Created by mac13 on 2021/6/11.
//  Copyright © 2021 mac11. All rights reserved.
//

import Foundation
import SpriteKit

enum SkillType {
    case Sprint
    case Lighting
    case Healing
    case Buff
}

class GameUI {
    let sheet = Asset()
    let toRender: GameScene
    let player: Player
    let healthPointMaxValue: CGFloat
    var healthPoint: CGFloat
    let healthBarFrame = SKSpriteNode()
    let healthBarRemaining = SKShapeNode()
    let skill_Sprint_icon: FTButtonNode
    let skill_Healing_icon: FTButtonNode
    let skill_Buff_icon: FTButtonNode
    init(forScene scene: SKScene, forPlayer player: Player){
        self.toRender = scene as! GameScene
        self.player = player
        self.healthPointMaxValue = player.healthPointMaxValue
        self.healthPoint = player.healthPoint
        self.skill_Sprint_icon = FTButtonNode(normalTexture: self.sheet.UI_skillIcon_sprint(), selectedTexture: self.sheet.UI_skillIcon_sprint(), disabledTexture: self.sheet.UI_skillIcon_sprint_CD())
        self.skill_Healing_icon = FTButtonNode(normalTexture: self.sheet.UI_skillIcon_healing(), selectedTexture: sheet.UI_skillIcon_healing(), disabledTexture: self.sheet.UI_skillIcon_healing_CD())
        self.skill_Buff_icon = FTButtonNode(normalTexture: self.sheet.UI_skillIcon_atkBuff(), selectedTexture: sheet.UI_skillIcon_atkBuff(), disabledTexture: self.sheet.UI_skillIcon_atkBuff_CD())
        skillSetup()
        healthBarRendering()
        
    }
    
    func skillSetup() {
        self.skill_Sprint_icon.position = CGPoint(x: self.toRender.frame.maxX - 60,y: self.toRender.frame.minY + 60)
        self.skill_Sprint_icon.zPosition = 20
        self.skill_Sprint_icon.size = CGSize(width: 54, height: 54)
        self.skill_Sprint_icon.name = "Sprint_icon"
        self.skill_Sprint_icon.setButtonAction(target: self.toRender, triggerEvent: .TouchUpInside, action: #selector(self.toRender.c_shadowSprint))
        
        self.skill_Healing_icon.position = CGPoint(x: self.toRender.frame.maxX - 130,y: self.toRender.frame.minY + 60)
        self.skill_Healing_icon.zPosition = 20
        self.skill_Healing_icon.size = CGSize(width: 54, height: 54)
        self.skill_Healing_icon.name = "Healing_icon"
        self.skill_Healing_icon.setButtonAction(target: self.toRender, triggerEvent: .TouchUpInside, action: #selector(self.toRender.c_healing))
        
        self.skill_Buff_icon.position = CGPoint(x: self.toRender.frame.maxX - 200,y: self.toRender.frame.minY + 60)
        self.skill_Buff_icon.zPosition = 20
        self.skill_Buff_icon.size = CGSize(width: 54, height: 54)
        self.skill_Buff_icon.name = "Buff_icon"
        self.skill_Buff_icon.setButtonAction(target: self.toRender, triggerEvent: .TouchUpInside, action: #selector(self.toRender.c_buff))
        
        self.toRender.addChild(skill_Sprint_icon)
        self.toRender.addChild(skill_Healing_icon)
        self.toRender.addChild(skill_Buff_icon)
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
    func disableSkill(type: SkillType){
        switch type {
        case .Sprint:
            self.skill_Sprint_icon.isEnabled = false
            Timer.scheduledTimer(timeInterval: 1.8, target: self, selector: #selector(self.enableSkill_Sprint), userInfo: nil, repeats: false)
        case .Healing:
            self.skill_Healing_icon.isEnabled = false
            Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.enableSkill_Healing), userInfo: nil, repeats: false)
        case .Buff:
            self.skill_Buff_icon.isEnabled = false
            Timer.scheduledTimer(timeInterval: 45, target: self, selector: #selector(self.enableSkill_Buff), userInfo: nil, repeats: false)
        default:
            break
        }
    }
    @objc func enableSkill_Sprint(){
        self.skill_Sprint_icon.isEnabled = true
    }
    @objc func enableSkill_Healing(){
        self.skill_Healing_icon.isEnabled = true
    }
    @objc func enableSkill_Buff(){
        self.skill_Buff_icon.isEnabled = true
    }
}

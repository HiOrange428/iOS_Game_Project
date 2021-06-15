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
    let healthBarRemaining = SKSpriteNode()
    let skill_Sprint_icon: FTButtonNode
    let skill_Healing_icon: FTButtonNode
    let skill_Buff_icon: FTButtonNode
    let ctrl_pause: FTButtonNode
    let ctrl_unpause: FTButtonNode
    let ctrl_story: FTButtonNode
    let storyBlank = SKShapeNode()
    let storyLabel = SKLabelNode()
    let speakerLabel = SKLabelNode()
    let story = Story()
    
    init(forScene scene: SKScene, forPlayer player: Player){
        self.toRender = scene as! GameScene
        self.player = player
        self.healthPointMaxValue = player.healthPointMaxValue
        self.healthPoint = player.healthPoint
        self.skill_Sprint_icon = FTButtonNode(normalTexture: self.sheet.UI_skillIcon_sprint(), selectedTexture: self.sheet.UI_skillIcon_sprint(), disabledTexture: self.sheet.UI_skillIcon_sprint_CD())
        self.skill_Healing_icon = FTButtonNode(normalTexture: self.sheet.UI_skillIcon_healing(), selectedTexture: sheet.UI_skillIcon_healing(), disabledTexture: self.sheet.UI_skillIcon_healing_CD())
        self.skill_Buff_icon = FTButtonNode(normalTexture: self.sheet.UI_skillIcon_atkBuff(), selectedTexture: sheet.UI_skillIcon_atkBuff(), disabledTexture: self.sheet.UI_skillIcon_atkBuff_CD())
        self.ctrl_pause = FTButtonNode(normalTexture: self.sheet.UI_btn_ctrl_pause_default(), selectedTexture: self.sheet.UI_btn_ctrl_pause_selected(), disabledTexture: nil)
        self.ctrl_unpause = FTButtonNode(normalTexture: self.sheet.UI_btn_ctrl_play_default(), selectedTexture: self.sheet.UI_btn_ctrl_play_selected(), disabledTexture: nil)
        self.ctrl_story = FTButtonNode(normalTexture: self.sheet.UI_btn_default(), selectedTexture: self.sheet.UI_btn_selected(), disabledTexture: nil)
        btnSetup()
        healthBarRendering()
        storySetup()
    }
    
    func btnSetup() {
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
        
        self.ctrl_pause.position = CGPoint(x: self.toRender.frame.midX,y: self.toRender.frame.maxY - 20)
        self.ctrl_pause.zPosition = 20
        self.ctrl_pause.size = CGSize(width: ((self.ctrl_pause.texture?.size().width)!)*0.3, height: ((self.ctrl_pause.texture?.size().height)!)*0.3)
        self.ctrl_pause.name = "ctrl_pause"
        self.ctrl_pause.setButtonAction(target: self.toRender, triggerEvent: .TouchUp, action: #selector(self.toRender.c_pause))
        
        self.ctrl_unpause.position = CGPoint(x: self.toRender.frame.midX,y: self.toRender.frame.midY)
        self.ctrl_unpause.zPosition = 26
        self.ctrl_unpause.size = CGSize(width: ((self.ctrl_unpause.texture?.size().width)!), height: ((self.ctrl_unpause.texture?.size().height)!))
        self.ctrl_unpause.name = "ctrl_unpause"
        self.ctrl_unpause.setButtonAction(target: self.toRender, triggerEvent: .TouchUp, action: #selector(self.toRender.c_unpause))
        self.ctrl_unpause.isHidden = true
        
        self.toRender.addChild(skill_Sprint_icon)
        self.toRender.addChild(skill_Healing_icon)
        self.toRender.addChild(skill_Buff_icon)
        self.toRender.addChild(ctrl_pause)
        self.toRender.addChild(ctrl_unpause)
    }
    
    func healthBarRendering() {
        let postion = CGPoint(x: self.toRender.frame.minX + 22 , y: self.toRender.frame.maxY - 15)
        self.healthBarFrame.texture = self.sheet.UI_healthBarFrame()
        self.healthBarFrame.size = CGSize(width: (healthBarFrame.texture?.size().width)!, height: (healthBarFrame.texture?.size().height)!)
        self.healthBarFrame.name = "healthBarFrame"
        self.healthBarFrame.anchorPoint = CGPoint(x: (3/136), y: 0.5)
        self.healthBarFrame.position = postion
       
        self.healthBarRemaining.texture = self.sheet.UI_healthBarRemaining()
        self.healthBarRemaining.size = CGSize(width: (healthBarRemaining.texture?.size().width)!, height: (healthBarRemaining.texture?.size().height)!)
        self.healthBarRemaining.anchorPoint = CGPoint(x: 0, y: 0.5)
        self.healthBarRemaining.name = "healthBarRemaining"
        self.healthBarRemaining.position = postion
        self.healthBarRemaining.zPosition = 20
        self.healthBarFrame.zPosition = 20
        self.healthBarRemaining.color = UIColor.green
        self.healthBarRemaining.run(SKAction.colorize(with: UIColor.green, colorBlendFactor: 1, duration: 0.1))
        self.toRender.addChild(healthBarFrame)
        self.toRender.addChild(healthBarRemaining)
    }
    
    func storySetup() {
        self.storyBlank.path = CGPath(rect: CGRect(x: 0, y: 0 , width: self.toRender.frame.width*0.9, height: self.toRender.frame.height/3), transform: nil)
        self.storyBlank.strokeColor = UIColor.clear
        self.storyBlank.fillColor = UIColor.black
        self.storyBlank.alpha = 0.5
        self.storyBlank.name = "storyBlank"
        self.storyBlank.position = CGPoint(x: self.toRender.frame.minX + self.toRender.frame.width/40, y: self.toRender.frame.minY + self.toRender.frame.height/30)
        self.storyBlank.zPosition = 20
        
        self.ctrl_story.setButtonLabel(title: "Next", font: "Silver", fontSize: 30)
        self.ctrl_story.position = CGPoint(x: self.toRender.frame.midX + self.toRender.frame.width/3, y: self.toRender.frame.minY + 40)
        self.ctrl_story.zPosition = 22
        self.ctrl_story.size = CGSize(width: ((self.ctrl_story.texture?.size().width)!)*0.3, height: ((self.ctrl_story.texture?.size().height)!)*0.3)
        self.ctrl_story.name = "ctrl_story"
        self.ctrl_story.setButtonAction(target: self.toRender, triggerEvent: .TouchUp, action: #selector(self.toRender.c_story))
        
        
        self.storyLabel.name = "storyLabel"
        self.storyLabel.fontName = "Silver" //Original: Avenir-Oblique
        self.storyLabel.fontSize = 40
        self.storyLabel.horizontalAlignmentMode = .left
        self.storyLabel.lineBreakMode = .byWordWrapping
        self.storyLabel.numberOfLines = 2
        self.storyLabel.zPosition = 35
        self.storyLabel.verticalAlignmentMode = .top
        self.storyLabel.preferredMaxLayoutWidth = self.toRender.frame.width*0.6
        self.storyLabel.position = CGPoint(x: self.toRender.frame.minX + self.toRender.frame.width/6, y: self.toRender.frame.midY - self.toRender.frame.height/5)
        self.storyLabel.alpha = 1
        
        self.speakerLabel.name = "speakerLabel"
        self.speakerLabel.fontName = "Silver" //Original: Avenir-Oblique
        self.speakerLabel.fontSize = 50
        self.speakerLabel.horizontalAlignmentMode = .left
        self.speakerLabel.zPosition = 36
        self.speakerLabel.position = CGPoint(x: self.toRender.frame.minX + self.toRender.frame.width/18, y: self.toRender.frame.midY - self.toRender.frame.height/8)
        self.speakerLabel.alpha = 1
        
        let sticker = SKSpriteNode(texture: self.sheet.Sticker_Amelia())
        sticker.zPosition = 36
        sticker.name = "sticker"
        sticker.size = CGSize(width: self.toRender.frame.height*0.2, height: self.toRender.frame.height*0.2)
        sticker.position = CGPoint(x: self.toRender.frame.width*0.07, y: self.toRender.frame.height*0.17)
        
        hideStory()
        self.toRender.addChild(storyBlank)
        self.storyBlank.addChild(sticker)
        self.toRender.addChild(ctrl_story)
        self.toRender.addChild(storyLabel)
        self.toRender.addChild(speakerLabel)
    }
    
    func healthBarChanging(newHP: CGFloat){
        if newHP > 0 {
            let width = (self.healthBarRemaining.texture?.size().width)!
            
            self.healthBarRemaining.run(SKAction.resize(toWidth: width * (newHP / healthPointMaxValue), duration: 0.1))
            if newHP < 750 {
                self.healthBarRemaining.color = UIColor.red
                self.healthBarRemaining.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: 1, duration: 0))
            } else if newHP < 1700 {
                self.healthBarRemaining.color = UIColor.yellow
                self.healthBarRemaining.run(SKAction.colorize(with: UIColor.yellow, colorBlendFactor: 1, duration: 0))
            } else {
                self.healthBarRemaining.color = UIColor.green
                self.healthBarRemaining.run(SKAction.colorize(with: UIColor.green, colorBlendFactor: 1, duration: 0))
            }
            
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
    
    func hideUI(){
        self.healthBarFrame.isHidden = true
        self.healthBarRemaining.isHidden = true
        self.skill_Buff_icon.isHidden = true
        self.skill_Sprint_icon.isHidden = true
        self.skill_Healing_icon.isHidden = true
        self.ctrl_pause.isHidden = true
        self.toRender.paddle.paddle.hide()
    }
    
    func showUI(){
        self.healthBarFrame.isHidden = false
        self.healthBarRemaining.isHidden = false
        self.skill_Buff_icon.isHidden = false
        self.skill_Sprint_icon.isHidden = false
        self.skill_Healing_icon.isHidden = false
        self.ctrl_pause.isHidden = false
        self.toRender.paddle.paddle.show()
    }
    
    func hideStory(){
        self.ctrl_story.isHidden = true
        self.storyBlank.isHidden = true
        self.storyLabel.isHidden = true
        self.speakerLabel.isHidden = true
    }
    
    func showStory(){
        self.storyLabel.text = self.story.firstLine()
        self.speakerLabel.text = self.story.speaker()
        self.ctrl_story.isHidden = false
        self.storyBlank.isHidden = false
        self.storyLabel.isHidden = false
        self.speakerLabel.isHidden = false
    }
    
    func nextScript(){
        self.speakerLabel.run(SKAction.playSoundFileNamed("btnClick.wav", waitForCompletion: true))
        
        if story.nextLine() {
            self.storyLabel.text = self.story.nowOn
            self.speakerLabel.text = self.story.speaker()
            let sticker = self.storyBlank.childNode(withName: "sticker") as! SKSpriteNode
            sticker.zPosition = 36
            if self.speakerLabel.text == "Amelia"{
                sticker.texture = self.sheet.Sticker_Amelia()
            } else if self.speakerLabel.text == "Gura"{
                sticker.texture = self.sheet.Sticker_Gura()
            }
            
        } else {
            print("story end")
            self.toRender.fightingMode()
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

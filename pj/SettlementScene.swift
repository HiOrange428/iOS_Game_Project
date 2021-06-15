//
//  SettlementScene.swift
//  pj
//
//  Created by mac13 on 2021/6/12.
//  Copyright © 2021 mac11. All rights reserved.
//

import Foundation
import SpriteKit

class SettlementData {
    var time: Int! = 0
    var damageDealed: CGFloat! = 0
    var damageAbsorbed: CGFloat! = 0
}

class SettlementScene: SKScene {
    private var data = SettlementData()
    private var complete = false
    override func didMove(to view: SKView) {
        createScene()
    }
    func createScene(){
        //self.testData()
        let msg: String
        var color = UIColor()
        if complete {
            msg = "Level Completed!"
            color = UIColor.white
        } else {
            msg = "You Are Dead!"
            color = UIColor.red
        }
        let titleLabel = SKLabelNode(text: msg)
        titleLabel.name = "titleLabel"
        titleLabel.fontName = "Silver" //Original: Avenir-Oblique
        titleLabel.fontSize = 80
        titleLabel.fontColor = color
        titleLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        titleLabel.alpha = 0
        
        let ani_fadeIn = SKAction.fadeIn(withDuration: 0.5)
        let ani_moveUp = SKAction.move(by: CGVector(dx: 0, dy: self.frame.height*0.26), duration: 0.5)
        titleLabel.run(SKAction.sequence([ani_fadeIn, SKAction.wait(forDuration: 0.5), ani_moveUp]))
        self.addChild(titleLabel)
        self.createDataLabels()
    }
    
    func createDataLabels(){
        let timeLabel = SKLabelNode(text: "Time used: \(self.data.time!) sec")
        timeLabel.name = "timeLabel"
        timeLabel.fontName = "Silver" //Original: Avenir-Oblique
        timeLabel.fontSize = 35
        timeLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        timeLabel.alpha = 0
        
        let damageDealedLabel = SKLabelNode(text: "Damage dealed: \(self.data.damageDealed!)")
        damageDealedLabel.name = "damageDealedLabel"
        damageDealedLabel.fontName = "Silver" //Original: Avenir-Oblique
        damageDealedLabel.fontSize = 35
        damageDealedLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY - self.frame.height/9)
        damageDealedLabel.alpha = 0
        
        let damageAbsorbedLabel = SKLabelNode(text: "Damage Absorbed: \(self.data.damageAbsorbed!)")
        damageAbsorbedLabel.name = "damageAbsorbedLabel"
        damageAbsorbedLabel.fontName = "Silver" //Original: Avenir-Oblique
        damageAbsorbedLabel.fontSize = 35
        damageAbsorbedLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY - self.frame.height*(2/9))
        damageAbsorbedLabel.alpha = 0
        
        let ani_fadeIn = SKAction.fadeIn(withDuration: 0.4)
        
        timeLabel.run(SKAction.sequence([SKAction.wait(forDuration: 1.7), ani_fadeIn]))
        damageDealedLabel.run(SKAction.sequence([SKAction.wait(forDuration: 2.4), ani_fadeIn]))
        damageAbsorbedLabel.run(SKAction.sequence([SKAction.wait(forDuration: 3.1), ani_fadeIn]), completion: {
            self.createBtn()
        })
        
        self.addChild(timeLabel)
        self.addChild(damageDealedLabel)
        self.addChild(damageAbsorbedLabel)
    }
    
    func createBtn(){
        let sheet = Asset()
        let returnToMainMenuBtn = FTButtonNode(normalTexture: sheet.UI_btn_default(), selectedTexture: sheet.UI_btn_selected(), disabledTexture: nil)
        returnToMainMenuBtn.position = CGPoint(x: self.frame.midX + self.frame.width*0.2, y: self.frame.midY - self.frame.height*0.35)
        returnToMainMenuBtn.zPosition = 20
        returnToMainMenuBtn.alpha = 0
        returnToMainMenuBtn.size = CGSize(width: ((returnToMainMenuBtn.texture?.size().width)!)*0.5, height: ((returnToMainMenuBtn.texture?.size().height)!)*0.3)
        returnToMainMenuBtn.name = "returnToMainMenuBtn"
        returnToMainMenuBtn.setButtonLabel(title: "Main Menu", font: "Silver", fontSize: 30)
        returnToMainMenuBtn.setButtonAction(target: self, triggerEvent: .TouchUp, action: #selector(self.returnToMainMenu))
        
        let tryAgainBtn = FTButtonNode(normalTexture: sheet.UI_btn_default(), selectedTexture: sheet.UI_btn_selected(), disabledTexture: nil)
        tryAgainBtn.position = CGPoint(x: self.frame.midX + self.frame.width*0.375, y: self.frame.midY - self.frame.height*0.35)
        tryAgainBtn.zPosition = 20
        tryAgainBtn.alpha = 0
        tryAgainBtn.size = CGSize(width: ((tryAgainBtn.texture?.size().width)!)*0.5, height: ((tryAgainBtn.texture?.size().height)!)*0.3)
        tryAgainBtn.name = "tryAgainBtn"
        tryAgainBtn.setButtonLabel(title: "Try Again!", font: "Silver", fontSize: 30)
        tryAgainBtn.setButtonAction(target: self, triggerEvent: .TouchUp, action: #selector(self.tryAgain))
        
        returnToMainMenuBtn.run(SKAction.fadeIn(withDuration: 2))
        tryAgainBtn.run(SKAction.fadeIn(withDuration: 2))
        
        self.addChild(tryAgainBtn)
        self.addChild(returnToMainMenuBtn)
    }
    
    func catchData(data: SettlementData, complete: Bool){
        self.data = data
        self.complete = complete
    }
    
    @objc func returnToMainMenu(){
        self.run(SKAction.playSoundFileNamed("btnClick.wav", waitForCompletion: true))
        let scene = MainScene(size: self.size)
        scene.scaleMode = .aspectFit
        let fade = SKTransition.fade(withDuration: 0.4)
        self.view?.presentScene(scene, transition: fade)
    }
    
    @objc func tryAgain(){
        self.run(SKAction.playSoundFileNamed("btnClick.wav", waitForCompletion: true))
        let scene = GameScene(size: self.size)
        scene.scaleMode = .aspectFit
        let fade = SKTransition.fade(withDuration: 0.4)
        self.view?.presentScene(scene, transition: fade)
    }
    
    func testData() {
        self.data.time = 200
        self.data.damageDealed = 12200
        self.data.damageAbsorbed = 1800
        self.complete = false
    }
}

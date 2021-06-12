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
    override func didMove(to view: SKView) {
        createScene()
    }
    func createScene(){
        let titleLabel = SKLabelNode(text: "Level Completed!")
        titleLabel.name = "titleLabel"
        titleLabel.fontName = "Silver" //Original: Avenir-Oblique
        titleLabel.fontSize = 80
        titleLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        titleLabel.alpha = 0
        
        let ani_fadeIn = SKAction.fadeIn(withDuration: 0.5)
        let ani_moveUp = SKAction.move(by: CGVector(dx: 0, dy: self.frame.height/3), duration: 0.5)
        titleLabel.run(SKAction.sequence([ani_fadeIn, SKAction.wait(forDuration: 0.5), ani_moveUp]))
        self.addChild(titleLabel)
        
        //self.testData()
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
        
        let ani_fadeIn = SKAction.fadeIn(withDuration: 0.5)
        
        timeLabel.run(SKAction.sequence([SKAction.wait(forDuration: 1.7), ani_fadeIn]))
        damageDealedLabel.run(SKAction.sequence([SKAction.wait(forDuration: 2.6), ani_fadeIn]))
        damageAbsorbedLabel.run(SKAction.sequence([SKAction.wait(forDuration: 3.5), ani_fadeIn]))
        
        self.addChild(timeLabel)
        self.addChild(damageDealedLabel)
        self.addChild(damageAbsorbedLabel)
    }
    
    func catchData(data: SettlementData){
        self.data = data
    }
    
    func testData() {
        self.data.time = 200
        self.data.damageDealed = 12200
        self.data.damageAbsorbed = 1800
    }
}

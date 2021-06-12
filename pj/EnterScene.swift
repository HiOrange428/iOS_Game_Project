//
//  EnterScene.swift
//  class5_2
//
//  Created by mac11 on 2021/4/13.
//  Copyright © 2021 mac11. All rights reserved.
//

import UIKit
import SpriteKit

class EnterScene: SKScene {
    override func didMove(to view: SKView) {
        createScene()
        greeting()
    }
    func createScene(){
        let titleLabel = SKLabelNode(text: "B10715060")
        titleLabel.name = "titleLabel"
        titleLabel.fontName = "Silver" //Original: Avenir-Oblique
        titleLabel.fontSize = 60
        titleLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        titleLabel.zPosition = 0
        titleLabel.isHidden = true
        self.addChild(titleLabel)
    }
    func greeting(){
        let openSound = SKAction.playSoundFileNamed("decide18.wav", waitForCompletion: false)
        
        let labelNode = self.childNode(withName: "titleLabel") as! SKLabelNode
        labelNode.alpha = 0
        let fadeIn = SKAction.fadeIn(withDuration: 0.7)
        let fadeOut = SKAction.fadeOut(withDuration: 0.7)
        let wait1 = SKAction.wait(forDuration: 0.5)
        let wait2 = SKAction.wait(forDuration: 2.2)
        let remove = SKAction.removeFromParent()
        
        labelNode.isHidden = false
        let moveSequence = SKAction.sequence([wait1 ,openSound, fadeIn, wait2, fadeOut, remove])
        labelNode.run(moveSequence, completion: {
            let scene = MainScene(size: self.size)
            let fade = SKTransition.fade(withDuration: 0.4)
            self.view?.presentScene(scene, transition: fade)
        })
    }
}

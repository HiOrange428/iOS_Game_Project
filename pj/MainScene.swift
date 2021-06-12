//
//  MainScene.swift
//  pj
//
//  Created by mac13 on 2021/6/12.
//  Copyright © 2021 mac11. All rights reserved.
//

import Foundation
import SpriteKit

class MainScene: SKScene {
    
    override func didMove(to view: SKView) {
        createScene()
    }
    func createScene(){
        let sheet = Asset()
        let titleLabel = SKLabelNode(text: "Ame Lane")
        titleLabel.name = "titleLabel"
        titleLabel.fontName = "Silver"
        titleLabel.fontSize = 110
        titleLabel.position = CGPoint(x: self.frame.midX + ((self.frame.maxX - self.frame.midX)/2), y: self.frame.midY + ((self.frame.maxY - self.frame.midY)/3))
        titleLabel.zPosition = 0
        
        let ame = SKSpriteNode(texture: sheet.Amelia_Without_Gun_1())
        let textureCycle = SKAction.repeatForever(SKAction.animate(with: sheet.Amelia_Without_Gun(), timePerFrame: 0.3))
        ame.position = CGPoint(x: self.frame.midX + ((self.frame.maxX - self.frame.midX)/2), y: self.frame.midY + ((self.frame.minY - self.frame.midY)/3))
        ame.run(textureCycle, withKey: "Without_Gun")
        ame.alpha = 1
        ame.size = CGSize(width: ((ame.texture?.size().width)!) * 0.7, height: ((ame.texture?.size().height)!) * 0.7)
        ame.xScale *= -1
        ame.name = "ame"
        
        let background = SKSpriteNode(imageNamed: "background_city_sunset.jpg")
        background.size = CGSize(width: self.frame.width, height: self.frame.height)
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        background.alpha = 0.7
        background.zPosition = -1
        
        creatButton()
        
        self.addChild(titleLabel)
        self.addChild(ame)
        self.addChild(background)
    }
    func creatButton() {
        let sheet = Asset()
        let btnPlay = FTButtonNode(normalTexture: sheet.UI_btn_play_default(), selectedTexture: sheet.UI_btn_play_selected(), disabledTexture: sheet.UI_btn_play_disabled())
        let btnExit = FTButtonNode(normalTexture: sheet.UI_btn_exit_default(), selectedTexture: sheet.UI_btn_exit_selected(), disabledTexture: sheet.UI_btn_exit_disabled())
        
        btnPlay.position = CGPoint(x: self.frame.midX + ((self.frame.minX - self.frame.midX)/2), y: self.frame.midY + ((self.frame.maxY - self.frame.midY)/4))
        btnPlay.zPosition = 10
        btnPlay.size = CGSize(width: ((btnPlay.texture?.size().width)!)*4, height: ((btnPlay.texture?.size().height)!)*4)
        btnPlay.name = "btnPlay"
        btnPlay.setButtonAction(target: self, triggerEvent: .TouchUp, action: #selector(self.play))
        
        btnExit.position = CGPoint(x: self.frame.midX + ((self.frame.minX - self.frame.midX)/2), y: self.frame.midY + ((self.frame.minY - self.frame.midY)/4))
        btnExit.zPosition = 10
        btnExit.size = CGSize(width: ((btnExit.texture?.size().width)!)*4, height: ((btnExit.texture?.size().height)!)*4)
        btnExit.name = "btnExit"
        btnExit.setButtonAction(target: self, triggerEvent: .TouchUp, action: #selector(self.exit))
        self.addChild(btnPlay)
        self.addChild(btnExit)
    }
    @objc func play(){
        self.run(SKAction.wait(forDuration: 0.2), completion: {
            let gameScene = GameScene(size: self.size)
            let fade = SKTransition.fade(withDuration: 0.4)
            self.view?.presentScene(gameScene, transition: fade)
        })
    }
    @objc func exit(){
        print("exit Game")
        UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
    }
}

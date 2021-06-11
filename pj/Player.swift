//
//  Player.swift
//  pj
//
//  Created by mac11 on 2021/5/7.
//  Copyright © 2021 mac11. All rights reserved.
//

import Foundation
import SpriteKit

class Player {
    let sheet = Asset()
    let player: SKSpriteNode!
    let toRender: GameScene
    let bodyBitBox = CGSize(width: 30, height: 51)
    let textureSize = CGSize(width: 60, height: 60)
    var fire: Timer?
    var isFiring: Bool
    let healthPointMaxValue: CGFloat = 2000
    var healthPoint: CGFloat = 2000
    var bulletDamage: CGFloat = 500
    var currentDirection = 0
    init(forScene scene:SKScene){
        toRender = scene as! GameScene
        player = SKSpriteNode(texture: sheet.Amelia_Without_Gun_1(),size: self.textureSize)
        let textureCycle = SKAction.repeatForever(SKAction.animate(with: self.sheet.Amelia_Without_Gun(), timePerFrame: 0.3))
        self.player.run(textureCycle, withKey: "Without_Gun")
        player.alpha = 1
        player.name = "player"
        player.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY)
        player.physicsBody = SKPhysicsBody(rectangleOf:self.bodyBitBox)
        player.physicsBody?.categoryBitMask = self.toRender.categoryBitMask_player
        player.physicsBody?.collisionBitMask = self.toRender.categoryBitMask_player
        player.physicsBody?.contactTestBitMask = self.toRender.categoryBitMask_player | self.toRender.categoryBitMask_enemiesBullets | self.toRender.categoryBitMask_bossAttack
        player.zPosition = 10
        scene.addChild(player)
        
        isFiring = false
    }
    func moveBy(vector: CGVector){
        let moveAction = SKAction.move(by: vector, duration: 0.02)
        self.player.run(moveAction)
    }
    func getPosition() ->CGPoint {
        return self.player.position
    }
    func newBullet(){
        let bullet = SKShapeNode()
        bullet.path = CGPath(rect: CGRect(x: -4, y: -2, width: 8, height: 4), transform: nil)
        bullet.strokeColor = SKColor.white
        bullet.fillColor = SKColor.cyan
        let fireAnimation = SKAction.sequence([SKAction.move(by: CGVector(dx:1500, dy:0), duration: 2), SKAction.removeFromParent()])
        bullet.position = CGPoint(x: 4, y: 2)
        bullet.name = "bullets"
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: 4)
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        bullet.physicsBody?.isDynamic = false
        bullet.physicsBody?.categoryBitMask = self.toRender.categoryBitMask_playerBullets
        bullet.physicsBody?.collisionBitMask = self.toRender.categoryBitMask_playerBullets
        bullet.physicsBody?.contactTestBitMask = self.toRender.categoryBitMask_enemies | self.toRender.categoryBitMask_playerBullets
        bullet.zPosition = 5
        bullet.run(fireAnimation)
        self.player.addChild(bullet)
    }
    
    func healthChanging(changedValue: CGFloat) -> CGFloat{
        var newHP = self.healthPoint + changedValue
        if newHP > self.healthPointMaxValue { newHP = self.healthPointMaxValue }
        self.toRender.gameUI.healthBarChanging(newHP: newHP)
        if (newHP > 0) {
            self.healthPoint = newHP
        } else {
            print("you are dead")
            stopFiring()
            //else dead
        }
        return newHP
    }
    func startFiring(){
        self.fire = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.playerFire), userInfo: nil, repeats: true)
        self.isFiring = true
        stopAnimationCycle()
        self.player.texture = self.sheet.Amelia_Normal_1()
        let textureCycle = SKAction.repeatForever(SKAction.animate(with: self.sheet.Amelia_Normal(), timePerFrame: 0.1))
        self.player.run(textureCycle, withKey: "Normal")
    }
    func stopFiring(){
        fire?.invalidate()
        self.isFiring = false
        stopAnimationCycle()
        self.player.texture = self.sheet.Amelia_Without_Gun_1()
        let textureCycle = SKAction.repeatForever(SKAction.animate(with: self.sheet.Amelia_Without_Gun(), timePerFrame: 0.1))
        self.player.run(textureCycle, withKey: "Without_Gun")
    }
    
    func flyForward(){
        self.currentDirection = 1
        if isFiring{
            stopAnimationCycle()
            let textureCycle = SKAction.repeatForever(SKAction.animate(with: self.sheet.Amelia_Forward(), timePerFrame: 0.1))
            self.player.run(textureCycle, withKey: "Forward")
        } else {
            stopFiring()
        }
    }
    
    func flyBackword(){
        self.currentDirection = -1
        if isFiring{
            stopAnimationCycle()
            let textureCycle = SKAction.repeatForever(SKAction.animate(with: self.sheet.Amelia_Backward(), timePerFrame: 0.1))
            self.player.run(textureCycle, withKey: "Backward")
        } else {
            stopFiring()
        }
    }
    
    
    func flyVertical(){
        self.currentDirection = 0
        if isFiring{
            stopAnimationCycle()
            let textureCycle = SKAction.repeatForever(SKAction.animate(with: self.sheet.Amelia_Normal(), timePerFrame: 0.1))
            self.player.run(textureCycle, withKey: "Normal")
        } else {
            stopFiring()
        }
    }
    
    func stopAnimationCycle(){
        self.player.removeAction(forKey: "Normal")
        self.player.removeAction(forKey: "Without_Gun")
        self.player.removeAction(forKey: "Forward")
        self.player.removeAction(forKey: "Backward")
    }
    
    @objc func playerFire(){
        self.newBullet()
    }    
}

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
    //let Player: SKSpriteNode!
    let sheet = character_texture()
    let player: SKSpriteNode!
    let toRender: GameScene
    var fire: Timer?
    var isFiring: Bool
    let healthPointMaxValue: CGFloat = 2000
    var healthPoint: CGFloat = 2000
    let healthBarFrame = SKShapeNode()
    let healthBarRemaining = SKShapeNode()
    var bulletDamage: CGFloat = 500
    init(forScene scene:SKScene){
        toRender = scene as! GameScene
        player = SKSpriteNode(texture: sheet.Amelia_Amelia_fly_normal(),size: CGSize(width: 60, height: 60))
        player.alpha = 1
        player.name = "player"
        player.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY)
        player.physicsBody = SKPhysicsBody(rectangleOf:CGSize(width: 30, height: 51.6))
        player.physicsBody?.categoryBitMask = self.toRender.categoryBitMask_player
        player.physicsBody?.collisionBitMask = self.toRender.categoryBitMask_player
        player.physicsBody?.contactTestBitMask = self.toRender.categoryBitMask_player | self.toRender.categoryBitMask_enemiesBullets | self.toRender.categoryBitMask_bossAttack
        player.zPosition = 10
        scene.addChild(player)
        
        isFiring = false
        self.healthBarRendering()
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
    func healthBarRendering(){
        let width = (self.toRender.frame.maxX-self.toRender.frame.minX)/3
        let height = CGFloat(30.0)
        self.healthBarFrame.path = CGPath(rect: CGRect(x: 0, y: CGFloat(-height), width: width, height: height), transform: nil)
        self.healthBarFrame.strokeColor = UIColor.lightGray
        self.healthBarFrame.fillColor = UIColor.clear
        self.healthBarFrame.name = "healthBarFrame"
        self.healthBarFrame.position = CGPoint(x: self.toRender.frame.minX + 10, y: self.toRender.frame.maxY - 10)
        
        self.healthBarRemaining.path = CGPath(rect: CGRect(x: 0, y: CGFloat(-height), width: width, height: height), transform: nil)
        self.healthBarRemaining.strokeColor = UIColor.clear
        self.healthBarRemaining.fillColor = UIColor.systemGreen
        self.healthBarRemaining.name = "healthBarRemaining"
        self.healthBarRemaining.position = CGPoint(x: self.toRender.frame.minX + 10, y: self.toRender.frame.maxY - 10)
        self.healthBarRemaining.zPosition = 20
        self.healthBarFrame.zPosition = 20
        self.toRender.addChild(healthBarFrame)
        self.toRender.addChild(healthBarRemaining)
    }
    func healthBarChanging(changedValue: CGFloat) -> CGFloat{
        let newHP = self.healthPoint + changedValue
        if (newHP > 0) {
            let width = (self.toRender.frame.maxX-self.toRender.frame.minX)/3
            let height = CGFloat(30.0)
            self.healthBarRemaining.path = CGPath(rect: CGRect(x: 0, y: CGFloat(-height), width: width * (newHP / healthPointMaxValue), height: height), transform: nil)
            self.healthPoint = newHP
        } else {
            healthBarRemaining.isHidden = true
            print("you are dead")
            stopFiring()
            //else dead
        }
        return newHP
    }
    func startFiring(){
        self.fire = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.playerFire), userInfo: nil, repeats: true)
        self.isFiring = true
        player.texture = sheet.Amelia_Amelia_fly_normal_fire()
    }
    func stopFiring(){
        fire?.invalidate()
        self.isFiring = false
        player.texture = sheet.Amelia_Amelia_fly_normal()
    }
    
    func flyForward(){
        if isFiring{
            self.player.texture = self.sheet.Amelia_Amelia_fly_forward_fire()
        } else {
            self.player.texture = self.sheet.Amelia_Amelia_fly_forward()
        }
        
    }
    
    func flyBackword(){
        if isFiring{
            self.player.texture = self.sheet.Amelia_Amelia_fly_backward_fire()
        } else {
            self.player.texture = self.sheet.Amelia_Amelia_fly_backward()
        }
    }
    
    func flyVertical(){
        if isFiring{
            self.player.texture = self.sheet.Amelia_Amelia_fly_normal_fire()
        } else {
            self.player.texture = self.sheet.Amelia_Amelia_fly_normal()
        }
    }
    
    @objc func playerFire(){
        self.newBullet()
    }
}

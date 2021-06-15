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
    let bodyBitBox = CGSize(width: 28, height: 49.5)
    let textureSize = CGSize(width: 60, height: 60)
    var fire: Timer?
    var isFiring: Bool
    let healthPointMaxValue: CGFloat = 3000
    var healthPoint: CGFloat = 3000
    var bulletDamage: CGFloat = 500
    var currentDirection = 0
    var isInvincible = false
    
    init(forScene scene:SKScene){
        toRender = scene as! GameScene
        player = SKSpriteNode(texture: sheet.Amelia_Without_Gun_1(),size: self.textureSize)
        let textureCycle = SKAction.repeatForever(SKAction.animate(with: self.sheet.Amelia_Without_Gun(), timePerFrame: 0.3))
        self.player.run(textureCycle, withKey: "Without_Gun")
        player.alpha = 1
        player.name = "player"
        player.position = CGPoint(x: self.toRender.frame.midX - self.toRender.frame.width / 4, y: self.toRender.frame.midY)
        player.physicsBody = SKPhysicsBody(rectangleOf:self.bodyBitBox, center: CGPoint(x: 0, y: -1.3))
        player.physicsBody?.categoryBitMask = self.toRender.categoryBitMask_player
        player.physicsBody?.collisionBitMask = self.toRender.categoryBitMask_player
        player.physicsBody?.contactTestBitMask = self.toRender.categoryBitMask_player | self.toRender.categoryBitMask_enemiesBullets | self.toRender.categoryBitMask_bossAttack
        player.zPosition = 10
        scene.addChild(player)
        
        isFiring = false
    }
    func moveBy(vector: CGVector){
        let moveAction = SKAction.move(by: vector, duration: 0.03)
        self.player.run(moveAction)
    }
    func getPosition() ->CGPoint {
        return self.player.position
    }
    func newBullet(){
        let bullet = SKShapeNode()
        bullet.path = CGPath(rect: CGRect(x: -4, y: -2, width: 8, height: 4), transform: nil)
        bullet.strokeColor = SKColor.white
        if self.bulletDamage <= 700{
            bullet.fillColor = SKColor.cyan
        } else {
            bullet.fillColor = SKColor.purple
        }
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
        if isInvincible && changedValue <= 0{
            return self.healthPoint
        }
        var newHP = self.healthPoint + changedValue
        if newHP > self.healthPointMaxValue { newHP = self.healthPointMaxValue }
        self.toRender.gameUI.healthBarChanging(newHP: newHP)
        if (newHP > 0) {
            self.healthPoint = newHP
        } else {
            print("you are dead")
            stopFiring()
            //else dead
            self.toRender.gameOver()
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
    
    func moveToInitPos(){
        let initPos = CGPoint(x: self.toRender.frame.midX - self.toRender.frame.width / 4, y: self.toRender.frame.midY)
        player.run(SKAction.move(to: initPos, duration: 0.1))
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
    func shadowSprint(){
        let dx = self.toRender.accelerationVector.dx
        let dy = self.toRender.accelerationVector.dy
        let length = sqrt(dx*dx+dy*dy)
        let distance: CGFloat = 125
        let effect = SKSpriteNode(texture: sheet.Amelia_Skill_Sprint_1(), size: CGSize(width: 200, height: 200))
        effect.alpha = 1
        let textureCycle = SKAction.animate(with: sheet.Amelia_Skill_Sprint(), timePerFrame: 0.03)
        effect.position = CGPoint(x: 0, y: 0)
        effect.zPosition = 21
        effect.name = "sprint_effect"
        let sound = SKAction.playSoundFileNamed("Amelia_sprint.wav", waitForCompletion: false)
        effect.run(SKAction.sequence([textureCycle, sound]), completion: {
            effect.removeFromParent()
            self.isInvincible = false
        })
        player.addChild(effect)
        self.isInvincible = true
        if length < 0.1{
            let destination = CGPoint(x: player.position.x + 100, y: player.position.y)
            if destination.x > self.toRender.frame.maxX {
                let vector = CGVector(dx: self.toRender.frame.maxX - player.position.x, dy: 0)
                let moveAction = SKAction.move(by: vector, duration: 0.02)
                self.player.run(moveAction)
            } else {
                let vector = CGVector(dx: 100, dy: 0)
                let moveAction = SKAction.move(by: vector, duration: 0.02)
                self.player.run(moveAction)
            }
        } else {
            let destination = CGPoint(x: player.position.x + dx/length*distance, y: player.position.y + dy/length*distance)
            switch borderDetect(d: destination) {
            case 0:
                let vector = CGVector(dx: dx/length*distance, dy: dy/length*distance)
                let moveAction = SKAction.move(by: vector, duration: 0.02)
                self.player.run(moveAction)
            case 1:
                let vector = CGVector(dx: self.toRender.frame.maxX - player.position.x, dy: dy / dx * (self.toRender.frame.maxX - player.position.x))
                let moveAction = SKAction.move(by: vector, duration: 0.02)
                self.player.run(moveAction)
            case 2:
                let vector = CGVector(dx: self.toRender.frame.minX - player.position.x, dy: dy / dx * ( self.toRender.frame.minX - player.position.x))
                let moveAction = SKAction.move(by: vector, duration: 0.02)
                self.player.run(moveAction)
            case 3:
                let vector = CGVector(dx: dx / dy * (self.toRender.frame.maxY - player.position.y), dy:self.toRender.frame.maxY - player.position.y)
                let moveAction = SKAction.move(by: vector, duration: 0.02)
                self.player.run(moveAction)
            case 4:
                let vector = CGVector(dx: dx / dy * (self.toRender.frame.minY - player.position.y), dy: self.toRender.frame.minY -  player.position.y)
                let moveAction = SKAction.move(by: vector, duration: 0.02)
                self.player.run(moveAction)
            default:
                break
            }
        }
        self.toRender.gameUI.disableSkill(type: .Sprint)
    }
    
    func borderDetect(d:CGPoint) -> Int8 {
        if d.x > self.toRender.frame.maxX {
            if d.y > self.toRender.frame.maxY  {
                let deltaX = abs(self.toRender.frame.maxX - d.x)
                let deltaY = abs(self.toRender.frame.maxY - d.y)
                if deltaX > deltaY {
                    return 1
                } else {
                    return 3
                }
            } else if d.y < self.toRender.frame.minY {
                let deltaX = abs(self.toRender.frame.maxX - d.x)
                let deltaY = abs(self.toRender.frame.minY - d.y)
                if deltaX > deltaY {
                    return 1
                } else {
                    return 4
                }
            } else {
                return 1
            }
        } else if d.x < self.toRender.frame.minX {
            if d.y > self.toRender.frame.maxY  {
                let deltaX = abs(self.toRender.frame.minX - d.x)
                let deltaY = abs(self.toRender.frame.maxY - d.y)
                if deltaX > deltaY {
                    return 2
                } else {
                    return 3
                }
            } else if d.y < self.toRender.frame.minY {
                let deltaX = abs(self.toRender.frame.minX - d.x)
                let deltaY = abs(self.toRender.frame.minY - d.y)
                if deltaX > deltaY {
                    return 2
                } else {
                    return 4
                }
            } else {
                return 2
            }
        } else if d.y > self.toRender.frame.maxY {
            return 3
        } else if d.y < self.toRender.frame.minY {
            return 4
        } else {
            return 0
        }
    }
    
    func healing(){
        let sound = SKAction.playSoundFileNamed("Amelia_healing.wav", waitForCompletion: false)
        self.player.run(sound)
        self.healthChanging(changedValue: 800)
        print("H_triggered")
        self.toRender.gameUI.disableSkill(type: .Healing)
    }
    
    func buff(){
        self.bulletDamage *= 2
        Timer.scheduledTimer(timeInterval: 9, target: self, selector: #selector(self.buffOver), userInfo: nil, repeats: false)
        let effect = SKSpriteNode(texture: sheet.Amelia_Skill_Buff_FX001(), size: CGSize(width: 200, height: 200))
        effect.alpha = 0.6
        effect.size = CGSize(width: ((effect.texture?.size().width)!)*1.8, height: ((effect.texture?.size().height)!)*1.9)
        let textureCycle = SKAction.repeatForever(SKAction.animate(with: sheet.Amelia_Skill_Buff_FX(), timePerFrame: 0.1))
        effect.position = CGPoint(x: 0, y: 0)
        effect.zPosition = 21
        effect.name = "buff_effect"
        let sound = SKAction.playSoundFileNamed("Amelia_buff.wav", waitForCompletion: false)
        effect.run(SKAction.sequence([textureCycle, sound]), withKey: "buff_aura")
        print("Buff_triggered")
        self.toRender.gameUI.disableSkill(type: .Buff)
        player.addChild(effect)
    }
    @objc func buffOver(){
        self.bulletDamage = 500
        self.player.childNode(withName: "buff_effect")?.removeFromParent()
        print("Buff_over")
    }
}

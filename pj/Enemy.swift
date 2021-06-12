//
//  Enemy.swift
//  pj
//
//  Created by mac11 on 2021/5/11.
//  Copyright © 2021 mac11. All rights reserved.
//

import Foundation
import SpriteKit

enum EnemyType {
    case bat
    case ghost
    case shark
}

class Enemy {
    let sheet = Asset()
    var enemy :SKSpriteNode?
    let toRender: GameScene
    let nodeName: String
    let bodyHitBox = SKPhysicsBody(circleOfRadius: 20)
    let textureSize = CGSize(width: 60, height: 60)
    
    let healthPointMaxValue: CGFloat = 4000
    var healthPoint: CGFloat = 4000
    let healthBarFrame = SKShapeNode()
    let healthBarRemaining = SKShapeNode()
    let bulletDamage = 200
    let enemyType: EnemyType
    var fire: Timer?
    
    init(forScene scene: SKScene, name nodeName: String, position nodePosition: CGPoint, type: EnemyType){
        toRender = scene as! GameScene
        // the nodeName must be unique at the same time
        self.nodeName = nodeName
        self.enemyType = type
        self.loadTexture()
       
        self.enemy!.name = nodeName
        self.enemy!.position = nodePosition
        
        self.enemy!.physicsBody = self.bodyHitBox
        self.enemy!.physicsBody?.categoryBitMask = self.toRender.categoryBitMask_enemies
        self.enemy!.physicsBody?.collisionBitMask = self.toRender.categoryBitMask_enemies
        self.enemy!.physicsBody?.contactTestBitMask = self.toRender.categoryBitMask_enemies | self.toRender.categoryBitMask_playerBullets
        //scene.addChild(enemy!)
        self.healthBarRendering()
        self.enemy!.zPosition = 10
        self.enterSceneActions()
    }
    
    func loadTexture(){
        print(enemyType)
        switch enemyType {
        case EnemyType.bat:
            self.enemy = SKSpriteNode(texture: sheet.Enemy_Bat_1(),size: self.textureSize)
            self.enemy!.run(SKAction.repeatForever(SKAction.animate(with: sheet.Enemy_Bat(), timePerFrame: 0.2)))
        case EnemyType.ghost:
            self.enemy = SKSpriteNode(texture: sheet.Enemy_Ghost_1(),size: self.textureSize)
            self.enemy!.run(SKAction.repeatForever(SKAction.animate(with: sheet.Enemy_Ghost(), timePerFrame: 0.2)))
        case EnemyType.shark:
            self.enemy = SKSpriteNode(texture: sheet.Enemy_Bloop_1(),size: self.textureSize)
            self.enemy!.run(SKAction.repeatForever(SKAction.animate(with: sheet.Enemy_Bloop(), timePerFrame: 0.2)))
        }
        if self.enemyType == EnemyType.shark { self.enemy?.alpha = 0 }
        else {self.enemy?.alpha = 1}
    }
    
    func enterSceneActions(){
        var moveInToScreen = SKAction()
        if self.enemyType == EnemyType.shark {
            moveInToScreen = SKAction.fadeIn(withDuration: 3)
        } else {
            moveInToScreen = SKAction.move(by: CGVector(dx: -100,dy: 0), duration: 2)
        }
        enemy!.run(moveInToScreen, completion: {self.fire = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.enemyFire), userInfo: nil, repeats: true)})
        self.toRender.addChild(self.enemy!)
    }
    
    func moveBy(vector: CGVector){
        let moveAction = SKAction.move(by: vector, duration: 0.02)
        self.enemy!.run(moveAction)
    }
    
    func getPosition() ->CGPoint {
        return self.enemy!.position
    }
    
    func newBullet(dx: CGFloat, dy: CGFloat){
        let bullet = SKShapeNode()
        bullet.path = CGPath(rect: CGRect(x: -4, y: -2, width: 8, height: 4), transform: nil)
        bullet.strokeColor = SKColor.white
        bullet.fillColor = SKColor.systemRed
        let fire = SKAction.sequence([SKAction.move(by: CGVector(dx:dx, dy:dy), duration: 15), SKAction.removeFromParent()])
        bullet.position = enemy!.position
        
        bullet.zRotation = atan(dy/dx)
        bullet.name = "bullets"
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: 4)
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        bullet.physicsBody?.isDynamic = false
        
        bullet.physicsBody?.categoryBitMask = self.toRender.categoryBitMask_enemiesBullets
        bullet.physicsBody?.collisionBitMask = self.toRender.categoryBitMask_enemiesBullets
        bullet.physicsBody?.contactTestBitMask = self.toRender.categoryBitMask_enemiesBullets | self.toRender.categoryBitMask_player
        bullet.zPosition = 5
        bullet.run(fire)
        self.toRender.addChild(bullet)
    }
    
    func healthBarRendering(){
        let width = CGFloat(50.0)
        let height = CGFloat(5.0)
        self.healthBarFrame.path = CGPath(rect: CGRect(x: 0.0, y: CGFloat(-height/2), width: width, height: height), transform: nil)
        self.healthBarFrame.strokeColor = UIColor.lightGray
        self.healthBarFrame.fillColor = UIColor.clear
        self.healthBarFrame.name = "healthBarFrame"
        self.healthBarFrame.position = CGPoint(x: CGFloat(-width / 2), y: 25)
        
        self.healthBarRemaining.path = CGPath(rect: CGRect(x: 0.0, y: CGFloat(-height/2), width: width, height: height), transform: nil)
        self.healthBarRemaining.strokeColor = UIColor.clear
        self.healthBarRemaining.fillColor = UIColor.systemGreen
        self.healthBarRemaining.name = "healthBarRemaining"
        self.healthBarRemaining.position = CGPoint(x: CGFloat(-width / 2), y: 25)
        self.healthBarFrame.zPosition = 15
        self.healthBarRemaining.zPosition = 15
        
        self.enemy!.addChild(healthBarFrame)
        self.enemy!.addChild(healthBarRemaining)
    }
    
    func healthBarChanging(changedValue: CGFloat) -> CGFloat{
        let newHP = self.healthPoint + changedValue
        if (newHP > 0) {
            let width = CGFloat(50.0)
            let height = CGFloat(5.0)
            self.healthBarRemaining.path = CGPath(rect: CGRect(x: 0.0, y: CGFloat(-height/2), width: width * (newHP / healthPointMaxValue), height: height), transform: nil)
            self.healthPoint = newHP
        } else {
            distroyed()
        }
        return newHP
    }
    
    func distroyed() {
        fire?.invalidate()
        enemy!.removeFromParent()
    }
    
    @objc func enemyFire(){
        self.newBullet(dx: -800, dy: 200)
        self.newBullet(dx: -800, dy: -200)
        self.newBullet(dx: -800, dy: 0)
        //print(nodeName)
    }
}

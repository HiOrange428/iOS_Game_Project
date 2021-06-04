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
    
}

class Enemy {
    let sheet = character_texture()
    var enemy :SKSpriteNode?
    let toRender: GameScene
    let nodeName: String
    let healthPointMaxValue: CGFloat = 2000
    var healthPoint: CGFloat = 2000
    let healthBarFrame = SKShapeNode()
    let healthBarRemaining = SKShapeNode()
    let bulletDamage = 200
    let enemyType: EnemyType
    var fire: Timer?
    
    init(forScene scene: SKScene, name nodeName: String, position nodePosition: CGPoint, type: EnemyType){
        //enemy = SKShapeNode(circleOfRadius: 20)
        toRender = scene as! GameScene
        // the node name must be unique at the same time
        self.nodeName = nodeName
        self.enemyType = type
        loadTexture()
       
        enemy!.name = nodeName
        enemy!.position = nodePosition
        enemy!.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        enemy!.physicsBody?.categoryBitMask = self.toRender.categoryBitMask_enemies
        enemy!.physicsBody?.collisionBitMask = self.toRender.categoryBitMask_enemies
        enemy!.physicsBody?.contactTestBitMask = self.toRender.categoryBitMask_enemies | self.toRender.categoryBitMask_playerBullets
        //scene.addChild(enemy!)
        self.healthBarRendering()
        enemy!.zPosition = 10
        enterSceneActions()
        //fire = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(enemyFire), userInfo: nil, repeats: true)
        // let selfDistruct = Timer.scheduledTimer(timeInterval: 16, target: self, selector: #selector(distroyed), userInfo: nil, repeats: false)
    }
    func loadTexture(){
        enemy = SKSpriteNode(texture: sheet.enemy_bat_bat_1(),size: CGSize(width: 60, height: 60))
        enemy!.alpha = 1
        enemy!.run(SKAction.repeatForever(SKAction.animate(with: sheet.enemy_bat_bat_(), timePerFrame: 0.2)))
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
        let fire = SKAction.sequence([SKAction.move(by: CGVector(dx:dx, dy:dy), duration: 10), SKAction.removeFromParent()])
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
    func enterSceneActions(){
        let moveInToScreen = SKAction.move(by: CGVector(dx: -100,dy: 0), duration: 2)
        enemy!.run(moveInToScreen, completion: {self.fire = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.enemyFire), userInfo: nil, repeats: true)})
        self.toRender.addChild(self.enemy!)
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
        //if self.nodeName != "test1" || self.nodeName != "test\(self.countInOneWave)"{
            self.newBullet(dx: -800, dy: 200)
            self.newBullet(dx: -800, dy: -200)
        //}
       
        self.newBullet(dx: -800, dy: 0)
       //print(nodeName)
    }
}

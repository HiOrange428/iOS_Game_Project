//
//  GameScene.swift
//  pj
//
//  Created by mac11 on 2021/5/5.
//  Copyright © 2021 mac11. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate, JDPaddleVectorDelegate {
    var paddle:JDGamePaddle!
    var player: Player!
    var enemies = [Enemy]()
    var boss: Boss?
    var enemyCountInEachWave = [0, 1]
    var inBossFight: Bool = false
    var wave = 1
    var accelerationVector = CGVector(dx: 0, dy: 0)
    private var keepDetectMove: Timer?
    public let categoryBitMask_player: UInt32 = 0x1 << 1
    public let categoryBitMask_enemies: UInt32 = 0x1 << 2
    public let categoryBitMask_playerBullets: UInt32 = 0x1 << 3
    public let categoryBitMask_enemiesBullets: UInt32 = 0x1 << 4
    public let categoryBitMask_boss: UInt32 = 0x1 << 5
    public let categoryBitMask_bossAttack: UInt32 = 0x1 << 6
    
    func getVector(vector: CGVector) {
        accelerationVector = vector
        //self.player.moveBy(vector: vector)
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        createScene()
    }
    func createScene() {
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        let background = SKSpriteNode(imageNamed: "background_city_sunset.jpg")
        background.size = CGSize(width: self.frame.width, height: self.frame.height)
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        background.alpha = 0.7
        background.zPosition = -1
        self.addChild(background)
        paddle = JDGamePaddle(forScene: self, size:CGSize(width: 200, height: 200), position: CGPoint(x: self.frame.minX + 80.0, y: self.frame.minY + 80.0))
        paddle.delegate = self
        player = Player(forScene: self)
        self.keepDetectMove = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(keepMove), userInfo: nil, repeats: true)
        createEnemy()
        player.startFiring()
    }
    func createEnemy() {
        let topSpawnPiontY = self.frame.maxY
        let buttomSpawnPointY = self.frame.minY
        let distenceOfSpawnPointY = topSpawnPiontY - buttomSpawnPointY
        if (wave < enemyCountInEachWave.count){
            for i in 1 ... enemyCountInEachWave[wave]{
                let enemy = Enemy(forScene: self, name: "test\(i)", position: CGPoint(x: self.frame.maxX + 40,y: topSpawnPiontY - (distenceOfSpawnPointY * CGFloat(i) / CGFloat(enemyCountInEachWave[wave] + 1))), type: EnemyType.bat)
                enemies.append(enemy)
            }
        }
    }
    
    func createBoss() {
        print(CGPoint(x: self.frame.maxX + 40, y: self.frame.midY))
        self.boss = Boss(forScene: self, name: "gura", position: CGPoint(x: self.frame.maxX + 40, y: self.frame.midY))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch collision {
// player been hit
        case categoryBitMask_player | categoryBitMask_enemiesBullets:
            contact.bodyB.node?.removeFromParent()
            self.player.healthBarChanging(changedValue: -200)
// player hits enemy
        case categoryBitMask_playerBullets | categoryBitMask_enemies:
            if contact.bodyA.categoryBitMask == categoryBitMask_enemies{
                if let targetName = contact.bodyA.node?.name {
                    if let index = self.enemies.firstIndex(where: {$0.nodeName == targetName}){
                        //print(self.enemies[index].nodeName)
                        if  self.enemies[index].healthBarChanging(changedValue: -self.player.bulletDamage) <= 0 {
                            enemies.remove(at: index)
                            if targetName.hasPrefix("shark") {
                                self.boss?.sharkRemain -= 1
                            }
                        }
                    }
                }
                contact.bodyB.node?.removeFromParent()
            } else {
                if let targetName = contact.bodyB.node?.name {
                    if let index = self.enemies.firstIndex(where: {$0.nodeName == targetName}){
                        //print(self.enemies[index].nodeName)
                        if self.enemies[index].healthBarChanging(changedValue: -self.player.bulletDamage) <= 0 {
                            enemies.remove(at: index)
                        }
                    }
                }
                contact.bodyA.node?.removeFromParent()
            }
        case categoryBitMask_playerBullets | categoryBitMask_boss:
            if self.boss!.healthBarChanging(changedValue: -self.player.bulletDamage) <= 0{
                self.boss = nil
            }
            if contact.bodyA.categoryBitMask == categoryBitMask_boss{
                contact.bodyB.node?.removeFromParent()
            } else {
                contact.bodyA.node?.removeFromParent()
            }
        case categoryBitMask_player | categoryBitMask_bossAttack:
            self.player.healthBarChanging(changedValue: -400)
            print("boss skill hit")
        default:
            print("為什麼是這裡")
            break
        }
        if self.enemies.count == 0 {
            if wave < (enemyCountInEachWave.count - 1){
                self.wave += 1
                createEnemy()
            } else if !inBossFight {
                print("Boss Fight")
                self.inBossFight = true
                createBoss()
            }
        }
    }
    
    @objc func keepMove(){
        // TopFrameBorder
        if (self.player.getPosition().y >= self.frame.maxY) && (accelerationVector.dy > 0) {
            if((self.player.getPosition().x <= self.frame.minX) && (accelerationVector.dx < 0)) || ((self.player.getPosition().x >= self.frame.maxX) && (accelerationVector.dx > 0)){
                self.player.moveBy(vector: CGVector(dx: 0, dy: 0))
            } else {
                self.player.moveBy(vector: CGVector(dx: accelerationVector.dx, dy: 0))
            }
        }
        // ButtomFrameBorder
        else if(self.player.getPosition().y <= self.frame.minY) && (accelerationVector.dy < 0) {
            if((self.player.getPosition().x <= self.frame.minX) && (accelerationVector.dx < 0)) || ((self.player.getPosition().x >= self.frame.maxX) && (accelerationVector.dx > 0)){
                self.player.moveBy(vector: CGVector(dx: 0, dy: 0))
            } else {
                self.player.moveBy(vector: CGVector(dx: accelerationVector.dx, dy: 0))
            }
        }
        // LeftFrameBorder
        else if(self.player.getPosition().x <= self.frame.minX) && (accelerationVector.dx < 0) {
            self.player.moveBy(vector: CGVector(dx: 0, dy: accelerationVector.dy))
        }
        // RightFrameBorder
        else if(self.player.getPosition().x >= self.frame.maxX) && (accelerationVector.dx > 0) {
            self.player.moveBy(vector: CGVector(dx: 0, dy: accelerationVector.dy))
        }
        // default
        else {
            self.player.moveBy(vector: accelerationVector)
        }
        //print(accelerationVector)
        if accelerationVector.dx > 2.5 {
            self.player.flyForward()
        } else if accelerationVector.dx < -2.5 {
            self.player.flyBackword()
        } else {
            self.player.flyVertical()
        }
    }  
}

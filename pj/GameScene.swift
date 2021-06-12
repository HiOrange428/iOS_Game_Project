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
    let sheet = Asset()
    var paddle:JDGamePaddle!
    var player: Player!
    var enemies = [Enemy]()
    var boss: Boss?
    var gameUI: GameUI!
    var enemyCountInEachWave = [0, 1, 3, 3, 4, 4]
    var inBossFight: Bool = false
    var wave = 1
    var accelerationVector = CGVector(dx: 0, dy: 0)
    private var keepDetectMove: Timer?
    private var GenerateCloud: Timer?
    public let categoryBitMask_player: UInt32 = 0x1 << 1
    public let categoryBitMask_enemies: UInt32 = 0x1 << 2
    public let categoryBitMask_playerBullets: UInt32 = 0x1 << 3
    public let categoryBitMask_enemiesBullets: UInt32 = 0x1 << 4
    public let categoryBitMask_boss: UInt32 = 0x1 << 5
    public let categoryBitMask_bossAttack: UInt32 = 0x1 << 6
    //var skill_Sprint_icon: FTButtonNode
    func getVector(vector: CGVector) {
        accelerationVector = vector
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        createScene()
    }
    func createScene() {
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        let background = SKSpriteNode(texture: self.sheet.background_set_B1013_1())
        background.size = CGSize(width: self.frame.width, height: self.frame.height)
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        background.alpha = 1
        background.zPosition = -2
        let textureCycle = SKAction.repeatForever(SKAction.animate(with: self.sheet.background_set_B1013_p1(), timePerFrame: 1))
        background.run(textureCycle, withKey: "starry")
        let moon = SKSpriteNode(texture: self.sheet.background_set_M1010())
        moon.size = CGSize(width: ((moon.texture?.size().width)!)/6, height: ((moon.texture?.size().height)!)/6)
        moon.position = CGPoint(x: self.frame.midX - self.frame.width/3, y: self.frame.midY + self.frame.height/4)
        moon.alpha = 1
        moon.zPosition = -1
        
        self.paddle = JDGamePaddle(forScene: self, size:CGSize(width: 200, height: 200), position: CGPoint(x: self.frame.minX + 80.0, y: self.frame.minY + 80.0))
        self.paddle.delegate = self
        self.player = Player(forScene: self)
        self.keepDetectMove = Timer.scheduledTimer(timeInterval: 0.03, target: self, selector: #selector(keepMove), userInfo: nil, repeats: true)
        self.newCloud()
        self.GenerateCloud = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(newCloud), userInfo: nil, repeats: true)
        self.gameUI = GameUI(forScene: self, forPlayer: self.player)
        
        self.addChild(background)
        self.addChild(moon)
        
        createEnemy()
        player.startFiring()
        
    }
    
    @objc func test(){
        print("hi")
    }
    func createEnemy() {
        let topSpawnPiontY = self.frame.maxY
        let buttomSpawnPointY = self.frame.minY
        let distenceOfSpawnPointY = topSpawnPiontY - buttomSpawnPointY
        let type: EnemyType
        if wave % 2 == 0{
            type = .bat
        } else {
            type = .ghost
        }
        if (wave < enemyCountInEachWave.count){
            for i in 1 ... enemyCountInEachWave[wave]{
                let enemy = Enemy(forScene: self, name: "enemy\(i)", position: CGPoint(x: self.frame.maxX + 40,y: topSpawnPiontY - (distenceOfSpawnPointY * CGFloat(i) / CGFloat(enemyCountInEachWave[wave] + 1))), type: type)
                enemies.append(enemy)
            }
        }
    }
    
    func createBoss() {
        print(CGPoint(x: self.frame.maxX + 60, y: self.frame.midY))
        self.boss = Boss(forScene: self, name: "gura", position: CGPoint(x: self.frame.maxX + 40, y: self.frame.midY))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch collision {
// player been hit
        case categoryBitMask_player | categoryBitMask_enemiesBullets:
            contact.bodyB.node?.removeFromParent()
            self.player.healthChanging(changedValue: -200)
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
                            if targetName.hasPrefix("shark") {
                                self.boss?.sharkRemain -= 1
                            }
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
            if let damage = self.boss?.attackDamage {
                self.player.healthChanging(changedValue: -damage)
                print("boss skill hit")
            }
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
    
    func levelComplete(){
        
    }
    
    @objc func newCloud(){
        let deltaY = CGFloat.random(in: 0...(self.frame.maxY - self.frame.midY)*(2/3))
        
        let cloud = SKSpriteNode()
        
        let texture = self.sheet.background_set_C()
        let type = Int.random(in: 0..<texture.count)
        cloud.texture = texture[type]
        cloud.size = CGSize(width: (cloud.texture?.size().width)!/3, height: (cloud.texture?.size().height)!/3)
        let cloudAnimation = SKAction.moveTo(x: self.frame.minX - 100, duration: 10)
        cloud.position = CGPoint(x: self.frame.maxX + 100, y: self.frame.maxY - deltaY)
        cloud.alpha = 0.6
        cloud.name = "clouds"
        cloud.zPosition = 0
        cloud.run(cloudAnimation, completion: {
            cloud.removeFromParent()
        })
        self.addChild(cloud)
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
        if accelerationVector.dx > 2.2 && self.player.currentDirection != 1{
            self.player.flyForward()
        } else if accelerationVector.dx < -2.2 && self.player.currentDirection != -1{
            self.player.flyBackword()
        } else if accelerationVector.dx < 2.2 && accelerationVector.dx > -2.2 && self.player.currentDirection != 0{
            self.player.flyVertical()
        }
    }
    
    @objc func c_shadowSprint(){
        self.player.shadowSprint()
    }
    
    @objc func c_healing(){
        self.player.healing()
    }
    
    @objc func c_buff(){
        self.player.buff()
    }
    
    @objc func c_pause(){
        let mask = SKShapeNode(rect: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        mask.fillColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.65)
        mask.strokeColor = UIColor.clear
        mask.position = CGPoint(x: self.frame.minX, y: self.frame.minY)
        mask.name = "pause_mask"
        mask.zPosition = 24
        self.addChild(mask)
        gameUI.ctrl_unpause.isHidden = false
        gameUI.ctrl_pause.isHidden = true
        self.run(SKAction.wait(forDuration: 0.03), completion: {
            self.view?.isPaused = true
        })
    }
    
    @objc func c_unpause(){
        self.view?.isPaused = false
        gameUI.ctrl_unpause.isHidden = true
        gameUI.ctrl_pause.isHidden = false
        self.run(SKAction.wait(forDuration: 0.03), completion: {
            self.childNode(withName: "pause_mask")?.removeFromParent()
        })
    }
}


//
//  Boss.swift
//  pj
//
//  Created by mac11 on 2021/6/1.
//  Copyright © 2021 mac11. All rights reserved.
//

import Foundation
import SpriteKit

class Boss {
    let sheet = character_texture()
    var boss: SKSpriteNode!
    let toRender: GameScene
    let nodeName: String
    let healthPointMaxValue: CGFloat = 12000
    var healthPoint: CGFloat = 12000
    let healthBarFrame = SKShapeNode()
    let healthBarRemaining = SKShapeNode()
    var invincible: Bool = true
    var skillTimer: Timer?
    var skillRunning: Bool = false
    var skillParameter: CGFloat = 1
    var sharkRemain: Int = 0
    init(forScene scene: SKScene, name nodeName: String, position nodePosition: CGPoint){
        self.toRender = scene as! GameScene
        self.nodeName = nodeName
        loadTexture()
        self.boss.position = nodePosition
        self.boss.physicsBody = SKPhysicsBody(rectangleOf:CGSize(width: 30, height: 51.6))
        self.boss.physicsBody?.categoryBitMask = self.toRender.categoryBitMask_boss
        self.boss.physicsBody?.collisionBitMask = self.toRender.categoryBitMask_boss
        self.boss.physicsBody?.contactTestBitMask = self.toRender.categoryBitMask_boss | self.toRender.categoryBitMask_playerBullets
        self.boss.zPosition = 10
        self.enterSceneActions()
    }
    func loadTexture(){
        self.boss = SKSpriteNode(texture: sheet.Gura_gura_1(),size: CGSize(width: 60, height: 60))
        self.boss.alpha = 1
        self.boss!.run(SKAction.repeatForever(SKAction.animate(with: sheet.Gura_gura_(), timePerFrame: 0.3)))
        
    }
    func getPosition() ->CGPoint {
        return self.boss.position
    }
    
    func enterSceneActions(){
        let moveInToScreen = SKAction.move(by: CGVector(dx: -100,dy: 0), duration: 2)
        self.boss.run(moveInToScreen, completion: {
            self.invincible = false
            self.healthBarRendering()
            self.skillTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.tryCastingSkill), userInfo: nil, repeats: true)
            //self.poseidonBlast(castingCount: 1)
        })
        self.toRender.addChild(self.boss)
    }
    func healthBarRendering(){
        let width = CGFloat(50.0)
        let height = CGFloat(5.0)
        self.healthBarFrame.path = CGPath(rect: CGRect(x: 0.0, y: CGFloat(-height/2), width: width, height: height), transform: nil)
        self.healthBarFrame.strokeColor = UIColor.lightGray
        self.healthBarFrame.fillColor = UIColor.clear
        self.healthBarFrame.name = "healthBarFrame"
        self.healthBarFrame.position = CGPoint(x: CGFloat(-width / 2), y: 35)
        
        self.healthBarRemaining.path = CGPath(rect: CGRect(x: 0.0, y: CGFloat(-height/2), width: width, height: height), transform: nil)
        self.healthBarRemaining.strokeColor = UIColor.clear
        self.healthBarRemaining.fillColor = UIColor.systemGreen
        self.healthBarRemaining.name = "healthBarRemaining"
        self.healthBarRemaining.position = CGPoint(x: CGFloat(-width / 2), y: 35)
        self.healthBarFrame.zPosition = 15
        self.healthBarRemaining.zPosition = 15
        
        self.boss.addChild(healthBarFrame)
        self.boss.addChild(healthBarRemaining)
    }
    func healthBarChanging(changedValue: CGFloat) -> CGFloat{
        if invincible {
            return self.healthPoint
        }
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
        skillTimer?.invalidate()
        boss.removeFromParent()
    }
    
    func poseidonBlast(castingCount: Int){
        if let playerPosition = self.toRender.childNode(withName: "player")?.position{
            self.skillRunning = true
            let width = toRender.frame.size.width
            let height: CGFloat = 20
            self.boss.texture = sheet.Gura_gura_trident()
            let blast = SKSpriteNode(texture: sheet.skill_beam(), size: CGSize(width: 10, height: height))
            let attackWarning = SKShapeNode()
            blast.position = CGPoint(x: -16, y: 0)
            blast.anchorPoint = CGPoint(x: 1, y: 0)
            blast.zPosition = 4
            blast.name = "blast"
            blast.alpha = 0
            
            attackWarning.path = CGPath(rect: CGRect(x: -(width + 16), y: 0, width: width, height: height), transform: nil)
            attackWarning.fillColor = UIColor.red
            attackWarning.position = CGPoint(x: 0, y: 0)
            attackWarning.zPosition = 3
            attackWarning.name = "warning"
            attackWarning.alpha = 0
            
            blast.physicsBody = SKPhysicsBody(rectangleOf: blast.size)
            blast.physicsBody?.usesPreciseCollisionDetection = true
            blast.physicsBody?.isDynamic = false
            
            blast.physicsBody?.categoryBitMask = self.toRender.categoryBitMask_bossAttack
            blast.physicsBody?.collisionBitMask = self.toRender.categoryBitMask_bossAttack
            blast.physicsBody?.contactTestBitMask = self.toRender.categoryBitMask_bossAttack | self.toRender.categoryBitMask_player
            let moveToTargetY = SKAction.moveTo(y: playerPosition.y, duration: 0.2)
            let casting = SKAction.resize(byWidth: 100, height: 0, duration: 0.05)
            // let repeatCasting = SKAction.repeat(casting, count: Int(ceil(width/40)))
            let wait = SKAction.wait(forDuration: 0.6)
            
            let fadeIn = SKAction.fadeIn(withDuration: 0.15)
            let fade03 = SKAction.fadeAlpha(to: 0.3, duration: 0.1)
            let fadeOut = SKAction.fadeOut(withDuration: 0.15)
            let seq = SKAction.sequence([/*repeatCasting,*/ fadeIn, wait, fadeOut, SKAction.removeFromParent()])
            //self.toRender.addChild(attackWarning)
            self.boss.addChild(attackWarning)
            self.boss.run(moveToTargetY, completion:{
                attackWarning.run(fade03)
//                print("added")
                self.boss.run(wait, completion:{
                    attackWarning.removeFromParent()
//                    print("removed")
                    self.boss.addChild(blast)
                    for i in 1 ... Int(ceil(width/100)){
                        blast.run(casting)
                        blast.size = CGSize(width: blast.size.width + CGFloat(i * 100), height: blast.size.height)
                        blast.physicsBody = SKPhysicsBody(rectangleOf: blast.size, center: CGPoint(x: 1, y: 0))
                        blast.physicsBody?.usesPreciseCollisionDetection = true
                        blast.physicsBody?.isDynamic = false
                        
                        blast.physicsBody?.categoryBitMask = self.toRender.categoryBitMask_bossAttack
                        blast.physicsBody?.collisionBitMask = self.toRender.categoryBitMask_bossAttack
                        blast.physicsBody?.contactTestBitMask = self.toRender.categoryBitMask_bossAttack | self.toRender.categoryBitMask_player
                    }
                    blast.run(seq, completion: {
                        print("Blast wave:\(castingCount)")
                        if(castingCount<4){
                             self.poseidonBlast(castingCount: castingCount+1)
                        } else {
                            self.skillRunning = false
                        }
                    })
                })
            })
        }
    }
    
    func throwingTrident() {
        if let playerPosition = self.toRender.childNode(withName: "player")?.position{
            self.skillRunning = true
            let trident = SKShapeNode()
            trident.path = CGPath(rect: CGRect(x: -40, y: -10, width: 80, height: 20), transform: nil)
            trident.fillColor = UIColor.systemTeal
            trident.position = self.boss.position
            trident.zPosition = 9
            trident.zRotation = -CGFloat.pi/3
            trident.alpha = 0
            trident.name = "trident"
            
            let attackWarning = SKShapeNode(circleOfRadius: 100)
            attackWarning.alpha = 0
            attackWarning.fillColor = UIColor.red
            attackWarning.position = playerPosition
            attackWarning.zPosition = 3
            attackWarning.name = "warning"
            
            let attackArea = SKShapeNode(circleOfRadius: 100)
            attackArea.alpha = 1
            attackArea.fillColor = UIColor.green
            attackArea.position = attackWarning.position
            attackArea.zPosition = 4
            attackArea.name = "area"
            
            attackArea.physicsBody = SKPhysicsBody(circleOfRadius: 100)
            attackArea.physicsBody?.usesPreciseCollisionDetection = true
            attackArea.physicsBody?.isDynamic = false
            
            attackArea.physicsBody?.categoryBitMask = self.toRender.categoryBitMask_bossAttack
            attackArea.physicsBody?.collisionBitMask = self.toRender.categoryBitMask_bossAttack
            attackArea.physicsBody?.contactTestBitMask = self.toRender.categoryBitMask_bossAttack | self.toRender.categoryBitMask_player
            
            let wait = SKAction.wait(forDuration: 1.2)
            let fadeIn = SKAction.fadeIn(withDuration: 0.15)
            let fade03 = SKAction.fadeAlpha(to: 0.3, duration: 0.1)
            let fadeOut = SKAction.fadeOut(withDuration: 0.15)
            let moveToTarget = SKAction.move(to: attackWarning.position, duration: 0.3)
            let seq = SKAction.sequence([/*repeatCasting,*/ fadeIn, wait])
            self.toRender.addChild(trident)
            self.toRender.addChild(attackWarning)
            trident.run(seq)
            attackWarning.run(SKAction.sequence([fade03, wait]), completion: {
                trident.zRotation = atan((attackWarning.position.y - trident.position.y)/(attackWarning.position.x - trident.position.x))
                trident.run(moveToTarget, completion: {
                    attackWarning.run(SKAction.removeFromParent())
                    trident.run(SKAction.removeFromParent())
                    self.toRender.addChild(attackArea)
                    attackArea.run(fadeOut, completion: {
                        self.skillRunning = false
                    })
                })
            })
        }
    }
    
    func summonSharks(){
        if sharkRemain <= 0{
            skillRunning = true
            let topSpawnPiontY = self.toRender.frame.maxY
            let buttomSpawnPointY = self.toRender.frame.minY
            let distenceOfSpawnPointY = topSpawnPiontY - buttomSpawnPointY
            for i in 1 ... 2{
                let shark = Enemy(forScene: self.toRender, name: "shark\(i)", position: CGPoint(x: self.toRender.frame.maxX + 40,y: topSpawnPiontY - (distenceOfSpawnPointY * CGFloat(i) / CGFloat(2 + 1))), type: EnemyType.ghost)
                self.toRender.enemies.append(shark)
                sharkRemain += 1
            }
            let wait = SKAction.wait(forDuration: 3)
            let moveToCenter = SKAction.moveTo(y: self.toRender.frame.midY, duration: 0.2)
            let seq = SKAction.sequence([moveToCenter, wait])
            self.boss.run(seq, completion:{
                self.skillRunning = false
            })
        }
    }
    
    @objc func tryCastingSkill(){
        if skillRunning { return }
        else{
            print("SP:\(skillParameter)")
            switch self.skillParameter {
            case 1:
                poseidonBlast(castingCount: 1)
                self.skillParameter += 1
            case 2:
                throwingTrident()
                self.skillParameter += 1
            case 3:
                summonSharks()
                self.skillParameter = 1
            default: break
                // do nothing
            }
        }
        
    }
}

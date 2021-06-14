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
    let sheet = Asset()
    var boss: SKSpriteNode!
    let toRender: GameScene
    let nodeName: String
    let healthPointMaxValue: CGFloat = 20000
    var healthPoint: CGFloat = 20000
    let healthBarFrame = SKShapeNode()
    let healthBarRemaining = SKShapeNode()
    var attackDamage: CGFloat = 350
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
        self.boss.name = "boss"
        self.boss.physicsBody = SKPhysicsBody(rectangleOf:CGSize(width: 30, height: 51.6))
        self.boss.physicsBody?.categoryBitMask = self.toRender.categoryBitMask_boss
        self.boss.physicsBody?.collisionBitMask = self.toRender.categoryBitMask_boss
        self.boss.physicsBody?.contactTestBitMask = self.toRender.categoryBitMask_boss | self.toRender.categoryBitMask_playerBullets
        self.boss.zPosition = 10
        self.enterSceneActions()
    }
    func loadTexture(){
        self.boss = SKSpriteNode(texture: sheet.Gura_1(),size: CGSize(width: 60, height: 60))
        self.boss.alpha = 1
        let textureCycle = SKAction.repeatForever(SKAction.animate(with: sheet.Gura(), timePerFrame: 0.3))
        self.boss!.run(textureCycle, withKey: "normal_fly")
    }
    
    func getPosition() ->CGPoint {
        return self.boss.position
    }
    
    func enterSceneActions(){
        self.toRender.clearBullet()
        let moveInToScreen = SKAction.move(by: CGVector(dx: -100,dy: 0), duration: 2)
        self.boss.run(moveInToScreen, completion: {
            self.toRender.storyMode()
        })
        self.toRender.addChild(self.boss)
    }
    
    func bossFight(){
        self.invincible = false
        self.healthBarRendering()
        self.skillTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.tryCastingSkill), userInfo: nil, repeats: true)
        //self.poseidonBlast(castingCount: 1)
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
        self.toRender.enemies.forEach{element in
            element.distroyed()
        }
        
        self.toRender.enemies.removeAll()
        var toRemove = [SKNode]()
        self.toRender.children.forEach({
            if let flag = $0.name?.hasPrefix("Gura"){
                if flag == true{
                    toRemove.append($0)
                }
            } else if let flag = $0.name?.hasPrefix("bullet"){
                if flag == true{
                    toRemove.append($0)
                }
            }
        })
        self.toRender.removeChildren(in: toRemove)
        self.skillTimer?.invalidate()
        self.boss.removeFromParent()
        self.toRender.levelComplete()
    }
    
    
    
    func poseidonBlast(castingCount: Int){
        if let playerPosition = self.toRender.childNode(withName: "player")?.position{
            self.skillRunning = true
            let width = toRender.frame.size.width
            let height: CGFloat = 20
            self.boss.removeAction(forKey: "normal_fly")
            self.boss.texture = sheet.Gura_trident()
            let blast = SKSpriteNode(texture: sheet.Gura_Skill_beam(), size: CGSize(width: 10, height: height))
            let blastCore = SKSpriteNode(texture: sheet.Gura_Skill_beamCore(), size: CGSize(width: 32, height: 32))
            let attackWarning = SKShapeNode()
            blast.position = CGPoint(x: -24, y: 0)
            blast.anchorPoint = CGPoint(x: 1, y: 0)
            blast.zPosition = 3
            blast.name = "Gura_blast"
            blast.alpha = 1
            
            blastCore.position = CGPoint(x: -16, y: -6)
            blastCore.anchorPoint = CGPoint(x: 1, y: 0)
            blastCore.zPosition = 4
            blastCore.name = "Gura_blastCore"
            blastCore.alpha = 0
            
            attackWarning.path = CGPath(rect: CGRect(x: -(width + 16), y: 0, width: width, height: height), transform: nil)
            attackWarning.fillColor = UIColor.red
            attackWarning.strokeColor = UIColor.clear
            attackWarning.position = CGPoint(x: 0, y: 0)
            attackWarning.zPosition = 2
            attackWarning.name = "Gura_warning"
            attackWarning.alpha = 0
            
            blast.physicsBody = SKPhysicsBody(rectangleOf: blast.size)
            blast.physicsBody?.usesPreciseCollisionDetection = true
            blast.physicsBody?.isDynamic = false
            
            blast.physicsBody?.categoryBitMask = self.toRender.categoryBitMask_bossAttack
            blast.physicsBody?.collisionBitMask = self.toRender.categoryBitMask_bossAttack
            blast.physicsBody?.contactTestBitMask = self.toRender.categoryBitMask_bossAttack | self.toRender.categoryBitMask_player
            let moveToTargetY = SKAction.moveTo(y: playerPosition.y, duration: 0.2)
            let casting = SKAction.resize(byWidth: 100, height: 0, duration: 0.05)
            let sound = SKAction.playSoundFileNamed("Gura_beam.wav", waitForCompletion: false)
            let wait = SKAction.wait(forDuration: 0.6)
            
            let fadeIn = SKAction.fadeIn(withDuration: 0.15)
            
            let fade03 = SKAction.fadeAlpha(to: 0.3, duration: 0.1)
            let fadeOut = SKAction.fadeOut(withDuration: 0.15)
            let seq = SKAction.sequence([wait, sound, fadeOut, SKAction.removeFromParent()])
            let seq2 = SKAction.sequence([SKAction.wait(forDuration:0.3) ,fadeIn, SKAction.wait(forDuration:0.8), fadeOut, SKAction.removeFromParent()])
            blastCore.run(seq2)
            self.boss.addChild(attackWarning)
            self.boss.run(moveToTargetY, completion:{
                attackWarning.run(fade03)
                self.boss.addChild(blastCore)
                self.boss.run(wait, completion:{
                    attackWarning.removeFromParent()
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
                        if(castingCount<4){
                             self.poseidonBlast(castingCount: castingCount+1)
                        } else {
                            self.skillRunning = false
                            let textureCycle = SKAction.repeatForever(SKAction.animate(with: self.sheet.Gura(), timePerFrame: 0.3))
                            self.boss!.run(textureCycle, withKey: "normal_fly")
                        }
                    })
                })
            })
        }
    }
    
    func throwingTrident() {
        if let playerPosition = self.toRender.childNode(withName: "player")?.position{
            self.skillRunning = true
            self.boss.removeAction(forKey: "normal_fly")
            self.boss.texture = sheet.Gura_handout()
            let trident = SKSpriteNode(texture: sheet.Gura_Skill_trident())
            trident.size = CGSize(width: (trident.texture?.size().width)!/2, height: (trident.texture?.size().height)!/2) 
            trident.position = self.boss.position
            trident.zPosition = 9
            trident.zRotation = +CGFloat.pi/3
            trident.alpha = 0
            trident.name = "Gura_trident"
            
            let attackWarning = SKShapeNode(circleOfRadius: 100)
            attackWarning.alpha = 0
            attackWarning.fillColor = UIColor.red
            attackWarning.strokeColor = UIColor.clear
            attackWarning.position = playerPosition
            attackWarning.zPosition = 3
            attackWarning.name = "Gura_warning"
            
            let attackArea = SKSpriteNode(texture: sheet.Gura_Skill_round_vortex_frame0000(), size: CGSize(width: 200, height: 200))
            attackArea.alpha = 1
            let textureCycle = SKAction.animate(with: sheet.Gura_Skill_round_vortex_frame(), timePerFrame: 0.02)
            attackArea.position = attackWarning.position
            attackArea.zPosition = 4
            attackArea.name = "Gura_area"
            
            attackArea.physicsBody = SKPhysicsBody(circleOfRadius: 100)
            attackArea.physicsBody?.usesPreciseCollisionDetection = true
            attackArea.physicsBody?.isDynamic = false
            
            attackArea.physicsBody?.categoryBitMask = self.toRender.categoryBitMask_bossAttack
            attackArea.physicsBody?.collisionBitMask = self.toRender.categoryBitMask_bossAttack
            attackArea.physicsBody?.contactTestBitMask = self.toRender.categoryBitMask_bossAttack | self.toRender.categoryBitMask_player
            
            let sound = SKAction.playSoundFileNamed("Gura_trident_explode.wav", waitForCompletion: false)
            
            let wait = SKAction.wait(forDuration: 1.2)
            let fadeIn = SKAction.fadeIn(withDuration: 0.3)
            let fade03 = SKAction.fadeAlpha(to: 0.3, duration: 0.1)
            //let fadeOut = SKAction.fadeOut(withDuration: 0.15)
            let moveToTarget = SKAction.move(to: attackWarning.position, duration: 0.3)
            let seq = SKAction.sequence([/*repeatCasting,*/ fadeIn, wait])
            self.toRender.addChild(trident)
            self.toRender.addChild(attackWarning)
            trident.run(seq)
            attackWarning.run(SKAction.sequence([fade03, wait]), completion: {
                trident.zRotation = atan((attackWarning.position.y - trident.position.y)/(attackWarning.position.x - trident.position.x)) + CGFloat.pi / 2
                trident.run(moveToTarget, completion: {
                    attackWarning.run(SKAction.removeFromParent())
                    trident.run(SKAction.removeFromParent())
                    self.toRender.addChild(attackArea)
                    attackArea.run(SKAction.sequence([sound, SKAction.changeVolume(to: 1.2, duration: 0), textureCycle]) , completion: {
                        attackArea.removeFromParent()
                        self.skillRunning = false
                        let textureCycle = SKAction.repeatForever(SKAction.animate(with: self.sheet.Gura(), timePerFrame: 0.3))
                        self.boss!.run(textureCycle, withKey: "normal_fly")
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
            var portals = [SKSpriteNode]()
            let portal = SKSpriteNode(texture: sheet.Gura_Skill_Portal_1())
            portal.alpha = 0
            portal.zPosition = 3
            portal.size = CGSize(width: 55, height: 90)
            let textureCycle = SKAction.repeatForever(SKAction.animate(with: sheet.Gura_Skill_Portal(), timePerFrame: 0.1))
            portal.run(SKAction.sequence([SKAction.fadeAlpha(to: 1, duration: 0.15), textureCycle]), withKey: "summonning")
            for i in 1 ... 2{
                let position = CGPoint(x: self.toRender.frame.maxX - 100,y: topSpawnPiontY - (distenceOfSpawnPointY * CGFloat(i) / CGFloat(2 + 1)))
                portal.position = position
                portal.name = "Gura_portal\(i)"
                portals.append(portal.copy() as! SKSpriteNode)
                self.toRender.addChild(portals[i-1])
                let shark = Enemy(forScene: self.toRender, name: "shark\(i)", position: position, type: .shark)
                self.toRender.enemies.append(shark)
                sharkRemain += 1
            }
            let sound = SKAction.playSoundFileNamed("Gura_Summonning.wav", waitForCompletion: false)
            let wait = SKAction.wait(forDuration: 3)
            let moveToCenter = SKAction.moveTo(y: self.toRender.frame.midY, duration: 0.2)
            let seq = SKAction.sequence([moveToCenter, sound, wait])
            self.boss.run(seq, completion:{
                self.skillRunning = false
                portals.forEach{ element in
                    element.removeAction(forKey: "summonning")
                    element.removeFromParent()
                }
            })
        }
    }
    
    @objc func tryCastingSkill(){
        if skillRunning { return }
        else{
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

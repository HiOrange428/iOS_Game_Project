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
            self.poseidonBlast(castingCount: 0)
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
           
            let width = toRender.frame.size.width
            let height: CGFloat = 20
            self.boss.texture = sheet.Gura_gura_trident()
            let blast = SKSpriteNode(texture: sheet.skill_beam(), size: CGSize(width: 10, height: height))
            let attackWarning = SKShapeNode()
            blast.position = CGPoint(x: -16, y: 0)
            blast.anchorPoint = CGPoint(x: 1, y: 0)
            blast.zPosition = 4
            blast.name = "blast"
            
            attackWarning.path = CGPath(rect: CGRect(x: -(width + 16), y: 0, width: width, height: height), transform: nil)
            attackWarning.fillColor = UIColor.red
            attackWarning.alpha = 0.3
            attackWarning.position = CGPoint(x: 0, y: 0)
            attackWarning.zPosition = 3
            attackWarning.name = "warning"
            
            blast.physicsBody = SKPhysicsBody(rectangleOf: blast.size)
            blast.physicsBody?.usesPreciseCollisionDetection = true
            blast.physicsBody?.isDynamic = false
            
            blast.physicsBody?.categoryBitMask = self.toRender.categoryBitMask_bossAttack
            blast.physicsBody?.collisionBitMask = self.toRender.categoryBitMask_bossAttack
            blast.physicsBody?.contactTestBitMask = self.toRender.categoryBitMask_bossAttack | self.toRender.categoryBitMask_player
            let moveToTargetY = SKAction.moveTo(y: playerPosition.y, duration: 0.4)
            let casting = SKAction.resize(byWidth: 100, height: 0, duration: 0.05)
            // let repeatCasting = SKAction.repeat(casting, count: Int(ceil(width/40)))
            let wait = SKAction.wait(forDuration: 1)
            let seq = SKAction.sequence([/*repeatCasting,*/ wait, SKAction.removeFromParent()])
            //self.toRender.addChild(attackWarning)
            
            self.boss.run(moveToTargetY, completion:{
                self.boss.addChild(attackWarning)
                print("added")
                self.boss.run(wait, completion:{
                    attackWarning.removeFromParent()
                    print("removed")
                    self.boss.addChild(blast)
                    for i in 1 ... Int(ceil(width/100)){
                        blast.run(casting)
                        //print(blast.physicsBody?.si)
                        blast.size = CGSize(width: blast.size.width + CGFloat(i * 100), height: blast.size.height)
                        print(blast.size)
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
                        }
                    })
                })
            })
        }
    }
}

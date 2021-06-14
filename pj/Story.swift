//
//  Story.swift
//  pj
//
//  Created by mac13 on 2021/6/13.
//  Copyright © 2021 mac11. All rights reserved.
//

import Foundation

class Story {
    var nowOn = ""
    var currentLine = 0
    var currentSection = 0
    let section0 = [ // Ame
        "Damn...\nWhere am I?",
        "Seems the tiem mechine has broken again.\nRrrrr...that stubid device.",
        "Due to the accident, I can't even know which timeline I am in...",
        "Need to find all the piece of the mechine to fix it...",
        "Gatta be FAST, Bubba's still hungry!",
        "Let's go...",
    ]
    let section1 = [
        "Hey Gura, do you know me?\nI didn't suppose to meet you here.",
        "Gura...?",
        "I'm the King of the Ocean, also the Lord of the Sky!", //Gura
        "Who are you over there, get out of my way!!", // Gura
        "This shark is totally CRAZYYYY.\nShe's gonna attack me, run!",
    ]
    var sections: Array<[String]>
    
    init() {
        self.sections = [
            section0,
            section1
        ]
    }
    
    func speaker() -> String{
        if currentSection == 1 && (currentLine == 2 || currentLine == 3){
            return "Gura"
        }
        return "Amelia"
    }
    
    func firstLine() -> String{
        nowOn = sections[self.currentSection][0]
        return nowOn
    }
    func nextLine() -> Bool{
        if currentLine < (sections[currentSection].count-1){
            currentLine += 1
            nowOn = sections[currentSection][currentLine]
            return true
        }
        currentLine = 0
        if nextSection(){
            nowOn = sections[currentSection][currentLine]
        }
        return false
        // 段落結尾
    }
    func nextSection() -> Bool{
        if currentSection < sections.count - 1 {
            currentSection += 1
            return true
        }
        return false
        // 文本結尾
    }
}

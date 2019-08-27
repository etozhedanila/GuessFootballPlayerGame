//
//  GameModel.swift
//  TryToGuess
//
//  Created by Виталий Субботин on 10/03/2019.
//  Copyright © 2019 Виталий Субботин. All rights reserved.
//

import UIKit


struct Game {
    
    private static var questionNumber: Int = 0
    
    static func getQuestionNumber() -> Int {
        return self.questionNumber
    }
    
    private static var coins: Int = 0
    
    static func getNumberOfCoins() -> Int {
        return self.coins
    }
    
    private static let footballPlayers = FootballPlayers.footballPlayers
    
    static func getIndexOfSpace() -> Int {
        guard let index = footballPlayers[questionNumber]["indexOfSpace"] as? Int else {
            return -1
        }
        return index
    }
    
    private static func getRandomLetters(count: Int) -> [String]? {
        if count < 1 {
            return nil
        }
        
        let allLetters = ["Q","W","E","R","T","Y","U",   "I","O","P","A","S","D","F","G","H","J","K","L","Z","X","C","V","B","N","M"]
        
        var result: [String] = []
        for _ in 0..<count {
            if let randonLetter = allLetters.randomElement() {
                
                result.append(randonLetter)
            }
        }
        
        return result
    }
    
    static func getLetters() -> [String]? {
        
        guard var correctLetters = footballPlayers[questionNumber]["letters"] as? [String] else {
            return nil
        }
        if getIndexOfSpace() > 0 {
            correctLetters.remove(at: getIndexOfSpace())
        }
        
        
        guard let uncorrectLetters = getRandomLetters(count: 14 - correctLetters.count) else {
            return correctLetters
        }
        
        let result = correctLetters + uncorrectLetters
        
        return result
    }
    
    static func getImage() -> UIImage? {
        
        guard let imageName = footballPlayers[questionNumber]["image"] as? String else {
            return nil
        }
        return UIImage.init(named: imageName)
    }
    
    static func checkAnswer(answer: [String]) -> Bool {
        
        guard let name = self.footballPlayers[questionNumber]["letters"] as? [String] else {
            return false
        }
        
        if answer == name {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.questionNumber += 1
                self.coins += 20
                
                saveGame()
            }
            
            return true
        }
        else {
            return false
        }
    }
    
    static func numberOfLetters() -> Int {
        
        guard let letters = footballPlayers[questionNumber]["letters"] as? [String] else {
            return 0
        }
        
        return letters.count
    }
    
    
    static func openLetter(withIndex ind: Int) -> String? {
        coins -= 50
        saveGame()
        
        guard let answer = footballPlayers[questionNumber]["letters"] as? [String] else {
            return nil
        }
        var index = ind
        if answer[ind] == "_" {
            index += 1
        }
        
        return answer[index]
    }
    
    static func openAnswer() -> [String] {
        coins -= 100
        saveGame()
        guard let answer = footballPlayers[questionNumber]["letters"] as? [String] else {
            return []
        }
        return answer
    }
    

    static func saveGame() {
        if questionNumber >= footballPlayers.count {
            
            questionNumber = 0
        }
        UserDefaults.standard.set(coins, forKey: "coins")
        UserDefaults.standard.set(questionNumber, forKey: "questionNumber")
        UserDefaults.standard.synchronize()
    }
    
    
    static func loadGame() {
        
        coins = UserDefaults.standard.integer(forKey: "coins")
        questionNumber = UserDefaults.standard.integer(forKey: "questionNumber")
        if questionNumber >= footballPlayers.count {
            
            questionNumber = 0
        }
        UserDefaults.standard.synchronize()
    }
}

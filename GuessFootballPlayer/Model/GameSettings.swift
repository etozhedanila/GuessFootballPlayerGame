//
//  GameSettings.swift
//  TryToGuess
//
//  Created by Виталий Субботин on 28/03/2019.
//  Copyright © 2019 Виталий Субботин. All rights reserved.
//

import Foundation

class GameSettings {
    
    private let ud = UserDefaults.standard
    
    var isMusicOn = true  
    
    var isMusicEffectsOn = true
    
    static let shared = GameSettings()
    
    func saveSettings() {
        
        ud.set(isMusicOn, forKey: "isMusicOn")
        ud.set(isMusicEffectsOn, forKey: "isMusicEffectsOn")
        ud.synchronize()
    }
    
    func loadSettings() {
        isMusicOn = ud.bool(forKey: "isMusicOn")
        isMusicEffectsOn = ud.bool(forKey: "isMusicEffectsOn")
        ud.synchronize()
    }
    
    private init() {
        loadSettings()
    }
    
}

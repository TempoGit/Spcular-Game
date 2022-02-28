//
//  LanguageHandler.swift
//  Specular-Game
//
//  Created by Salvatore Manna on 22/02/22.
//

import Foundation
import SwiftUI

class LanguageHandler {
    
    static let instance = LanguageHandler()
    
    @AppStorage("language") var language: String = "English"
    
    public let settingsLabelEnglish = "Settings"
    public let closePauseEnglish = "Close"
    public let pauseLabelEnglish = "Pause"
    public let objectiveEnglish = "Hello there!"
    public let objectiveEnglish2 = "You are a kid that has"
    public let objectiveEnglish3 = "to reach the closet at the end of the level."
    public let objectiveEnglish4 = "Interact with the objects and furniture in"
    public let objectiveEnglish5 = "the scene, you might find something useful..."
    public let objectiveEnglish6 = "...or you might encounter a gruesome death! :)"
    
    public let settingsLabelItalian = "Impostazioni"
    public let closePauseItalian = "Chiudi"
    public let pauseLabelItalian = "Pausa"
    public let objectiveItalian = "Ciao!"
    public let objectiveItalian2 = "Sei un fanciullo che deve"
    public let objectiveItalian3 = "raggiungere lo sgabuzzino alla fine del livello."
    public let objectiveItalian4 = "Interagisci con gli oggetti e i mobili nella"
    public let objectiveItalian5 = "scena, potresti trovare qualcosa di utile..."
    public let objectiveItalian6 = "...oppure incotrare una morte orribile! :)"
    
    
    public let objectiveEnglish11 = "A very old key!"
    public let objectiveEnglish21 = "L"
    public let objectiveEnglish31 = ""
    
    public let objectiveItalian11 = "Una chiave molto vecchia!"
    public let objectiveItalian21 = ""
    public let objectiveItalian31 = ""
    
}

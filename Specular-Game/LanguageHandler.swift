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
    
//    chiave
    public let objectiveEnglish11 = "It's a very small key,\nit could open a \nvery small door "
//    public let objectiveEnglish21 = "L"
//    public let objectiveEnglish31 = ""
    
    public let objectiveItalian11 = "È una chiave molto piccola,\npotrebbe aprire una \nporta molto piccola"
//    public let objectiveItalian21 = ""
//    public let objectiveItalian31 = ""
    
//  diario
    public let objectiveEnglishDiary = "Dear Diary,"
    public let objectiveEnglishDiary1 = "It's moving day and I couldn't be happier! \nI really want to explore the whole house and \nsee what secrets is going to hide!"
    public let objectiveEnglishDiary2 = "Will keep you informed."
    
    public let objectiveItalianDiary = "Caro Diario,"
    public let objectiveItalianDiary1 = "è la giornata del trasloco e non potevo essere più felice! \nHo tanta voglia di esporare tutta la casa e \nvedere che segreti nasconde!"
    public let objectiveItalianDiary2 = "Ti terrò informato."
//    doll
    public let objectiveEnglishDoll = "Such a creepy looking doll! \nWill it be safe to pick it?,"
//    public let objectiveEnglishDoll1 = "L"
//    public let objectiveEnglishDoll2 = ""
    
    public let objectiveItalianDoll = "Una bambola dall'aspetto \nraccapricciante! \nSarà sicuro prenderla?"
//    public let objectiveItalianDoll1 = "dall'aspetto raccapricciante!"
//    public let objectiveItalianDoll2 = "Sarà sicuro prenderla?"
    
    
    public let infoTextOneEnglish = "Hello there! \n\nYou are a kid that has to reach the closet at the end of the level. \n\nInteract with the objects and furniture in the scene, you might find something useful... \n\n...or you might encounter a gruesome death! :)"
    public let infoTextTwoEnglish = "You can move by tapping and holding on the screen. \n\nTo interact with the objects simply click on them."
 
    public let infoTextOneItalian = "Ciao! \n\nSei un fanciullo che deve raggiungere lo sgabuzzino alla fine del livello. \n\nInteragisci con gli oggetti e i mobili nella scena, potresti trovare qualcosa di utile... \n\n...oppure incotrare una morte orribile! :)"
    public let infoTextTwoItalian = "Per muoverti clicca sullo schermo e tieni premuto. \n\nPer interagire con gli oggetti cliccaci sopra."

}

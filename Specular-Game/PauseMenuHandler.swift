//
//  PauseMenuHandler.swift
//  Specular-Game
//
//  Created by Salvatore Manna on 21/02/22.
//

import Foundation
import SpriteKit


//Classe all'interno della quale vengono definiti i nodi per creare il menu di pausa in ogni scena

class PauseMenuHandler {
    
    //Istanza della classe, su questa istanza richiamo variabili e funzioni della classe
    static let instance = PauseMenuHandler()
    
    //Nodi del menu di pausa
    
    public let settingsBackground = SKSpriteNode(imageNamed: "DropMenu2")
    
    public let backgroundSettings = SKShapeNode(rectOf: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
    
    public let settingsLabel = SKLabelNode(text: "Settings")
    
    public let pauseLabel = SKSpriteNode(imageNamed: "PauseEnglish")
    public let pauseLabelItalian = SKSpriteNode(imageNamed: "PausaItalian")
    
    public let musicIcon = SKSpriteNode(imageNamed: "MusicOn")
    public let musicIconOff = SKSpriteNode(imageNamed: "MusicOff")
    
    public let sfxButton = SKSpriteNode(imageNamed: "SfxOn")
    public let sfxButtonOff = SKSpriteNode(imageNamed: "SfxOff")
    
    public let languageButton = SKSpriteNode(imageNamed: "EnglishFlag")
    public let languageButtonItalian = SKSpriteNode(imageNamed: "ItalianFlag")
    
    public let mainMenuButtonEnglish = SKSpriteNode(imageNamed: "MainMenu")
    public let mainMenuButtonItalian = SKSpriteNode(imageNamed: "MenuPrincipale")
    
    public let closeSettingsButton = SKLabelNode(text: "Close")
//    public let closePauseButton = SKLabelNode(text: "Close")
    public let closePauseButtonEnglish = SKSpriteNode(imageNamed: "Close")
    public let closePauseButtonItalian = SKSpriteNode(imageNamed: "Chiudi")

    
    public let goToMainMenuButton = SKLabelNode(text: "Go to Main Menu")
    
    
    
    
    
    public let closePauseMenu = SKShapeNode(rectOf: CGSize(width: 30, height: 30))
//    public let closePauseMenu = SKLabelNode(text: "Close pause menu")
    public let goBackToMenu = SKLabelNode(text: "Go back to main menu")
//    public let languageButton = SKLabelNode(text: "Language Button")
    let languageLabel = SKLabelNode(text: "Language")
    let languageSelectionButton = SKLabelNode(text: "English")
    public let volumeOnButton = SKSpriteNode(imageNamed: "VolumeOn")
    public let volumeOffButton = SKSpriteNode(imageNamed: "VolumeOff")
    public let backgroundPause = SKShapeNode(rectOf: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
    public let pauseSquare = SKShapeNode(rectOf: CGSize(width: UIScreen.main.bounds.size.width*0.7, height: UIScreen.main.bounds.size.height*0.4))
    //Variabile che uso per vedere se è da quando ho aperto l'appliczione ho già impostato le proprietà di base dei nodi
    //Dopo aver impostato le proprietà dei nodi per la prima volta la metto a true
    public var firstSet = false
    
    //Funzione che si occupa di impostare le proprietà dei nodi, dimensioni, tag, nomi, trasparenza etc...
    func initializeNodeSettings (){
        if(!firstSet){
            //Impostazioni delle proprietà dei nodi
            backgroundSettings.fillColor = .black
            backgroundSettings.strokeColor = .black
            backgroundSettings.alpha = 0.45
            backgroundSettings.zPosition = 100
            backgroundSettings.name = "closePause"
            
            settingsBackground.zPosition = 101
            
            pauseLabel.zPosition = 102
            pauseLabelItalian.zPosition = 102
            
            musicIcon.zPosition = 102
            musicIcon.name = "musicButton"
            musicIconOff.zPosition = 102
            musicIconOff.name = "musicButton"
            
            sfxButton.zPosition = 102
            sfxButton.name = "sfxButton"
            sfxButtonOff.zPosition = 102
            sfxButtonOff.name = "sfxButton"
            
            languageButton.zPosition = 102
            languageButton.name = "languageButton"
            languageButtonItalian.zPosition = 102
            languageButtonItalian.name = "languageButton"
            
            mainMenuButtonEnglish.zPosition = 102
            mainMenuButtonEnglish.name = "mainMenu"
            mainMenuButtonItalian.zPosition = 102
            mainMenuButtonItalian.name = "mainMenu"
            
            closeSettingsButton.zPosition = 102
            closeSettingsButton.fontColor = .white
            closeSettingsButton.fontSize = 32
            closeSettingsButton.name = "closePause"
            
            closePauseButtonItalian.zPosition = 102
            closePauseButtonItalian.name = "closePause"
            closePauseButtonEnglish.zPosition = 102
            closePauseButtonEnglish.name = "closePause"
            
//            closePauseMenu.zPosition = 102
//            closePauseMenu.fontSize = 32
//            closePauseMenu.strokeColor = .white
//            closePauseMenu.fillColor = .white
//            closePauseMenu.name = "closePause"
//            goBackToMenu.zPosition = 102
//            goBackToMenu.fontSize = 26
//            goBackToMenu.fontColor = .white
//            goBackToMenu.name = "goToMenu"
//            languageLabel.zPosition = 102
//            languageLabel.fontSize = 26
//            languageLabel.fontColor = .white
//            languageSelectionButton.zPosition = 102
//            languageSelectionButton.fontColor = .white
//            languageSelectionButton.fontSize = 26
//            languageSelectionButton.name = "languageButton"
//            volumeOffButton.xScale = 0.2
//            volumeOffButton.yScale = 0.2
//            volumeOffButton.name = "volumeButton"
//            volumeOffButton.zPosition = 102
//            volumeOnButton.xScale = 0.2
//            volumeOnButton.yScale = 0.2
//            volumeOnButton.name = "volumeButton"
//            volumeOnButton.zPosition = 102
//            pauseSquare.fillColor = .black
//            pauseSquare.strokeColor = .black
//            pauseSquare.zPosition = 101
//            backgroundPause.fillColor = .black
//            backgroundPause.strokeColor = .black
//            backgroundPause.alpha = 0.6
//            backgroundPause.zPosition = 100
//            backgroundPause.name = "closePause"
            //Dopo aver impostato le proprietà dei nodi metto questa variabile a true, così non rifaccio più questa operazione quando richiamo questa funzione
            firstSet = true
        }
    }
}

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
            closePauseMenu.zPosition = 102
//            closePauseMenu.fontSize = 26
            closePauseMenu.strokeColor = .white
            closePauseMenu.fillColor = .white
            closePauseMenu.name = "closePause"
            goBackToMenu.zPosition = 102
            goBackToMenu.fontSize = 26
            goBackToMenu.fontColor = .white
            goBackToMenu.name = "goToMenu"
            languageLabel.zPosition = 102
            languageLabel.fontSize = 26
            languageLabel.fontColor = .white
            languageSelectionButton.zPosition = 102
            languageSelectionButton.fontColor = .white
            languageSelectionButton.fontSize = 26
            languageSelectionButton.name = "languageButton"
            volumeOffButton.xScale = 0.2
            volumeOffButton.yScale = 0.2
            volumeOffButton.name = "volumeButton"
            volumeOffButton.zPosition = 102
            volumeOnButton.xScale = 0.2
            volumeOnButton.yScale = 0.2
            volumeOnButton.name = "volumeButton"
            volumeOnButton.zPosition = 102
            pauseSquare.fillColor = .black
            pauseSquare.strokeColor = .black
            pauseSquare.zPosition = 101
            backgroundPause.fillColor = .black
            backgroundPause.strokeColor = .black
            backgroundPause.alpha = 0.6
            backgroundPause.zPosition = 100
            backgroundPause.name = "closePause"
            //Dopo aver impostato le proprietà dei nodi metto questa variabile a true, così non rifaccio più questa operazione quando richiamo questa funzione
            firstSet = true
        }
    }
}

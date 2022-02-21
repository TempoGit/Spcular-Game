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
    public let closePauseMenu = SKLabelNode(text: "Close pause menu")
    public let goBackToMenu = SKLabelNode(text: "Go back to main menu")
    public let languageButton = SKLabelNode(text: "Language Button")
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
            closePauseMenu.fontSize = 26
            closePauseMenu.fontColor = .white
            closePauseMenu.name = "closePause"
            goBackToMenu.zPosition = 102
            goBackToMenu.fontSize = 26
            goBackToMenu.fontColor = .white
            goBackToMenu.name = "goToMenu"
            languageButton.zPosition = 102
            languageButton.fontSize = 26
            languageButton.fontColor = .white
            volumeOffButton.xScale = 0.2
            volumeOffButton.yScale = 0.2
            volumeOffButton.name = "volumeOff"
            volumeOffButton.zPosition = 102
            volumeOnButton.xScale = 0.2
            volumeOnButton.yScale = 0.2
            volumeOnButton.name = "volumeOn"
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
        //Dopo aver impostato le prorpietà dei nodi imposto la trasparenza dei bottoni per gestire l'audio, questa operazione viene fatta sempre, anche se non è la prima volta che inizializzo le impostazioni dei nodi
        if(musicHandler.instance.mutedMusic){
            //Se la musica è disattivata allora imposto la trasparenza del bottone volumeOnButton a metà e quella del volumeOffButton a 1
            volumeOnButton.alpha = 0.5
            volumeOffButton.alpha = 1
        } else if(!musicHandler.instance.mutedMusic) {
            //Se la musica non è disattivata allora imposto la trasparenza dei bottoni al contrario di come ho fatto prima
            volumeOnButton.alpha = 1
            volumeOffButton.alpha = 0.5
        }
    }
}

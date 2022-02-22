//
//  GameScene.swift
//  Specular-Game
//
//  Created by Salvatore Manna on 18/02/22.
//



/*

 
            GIGGINO GRANDE GRANDE
            
            Piccolo piccolo
 
 
 */

import SpriteKit
import GameplayKit
import SwiftUI

//Changed

class GameScene: SKScene {
    
    @AppStorage("language") var language: String = "English"
    
    //Variabili che compongono l'home page, background, logo, riflessi e scritta
    let squareUp = SKShapeNode(rectOf: CGSize(width: 200, height: 200))
    let backgroundScreenBottomPart = SKShapeNode(rectOf: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.3))
    let backgroundScreen = SKSpriteNode(imageNamed: "Gradient")
    let playButton = SKSpriteNode(imageNamed: "SquarePlay4")
    let houseSpriteMenu = SKSpriteNode(imageNamed: "House.png")
    let houseSpriteMenuMirrored = SKSpriteNode(imageNamed: "House.png")
    var gameTitle = SKLabelNode(text: "SPECULAR")
    let gameTitleMirrored = SKLabelNode(text: "SPECULAR")
    
    //Variabili che compongono il menu di impostazioni contenenti impostazioni per l'audio e per la lingua
    let settingsButton = SKShapeNode(rectOf: CGSize(width: 50, height: 50))
    let closeSettingsButton = SKShapeNode(rectOf: CGSize(width: 30, height: 30))
    
    let backgroundSettings = SKShapeNode(rectOf: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
    let settingsSquare = SKShapeNode(rectOf: CGSize(width: UIScreen.main.bounds.size.width*0.7, height: UIScreen.main.bounds.size.height*0.4))
    
    let volumeOnButton = SKSpriteNode(imageNamed: "VolumeOn")
    let volumeOffButton = SKSpriteNode(imageNamed: "VolumeOff")
    
    let languageLabel = SKLabelNode(text: "Language")
    let languageSelectionLabel = SKLabelNode(text: "English")
    
    let italianFlag = SKSpriteNode(imageNamed: "ItalyFlag")
    let ukFlag = SKSpriteNode(imageNamed: "UkFlag")
    
    override func didMove(to view: SKView) {
        backgroundScreen.size.width = size.width
        backgroundScreen.size.height = size.height
        backgroundScreen.position = CGPoint(x: size.width*0.5,y: size.height*0.5)
        addChild(backgroundScreen)
        
        backgroundScreenBottomPart.position = CGPoint(x: size.width*0.5,y: size.height*0.15)
        backgroundScreenBottomPart.fillColor = .black
        backgroundScreenBottomPart.strokeColor = .black
        addChild(backgroundScreenBottomPart)
        
        houseSpriteMenu.position = CGPoint(x: size.width*0.5, y: size.height*0.45)
        
        houseSpriteMenuMirrored.position = CGPoint(x: size.width*0.5, y: size.height*0.055)
        houseSpriteMenuMirrored.alpha = 0.2
        houseSpriteMenuMirrored.zRotation = 3.14
        houseSpriteMenuMirrored.xScale = -1
        
        gameTitle.position = CGPoint(x: size.width*0.5, y: size.height*0.8)
        gameTitle.fontName = "SFMono"
        gameTitle.fontSize = 50
        gameTitle.fontColor = .systemGray
        
        
        gameTitleMirrored.position = CGPoint(x: size.width*0.5,y: size.height*0.8)
        gameTitleMirrored.fontSize = 50
        gameTitleMirrored.fontName = "SFMono"
        gameTitleMirrored.zRotation = 3.14
        gameTitleMirrored.xScale = -1.0
        gameTitleMirrored.fontColor = .black
        
        playButton.position = CGPoint(x: size.width*0.5,y: size.height*0.15)
        playButton.size = CGSize(width: size.width*0.25, height: size.width*0.25)
        playButton.name = "playGameName"
        
        
        //Impostazioni relative al menu di opzioni
        settingsButton.fillColor = .white
        settingsButton.strokeColor = .white
        settingsButton.position = CGPoint(x: size.width*0.85, y: size.height*0.9)
        settingsButton.name = "settingsButton"
        
        settingsSquare.fillColor = .black
        settingsSquare.strokeColor = .black
        settingsSquare.zPosition = 8
        settingsSquare.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        backgroundSettings.fillColor = .black
        backgroundSettings.strokeColor = .black
        backgroundSettings.alpha = 0.6
        backgroundSettings.zPosition = 7
        backgroundSettings.name = "closeSettings"
        backgroundSettings.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        
        closeSettingsButton.fillColor = .white
        closeSettingsButton.strokeColor = .white
        closeSettingsButton.zPosition = 10
        closeSettingsButton.position = CGPoint(x: size.width*0.28, y: size.height*0.65)
        closeSettingsButton.name = "closeSettings"
        
        volumeOnButton.xScale = 0.2
        volumeOnButton.yScale = 0.2
        volumeOnButton.name = "volumeButton"
        volumeOnButton.zPosition = 10
        volumeOnButton.position = CGPoint(x: size.width*0.35,y: size.height*0.55 )
        
        volumeOffButton.xScale = 0.2
        volumeOffButton.yScale = 0.2
        volumeOffButton.name = "volumeButton"
        volumeOffButton.zPosition = 10
        volumeOffButton.position = CGPoint(x: size.width*0.35,y: size.height*0.55 )

        languageLabel.zPosition = 10
        languageLabel.fontColor = .white
        languageLabel.position = CGPoint(x: size.width*0.35, y: size.height*0.45)
        languageSelectionLabel.zPosition = 10
        languageSelectionLabel.fontColor = .white
        languageSelectionLabel.position = CGPoint(x: size.width*0.65, y: size.height*0.45)
        languageSelectionLabel.name = "languageButton"
        
        
        //Aggiungo gli elementi alla scena
        addChild(houseSpriteMenu)
        addChild(houseSpriteMenuMirrored)
        addChild(gameTitle)
        addChild(gameTitleMirrored)
        addChild(playButton)
        addChild(settingsButton)
        
        //Avvio la musica
        musicHandler.instance.playBackgroundMusicMenu()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{
            return
        }
        
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        if(touchedNode.name == "playGameName"){
            musicHandler.instance.stopBackgroundMusicMenu()
            let startGameScene = Level00(size: size)
            view?.presentScene(startGameScene)
        }
        
        if(touchedNode.name == "settingsButton"){
            addChild(backgroundSettings)
            addChild(settingsSquare)
            if(musicHandler.instance.mutedMusic == true){
                addChild(volumeOffButton)
            } else if (musicHandler.instance.mutedMusic == false){
                addChild(volumeOnButton)
            }
            if(language == "Italian"){
                languageLabel.text = "Lingua"
                languageSelectionLabel.text = "Italiano"
            } else if(language == "English") {
                languageLabel.text = "Language"
                languageSelectionLabel.text = "English"
            }
            addChild(languageLabel)
            addChild(languageSelectionLabel)
            addChild(closeSettingsButton)
        }
        
        if(touchedNode.name == "volumeButton"){
            if(musicHandler.instance.mutedMusic == true){
                volumeOffButton.removeFromParent()
                musicHandler.instance.unmuteBackgroundMusic()
                addChild(volumeOnButton)
            } else if (!musicHandler.instance.mutedMusic){
                volumeOnButton.removeFromParent()
                musicHandler.instance.muteBackgroundMusic()
                addChild(volumeOffButton)
            }
        }
        
        if (touchedNode.name == "languageButton"){
            if(language == "English"){
                language = "Italian"
            } else if(language == "Italian"){
                language = "English"
            }
            languageLabel.removeFromParent()
            languageSelectionLabel.removeFromParent()
            if(language == "English"){
                languageLabel.text = "Language"
                languageSelectionLabel.text = "English"
            } else if(language == "Italian"){
                languageLabel.text = "Lingua"
                languageSelectionLabel.text = "Italiano"
            }
            addChild(languageLabel)
            addChild(languageSelectionLabel)
        }
        
        if(touchedNode.name == "closeSettings"){
            settingsSquare.removeFromParent()
            backgroundSettings.removeFromParent()
            if(musicHandler.instance.mutedMusic){
                volumeOffButton.removeFromParent()
            } else {
                volumeOnButton.removeFromParent()
            }
            closeSettingsButton.removeFromParent()
            languageLabel.removeFromParent()
            languageSelectionLabel.removeFromParent()
        }
       
    }

}

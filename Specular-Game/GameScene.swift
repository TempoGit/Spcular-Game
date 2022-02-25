//
//  GameScene.swift
//  Specular-Game
//
//  Created by Salvatore Manna on 18/02/22.
//



import SpriteKit
import GameplayKit
import SwiftUI



class GameScene: SKScene {
    
    let myGray = UIColor(red: 129/255, green: 129/255, blue: 129/255, alpha: 1.0)
    
    
    
    //Variabili che compongono l'home page, background, logo, riflessi e scritta
    let squareUp = SKShapeNode(rectOf: CGSize(width: 200, height: 200))
    let backgroundScreenBottomPart = SKShapeNode(rectOf: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.3))
    let backgroundScreen = SKSpriteNode(imageNamed: "Gradient")
    let playButton = SKSpriteNode(imageNamed: "PlayButton")
//    let playButton = SKSpriteNode(imageNamed: "Start")
    let door = SKSpriteNode(imageNamed: "MainMenuBackground")
//    let houseSpriteMenuMirrored = SKSpriteNode(imageNamed: "House.png")
    var gameTitleWithReflection = SKSpriteNode(imageNamed: "Title_white_resized")
    
    
    
    //Variabili che compongono il menu di impostazioni contenenti impostazioni per l'audio e per la lingua
    let settingsButton = SKSpriteNode(imageNamed: "Setting")
    
    let settingsBackground = SKSpriteNode(imageNamed: "DropMenu2")
    
    let backgroundSettings = SKShapeNode(rectOf: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
    
    let settingsLabel = SKLabelNode(text: "Settings")
    
    let musicIcon = SKSpriteNode(imageNamed: "MusicOn")
    
    let sfxButton = SKSpriteNode(imageNamed: "SfxOn")
    
    let languageButton = SKSpriteNode(imageNamed: "EnglishFlag")
    
//    let closeSettingsButton = SKLabelNode(text: "Close")
    let closeSettingsButton = SKSpriteNode(imageNamed: "Close")

    
    
    override func didMove(to view: SKView) {
        backgroundScreen.size.width = size.width
        backgroundScreen.size.height = size.height
        backgroundScreen.position = CGPoint(x: size.width*0.5,y: size.height*0.5)
        addChild(backgroundScreen)
        
        backgroundScreenBottomPart.position = CGPoint(x: size.width*0.5,y: size.height*0.15)
        backgroundScreenBottomPart.fillColor = .black
        backgroundScreenBottomPart.strokeColor = .black
        addChild(backgroundScreenBottomPart)
        
        door.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        door.xScale = 0.3
        door.yScale = 0.3
        
//        houseSpriteMenuMirrored.position = CGPoint(x: size.width*0.5, y: size.height*0.055)
//        houseSpriteMenuMirrored.alpha = 0.2
//        houseSpriteMenuMirrored.zRotation = 3.14
//        houseSpriteMenuMirrored.xScale = -1
//
        playButton.position = CGPoint(x: size.width*0.5,y: size.height*0.1)
        playButton.size = CGSize(width: size.width*0.25, height: size.width*0.25)
        playButton.name = "playGameName"
        
        gameTitleWithReflection.position = CGPoint(x: size.width*0.5, y: size.height*0.85)
        gameTitleWithReflection.xScale = 0.3
        gameTitleWithReflection.yScale = 0.3

        
        //Impostazioni relative al menu di opzioni
        settingsButton.position = CGPoint(x: size.width*0.88, y: size.height*0.92)
        settingsButton.xScale = size.width*0.00015
        settingsButton.yScale = size.width*0.00015
        settingsButton.name = "settingsButton"
        
        backgroundSettings.fillColor = .black
        backgroundSettings.strokeColor = .black
        backgroundSettings.alpha = 0.45
        backgroundSettings.zPosition = 7
        backgroundSettings.name = "closeSettings"
        backgroundSettings.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        
        settingsBackground.zPosition = 8
        settingsBackground.position = CGPoint(x: size.width*0.5, y:size.height*0.5)
//        settingsBackground.xScale = 0.45
//        settingsBackground.yScale = 0.45
        settingsBackground.xScale = size.width*0.0011
        settingsBackground.yScale = size.width*0.0011

        
        settingsLabel.zPosition = 9
        settingsLabel.fontColor = .white
        settingsLabel.fontSize = 32
        settingsLabel.position = CGPoint(x: size.width*0.51, y: size.height*0.63)
        
        musicIcon.position = CGPoint(x: size.width*0.675, y: size.height*0.55)
        musicIcon.zPosition = 9
        musicIcon.xScale = size.width*0.0005
        musicIcon.yScale = size.width*0.0005
        musicIcon.name = "musicButton"
        
        sfxButton.position = CGPoint(x: size.width*0.38, y: size.height*0.55)
        sfxButton.zPosition = 9
        sfxButton.xScale = size.width*0.0005
        sfxButton.yScale = size.width*0.0005
        sfxButton.name = "sfxButton"
        
        languageButton.position = CGPoint(x: size.width*0.51, y: size.height*0.43)
        languageButton.zPosition = 9
        languageButton.xScale = size.width*0.00035
        languageButton.yScale = size.width*0.00035
        languageButton.name = "languageButton"
        
        
        closeSettingsButton.zPosition = 9
        closeSettingsButton.xScale = size.width*0.0007
        closeSettingsButton.yScale = size.width*0.0007
        closeSettingsButton.position = CGPoint(x: size.width*0.51, y: size.height*0.31)
        closeSettingsButton.name = "closeSettings"
        
        
        //Aggiungo gli elementi alla scena
        addChild(door)
//        addChild(houseSpriteMenuMirrored)
       addChild(gameTitleWithReflection)
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
            
            if(musicHandler.instance.mutedMusic == true){
                musicIcon.run(SKAction.setTexture(SKTexture(imageNamed: "MusicOff")))
            } else if (musicHandler.instance.mutedMusic == false){
                musicIcon.run(SKAction.setTexture(SKTexture(imageNamed: "MusicOn")))
            }
            
            if(musicHandler.instance.mutedSFX == true){
                sfxButton.run(SKAction.setTexture(SKTexture(imageNamed: "SfxOff")))
            } else if (musicHandler.instance.mutedSFX == false){
                sfxButton.run(SKAction.setTexture(SKTexture(imageNamed: "SfxOn")))
            }
            
            if(LanguageHandler.instance.language == "Italian"){
                languageButton.run(SKAction.setTexture(SKTexture(imageNamed: "ItalianFlag")))
                closeSettingsButton.run(SKAction.setTexture(SKTexture(imageNamed: "Chiudi")))
            } else if(LanguageHandler.instance.language == "English") {
                languageButton.run(SKAction.setTexture(SKTexture(imageNamed: "EnglishFlag")))
                closeSettingsButton.run(SKAction.setTexture(SKTexture(imageNamed: "Close")))
            }

            
            addChild(settingsBackground)
            addChild(backgroundSettings)
            addChild(settingsLabel)
            addChild(musicIcon)
            addChild(sfxButton)
            addChild(languageButton)
            addChild(closeSettingsButton)
        }
        
        if(touchedNode.name == "musicButton"){
            if(musicHandler.instance.mutedMusic == true){
                musicHandler.instance.unmuteBackgroundMusic()
                musicIcon.run(SKAction.setTexture(SKTexture(imageNamed: "MusicOn")))
            } else if (!musicHandler.instance.mutedMusic){
                musicHandler.instance.muteBackgroundMusic()
                musicIcon.run(SKAction.setTexture(SKTexture(imageNamed: "MusicOff")))
            }
        }
        
        if(touchedNode.name == "sfxButton"){
            if(musicHandler.instance.mutedSFX == true){
                musicHandler.instance.unmuteSfx()
                sfxButton.run(SKAction.setTexture(SKTexture(imageNamed: "SfxOn")))
            } else if (!musicHandler.instance.mutedSFX){
                musicHandler.instance.muteSfx()
                sfxButton.run(SKAction.setTexture(SKTexture(imageNamed: "SfxOff")))
            }
        }
        
        if (touchedNode.name == "languageButton"){
            if(LanguageHandler.instance.language == "English"){
                LanguageHandler.instance.language = "Italian"
                languageButton.run(SKAction.setTexture(SKTexture(imageNamed: "ItalianFlag")))
                settingsLabel.removeFromParent()
                closeSettingsButton.removeFromParent()
                settingsLabel.text = LanguageHandler.instance.settingsLabelItalian
                closeSettingsButton.run(SKAction.setTexture(SKTexture(imageNamed: "Chiudi")))
                addChild(settingsLabel)
                addChild(closeSettingsButton)
            } else if(LanguageHandler.instance.language == "Italian"){
                LanguageHandler.instance.language = "English"
                settingsLabel.removeFromParent()
                closeSettingsButton.removeFromParent()
                settingsLabel.text = LanguageHandler.instance.settingsLabelEnglish
                closeSettingsButton.run(SKAction.setTexture(SKTexture(imageNamed: "Close")))
                addChild(settingsLabel)
                addChild(closeSettingsButton)
                languageButton.run(SKAction.setTexture(SKTexture(imageNamed: "EnglishFlag")))
            }
        }
        
        
        if(touchedNode.name == "closeSettings"){
            backgroundSettings.removeFromParent()
            settingsBackground.removeFromParent()
            settingsLabel.removeFromParent()
            musicIcon.removeFromParent()
            sfxButton.removeFromParent()
            languageButton.removeFromParent()
            closeSettingsButton.removeFromParent()
        }
       
    }

}

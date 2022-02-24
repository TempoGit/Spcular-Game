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
    
    let myGray = UIColor(red: 129, green: 129, blue: 129, alpha: 1)
    
    @AppStorage("language") var language: String = "English"
    
    //Variabili che compongono l'home page, background, logo, riflessi e scritta
    let squareUp = SKShapeNode(rectOf: CGSize(width: 200, height: 200))
    let backgroundScreenBottomPart = SKShapeNode(rectOf: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.3))
    let backgroundScreen = SKSpriteNode(imageNamed: "Gradient")
    let playButton = SKSpriteNode(imageNamed: "SquarePlay4")
    let houseSpriteMenu = SKSpriteNode(imageNamed: "House.png")
    let houseSpriteMenuMirrored = SKSpriteNode(imageNamed: "House.png")
    var gameTitleWithReflection = SKSpriteNode(imageNamed: "Title_white_resized")
    
    
    
    //Variabili che compongono il menu di impostazioni contenenti impostazioni per l'audio e per la lingua
    let settingsButton = SKShapeNode(rectOf: CGSize(width: 50, height: 50))
    let closeSettingsButton = SKShapeNode(rectOf: CGSize(width: 30, height: 30))
    
    let backgroundSettings = SKShapeNode(rectOf: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
    let settingsSquare = SKShapeNode(rectOf: CGSize(width: UIScreen.main.bounds.size.width*0.70, height: UIScreen.main.bounds.size.height*0.4))
    let settingsSquareBorder = SKShapeNode(rectOf: CGSize(width: UIScreen.main.bounds.size.width*0.71, height: UIScreen.main.bounds.size.height*0.41))
    let settingsSquareBorder2 = SKShapeNode(rectOf: CGSize(width: UIScreen.main.bounds.size.width*0.7, height: UIScreen.main.bounds.size.height*0.403))
    
    let volumeOnButton = SKSpriteNode(imageNamed: "VolumeOn")
    let volumeOffButton = SKSpriteNode(imageNamed: "VolumeOff")
    let musicLabel = SKLabelNode(text: "BGM")

    let soundEffectsLabel = SKLabelNode(text: "Sound effects")
    var soundEffectsLabelSpriteNode = SKSpriteNode()
    
    let languageLabel = SKLabelNode(text: "Language")
    let languageSelectionLabel = SKLabelNode(text: "English")
    
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
        
        settingsSquareBorder.strokeColor = .white
        settingsSquareBorder.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        settingsSquareBorder.zPosition = 8
        settingsSquareBorder.lineWidth = 3
        
        settingsSquareBorder2.strokeColor = myGray
        settingsSquareBorder2.lineWidth = 4
        settingsSquareBorder2.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        settingsSquareBorder2.zPosition = 8
        
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
        volumeOnButton.position = CGPoint(x: size.width*0.7,y: size.height*0.57 )
        
        volumeOffButton.xScale = 0.2
        volumeOffButton.yScale = 0.2
        volumeOffButton.name = "volumeButton"
        volumeOffButton.zPosition = 10
        volumeOffButton.position = CGPoint(x: size.width*0.7,y: size.height*0.57 )
        
        
        musicLabel.fontColor = .white
        musicLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        musicLabel.position = CGPoint(x: size.width*0.2, y: size.height*0.55)
        musicLabel.zPosition = 10
        
        soundEffectsLabel.fontColor = .white
        soundEffectsLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        soundEffectsLabel.position = CGPoint(x: size.width*0.2, y: size.height*0.5)
        soundEffectsLabel.zPosition = 10
        

        languageLabel.zPosition = 10
        languageLabel.fontColor = .white
        languageLabel.position = CGPoint(x: size.width*0.2, y: size.height*0.45)
        languageLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        languageSelectionLabel.zPosition = 10
        languageSelectionLabel.fontColor = .white
        languageSelectionLabel.position = CGPoint(x: size.width*0.8, y: size.height*0.45)
        languageSelectionLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        languageSelectionLabel.name = "languageButton"
        
        gameTitleWithReflection.position = CGPoint(x: size.width*0.5, y: size.height*0.8)
        gameTitleWithReflection.xScale = 0.4
        gameTitleWithReflection.yScale = 0.4
        
        
        //Aggiungo gli elementi alla scena
        addChild(houseSpriteMenu)
        addChild(houseSpriteMenuMirrored)
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
            addChild(backgroundSettings)
            addChild(settingsSquare)
            addChild(settingsSquareBorder)
            addChild(settingsSquareBorder2)
            addChild(musicLabel)
            addChild(soundEffectsLabel)
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
            soundEffectsLabel.removeFromParent()
            musicLabel.removeFromParent()
            if(language == "English"){
                languageLabel.text = LanguageHandler.instance.languageLabelEnglish
                languageSelectionLabel.text = LanguageHandler.instance.languageSelectionButtonEnglish
                soundEffectsLabel.text = LanguageHandler.instance.soundEffectsLabelEnglish
                musicLabel.text = LanguageHandler.instance.musicLabelEnglish
            } else if(language == "Italian"){
                languageLabel.text = LanguageHandler.instance.languageLabelItalian
                languageSelectionLabel.text = LanguageHandler.instance.languageSelectionButtonEnglish
                soundEffectsLabel.text = LanguageHandler.instance.soundEffectsLabelItalian
                musicLabel.text = LanguageHandler.instance.musicLabelItalian
            }
            addChild(soundEffectsLabel)
            addChild(musicLabel)
            addChild(languageLabel)
            addChild(languageSelectionLabel)
        }
        
        if(touchedNode.name == "closeSettings"){
            settingsSquare.removeFromParent()
            backgroundSettings.removeFromParent()
            settingsSquareBorder.removeFromParent()
            settingsSquareBorder2.removeFromParent()
            if(musicHandler.instance.mutedMusic){
                volumeOffButton.removeFromParent()
            } else {
                volumeOnButton.removeFromParent()
            }
            closeSettingsButton.removeFromParent()
            languageLabel.removeFromParent()
            languageSelectionLabel.removeFromParent()
            musicLabel.removeFromParent()
            soundEffectsLabel.removeFromParent()
            
        }
       
    }

}

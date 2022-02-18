//
//  GameScene.swift
//  Specular-Game
//
//  Created by Salvatore Manna on 18/02/22.
//


import SpriteKit
import GameplayKit

//Changed

class GameScene: SKScene {
    
    let startGameLabel = SKLabelNode(text: "Start Game")
    
    let squareUp = SKShapeNode(rectOf: CGSize(width: 200, height: 200))
    
    
    let backgroundScreenBottomPart = SKShapeNode(rectOf: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.3))
    let backgroundScreen = SKSpriteNode(imageNamed: "Gradient")
    let playButton = SKSpriteNode(imageNamed: "SquarePlay4")
    let settingsButton = SKLabelNode(text: "Settings")
    let houseSpriteMenu = SKSpriteNode(imageNamed: "House.png")
    let houseSpriteMenuMirrored = SKSpriteNode(imageNamed: "House.png")
    var gameTitle = SKLabelNode(text: "SPECULAR")
    let gameTitleMirrored = SKLabelNode(text: "SPECULAR")
    
    let volumeOnButton = SKSpriteNode(imageNamed: "VolumeOn")
    let volumeOffButton = SKSpriteNode(imageNamed: "VolumeOff")
    
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
        
        volumeOnButton.xScale = 0.2
        volumeOnButton.yScale = 0.2
        volumeOnButton.name = "volumeOn"
        volumeOnButton.position = CGPoint(x: size.width*0.3,y: size.height*0.9 )
        
        
        volumeOffButton.xScale = 0.2
        volumeOffButton.yScale = 0.2
        volumeOffButton.name = "volumeOff"
        volumeOffButton.position = CGPoint(x: size.width*0.6,y: size.height*0.9 )
        
        if(musicHandler.instance.mutedMusic){
            volumeOnButton.alpha = 0.5
            volumeOffButton.alpha = 1
        } else if(!musicHandler.instance.mutedMusic) {
            volumeOnButton.alpha = 1
            volumeOffButton.alpha = 0.5
        }
        addChild(volumeOnButton)
        addChild(volumeOffButton)
        
        
        addChild(houseSpriteMenu)
        addChild(houseSpriteMenuMirrored)
        addChild(gameTitle)
        addChild(gameTitleMirrored)
        addChild(playButton)

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
        if(touchedNode.name == "volumeOff"){
            volumeOnButton.alpha = 0.5
            volumeOffButton.alpha = 1
            musicHandler.instance.muteBackgroundMusic()
        }
        if(touchedNode.name == "volumeOn"){
            volumeOnButton.alpha = 1
            volumeOffButton.alpha = 0.5
            musicHandler.instance.unmuteBackgroundMusic()
        }
       
    }

}

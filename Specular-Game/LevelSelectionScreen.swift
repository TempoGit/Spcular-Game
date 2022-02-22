//
//  LevelSelectionScreen.swift
//  Specular-Game
//
//  Created by Salvatore Manna on 21/02/22.
//

import UIKit
import SpriteKit


class LevelSelectionScreen: SKScene {

    
    let background = SKShapeNode(rectOf: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
    
    
    let goBack = SKLabelNode(text: "Go Back")
    
    let level0 = SKShapeNode(rectOf: CGSize(width: UIScreen.main.bounds.size.width*0.12, height: UIScreen.main.bounds.size.width*0.12))
    let level1 = SKShapeNode(rectOf: CGSize(width: UIScreen.main.bounds.size.width*0.12, height: UIScreen.main.bounds.size.width*0.12))
    
    override func didMove(to view: SKView) {
        
        background.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        background.fillColor = .black
        background.strokeColor = .black
        background.zPosition = 1
        
        goBack.position = CGPoint(x: size.width*0.2,y: size.height*0.9)
        goBack.name = "goBack"
        goBack.zPosition = 3
        
        level0.position = CGPoint(x: size.width*0.2, y: size.height*0.8)
        level0.strokeColor = .white
        level0.fillColor = .white
        level0.name = "level0"
        level0.zPosition = 3
        
        level1.position = CGPoint(x: size.width*0.4, y: size.height*0.8)
        level1.strokeColor = .white
        level1.fillColor = .white
        level1.name = "level1"
        level1.alpha = 0.6
        level1.zPosition = 3
        
        addChild(goBack)
        addChild(level0)
        addChild(level1)
        addChild(background)
        
        
        musicHandler.instance.playBackgroundMusicMenu()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let touchedNode = atPoint(touchLocation)
        
        if (touchedNode.name == "goBack"){
            musicHandler.instance.stopBackgroundMusicMenu()
            let menuScene = GameScene(size: size)
            view?.presentScene(menuScene)
        }
        
        if (touchedNode.name == "level0"){
            musicHandler.instance.stopBackgroundMusicMenu()
            let level0 = Level00_4(size: size)
            view?.presentScene(level0)
        }
    }
}

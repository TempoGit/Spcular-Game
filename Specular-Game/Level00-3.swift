//
//  Level00-3.swift
//  Specular-Game
//
//  Created by Guendalina De Laurentis on 21/02/22.
//


import AVFoundation
import UIKit
import SpriteKit


class Level00_3: SKScene, SKPhysicsContactDelegate{
    let pauseButton = SKSpriteNode(imageNamed: "pause")
    let room = SKSpriteNode(imageNamed: "Level0-Room3")
    let characterAvatar = SKSpriteNode(imageNamed: "Character")
    let characterFeetCollider = SKSpriteNode(imageNamed: "CharacterFeet2")
    
    let barrierDownLF = SKSpriteNode(imageNamed: "BarrierBottomLF-Room3")
    let barrierDownRT = SKSpriteNode(imageNamed: "BarrierBottomRT-Room3")
    let barrierTopLF = SKSpriteNode(imageNamed: "BarrierTopLF-Room3")
    let barrierTopRT = SKSpriteNode(imageNamed: "BarrierTopRT-Room3")
    
    let doorColliderTopLF = SKSpriteNode(imageNamed: "DoorColliderTopLF-Room3")
    let doorColliderTopRT = SKSpriteNode(imageNamed: "DoorColliderTopRT-Room3")
    
    let armachair = SKSpriteNode(imageNamed: "Armchairs-Room3")
    let books = SKSpriteNode(imageNamed: "Books-Room3")
    let doorLF = SKSpriteNode(imageNamed: "Door open1-Room3")
    let doorRT = SKSpriteNode(imageNamed: "Door open RT-Room3")
    let lamp = SKSpriteNode(imageNamed: "Floor Lamp-Room3")
    
    var WorldGroup = SKSpriteNode()
    
    let cameraNode = SKCameraNode()
    
    let gameArea: CGRect
    
    override init(size: CGSize) {
      let playableHeight = size.width
      let playableMargin = (size.height-playableHeight)/2.0
        gameArea = CGRect(x: 0, y: playableMargin,
                                width: size.width,
                                height: playableHeight)
          super.init(size: size)
    }
        required init(coder aDecoder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove(to view: SKView) {
        addChild(room)
        addChild(doorLF)
        addChild(doorRT)
        addChild(lamp)
        addChild(armachair)
        addChild(books)
        addChild(barrierTopLF)
        addChild(barrierTopRT)
        addChild(barrierDownLF)
        addChild(barrierDownRT)
        addChild(doorColliderTopLF)
        addChild(doorColliderTopRT)
        addChild(characterAvatar)
        addChild(characterFeetCollider)
        
        addChild(cameraNode)
        camera = cameraNode
        //Aggiungo il bottonr per aprire il menu di pausa alla camera di gioco
        cameraNode.addChild(pauseButton)
        
        
        //Avvio la musica del livello
        musicHandler.instance.playBackgroundMusic()
        
        //Per abilitare le collisioni nella scena
        self.scene?.physicsWorld.contactDelegate = self
        
    }
}

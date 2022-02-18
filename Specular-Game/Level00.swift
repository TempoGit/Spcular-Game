//
//  Level00.swift
//  Specular-Game
//
//  Created by Salvatore Manna on 18/02/22.
//

import UIKit
import SpriteKit


import AVFoundation




struct PhysicsCategories {
    static let Player : UInt32 = 0x1 << 0
    static let MapEdge : UInt32 = 0x1 << 1
//    static let Redball : UInt32 = 0x1 << 2
}

class Level00: SKScene, SKPhysicsContactDelegate {
    
    
    let closePauseMenu = SKLabelNode(text: "Close pause menu")
    let goBackToMenu = SKLabelNode(text: "Go back to main menu")
    let languageButton = SKLabelNode(text: "Language Button")
    let volumeOnButton = SKSpriteNode(imageNamed: "VolumeOn")
    let volumeOffButton = SKSpriteNode(imageNamed: "VolumeOff")
    let backgroundPause = SKShapeNode(rectOf: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
    let pauseSquare = SKShapeNode(rectOf: CGSize(width: UIScreen.main.bounds.size.width*0.7, height: UIScreen.main.bounds.size.height*0.4))
    
    let pauseButton = SKSpriteNode(imageNamed: "Pause")
//    var backgroundMusicPlayer: AVAudioPlayer!

    let goBackLabel = SKLabelNode(text: "Go Back")
    
    let room1 = SKSpriteNode(imageNamed: "Room 1")
    
    let barrier1 = SKSpriteNode(imageNamed: "BarrierRight")
    let barrier2 = SKSpriteNode(imageNamed: "BarrierDown")
    let barrier3 = SKSpriteNode(imageNamed: "BarrierUp")
    let barrier4 = SKSpriteNode(imageNamed: "BarrierLeft")
//    let lowerDoor = SKShapeNode(rectOf: CGSize(width: UIScreen.main.bounds.size.width*0.04, height: UIScreen.main.bounds.size.height*0.1))
    let lowerDoor = SKSpriteNode(imageNamed: "Lower")
    let music = SKAction.playSoundFileNamed("academy", waitForCompletion: false)
    var tappedObject: Bool = false
    
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
    
    
    var worldGroup = SKSpriteNode()
    
    let object = SKSpriteNode(imageNamed: "PlayerBox")
    let player = SKSpriteNode()
    let characterAvatar = SKSpriteNode(imageNamed: "Character")
    let characterFeetCollider = SKSpriteNode(imageNamed: "CharacterFeet2")
    
    var move: Bool = false
    var moveSingle: Bool = false
    var location = CGPoint.zero
    
    let cameraNode = SKCameraNode()
    
    let squareTest1 = SKShapeNode(rectOf: CGSize(width: 100,height: 100))
    
    override func didMove(to view: SKView) {
        room1.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        room1.xScale = 0.8
        room1.yScale = 0.8
//        room1.zPosition = 1
        
        
//        lowerDoor.position = CGPoint(x: size.width*0.24, y:size.height*0.2)
        lowerDoor.position = CGPoint(x: size.width*0.17, y: size.height*0.2)
        lowerDoor.name = "lowerDoor"
        lowerDoor.alpha = 0.01
//        lowerDoor.fillColor = .black
//        lowerDoor.strokeColor = .black
//        lowerDoor.zRotation = 3.14 * 55 / 180
        lowerDoor.xScale = 0.8
        lowerDoor.yScale = 0.8
        barrier1.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        barrier1.xScale = 0.8
        barrier1.yScale = 0.8
        barrier1.physicsBody = SKPhysicsBody(texture: barrier1.texture!, size: barrier1.size)
        barrier1.physicsBody?.affectedByGravity = false
        barrier1.physicsBody?.restitution = 0
        barrier1.physicsBody?.allowsRotation = false
        barrier1.physicsBody?.isDynamic = false
        barrier1.physicsBody?.categoryBitMask = PhysicsCategories.MapEdge
        barrier1.physicsBody?.contactTestBitMask = PhysicsCategories.Player
        barrier1.alpha = 0.01
        barrier1.name = "outerBarrier"
        barrier2.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        barrier2.xScale = 0.8
        barrier2.yScale = 0.8
        barrier2.physicsBody = SKPhysicsBody(texture: barrier2.texture!, size: barrier2.size)
        barrier2.physicsBody?.affectedByGravity = false
        barrier2.physicsBody?.restitution = 0
        barrier2.physicsBody?.allowsRotation = false
        barrier2.physicsBody?.isDynamic = false
        barrier2.physicsBody?.categoryBitMask = PhysicsCategories.MapEdge
        barrier2.physicsBody?.contactTestBitMask = PhysicsCategories.Player
        barrier2.alpha = 0.01
        barrier2.name = "outerBarrier"
        barrier3.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        barrier3.xScale = 0.8
        barrier3.yScale = 0.8
        barrier3.physicsBody = SKPhysicsBody(texture: barrier3.texture!, size: barrier3.size)
        barrier3.physicsBody?.affectedByGravity = false
        barrier3.physicsBody?.restitution = 0
        barrier3.physicsBody?.allowsRotation = false
        barrier3.physicsBody?.isDynamic = false
        barrier3.physicsBody?.categoryBitMask = PhysicsCategories.MapEdge
        barrier3.physicsBody?.contactTestBitMask = PhysicsCategories.Player
        barrier3.alpha = 0.01
        barrier3.name = "outerBarrier"
        barrier4.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        barrier4.xScale = 0.8
        barrier4.yScale = 0.8
        barrier4.physicsBody = SKPhysicsBody(texture: barrier4.texture!, size: barrier4.size)
        barrier4.physicsBody?.affectedByGravity = false
        barrier4.physicsBody?.restitution = 0
        barrier4.physicsBody?.allowsRotation = false
        barrier4.physicsBody?.isDynamic = false
        barrier4.physicsBody?.categoryBitMask = PhysicsCategories.MapEdge
        barrier4.physicsBody?.contactTestBitMask = PhysicsCategories.Player
        barrier4.alpha = 0.01
        barrier4.name = "outerBarrier"

        
        worldGroup.addChild(room1)
        worldGroup.addChild(barrier1)
        worldGroup.addChild(barrier2)
        worldGroup.addChild(barrier3)
        worldGroup.addChild(barrier4)
     
//        worldGroup.addChild(lowerDoor)
        addChild(worldGroup)
        addChild(lowerDoor)
        
        characterAvatar.anchorPoint = CGPoint(x: 0.5,y: 0)
        characterAvatar.position = CGPoint(x: size.width*0.5,y: size.height*0.3)
        characterAvatar.xScale = 0.5
        characterAvatar.yScale = 0.5
        characterAvatar.zPosition = 5
        characterFeetCollider.position = CGPoint(x: size.width*0.5,y: size.height*0.31)
        characterFeetCollider.xScale = 0.5
        characterFeetCollider.yScale = 0.5
        characterFeetCollider.physicsBody = SKPhysicsBody(texture: characterFeetCollider.texture!, size: characterFeetCollider.size)
        characterFeetCollider.physicsBody?.affectedByGravity = false
        characterFeetCollider.physicsBody?.restitution = 0
        characterFeetCollider.physicsBody?.allowsRotation = false
//        characterFeetCollider.physicsBody?.isDynamic = false
        characterFeetCollider.physicsBody?.categoryBitMask = PhysicsCategories.Player
        characterFeetCollider.physicsBody?.contactTestBitMask = PhysicsCategories.MapEdge
        addChild(characterAvatar)
        addChild(characterFeetCollider)
        
//        player.addChild(characterFeetCollider)
//        player.addChild(characterAvatar)
//        player.addChild(characterFeetCollider)
        player.position = CGPoint(x: size.width*0.5, y: size.height*0.35)
//        player.xScale = 0.12
//        player.yScale = 0.12
//        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
//        player.physicsBody?.affectedByGravity = false
//        player.physicsBody?.restitution = 0
//        player.physicsBody?.allowsRotation = false
//        player.physicsBody?.isDynamic = false
//        player.physicsBody?.categoryBitMask = PhysicsCategories.Player
//        player.physicsBody?.contactTestBitMask = PhysicsCategories.MapEdge
//        object.physicsBody = SKPhysicsBody(texture: object.texture!, size: object.size)
        object.xScale = 0.2
        object.yScale = 0.2
        object.zPosition = 4
        object.position = CGPoint(x: size.width * 0.4, y: size.height * 0.4)
        object.physicsBody = SKPhysicsBody(texture: object.texture!, size: object.size)
        object.physicsBody?.affectedByGravity = false
        object.physicsBody?.restitution = 0
        object.physicsBody?.allowsRotation = false
        object.physicsBody?.isDynamic = false
//        object.physicsBody?.categoryBitMask = PhysicsCategories.MapEdge
        object.physicsBody?.contactTestBitMask = PhysicsCategories.Player
        object.name = "tappedObject"
      
        addChild(object)
        player.name = "playerName"
//        player.zPosition = 3
        addChild(player)
        
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = characterAvatar.position

        
        pauseButton.name = "pause"
        pauseButton.position = CGPoint(x: -gameArea.size.width/3 + CGFloat(10), y: gameArea.size.height*0.9 + CGFloat(10))
        pauseButton.zPosition = 20
        pauseButton.xScale = 0.2
        pauseButton.yScale = 0.2
        cameraNode.addChild(pauseButton)
        
        squareTest1.position = CGPoint(x: size.width*0.8,y: size.height*0.3)
        squareTest1.fillColor = .black
        squareTest1.strokeColor = .black
        squareTest1.name = "posa"
        addChild(squareTest1)
        
        musicHandler.instance.playBackgroundMusic()
        
        self.scene?.physicsWorld.contactDelegate = self
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let touchedNode = atPoint(touchLocation)

        
        if (touchedNode.name == "tappedObject"){
            for touch in touches {
                location = touch.location(in: self)
                let removeObject = SKAction.sequence([SKAction.removeFromParent()])
                object.run(removeObject)
            }
       
        }
        
        if(touchedNode.name == "goToMenu"){
            musicHandler.instance.stopLevelBackgroundMusic()
            let gameScene = GameScene(size: size)
            view?.presentScene(gameScene)
        }
        if(touchedNode.name == "pause"){
            self.isPaused = true
            closePauseMenu.zPosition = 102
            closePauseMenu.fontSize = 26
            closePauseMenu.fontColor = .white
            closePauseMenu.position = CGPoint(x: gameArea.size.width*0, y: gameArea.size.height*0.35)
            closePauseMenu.name = "closePause"
            goBackToMenu.zPosition = 102
            goBackToMenu.fontSize = 26
            goBackToMenu.fontColor = .white
            goBackToMenu.name = "goToMenu"
            goBackToMenu.position = CGPoint(x: gameArea.size.width*0, y: -gameArea.size.height*0.4)
            languageButton.zPosition = 102
            languageButton.fontSize = 26
            languageButton.fontColor = .white
            languageButton.position = CGPoint(x: gameArea.size.width*0, y: gameArea.size.height*0)
            volumeOffButton.xScale = 0.2
            volumeOffButton.yScale = 0.2
            volumeOffButton.name = "volumeOff"
            volumeOffButton.zPosition = 102
            volumeOffButton.position = CGPoint(x: gameArea.size.width*0.15, y: gameArea.size.height*0.25)
            volumeOnButton.xScale = 0.2
            volumeOnButton.yScale = 0.2
            volumeOnButton.name = "volumeOn"
            volumeOnButton.zPosition = 102
            volumeOnButton.position = CGPoint(x: -gameArea.size.width*0.15, y: gameArea.size.height*0.25)
            if(musicHandler.instance.mutedMusic){
                volumeOnButton.alpha = 0.5
                volumeOffButton.alpha = 1
            } else if(!musicHandler.instance.mutedMusic) {
                volumeOnButton.alpha = 1
                volumeOffButton.alpha = 0.5
            }
            pauseSquare.fillColor = .black
            pauseSquare.strokeColor = .black
            pauseSquare.zPosition = 101
            backgroundPause.fillColor = .black
            backgroundPause.strokeColor = .black
            backgroundPause.alpha = 0.6
            backgroundPause.zPosition = 100
            backgroundPause.name = "closePause"
            cameraNode.addChild(pauseSquare)
            cameraNode.addChild(backgroundPause)
            cameraNode.addChild(volumeOnButton)
            cameraNode.addChild(volumeOffButton)
            cameraNode.addChild(closePauseMenu)
            cameraNode.addChild(goBackToMenu)
            cameraNode.addChild(languageButton)
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
        if(touchedNode.name == "closePause"){
            languageButton.removeFromParent()
            backgroundPause.removeFromParent()
            pauseSquare.removeFromParent()
            volumeOnButton.removeFromParent()
            volumeOffButton.removeFromParent()
            goBackToMenu.removeFromParent()
            closePauseMenu.removeFromParent()
            self.isPaused = false
        }
        if(touchLocation != player.position){
            location = touchLocation
            moveSingle = true
        }
    }

    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        player.removeAllActions()
        tappedObject = true
        moveSingle = false
        move = true
        for touch in touches {
            location = touch.location(in: self)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        move = false
        moveSingle = false

       
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        
        if(move || moveSingle){
            if(location.x > characterFeetCollider.position.x) {
                characterFeetCollider.position.x += 0.8
                if(location.y > characterFeetCollider.position.y){
                    characterFeetCollider.position.y += 0.8
                    
                } else if(location.y < characterFeetCollider.position.y){
                    characterFeetCollider.position.y -= 0.8
                }
            } else if (location.x < characterFeetCollider.position.x){
                characterFeetCollider.position.x -= 0.8
                if(location.y > characterFeetCollider.position.y){
                    characterFeetCollider.position.y += 0.8
                    
                } else if(location.y < characterFeetCollider.position.y){
                    characterFeetCollider.position.y -= 0.8
                }
            } else if (location.y > characterFeetCollider.position.y){
                characterFeetCollider.position.y += 0.8
            } else if (location.y < characterFeetCollider.position.y){
                characterFeetCollider.position.y -= 0.8
            }
        }
        characterAvatar.position = characterFeetCollider.position
        cameraNode.position = characterAvatar.position
        checkCollisions()
        
    
    }
    
    func checkCollisions(){
        if(characterFeetCollider.frame.intersects(self.squareTest1.frame)){
            print("Intersection")
//            squareTest1.zPosition = 5
//            player.zPosition = 10
            print(squareTest1.position.x)
            print(characterAvatar.position.x)
            if(squareTest1.position.x > characterAvatar.position.x){
                squareTest1.alpha = 0.2
            } else {
                squareTest1.alpha = 1
                characterAvatar.zPosition = 10
            }
            
        } else {
            squareTest1.alpha = 1
        }
        
        if(characterFeetCollider.frame.intersects(lowerDoor.frame)){
            print(lowerDoor.position)
            print(characterFeetCollider.position)
            print("Collision")
            let newRoom = Level00_2(size: size)
            view?.presentScene(newRoom)
        }
        
    }
}

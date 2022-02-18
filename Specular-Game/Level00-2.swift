//
//  Level00-2.swift
//  Specular-Game
//
//  Created by Salvatore Manna on 18/02/22.
//

import UIKit
import SpriteKit
import AVFoundation


struct PhysicsCategories1 {
    static let Player : UInt32 = 0x1 << 0
    static let MapEdge : UInt32 = 0x1 << 1
}


class Level00_2: SKScene, SKPhysicsContactDelegate {

    
    let room2 = SKSpriteNode(imageNamed: "Room2")
    let characterAvatar = SKSpriteNode(imageNamed: "Character")
    let characterFeetCollider = SKSpriteNode(imageNamed: "CharacterFeet2")
    let player = SKSpriteNode()
    let cameraNode = SKCameraNode()
    let barrieraSX = SKSpriteNode( imageNamed: "BarrierLeft")
    let barrieraDX = SKSpriteNode(imageNamed: "BarrierUp")
    var move: Bool = false
    var moveSingle: Bool = false
    var location = CGPoint.zero
    var worldGroup = SKSpriteNode()
    let volumeOnButton = SKSpriteNode(imageNamed: "VolumeOn")
    let volumeOffButton = SKSpriteNode(imageNamed: "VolumeOff")
    let pauseButton = SKSpriteNode(imageNamed: "Pause")
    let closePauseMenu = SKLabelNode(text: "Close pause menu")
    let goBackToMenu = SKLabelNode(text: "Go back to main menu")
    let languageButton = SKLabelNode(text: "Language Button")
    let backgroundPause = SKShapeNode(rectOf: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
    let pauseSquare = SKShapeNode(rectOf: CGSize(width: UIScreen.main.bounds.size.width*0.7, height: UIScreen.main.bounds.size.height*0.4))
    let testObjects = SKShapeNode(rectOf: CGSize(width: 100,height: 100))
    
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
        room2.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        room2.xScale = 0.8
        room2.yScale = 0.8
        
        
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
        player.position = CGPoint(x: size.width*0.5, y: size.height*0.35)
        
        barrieraSX.position = CGPoint(x: size.width/2, y: size.height/2)
        barrieraSX.xScale = 0.8
        barrieraSX.yScale = 0.8
        barrieraSX.physicsBody = SKPhysicsBody(texture: barrieraSX.texture!, size: barrieraSX.size)
        barrieraSX.physicsBody?.affectedByGravity = false
        barrieraSX.physicsBody?.restitution = 0
        barrieraSX.physicsBody?.allowsRotation = false
        barrieraSX.physicsBody?.isDynamic = false
        barrieraSX.physicsBody?.categoryBitMask = PhysicsCategories.MapEdge
        barrieraSX.physicsBody?.contactTestBitMask = PhysicsCategories.Player
        barrieraSX.alpha = 0.01
        barrieraSX.name = "outerBarrier"
        
        barrieraDX.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        barrieraDX.xScale = 0.8
        barrieraDX.yScale = 0.8
        barrieraDX.physicsBody = SKPhysicsBody(texture: barrieraDX.texture!, size: barrieraDX.size)
        barrieraDX.physicsBody?.affectedByGravity = false
        barrieraDX.physicsBody?.restitution = 0
        barrieraDX.physicsBody?.allowsRotation = false
        barrieraDX.physicsBody?.isDynamic = false
        barrieraDX.physicsBody?.categoryBitMask = PhysicsCategories.MapEdge
        barrieraDX.physicsBody?.contactTestBitMask = PhysicsCategories.Player
        barrieraDX.alpha = 0.01
        barrieraDX.name = "outerBarrier"
        
        pauseButton.name = "pause"
        pauseButton.position = CGPoint(x: -gameArea.size.width/3 + CGFloat(10), y: gameArea.size.height*0.9 + CGFloat(10))
        pauseButton.zPosition = 20
        pauseButton.xScale = 0.2
        pauseButton.yScale = 0.2
        cameraNode.addChild(pauseButton)
        
        testObjects.position = CGPoint(x: size.width*0.8,y: size.height*0.3)
        testObjects.zPosition = 6
        testObjects.physicsBody?.contactTestBitMask = PhysicsCategories.Player
        testObjects.physicsBody?.categoryBitMask = PhysicsCategories.MapEdge
        testObjects.fillColor = .black
        testObjects.strokeColor = .black
        testObjects.name = "testObject"
        addChild(testObjects)
        
        
        worldGroup.addChild(room2)
        worldGroup.addChild(barrieraDX)
        worldGroup.addChild(barrieraSX)
        addChild(worldGroup)
        addChild(characterAvatar)
        addChild(characterFeetCollider)
        addChild(player)
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = characterAvatar.position
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let touchedNode = atPoint(touchLocation)
        if(touchLocation != player.position){
            location = touchLocation
            moveSingle = true
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
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
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
        if(characterFeetCollider.frame.intersects(self.testObjects.frame)){
            print("Intersection")
            print(testObjects.position.x)
            print(characterAvatar.position.x)
            if(testObjects.position.x > characterAvatar.position.x){
                testObjects.alpha = 1
            } else {
                testObjects.alpha = 1
                characterAvatar.zPosition = 10
            }
            
        } else {
            testObjects.alpha = 1
        }
        if(characterFeetCollider.frame.intersects(testObjects.frame)){
            print(testObjects.position)
            print(characterFeetCollider.position)
            print("Collision")
        }
    }
}

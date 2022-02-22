//
//  Level00-5.swift
//  Specular-Game
//
//  Created by Salvatore Manna on 22/02/22.
//

import UIKit
import SpriteKit

class Level00_5: SKScene, SKPhysicsContactDelegate {
    
    let pauseButton = SKSpriteNode(imageNamed: "Pause")
    
    let cameraNode = SKCameraNode()

    let characterAvatar = SKSpriteNode(imageNamed: "Character")
    let characterFeetCollider = SKSpriteNode(imageNamed: "CharacterFeet2")
    
    let room = SKSpriteNode(imageNamed: "Level0-Room5-Background")
    let boxes = SKSpriteNode(imageNamed: "Level0-Room5-BookShelf")
    let doorLF = SKSpriteNode(imageNamed: "Level0-Room5-DoorLF")
    let doorRTclosed = SKSpriteNode(imageNamed: "Level0-Room5-HalfWall-open")
    let doorRTopen = SKSpriteNode(imageNamed: "Level0-Room5-HalfWall-closed")
    let lamp = SKSpriteNode(imageNamed: "Level0-Room5-Lamp")
    let barrierDownLF = SKSpriteNode(imageNamed: "BarrierBottomLT")
    let barrierDownRT = SKSpriteNode(imageNamed: "BarrierBottomRT")
    let barrierTopLF = SKSpriteNode(imageNamed: "BarrierTopLF")
    let barrierTopRT = SKSpriteNode(imageNamed: "BarrierTopRT")
    let doorColliderLF = SKSpriteNode(imageNamed: "DoorColliderLT")
    let doorColliderRT = SKSpriteNode(imageNamed: "DoorColliderRT")
    let colliderRT = SKSpriteNode(imageNamed: "DoorRT")
    
    var moveSingle: Bool = true
    var move: Bool = true
    var location = CGPoint.zero
    
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
        
        roomSetUp()
        addChild(room)
        addChild(boxes)
        addChild(doorLF)
        addChild(doorRTopen)
        addChild(doorRTclosed)
        addChild(characterAvatar)
        addChild(characterFeetCollider)
        addChild(lamp)
        addChild(barrierTopLF)
        addChild(barrierTopRT)
        addChild(barrierDownLF)
        addChild(barrierDownRT)
        addChild(colliderRT)
        addChild(doorColliderLF)
        addChild(doorColliderRT)
        
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.addChild(pauseButton)
        
        musicHandler.instance.playBackgroundMusic()
        
        
        self.scene?.physicsWorld.contactDelegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }

        let touchLocation = touch.location(in: self)
        let touchedNode = atPoint(touchLocation)

        if(touchedNode.name == "goToMenu"){
            musicHandler.instance.stopLevelBackgroundMusic()
            let gameScene = GameScene(size: size)
            view?.presentScene(gameScene)
        }

        if(touchedNode.name == "pause"){
            self.isPaused = true
            if(PauseMenuHandler.instance.firstSet == false){
                PauseMenuHandler.instance.closePauseMenu.position = CGPoint(x: gameArea.size.width*0, y: gameArea.size.height*0.35)
                PauseMenuHandler.instance.goBackToMenu.position = CGPoint(x: gameArea.size.width*0, y: -gameArea.size.height*0.4)
                PauseMenuHandler.instance.languageButton.position = CGPoint(x: gameArea.size.width*0, y: gameArea.size.height*0)
                PauseMenuHandler.instance.volumeOffButton.position = CGPoint(x: gameArea.size.width*0.15, y: gameArea.size.height*0.25)
                PauseMenuHandler.instance.volumeOnButton.position = CGPoint(x: -gameArea.size.width*0.15, y: gameArea.size.height*0.25)
            }
            PauseMenuHandler.instance.initializeNodeSettings()
            cameraNode.addChild(PauseMenuHandler.instance.pauseSquare)
            cameraNode.addChild(PauseMenuHandler.instance.backgroundPause)
            cameraNode.addChild(PauseMenuHandler.instance.volumeOnButton)
            cameraNode.addChild(PauseMenuHandler.instance.volumeOffButton)
            cameraNode.addChild(PauseMenuHandler.instance.closePauseMenu)
            cameraNode.addChild(PauseMenuHandler.instance.goBackToMenu)
            cameraNode.addChild(PauseMenuHandler.instance.languageButton)
        }
   
        if(touchedNode.name == "volumeOff"){
            if(musicHandler.instance.mutedMusic == false){
                PauseMenuHandler.instance.volumeOnButton.alpha = 0.5
                PauseMenuHandler.instance.volumeOffButton.alpha = 1
                musicHandler.instance.muteBackgroundMusic()
            }
        }
   
        if(touchedNode.name == "volumeOn"){
            if(musicHandler.instance.mutedMusic == true){
                PauseMenuHandler.instance.volumeOnButton.alpha = 1
                PauseMenuHandler.instance.volumeOffButton.alpha = 0.5
                musicHandler.instance.unmuteBackgroundMusic()
            }
        }

        if(touchedNode.name == "closePause"){
            PauseMenuHandler.instance.languageButton.removeFromParent()
            PauseMenuHandler.instance.backgroundPause.removeFromParent()
            PauseMenuHandler.instance.pauseSquare.removeFromParent()
            PauseMenuHandler.instance.volumeOnButton.removeFromParent()
            PauseMenuHandler.instance.volumeOffButton.removeFromParent()
            PauseMenuHandler.instance.goBackToMenu.removeFromParent()
            PauseMenuHandler.instance.closePauseMenu.removeFromParent()
            self.isPaused = false
        }
        
        if(touchLocation != characterFeetCollider.position){
            location = touchLocation
            moveSingle = true
            characterAvatar.run(SKAction.repeatForever(walkingAnimation))
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
        characterAvatar.removeAllActions()
        characterAvatar.run(SKAction.setTexture(SKTexture(imageNamed: "Character")))
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
        characterAvatar.position.y = characterAvatar.position.y - 8
        cameraNode.position = characterAvatar.position
        cameraNode.position.y += size.height*0.2
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactA = contact.bodyA.node?.name
        let contactB = contact.bodyB.node?.name
        
        //Se la collisione che si è verificata ha come protagonisti il personaggio e la porta sul lato inferiore della stanza allora avvia la transizione alla nuova stanza
        if(contactA == "player" || contactB == "player"){
            if(contactA == "doorColliderLF" || contactB == "doorColliderLF"){
                print("left")
                let room4 = Level00_4(size: size)
                view?.presentScene(room4)
                
            } else if(contactA == "doorColliderRT" || contactB == "doorColliderRT"){
                print("Right")
                let room6 = TheEnd(size: size)
                view?.presentScene(room6)
            }
        }
    }
    
    func roomSetUp(){
//        setup character
        characterAvatar.anchorPoint = CGPoint(x: 0.5,y: 0)
        characterAvatar.position = CGPoint(x: size.width*0.5,y: size.height*0.3)
        characterAvatar.xScale = 0.5
        characterAvatar.yScale = 0.5
        characterAvatar.zPosition = 5
        characterAvatar.name = "player"
        characterFeetCollider.position = CGPoint(x: size.width*0.5,y: size.height*0.31)
        characterFeetCollider.xScale = 0.5
        characterFeetCollider.yScale = 0.5
        characterFeetCollider.physicsBody = SKPhysicsBody(texture: characterFeetCollider.texture!, size: characterFeetCollider.size)
        characterFeetCollider.physicsBody?.affectedByGravity = false
        characterFeetCollider.physicsBody?.restitution = 0
        characterFeetCollider.physicsBody?.allowsRotation = false
        characterFeetCollider.physicsBody?.categoryBitMask = PhysicsCategories.Player
        characterFeetCollider.physicsBody?.contactTestBitMask = PhysicsCategories.MapEdge
        characterFeetCollider.name = "player"
//      setup pause button
        pauseButton.name = "pause"
        pauseButton.position = CGPoint(x: -gameArea.size.width/3 + CGFloat(10), y: gameArea.size.height*0.9 + CGFloat(10))
        pauseButton.zPosition = 20
        pauseButton.xScale = 0.08
        pauseButton.yScale = 0.08
//        setup room
        room.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        room.xScale = 0.4
        room.yScale = 0.4
        room.zPosition = 1
//        setup barrier
        barrierTopRT.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        barrierTopRT.xScale = 0.4
        barrierTopRT.yScale = 0.4
        barrierTopRT.physicsBody = SKPhysicsBody(texture: barrierTopRT.texture!, size: barrierTopRT.size)
        barrierTopRT.physicsBody?.affectedByGravity = false
        barrierTopRT.physicsBody?.restitution = 0
        barrierTopRT.physicsBody?.allowsRotation = false
        barrierTopRT.physicsBody?.isDynamic = false
        barrierTopRT.physicsBody?.categoryBitMask = PhysicsCategories.MapEdge
        barrierTopRT.physicsBody?.contactTestBitMask = PhysicsCategories.Player
        barrierTopRT.alpha = 0.01
        barrierTopRT.name = "outerBarrier"
        barrierTopLF.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        barrierTopLF.xScale = 0.4
        barrierTopLF.yScale = 0.4
        barrierTopLF.physicsBody = SKPhysicsBody(texture: barrierTopLF.texture!, size: barrierTopLF.size)
        barrierTopLF.physicsBody?.affectedByGravity = false
        barrierTopLF.physicsBody?.restitution = 0
        barrierTopLF.physicsBody?.allowsRotation = false
        barrierTopLF.physicsBody?.isDynamic = false
        barrierTopLF.physicsBody?.categoryBitMask = PhysicsCategories.MapEdge
        barrierTopLF.physicsBody?.contactTestBitMask = PhysicsCategories.Player
        barrierTopLF.alpha = 0.01
        barrierTopLF.name = "outerBarrier"
        barrierDownRT.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        barrierDownRT.xScale = 0.4
        barrierDownRT.yScale = 0.4
        barrierDownRT.physicsBody = SKPhysicsBody(texture: barrierDownRT.texture!, size: barrierDownRT.size)
        barrierDownRT.physicsBody?.affectedByGravity = false
        barrierDownRT.physicsBody?.restitution = 0
        barrierDownRT.physicsBody?.allowsRotation = false
        barrierDownRT.physicsBody?.isDynamic = false
        barrierDownRT.physicsBody?.categoryBitMask = PhysicsCategories.MapEdge
        barrierDownRT.physicsBody?.contactTestBitMask = PhysicsCategories.Player
        barrierDownRT.alpha = 0.01
        barrierDownRT.name = "outerBarrier"
        barrierDownLF.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        barrierDownLF.xScale = 0.4
        barrierDownLF.yScale = 0.4
        barrierDownLF.physicsBody = SKPhysicsBody(texture: barrierDownLF.texture!, size: barrierDownLF.size)
        barrierDownLF.physicsBody?.affectedByGravity = false
        barrierDownLF.physicsBody?.restitution = 0
        barrierDownLF.physicsBody?.allowsRotation = false
        barrierDownLF.physicsBody?.isDynamic = false
        barrierDownLF.physicsBody?.categoryBitMask = PhysicsCategories.MapEdge
        barrierDownLF.physicsBody?.contactTestBitMask = PhysicsCategories.Player
        barrierDownLF.alpha = 0.01
        barrierDownLF.name = "outerBarrier"
//        setup collider
        doorColliderLF.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        doorColliderLF.xScale = 0.4
        doorColliderLF.yScale = 0.4
        doorColliderLF.physicsBody = SKPhysicsBody(texture: doorColliderLF.texture!, size: doorColliderLF.size)
        doorColliderLF.physicsBody?.affectedByGravity = false
        doorColliderLF.physicsBody?.restitution = 0
        doorColliderLF.physicsBody?.allowsRotation = false
        doorColliderLF.physicsBody?.isDynamic = false
        doorColliderLF.physicsBody?.categoryBitMask = PhysicsCategories.MapEdge
        doorColliderLF.physicsBody?.contactTestBitMask = PhysicsCategories.Player
        doorColliderLF.alpha = 0.01
        doorColliderLF.name = "doorColliderLF"
        doorColliderRT.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        doorColliderRT.xScale = 0.4
        doorColliderRT.yScale = 0.4
        doorColliderRT.physicsBody = SKPhysicsBody(texture: doorColliderRT.texture!, size: doorColliderRT.size)
        doorColliderRT.physicsBody?.affectedByGravity = false
        doorColliderRT.physicsBody?.restitution = 0
        doorColliderRT.physicsBody?.allowsRotation = false
        doorColliderRT.physicsBody?.isDynamic = false
        doorColliderRT.physicsBody?.categoryBitMask = PhysicsCategories.MapEdge
        doorColliderRT.physicsBody?.contactTestBitMask = PhysicsCategories.Player
        doorColliderRT.alpha = 0.01
        doorColliderRT.name = "doorColliderRT"
//        setup boxes
        boxes.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        boxes.xScale = 0.4
        boxes.yScale = 0.4
        boxes.zPosition = 3
//        setup door left
        doorLF.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        doorLF.xScale = 0.4
        doorLF.yScale = 0.4
        doorLF.zPosition = 3
        doorLF.name = "doorLF"
//        setup door right
        doorRTopen.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        doorRTopen.xScale = 0.4
        doorRTopen.yScale = 0.4
        doorRTopen.zPosition = 3
//        setup lamp
        lamp.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        lamp.xScale = 0.4
        lamp.yScale = 0.4
        lamp.zPosition = 3

    }
}

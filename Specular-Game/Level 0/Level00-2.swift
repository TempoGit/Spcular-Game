
//  Level00-2.swift
//  Specular-Game
//
//  3331412399
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

    
    let room2 = SKSpriteNode(imageNamed: "Level0-Room2")
    let lamp = SKSpriteNode(imageNamed: "Level0-Room2-Lamp")
    let bookshelf = SKSpriteNode(imageNamed: "Level0-Room2-bookshelf")
    let door = SKSpriteNode(imageNamed: "Level0-Room2-DoorOpen")
    let characterAvatar = SKSpriteNode(imageNamed: "Character")
    let characterFeetCollider = SKSpriteNode(imageNamed: "CharacterFeet2")
    
    let player = SKSpriteNode()
    
    let cameraNode = SKCameraNode()
    
    let barrieraSX = SKSpriteNode( imageNamed: "Level0-Room2-LeftBarrier")
    let barrieraSU = SKSpriteNode(imageNamed: "Level0-Room2-TopBarrier")
    let barrieraGIU = SKSpriteNode(imageNamed: "Level0-Room2-BottomBarrier")
    let barrieraDX = SKSpriteNode(imageNamed: "level0-Room2-RightBarrier")
    
    var move: Bool = false
    var moveSingle: Bool = false
    var location = CGPoint.zero
    var worldGroup = SKSpriteNode()

    let pauseButton = SKSpriteNode(imageNamed: "Pause")

    
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
        room2.xScale = 0.4
        room2.yScale = 0.4
        
        lamp.position = CGPoint(x: size.width*0.5,y: size.height*0.5)
        lamp.xScale = 0.4
        lamp.yScale = 0.4
        
        bookshelf.position = CGPoint(x: size.width*0.5,y: size.height*0.5)
        bookshelf.xScale = 0.4
        bookshelf.yScale = 0.4
        
        door.position = CGPoint(x: size.width*0.5,y: size.height*0.5)
        door.xScale = 0.4
        door.yScale = 0.4
        door.zPosition = 7
        
        characterAvatar.anchorPoint = CGPoint(x: 0.5,y: 0)
        characterAvatar.position = CGPoint(x: size.width*1.1,y: size.height*0.24)
        characterAvatar.xScale = 0.5
        characterAvatar.yScale = 0.5
        characterAvatar.zPosition = 8
        characterFeetCollider.position = CGPoint(x: size.width*1.1,y: size.height*0.25)
        characterFeetCollider.xScale = 0.5
        characterFeetCollider.yScale = 0.5
        characterFeetCollider.physicsBody = SKPhysicsBody(texture: characterFeetCollider.texture!, size: characterFeetCollider.size)
        characterFeetCollider.physicsBody?.affectedByGravity = false
        characterFeetCollider.physicsBody?.restitution = 0
        characterFeetCollider.physicsBody?.allowsRotation = false
        characterFeetCollider.physicsBody?.categoryBitMask = PhysicsCategories.Player
        characterFeetCollider.physicsBody?.contactTestBitMask = PhysicsCategories.MapEdge
        player.position = CGPoint(x: size.width*0.5, y: size.height*0.35)
        
        barrieraGIU.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5 )
        barrieraGIU.zRotation = 0
        barrieraGIU.xScale = 0.4
        barrieraGIU.yScale = 0.4
        barrieraGIU.physicsBody = SKPhysicsBody(texture: barrieraSX.texture!, size: barrieraSX.size)
        barrieraGIU.physicsBody?.affectedByGravity = false
        barrieraGIU.physicsBody?.restitution = 0
        barrieraGIU.physicsBody?.allowsRotation = false
        barrieraGIU.physicsBody?.isDynamic = false
        barrieraGIU.physicsBody?.categoryBitMask = PhysicsCategories.MapEdge
        barrieraGIU.physicsBody?.contactTestBitMask = PhysicsCategories.Player
        barrieraGIU.alpha = 0.01
        barrieraGIU.name = "outerBarrier"
//
//        barrieraDX.position = CGPoint(x: size.width/2, y: size.height/2)
//        barrieraDX.xScale = 0.4
//        barrieraDX.yScale = 0.4
//        barrieraDX.physicsBody = SKPhysicsBody(texture: barrieraSX.texture!, size: barrieraSX.size)
//        barrieraDX.physicsBody?.affectedByGravity = false
//        barrieraDX.physicsBody?.restitution = 0
//        barrieraDX.physicsBody?.allowsRotation = false
//        barrieraDX.physicsBody?.isDynamic = false
//        barrieraDX.physicsBody?.categoryBitMask = PhysicsCategories.MapEdge
//        barrieraDX.physicsBody?.contactTestBitMask = PhysicsCategories.Player
//        barrieraDX.alpha = 0.01
//        barrieraDX.name = "outerBarrier"
        
        barrieraSX.position = CGPoint(x: size.width / 2, y: size.height / 2)
        barrieraSX.xScale = 0.4
        barrieraSX.yScale = 0.4
        barrieraSX.physicsBody = SKPhysicsBody(texture: barrieraSX.texture!, size: barrieraSX.size)
        barrieraSX.physicsBody?.affectedByGravity = false
        barrieraSX.physicsBody?.restitution = 0
        barrieraSX.physicsBody?.allowsRotation = false
        barrieraSX.physicsBody?.isDynamic = false
        barrieraSX.physicsBody?.categoryBitMask = PhysicsCategories.MapEdge
        barrieraSX.physicsBody?.contactTestBitMask = PhysicsCategories.Player
        barrieraSX.alpha = 0.01
        barrieraSX.name = "outerBarrier"
        
        barrieraSU.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        barrieraSU.xScale = 0.4
        barrieraSU.yScale = 0.4
        barrieraSU.physicsBody = SKPhysicsBody(texture: barrieraSU.texture!, size: barrieraSU.size)
        barrieraSU.physicsBody?.affectedByGravity = false
        barrieraSU.physicsBody?.restitution = 0
        barrieraSU.physicsBody?.allowsRotation = false
        barrieraSU.physicsBody?.isDynamic = false
        barrieraSU.physicsBody?.categoryBitMask = PhysicsCategories.MapEdge
        barrieraSU.physicsBody?.contactTestBitMask = PhysicsCategories.Player
        barrieraSU.alpha = 0.01
        barrieraSU.name = "outerBarrier"
        
        pauseButton.name = "pause"
        pauseButton.position = CGPoint(x: -gameArea.size.width/3 + CGFloat(10), y: gameArea.size.height*0.9 + CGFloat(10))
        pauseButton.zPosition = 20
        pauseButton.xScale = 0.2
        pauseButton.yScale = 0.2
        cameraNode.addChild(pauseButton)
        
        
        worldGroup.addChild(room2)
        worldGroup.addChild(lamp)
        worldGroup.addChild(bookshelf)
        worldGroup.addChild(door)
        worldGroup.addChild(barrieraSU)
        worldGroup.addChild(barrieraSX)
        worldGroup.addChild(barrieraGIU)
        worldGroup.addChild(barrieraDX)
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
            PauseMenuHandler.instance.volumeOnButton.alpha = 0.5
            PauseMenuHandler.instance.volumeOffButton.alpha = 1
            musicHandler.instance.muteBackgroundMusic()
        }
        if(touchedNode.name == "volumeOn"){
            PauseMenuHandler.instance.volumeOnButton.alpha = 1
            PauseMenuHandler.instance.volumeOffButton.alpha = 0.5
            musicHandler.instance.unmuteBackgroundMusic()
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
        //Se clicco in un punto qulasiasi dello schermo la cui posizione è diversa da quella del personaggio allora inizio il movimento del personaggio impostando la variabile moveSingle a true. Questo movimento del personaggio sul tap singolo dello schermo mi serve per fare una transizione fluida dal "non tocco" (quando il personaggio è fermo) dello schermo al "tocco continuo dello schermo" (quando il personaggio è in movimento e posso direzionare il suo spostamento muovendo il dito sullo schermo)
        //Assegno il valore della posizione del tocco alla variabile "location" così posso usare questo valore anche fuori da questa funzione, lo uso in particolare nella funzione di "update"
        if(touchLocation != characterFeetCollider.position){
            location = touchLocation
            moveSingle = true
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        //Se almeno una delle due variabili responsabili del movimento sono impostate a "true" allora inizia il movimento
        //Controllo se la posizione del tocco dello schermo è in alto, in basso, a sinistra o a destra rispetto alla posizione corrente del personaggio ed effettuo il movimento di conseguenza.
        //N.B.: Per cambiare la velocità di movimento basta cambiare il valore dopo i +=
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
        //Alla fine della funzione di update vado ad impostare la posizione dell'avatar del personaggio in relazione a quella del collider dei piedi
        characterAvatar.position = characterFeetCollider.position
        characterAvatar.position.y = characterAvatar.position.y - 8
        //Vado poi a centrare la camera sul personaggio
        cameraNode.position = characterAvatar.position
        //Metto la camera di gioco un po' pià in alto così si vede la cima della stanza
        cameraNode.position.y += size.height*0.2
        
        //Funzione che controlla le intersezioni tra gli oggetti
//        checkCollisions()
        
    
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
    
    
    func checkCollisions(){

    }
    
    func roomSetup(){
        
    }
    
}


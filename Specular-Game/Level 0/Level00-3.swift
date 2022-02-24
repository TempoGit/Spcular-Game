//
//  Level00-3.swift
//  Specular-Game
//
//  Created by Guendalina De Laurentis on 21/02/22.
//
//MANNAGGIA

import AVFoundation
import UIKit
import SpriteKit
import SwiftUI


class Level00_3: SKScene, SKPhysicsContactDelegate{
    @AppStorage("language") var language: String = "English"
    
    let pauseButton = SKSpriteNode(imageNamed: "Pause")
    let room = SKSpriteNode(imageNamed: "Level0-Room3")
    let characterAvatar = SKSpriteNode(imageNamed: "Stop")
    let characterFeetCollider = SKSpriteNode(imageNamed: "CharacterFeet2")
    
    let barrierDownLF = SKSpriteNode(imageNamed: "BarrierBottomLF-Room3")
    let barrierDownRT = SKSpriteNode(imageNamed: "BarrierBottomRT-Room3")
    let barrierTopLF = SKSpriteNode(imageNamed: "BarrierLeft(1)")
    let barrierTopRT = SKSpriteNode(imageNamed: "BarrierTopRT-Room3")
    
    let doorColliderTopLF = SKSpriteNode(imageNamed: "DoorColliderTopLF-Room3")
    let doorColliderTopRT = SKSpriteNode(imageNamed: "DoorColliderTopRT-Room3")
    
    let armachair = SKSpriteNode(imageNamed: "Armchairs-Room3")
    let books = SKSpriteNode(imageNamed: "Books-Room3")
    let doorLF = SKSpriteNode(imageNamed: "Door open1-Room3")
    let doorRT = SKSpriteNode(imageNamed: "Door open RT-Room3")
    let lamp = SKSpriteNode(imageNamed: "Floor Lamp-Room3")
    
    let colliderLamp = SKSpriteNode(imageNamed: "ColliderLampRoom3")
    let colliderBook = SKSpriteNode(imageNamed: "Level0-Room3-BookCollider")
    let bookTransparencyCollider = SKSpriteNode(imageNamed: "Level0-Room3-BooksTransparencyCollider")
    let colliderArmchairLeft = SKSpriteNode(imageNamed: "Level0-Room3-ArmchairColliderLeft")
    let colliderArmchairRight = SKSpriteNode(imageNamed: "Level0-Room3-ArmchairColliderRight")
    let colliderTrasparencyChair = SKSpriteNode(imageNamed: "ColliderTrasparencyRoom3")
    let armchairsTransparencyCollider = SKSpriteNode(imageNamed: "Level0-Room3-ArmchairsTransparencyCollider")
    
    var WorldGroup = SKSpriteNode()
    
    var tappedObject: Bool = false
    var moveSingle: Bool = false
    var move: Bool = false
    var location = CGPoint.zero
    
    //Variabili per gestire le animazioni
    var walkingRight: Bool = false
    var walkingLeft: Bool = false
    var walkingUp: Bool = false
    var walkingDown: Bool = false
    
    var chairCollider: Bool = false
    var booksCollided: Bool = false
    
    
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
        roomSetUp()
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
        addChild(colliderBook)
        addChild(bookTransparencyCollider)
        addChild(colliderLamp)
        addChild(colliderArmchairLeft)
        addChild(colliderArmchairRight)
        addChild(colliderTrasparencyChair)
        addChild(armchairsTransparencyCollider)
        
        addChild(cameraNode)
        camera = cameraNode
        //Aggiungo il bottonr per aprire il menu di pausa alla camera di gioco
        cameraNode.addChild(pauseButton)
        
        
        //Avvio la musica del livello
        musicHandler.instance.playBackgroundMusic()
        
        //Per abilitare le collisioni nella scena
        self.scene?.physicsWorld.contactDelegate = self
     
        previousRoom = "Room3"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{
            return
        }
        let touchLocation = touch.location(in: self)
        let touchedNode = atPoint(touchLocation)
        
        if(touchedNode.name == "goToMenu"){
            musicHandler.instance.stopLevelBackgroundMusic()
            let gameScene = GameScene(size: size)
            view?.presentScene(gameScene)
        }
        
        //Se premo sul bottone di pausa vado a mettere la scena in pausa, dopodichè faccio un controllo: nel caso in cui la variabile firstSet sia impostata a falsa significa che da quando ho aperto l'applicazione ancora non ho impostato nessuna volta la posizione degli elementi del menu di pausa, quindi procedo a farlo e dopodichè richiamo la funzione initializeNodeSettings() che nel caso in cui sia la prima volta che è richiamata fa tutte le impostazioni del caso del menu di pausa e poi mette la variabile firstSet a true, altrimenti si occupa solamente di impostare la trasparenza dei bottoni dell'attivazione e disattivazione della musica.
        //Fatto questo quello che faccio è caricare il menu di pausa nella scena aggiungengo i nodi al cameraNode
        if(touchedNode.name == "pause"){
            self.isPaused = true
            if(PauseMenuHandler.instance.firstSet == false){
                PauseMenuHandler.instance.closePauseMenu.position = CGPoint(x: -gameArea.size.width*0.25, y: gameArea.size.height*0.35)
                PauseMenuHandler.instance.goBackToMenu.position = CGPoint(x: -gameArea.size.width*0, y: -gameArea.size.height*0.4)
                PauseMenuHandler.instance.languageLabel.position = CGPoint(x: -gameArea.size.width*0.15, y: -gameArea.size.height*0.1)
                PauseMenuHandler.instance.languageSelectionButton.position = CGPoint(x: gameArea.size.width*0.2, y: -gameArea.size.height*0.1)
                PauseMenuHandler.instance.volumeOffButton.position = CGPoint(x: -gameArea.size.width*0.15, y: gameArea.size.height*0.15)
                PauseMenuHandler.instance.volumeOnButton.position = CGPoint(x: -gameArea.size.width*0.15, y: gameArea.size.height*0.15)
            }
            PauseMenuHandler.instance.initializeNodeSettings()
            cameraNode.addChild(PauseMenuHandler.instance.pauseSquare)
            cameraNode.addChild(PauseMenuHandler.instance.backgroundPause)
            if(musicHandler.instance.mutedMusic){
                cameraNode.addChild(PauseMenuHandler.instance.volumeOffButton)
            } else if(!musicHandler.instance.mutedMusic){
                cameraNode.addChild(PauseMenuHandler.instance.volumeOnButton)
            }
            if(language == "Italian"){
                PauseMenuHandler.instance.languageLabel.text = LanguageHandler.instance.languageLabelItalian
                PauseMenuHandler.instance.languageSelectionButton.text = LanguageHandler.instance.languageSelectionButtonItalian
                PauseMenuHandler.instance.goBackToMenu.text = LanguageHandler.instance.goBackToMainMenuLabelItalian
            } else if (language == "English"){
                PauseMenuHandler.instance.languageLabel.text = LanguageHandler.instance.languageLabelEnglish
                PauseMenuHandler.instance.languageSelectionButton.text = LanguageHandler.instance.languageSelectionButtonEnglish
                PauseMenuHandler.instance.goBackToMenu.text = LanguageHandler.instance.goBackToMainMenuLabelEnglish
            }
            cameraNode.addChild(PauseMenuHandler.instance.languageSelectionButton)
            cameraNode.addChild(PauseMenuHandler.instance.closePauseMenu)
            cameraNode.addChild(PauseMenuHandler.instance.goBackToMenu)
            cameraNode.addChild(PauseMenuHandler.instance.languageLabel)
        }

        
        if(touchedNode.name == "volumeButton"){
            if(musicHandler.instance.mutedMusic == false){
                PauseMenuHandler.instance.volumeOnButton.removeFromParent()
                musicHandler.instance.muteBackgroundMusic()
                cameraNode.addChild(PauseMenuHandler.instance.volumeOffButton)
            } else if  (musicHandler.instance.mutedMusic){
                PauseMenuHandler.instance.volumeOffButton.removeFromParent()
                musicHandler.instance.unmuteBackgroundMusic()
                cameraNode.addChild(PauseMenuHandler.instance.volumeOnButton)
            }
        }
        
        if(touchedNode.name == "languageButton"){
            if(language == "English"){
                language = "Italian"
            } else if (language == "Italian"){
                language = "English"
            }
            
            PauseMenuHandler.instance.languageLabel.removeFromParent()
            PauseMenuHandler.instance.languageSelectionButton.removeFromParent()
            PauseMenuHandler.instance.goBackToMenu.removeFromParent()
            if(language == "English"){
                PauseMenuHandler.instance.languageLabel.text = LanguageHandler.instance.languageLabelEnglish
                PauseMenuHandler.instance.languageSelectionButton.text = LanguageHandler.instance.languageSelectionButtonEnglish
                PauseMenuHandler.instance.goBackToMenu.text = LanguageHandler.instance.goBackToMainMenuLabelEnglish
            } else if (language == "Italian"){
                PauseMenuHandler.instance.languageLabel.text = LanguageHandler.instance.languageLabelItalian
                PauseMenuHandler.instance.languageSelectionButton.text = LanguageHandler.instance.languageSelectionButtonItalian
                PauseMenuHandler.instance.goBackToMenu.text = LanguageHandler.instance.goBackToMainMenuLabelItalian
            }
            cameraNode.addChild(PauseMenuHandler.instance.languageLabel)
            cameraNode.addChild(PauseMenuHandler.instance.languageSelectionButton)
            cameraNode.addChild(PauseMenuHandler.instance.goBackToMenu)
        }

        
        
        //Se clicco il bottone per chiudere il menu di pausa rimuovo tutti gli oggetti che compongono il menu di pausa dal cameraNode e rimuovo la pausa dalla scena di gioco
        if(touchedNode.name == "closePause"){
            PauseMenuHandler.instance.languageLabel.removeFromParent()
            PauseMenuHandler.instance.languageSelectionButton.removeFromParent()
            PauseMenuHandler.instance.backgroundPause.removeFromParent()
            PauseMenuHandler.instance.pauseSquare.removeFromParent()
            if(musicHandler.instance.mutedMusic){
                PauseMenuHandler.instance.volumeOffButton.removeFromParent()
            } else {
                PauseMenuHandler.instance.volumeOnButton.removeFromParent()
            }
            PauseMenuHandler.instance.goBackToMenu.removeFromParent()
            PauseMenuHandler.instance.closePauseMenu.removeFromParent()
            self.isPaused = false
        }
        
        if(touchLocation != characterFeetCollider.position){
            location = touchLocation
            moveSingle = true
            //Così faccio iniziare l'animazione della camminata che si ripete per sempre e viene interrotta solamente quando finisce il movimento, cioè quando alzo il dito dallo schermo
            
            if(location.x > characterFeetCollider.position.x){
                walkingRight = true
                if (location.y > characterFeetCollider.position.y) {
                    walkingUp = true
                    characterAvatar.run(SKAction.repeatForever(walkingAnimationRightUp))
                } else if (location.y < characterFeetCollider.position.y){
                    walkingDown = true
                    characterAvatar.run(SKAction.repeatForever(walkingAnimationRightDown))
                }
            } else if (location.x < characterFeetCollider.position.x){
                walkingLeft = true
                if (location.y > characterFeetCollider.position.y) {
                    walkingUp = true
                    characterAvatar.run(SKAction.repeatForever(walkingAnimationLeftUp))
                } else if (location.y < characterFeetCollider.position.y){
                    walkingDown = true
                    characterAvatar.run(SKAction.repeatForever(walkingAnimationLeftDown))
                }
            }
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
        //Quando smetto di toccare lo schermo interrompo entrambi i tipi di movimento
        move = false
        moveSingle = false
        //Se alzo il dito dallo schermo, ovvero interrompo il movimento, blocco le azioni del personaggio, cioè quello che mi interessa bloccare sono le animazioni e resetto la posizione statica del personaggio con il setTexture
        characterAvatar.removeAllActions()
        if(walkingLeft && walkingDown){
            characterAvatar.run(SKAction.setTexture(SKTexture(imageNamed: "Stop")))
        } else if (walkingRight && walkingDown){
            characterAvatar.run(SKAction.setTexture(SKTexture(imageNamed: "StopRight")))
        } else if (walkingRight && walkingUp){
            characterAvatar.run(SKAction.setTexture(SKTexture(imageNamed: "StopBackRight")))
        } else if (walkingLeft && walkingUp) {
            characterAvatar.run(SKAction.setTexture(SKTexture(imageNamed: "StopBackLeft")))
        }
        //Reimposto tutte le variabili che si occupano di gestire le animazioni della camminata a false
        walkingUp = false
        walkingDown = false
        walkingLeft = false
        walkingRight = false
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
                    if (location.y > characterFeetCollider.position.y + 10 && location.x > characterFeetCollider.position.x + 10){
                        if(!walkingRight || !walkingUp){
                            walkingLeft = false
                            walkingDown = false
                            walkingRight = true
                            walkingUp = true
                            characterAvatar.removeAllActions()
                            characterAvatar.run(SKAction.repeatForever(walkingAnimationRightUp))
                        }
                    }
                } else if(location.y < characterFeetCollider.position.y){
                    characterFeetCollider.position.y -= 0.8
                    if (location.y < characterFeetCollider.position.y - 10 && location.x > characterFeetCollider.position.x - 10){
                        if(!walkingRight || !walkingDown){
                            walkingRight = true
                            walkingDown = true
                            walkingLeft = false
                            walkingUp = false
                            characterAvatar.removeAllActions()
                            characterAvatar.run(SKAction.repeatForever(walkingAnimationRightDown))
                        }
                    }
                }
            } else if (location.x < characterFeetCollider.position.x){
                characterFeetCollider.position.x -= 0.8
                if(location.y > characterFeetCollider.position.y){
                    characterFeetCollider.position.y += 0.8
                    if(location.y > characterFeetCollider.position.y + 10 && location.x < characterFeetCollider.position.x + 10){
                        if(!walkingLeft || !walkingUp){
                            walkingLeft = true
                            walkingUp = true
                            walkingRight = false
                            walkingDown = false
                            characterAvatar.removeAllActions()
                            characterAvatar.run(SKAction.repeatForever(walkingAnimationLeftUp))
                        }
                    }
                } else if(location.y < characterFeetCollider.position.y){
                    characterFeetCollider.position.y -= 0.8
                    if(location.y < characterFeetCollider.position.y - 10 && location.x < characterFeetCollider.position.x - 10){
                        if(!walkingLeft || !walkingDown){
                            walkingLeft = true
                            walkingDown = true
                            walkingRight = false
                            walkingUp = false
                            characterAvatar.removeAllActions()
                            characterAvatar.run(SKAction.repeatForever(walkingAnimationLeftDown))
                        }
                    }
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
        
        checkCollisions()
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactA = contact.bodyA.node?.name
        let contactB = contact.bodyB.node?.name
        
       
        if(contactA == "player" || contactB == "player"){
            if(contactA == "doorColliderTopRT" || contactB == "doorColliderTopRT"){
                let room4 = Level00_4(size: size)
                view?.presentScene(room4)
            } else if(contactA == "doorColliderTopLF" || contactB == "doorColliderTopLF"){
                let room2 = Level00_2(size: size)
                view?.presentScene(room2)
            }
        }
    }
    
    func checkCollisions(){
        if(characterFeetCollider.frame.intersects(armchairsTransparencyCollider.frame)){
            chairCollider = true
            characterAvatar.zPosition = 10
            armachair.zPosition = 11
        } else{
            if(chairCollider){
                chairCollider = false
                characterAvatar.zPosition = 11
                armachair.zPosition = 10
            }
        }
        
        if(characterFeetCollider.frame.intersects(bookTransparencyCollider.frame)){
            booksCollided = true
            characterAvatar.zPosition = 10
            books.zPosition = 11
        } else{
            if(booksCollided){
                booksCollided = false
                characterAvatar.zPosition = 11
                books.zPosition = 10
            }
        }
        
    }
    
    
    
    func roomSetUp(){
        room.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        room.xScale = 0.4
        room.yScale = 0.4
        room.zPosition = -1
        
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
        
        characterAvatar.anchorPoint = CGPoint(x: 0.5,y: 0)
        characterAvatar.xScale = 0.14
        characterAvatar.yScale = 0.14
        characterAvatar.zPosition = 5
        characterAvatar.name = "player"
        if(previousRoom == "Room2"){
            characterFeetCollider.position = CGPoint(x: size.width*0,y: size.height*0.35)
            characterAvatar.run(SKAction.setTexture(SKTexture(imageNamed: "StopRight")))
        }else {
            characterFeetCollider.position = CGPoint(x: size.width*1.18,y: size.height*0.27)
        }
        characterFeetCollider.xScale = 0.5
        characterFeetCollider.yScale = 0.5
        characterFeetCollider.physicsBody = SKPhysicsBody(texture: characterFeetCollider.texture!, size: characterFeetCollider.size)
        characterFeetCollider.physicsBody?.affectedByGravity = false
        characterFeetCollider.physicsBody?.restitution = 0
        characterFeetCollider.physicsBody?.allowsRotation = false
        characterFeetCollider.physicsBody?.categoryBitMask = PhysicsCategories.Player
        characterFeetCollider.physicsBody?.contactTestBitMask = PhysicsCategories.MapEdge
        characterFeetCollider.name = "player"
        
        pauseButton.name = "pause"
        pauseButton.position = CGPoint(x: -gameArea.size.width/3 + CGFloat(10), y: gameArea.size.height*0.9 + CGFloat(10))
        pauseButton.zPosition = 20
        pauseButton.xScale = 0.2
        pauseButton.yScale = 0.2
        
        doorColliderTopRT.position = CGPoint(x: size.width*0.5, y:size.height*0.5)
        doorColliderTopRT.name = "doorColliderTopRT"
        doorColliderTopRT.alpha = 0.01
        doorColliderTopRT.xScale = 0.4
        doorColliderTopRT.yScale = 0.4
        doorColliderTopRT.physicsBody = SKPhysicsBody(texture: doorColliderTopRT.texture!, size: doorColliderTopRT.size)
        doorColliderTopRT.physicsBody?.affectedByGravity = false
        doorColliderTopRT.physicsBody?.restitution = 0
        doorColliderTopRT.physicsBody?.allowsRotation = false
        doorColliderTopRT.physicsBody?.isDynamic = false
        doorColliderTopRT.physicsBody?.categoryBitMask = PhysicsCategories.LowerDoor
        doorColliderTopRT.physicsBody?.contactTestBitMask = PhysicsCategories.Player
        
        doorColliderTopLF.position = CGPoint(x: size.width*0.5, y:size.height*0.5)
        doorColliderTopLF.name = "doorColliderTopLF"
        doorColliderTopLF.alpha = 0.01
        doorColliderTopLF.xScale = 0.4
        doorColliderTopLF.yScale = 0.4
        doorColliderTopLF.physicsBody = SKPhysicsBody(texture: doorColliderTopLF.texture!, size: doorColliderTopLF.size)
        doorColliderTopLF.physicsBody?.affectedByGravity = false
        doorColliderTopLF.physicsBody?.restitution = 0
        doorColliderTopLF.physicsBody?.allowsRotation = false
        doorColliderTopLF.physicsBody?.isDynamic = false
        doorColliderTopLF.physicsBody?.categoryBitMask = PhysicsCategories.LowerDoor
        doorColliderTopLF.physicsBody?.contactTestBitMask = PhysicsCategories.Player
        

        doorRT.position = CGPoint(x: size.width*0.5, y:size.height*0.5)
        doorRT.name = "doorRT"
        doorRT.alpha = 1
        doorRT.xScale = 0.4
        doorRT.yScale = 0.4
        
        doorLF.position = CGPoint(x: size.width*0.5, y:size.height*0.5)
        doorLF.name = "doorLF"
        doorLF.alpha = 1
        doorLF.xScale = 0.4
        doorLF.yScale = 0.4
 
        armachair.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        armachair.xScale = 0.4
        armachair.yScale = 0.4
        armachair.zPosition = 3
        colliderArmchairLeft.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        colliderArmchairLeft.xScale = 0.4
        colliderArmchairLeft.yScale = 0.4
        colliderArmchairLeft.alpha = 0.01
        colliderArmchairLeft.physicsBody = SKPhysicsBody(texture: colliderArmchairLeft.texture!, size: colliderArmchairLeft.size)
        colliderArmchairLeft.physicsBody?.affectedByGravity = false
        colliderArmchairLeft.physicsBody?.restitution = 0
        colliderArmchairLeft.physicsBody?.allowsRotation = false
        colliderArmchairLeft.physicsBody?.isDynamic = false
        colliderArmchairLeft.zPosition = 3
        colliderArmchairRight.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        colliderArmchairRight.xScale = 0.4
        colliderArmchairRight.yScale = 0.4
        colliderArmchairRight.alpha = 0.01
        colliderArmchairRight.physicsBody = SKPhysicsBody(texture: colliderArmchairRight.texture!, size: colliderArmchairRight.size)
        colliderArmchairRight.physicsBody?.affectedByGravity = false
        colliderArmchairRight.physicsBody?.restitution = 0
        colliderArmchairRight.physicsBody?.allowsRotation = false
        colliderArmchairRight.physicsBody?.isDynamic = false
        colliderArmchairRight.zPosition = 3
        
        colliderTrasparencyChair.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        colliderTrasparencyChair.xScale = 0.4
        colliderTrasparencyChair.yScale = 0.4
        colliderTrasparencyChair.alpha = 0.01
        armchairsTransparencyCollider.position = CGPoint(x: size.width*0.5, y: size.height*0.41)
        armchairsTransparencyCollider.xScale = 0.4
        armchairsTransparencyCollider.yScale = 0.4
        armchairsTransparencyCollider.alpha = 0.01
        
        lamp.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        lamp.xScale = 0.4
        lamp.yScale = 0.4
        lamp.zPosition = 3
        colliderLamp.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        colliderLamp.xScale = 0.4
        colliderLamp.yScale = 0.4
        colliderLamp.alpha = 0.01
        colliderLamp.physicsBody = SKPhysicsBody(texture: colliderLamp.texture!, size: colliderLamp.size)
        colliderLamp.physicsBody?.affectedByGravity = false
        colliderLamp.physicsBody?.allowsRotation = false
        colliderLamp.physicsBody?.restitution = 0
        colliderLamp.physicsBody?.isDynamic = false
        colliderLamp.zPosition = 3
        
        books.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        books.xScale = 0.4
        books.yScale = 0.4
        books.zPosition = 3
        colliderBook.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        colliderBook.xScale = 0.4
        colliderBook.yScale = 0.4
        colliderBook.alpha = 0.01
        colliderBook.physicsBody = SKPhysicsBody(texture: colliderBook.texture!, size: colliderBook.size)
        colliderBook.physicsBody?.affectedByGravity = false
        colliderBook.physicsBody?.allowsRotation = false
        colliderBook.physicsBody?.isDynamic = false
        colliderBook.physicsBody?.restitution = 0
        colliderBook.zPosition = 3
        bookTransparencyCollider.position = CGPoint(x: size.width*0.705, y: size.height*0.22)
        bookTransparencyCollider.xScale = 0.4
        bookTransparencyCollider.yScale = 0.4
        bookTransparencyCollider.zPosition = 3
        bookTransparencyCollider.alpha = 0.01
        
        
    }
}

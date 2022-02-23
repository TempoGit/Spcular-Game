
//  Level00-2.swift
//  Specular-Game
//

//
//  Created by Salvatore Manna on 18/02/22.
//

import UIKit
import SpriteKit
import AVFoundation
import SwiftUI


struct PhysicsCategories1 {
    static let Player : UInt32 = 0x1 << 0
    static let MapEdge : UInt32 = 0x1 << 1
}


class Level00_2: SKScene, SKPhysicsContactDelegate {

    @AppStorage("language") var language: String = "English"
    
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
    let barrieraDX = SKSpriteNode(imageNamed: "Level0-Room2-RightBarrier")
    let barrieraPortaSu = SKSpriteNode(imageNamed: "Level0-Room2-TopDoorCollider")
    let barrieraPortaDx = SKSpriteNode(imageNamed: "Level0-Room2-RightDoorCollider")
    
    var move: Bool = false
    var moveSingle: Bool = false
    var location = CGPoint.zero
    
    //Variabili per gestire le animazioni
    var walkingRight: Bool = false
    var walkingLeft: Bool = false
    var walkingUp: Bool = false
    var walkingDown: Bool = false
    
    
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
        roomSetup()
        
        
        worldGroup.addChild(room2)
        worldGroup.addChild(lamp)
        worldGroup.addChild(bookshelf)
        worldGroup.addChild(door)
        worldGroup.addChild(barrieraSU)
        worldGroup.addChild(barrieraSX)
        worldGroup.addChild(barrieraGIU)
        worldGroup.addChild(barrieraDX)
        worldGroup.addChild(barrieraPortaSu)
        worldGroup.addChild(barrieraPortaDx)
        addChild(worldGroup)
        addChild(characterAvatar)
        addChild(characterFeetCollider)
        addChild(player)
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = characterAvatar.position
        
        //Per abilitare le collisioni nella scena
        self.scene?.physicsWorld.contactDelegate = self
        
        previousRoom = "Room2"
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
        //Se clicco in un punto qulasiasi dello schermo la cui posizione è diversa da quella del personaggio allora inizio il movimento del personaggio impostando la variabile moveSingle a true. Questo movimento del personaggio sul tap singolo dello schermo mi serve per fare una transizione fluida dal "non tocco" (quando il personaggio è fermo) dello schermo al "tocco continuo dello schermo" (quando il personaggio è in movimento e posso direzionare il suo spostamento muovendo il dito sullo schermo)
        //Assegno il valore della posizione del tocco alla variabile "location" così posso usare questo valore anche fuori da questa funzione, lo uso in particolare nella funzione di "update"
        if(touchLocation != characterFeetCollider.position){
            location = touchLocation
            moveSingle = true
            //Così faccio iniziare l'animazione della camminata che si ripete per sempre e viene interrotta solamente quando finisce il movimento, cioè quando alzo il dito dallo schermo
//            if(location.x > characterFeetCollider.position.x){
//                print("Walking right")
//                characterAvatar.run(SKAction.repeatForever(walkingAnimation))
//            } else if (location.x < characterFeetCollider.position.x){
//                print("Walking left")
//            }
            
            if(location.x > characterFeetCollider.position.x){
                walkingRight = true
//                print("Walking right")
                if (location.y > characterFeetCollider.position.y) {
                    walkingUp = true
                    print("Walking right and up")
                    characterAvatar.run(SKAction.repeatForever(walkingAnimationRightUp))
                } else if (location.y < characterFeetCollider.position.y){
                    walkingDown = true
                    print("Walking right and down")
                    characterAvatar.run(SKAction.repeatForever(walkingAnimationRightDown))
                }
            } else if (location.x < characterFeetCollider.position.x){
                walkingLeft = true
//                print("Walking left")
                if (location.y > characterFeetCollider.position.y) {
                    walkingUp = true
                    print("Walking left and up")
                    characterAvatar.run(SKAction.repeatForever(walkingAnimationLeftUp))
                } else if (location.y < characterFeetCollider.position.y){
                    walkingDown = true
                    print("Walking left and down")
                    characterAvatar.run(SKAction.repeatForever(walkingAnimationLeftDown))
                }
            }
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
        //Reimposto tutte le variabili che si occupano di gestire le animazioni della camminata a false
        walkingUp = false
        walkingDown = false
        walkingLeft = false
        walkingRight = false
        //Se alzo il dito dallo schermo, ovvero interrompo il movimento, blocco le azioni del personaggio, cioè quello che mi interessa bloccare sono le animazioni e resetto la posizione statica del personaggio con il setTexture
        characterAvatar.removeAllActions()
        characterAvatar.run(SKAction.setTexture(SKTexture(imageNamed: "Character")))
    }
    
    
    func roomSetup(){
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
        characterAvatar.name = "player"
        characterAvatar.xScale = 0.5
        characterAvatar.yScale = 0.5
        characterAvatar.zPosition = 8
        
        if(previousRoom == "Room1"){
            characterFeetCollider.position = CGPoint(x: size.width*1.1,y: size.height*0.25)
        } else {
            characterFeetCollider.position = CGPoint(x: size.width*0.86, y: size.height*0.13)
        }
        
        
        characterFeetCollider.name = "player"
        characterFeetCollider.xScale = 0.5
        characterFeetCollider.yScale = 0.5
        characterFeetCollider.physicsBody = SKPhysicsBody(texture: characterFeetCollider.texture!, size: characterFeetCollider.size)
        characterFeetCollider.physicsBody?.affectedByGravity = false
        characterFeetCollider.physicsBody?.restitution = 0
        characterFeetCollider.physicsBody?.allowsRotation = false
        characterFeetCollider.physicsBody?.categoryBitMask = PhysicsCategories.Player
        characterFeetCollider.physicsBody?.contactTestBitMask = PhysicsCategories.LowerDoor
        player.position = CGPoint(x: size.width*0.5, y: size.height*0.35)
        
        barrieraPortaSu.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5 )
//        barrieraGIU.zRotation = 0
        barrieraPortaSu.name = "PortaSu"
        barrieraPortaSu.xScale = 0.4
        barrieraPortaSu.yScale = 0.4
        barrieraPortaSu.physicsBody = SKPhysicsBody(texture: barrieraPortaSu.texture!, size: barrieraPortaSu.size)
        barrieraPortaSu.physicsBody?.affectedByGravity = false
        barrieraPortaSu.physicsBody?.restitution = 0
        barrieraPortaSu.physicsBody?.allowsRotation = false
        barrieraPortaSu.physicsBody?.isDynamic = false
        barrieraPortaSu.physicsBody?.categoryBitMask = PhysicsCategories.LowerDoor
        barrieraPortaSu.physicsBody?.contactTestBitMask = PhysicsCategories.Player
        barrieraPortaSu.alpha = 0.01
        
        barrieraPortaDx.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5 )
//        barrieraGIU.zRotation = 0
        barrieraPortaDx.name = "PortaDx"
        barrieraPortaDx.xScale = 0.4
        barrieraPortaDx.yScale = 0.4
        barrieraPortaDx.physicsBody = SKPhysicsBody(texture: barrieraPortaDx.texture!, size: barrieraPortaDx.size)
        barrieraPortaDx.physicsBody?.affectedByGravity = false
        barrieraPortaDx.physicsBody?.restitution = 0
        barrieraPortaDx.physicsBody?.allowsRotation = false
        barrieraPortaDx.physicsBody?.isDynamic = false
        barrieraPortaDx.physicsBody?.categoryBitMask = PhysicsCategories.LowerDoor
        barrieraPortaDx.physicsBody?.contactTestBitMask = PhysicsCategories.Player
        barrieraPortaDx.alpha = 0.01
        
        barrieraGIU.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5 )
//        barrieraGIU.zRotation = 0
        barrieraGIU.xScale = 0.4
        barrieraGIU.yScale = 0.4
        barrieraGIU.physicsBody = SKPhysicsBody(texture: barrieraGIU.texture!, size: barrieraGIU.size)
        barrieraGIU.physicsBody?.affectedByGravity = false
        barrieraGIU.physicsBody?.restitution = 0
        barrieraGIU.physicsBody?.allowsRotation = false
        barrieraGIU.physicsBody?.isDynamic = false
        barrieraGIU.physicsBody?.categoryBitMask = PhysicsCategories.MapEdge
        barrieraGIU.physicsBody?.contactTestBitMask = PhysicsCategories.Player
        barrieraGIU.alpha = 0.01
        barrieraGIU.name = "outerBarrier"
//
        barrieraDX.position = CGPoint(x: size.width/2, y: size.height/2)
        barrieraDX.xScale = 0.4
        barrieraDX.yScale = 0.4
        barrieraDX.physicsBody = SKPhysicsBody(texture: barrieraDX.texture!, size: barrieraDX.size)
        barrieraDX.physicsBody?.affectedByGravity = false
        barrieraDX.physicsBody?.restitution = 0
        barrieraDX.physicsBody?.allowsRotation = false
        barrieraDX.physicsBody?.isDynamic = false
        barrieraDX.physicsBody?.categoryBitMask = PhysicsCategories.MapEdge
        barrieraDX.physicsBody?.contactTestBitMask = PhysicsCategories.Player
        barrieraDX.alpha = 0.01
        barrieraDX.name = "outerBarrier"
        
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
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactA = contact.bodyA.node?.name
        let contactB = contact.bodyB.node?.name
        
        
        //Se la collisione che si è verificata ha come protagonisti il personaggio e la porta sul lato inferiore della stanza allora avvia la transizione alla nuova stanza
        if(contactA == "player" || contactB == "player"){
            if(contactA == "PortaSu" || contactB == "PortaSu"){
                //TO DO: transizione verso la nuova stanza
                let room1 = Level00(size: size)
                view?.presentScene(room1)
            }
        }
        if(contactA == "player" || contactB == "player"){
            if(contactA == "PortaDx" || contactB == "PortaDx"){
                //TO DO: transizione verso la nuova stanza
                let room3 = Level00_3(size: size)
                view?.presentScene(room3)
            }
        }

    }
    
    
}




//
//  Level00-4.swift
//  Specular-Game
//
//  Created by Guendalina De Laurentis on 21/02/22.
//

import Foundation
import SpriteKit
import SwiftUI

//let furnitureFrames: [SKTexture] = []


class Level00_4: SKScene, SKPhysicsContactDelegate {
    @AppStorage("language") var language: String = "English"
    
    //    prova animazione cassettone
    var open: Bool = false
//        var openClose = SKSpriteNode()
//        var TextureAtlas = SKTextureAtlas()
//        var TextureArray = [SKTexture]()
        
    
    //Bottone che apre il menu di pausa
    let pauseButton = SKSpriteNode(imageNamed: "Pause")
    
    
    //Divido il personaggio in due parti, una è il collider per i piedi, per gestire le interazioni con gli altri collider per dove il personaggio può camminare, l'altra è l'avatar in sè
    let characterAvatar = SKSpriteNode(imageNamed: "Character")
    let characterFeetCollider = SKSpriteNode(imageNamed: "CharacterFeet2")
    
    //Definisco i nodi che creano la stanza di gioco
    let room = SKSpriteNode(imageNamed: "Level0-Room4-Background")
    let rightBarrier = SKSpriteNode(imageNamed: "Level0-Room4-RightBarrier")
    let lowerBarrier = SKSpriteNode(imageNamed: "Level0-Room4-LowerBarrier")
    let topBarrier = SKSpriteNode(imageNamed: "Level0-Room4-TopBarrier")
    let leftBarrier = SKSpriteNode(imageNamed: "Level0-Room4-LeftBarrier")
    let curtain = SKSpriteNode(imageNamed: "Level0-Room4-Curtain")
    let furniture = SKSpriteNode(imageNamed: "Level0-Room4-Furniture")
//    let furniture = SKSpriteNode(imageNamed: "Level0-Room4-FurnitureClosedSingle")
    let furnitureInteractionCollider = SKSpriteNode(imageNamed: "Level0-Room4-FurnitureInteractionCollider")
    let box = SKSpriteNode(imageNamed: "Level0-Room4-Box")
    let furnitureCollider = SKSpriteNode(imageNamed: "Level0-Room4-FurnitureCollider")
    let boxCollider = SKSpriteNode(imageNamed: "Level0-Room4-BoxCollider")
    let lowerDoor = SKSpriteNode(imageNamed: "Level0-Room4-LowerDoor")
    let rightDoor = SKSpriteNode(imageNamed: "Level0-Room4-RightRoom")
    
    //Variabili usate per il movimento del personaggio
    var move: Bool = false
    var moveSingle: Bool = false
    var location = CGPoint.zero
    
    //Variabili per gestire le animazioni
    var walkingRight: Bool = false
    var walkingLeft: Bool = false
    var walkingUp: Bool = false
    var walkingDown: Bool = false
    
    //Camera di gioco
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
        
//        TextureAtlas = SKTextureAtlas(named: "frame")
//        le immagini della texture atlas le metto nel TextureArray
//        for i in 1...TextureAtlas.textureNames.count{
//            var frame = "Frame_\(i)"
//            TextureArray.append(SKTexture(imageNamed: frame))
//        }
//        openClose = SKSpriteNode(imageNamed: TextureAtlas.textureNames[0])
//        self.addChild(openClose)
        //Per non imputtanire troppo il codice, metto le impostazioni più lunghe in un'altra funzione definita sempre nella classe e la richiamo qui, così almeno sembra un po' più pulito
        roomSetup()
        addChild(room)
        addChild(characterAvatar)
        addChild(characterFeetCollider)
        addChild(rightBarrier)
        addChild(lowerBarrier)
        addChild(topBarrier)
        addChild(leftBarrier)
        addChild(curtain)
        addChild(box)
        addChild(furniture)
        addChild(furnitureInteractionCollider)
        addChild(furnitureCollider)
        addChild(boxCollider)
        addChild(lowerDoor)
        addChild(rightDoor)
        
        
        
        //Aggiungo la camera di gioco
        addChild(cameraNode)
        camera = cameraNode
        
        //Aggiungo il bottonr per aprire il menu di pausa alla camera di gioco
        cameraNode.addChild(pauseButton)
        
        //Avvio la musica del livello
        musicHandler.instance.playBackgroundMusic()
        
        
        self.scene?.physicsWorld.contactDelegate = self
        
        previousRoom = "Room4"
    }
    
    //Funzione che rileva il tocco
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        //Ricavo la posizione sullo schermo del tocco e di eventuali nodi toccati
        let touchLocation = touch.location(in: self)
        let touchedNode = atPoint(touchLocation)
        
        //Se scelgo dal menu di pausa di tornare indietro, fermo la musica del livello e torno al menu principale
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
        //Se tocco il cassettone si apre, se ritocco si chiude, TO DO: Aggiungere una condizione che permette di aprire e chiudere il cassettone solamente se si è nelle vicinanz del cassettone
        if(touchedNode.name == "furniture"){
            if(!open){
                open = true
//                furniture.run(SKAction.setTexture(SKTexture(imageNamed: "Level0-Room4-FurnitureOpenSingle")))
                furniture.run(SKAction.setTexture(SKTexture(imageNamed: "Level0-Room4-FurnitureOpen")))
            } else if (open){
                furniture.run(SKAction.setTexture(SKTexture(imageNamed: "Level0-Room4-Furniture")))
                open = false
            }
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
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Per fare la transizione dal tocco singolo al tocco continuo, quando viene rilevato il tocco continuo, imposto la variabile moveSingle a false, in modo che il movimento col semplice tap si interrompa e poi metto la variabile move a true, così facendo avvio il movimento del personaggio col tocco continuo dello schermo
        //Tengo continuamente traccia di dove sto toccando lo schermo tramite il for ed assegnando il valore della posizione del tocco alla variabile "location", così facendo posso usare il valore del tocco anche al di fuori di questa funzione, in particolare lo uso nella funzione di "update"
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
        //Reimposto tutte le variabili che si occupano di gestire le animazioni della camminata a false
        walkingUp = false
        walkingDown = false
        walkingLeft = false
        walkingRight = false
        //Se alzo il dito dallo schermo, ovvero interrompo il movimento, blocco le azioni del personaggio, cioè quello che mi interessa bloccare sono le animazioni e resetto la posizione statica del personaggio con il setTexture
        characterAvatar.removeAllActions()
        characterAvatar.run(SKAction.setTexture(SKTexture(imageNamed: "Character")))
//        openClose.removeAllActions()
       
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactA = contact.bodyA.node?.name
        let contactB = contact.bodyB.node?.name
        
        //Se la collisione che si è verificata ha come protagonisti il personaggio e la porta sul lato inferiore della stanza allora avvia la transizione alla nuova stanza
        if(contactA == "player" || contactB == "player"){
            if(contactA == "lowerDoor" || contactB == "lowerDoor"){
//                print("Lower")
                //TO DO: transizione verso la nuova stanza, stanza precedente
                let nextRoom = Level00_3(size: size)
                view?.presentScene(nextRoom)
                
            } else if(contactA == "rightDoor" || contactB == "rightDoor"){
//                print("Right")
                //TO DO: transizione verso la nuova stanza, sgabuzzino
                let nextRoom = Level00_5(size: size)
                view?.presentScene(nextRoom)
                    
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
    
    //Funzione per creare definire le impostazioni dei nodi della stanza
    func roomSetup(){
        //        prova cassettone
//                openClose.xScale = 0.4
//                openClose.yScale = 0.4
//                openClose.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
//                openClose.zPosition = 5
//                openClose.name = "cassettone"
        //Impostazioni riguardanti il collider dei piedi e il personaggio stesso
        characterAvatar.anchorPoint = CGPoint(x: 0.5,y: 0)
        characterAvatar.xScale = 0.5
        characterAvatar.yScale = 0.5
        characterAvatar.zPosition = 5
        characterAvatar.name = "player"
        if(previousRoom == "Room3"){
            characterFeetCollider.position = CGPoint(x: size.width*0.25,y: size.height*0.13)
        } else {
            characterFeetCollider.position = CGPoint(x: size.width*0.89,y: size.height*0.13)
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
        //Impostazioni riguardanti il bottone che apre il menu di pausa
        pauseButton.name = "pause"
        pauseButton.position = CGPoint(x: -gameArea.size.width/3 + CGFloat(10), y: gameArea.size.height*0.9 + CGFloat(10))
        pauseButton.zPosition = 20
//        pauseButton.xScale = 0.2
//        pauseButton.yScale = 0.2
        pauseButton.xScale = 0.08
        pauseButton.yScale = 0.08
        //Impostazioni relative al background della stanza
        room.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        room.xScale = 0.4
        room.yScale = 0.4
        room.zPosition = 1
        //Impostazioni relative alle barriere che creano i confini della stanza
        rightBarrier.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        rightBarrier.xScale = 0.4
        rightBarrier.yScale = 0.4
        rightBarrier.physicsBody = SKPhysicsBody(texture: rightBarrier.texture!, size: rightBarrier.size)
        rightBarrier.physicsBody?.affectedByGravity = false
        rightBarrier.physicsBody?.restitution = 0
        rightBarrier.physicsBody?.allowsRotation = false
        rightBarrier.physicsBody?.isDynamic = false
        rightBarrier.physicsBody?.categoryBitMask = PhysicsCategories.MapEdge
        rightBarrier.physicsBody?.contactTestBitMask = PhysicsCategories.Player
        rightBarrier.alpha = 0.01
        rightBarrier.name = "outerBarrier"
        lowerBarrier.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        lowerBarrier.xScale = 0.4
        lowerBarrier.yScale = 0.4
        lowerBarrier.physicsBody = SKPhysicsBody(texture: lowerBarrier.texture!, size: lowerBarrier.size)
        lowerBarrier.physicsBody?.affectedByGravity = false
        lowerBarrier.physicsBody?.restitution = 0
        lowerBarrier.physicsBody?.allowsRotation = false
        lowerBarrier.physicsBody?.isDynamic = false
        lowerBarrier.physicsBody?.categoryBitMask = PhysicsCategories.MapEdge
        lowerBarrier.physicsBody?.contactTestBitMask = PhysicsCategories.Player
        lowerBarrier.alpha = 0.01
        lowerBarrier.name = "outerBarrier"
        topBarrier.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        topBarrier.xScale = 0.4
        topBarrier.yScale = 0.4
        topBarrier.physicsBody = SKPhysicsBody(texture: topBarrier.texture!, size: topBarrier.size)
        topBarrier.physicsBody?.affectedByGravity = false
        topBarrier.physicsBody?.restitution = 0
        topBarrier.physicsBody?.allowsRotation = false
        topBarrier.physicsBody?.isDynamic = false
        topBarrier.physicsBody?.categoryBitMask = PhysicsCategories.MapEdge
        topBarrier.physicsBody?.contactTestBitMask = PhysicsCategories.Player
        topBarrier.alpha = 0.01
        topBarrier.name = "outerBarrier"
        leftBarrier.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        leftBarrier.xScale = 0.4
        leftBarrier.yScale = 0.4
        leftBarrier.physicsBody = SKPhysicsBody(texture: leftBarrier.texture!, size: leftBarrier.size)
        leftBarrier.physicsBody?.affectedByGravity = false
        leftBarrier.physicsBody?.restitution = 0
        leftBarrier.physicsBody?.allowsRotation = false
        leftBarrier.physicsBody?.isDynamic = false
        leftBarrier.physicsBody?.categoryBitMask = PhysicsCategories.MapEdge
        leftBarrier.physicsBody?.contactTestBitMask = PhysicsCategories.Player
        leftBarrier.alpha = 0.01
        leftBarrier.name = "outerBarrier"
        //Impostazioni riguardanti la tenda
        curtain.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        curtain.xScale = 0.4
        curtain.yScale = 0.4
        curtain.zPosition = 2
        //Impostazioni riguardanti la scatola
        box.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        box.xScale = 0.4
        box.yScale = 0.4
        box.zPosition = 2
        boxCollider.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        boxCollider.xScale = 0.4
        boxCollider.yScale = 0.4
        boxCollider.zPosition = 2
        boxCollider.physicsBody = SKPhysicsBody(texture: boxCollider.texture!, size: boxCollider.size)
        boxCollider.physicsBody?.affectedByGravity = false
        boxCollider.physicsBody?.restitution = 0
        boxCollider.physicsBody?.allowsRotation = false
        boxCollider.physicsBody?.isDynamic = false
        boxCollider.alpha = 0.01
        //Impostazioni riguardanti il mobiletto
//        furniture.position = CGPoint(x: size.width*0, y: size.height*0.42)
        furniture.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        furniture.xScale = 0.4
        furniture.yScale = 0.4
        furniture.zPosition = 4
//        furniture.name = "furniture"
        furnitureInteractionCollider.position = CGPoint(x: size.width*0.05, y: size.height*0.45)
        furnitureInteractionCollider.xScale = 0.4
        furnitureInteractionCollider.yScale = 0.4
        furnitureInteractionCollider.zPosition = 5
        furnitureInteractionCollider.alpha = 0.01
        furnitureInteractionCollider.name = "furniture"
        furnitureCollider.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        furnitureCollider.xScale = 0.4
        furnitureCollider.yScale = 0.4
        furnitureCollider.zPosition = 2
        furnitureCollider.physicsBody = SKPhysicsBody(texture: furnitureCollider.texture!, size: furnitureCollider.size)
        furnitureCollider.physicsBody?.affectedByGravity = false
        furnitureCollider.physicsBody?.restitution = 0
        furnitureCollider.physicsBody?.allowsRotation = false
        furnitureCollider.physicsBody?.isDynamic = false
        furnitureCollider.alpha = 0.01
        //Impostazioni riguardanti il collider delle porte
        lowerDoor.position = CGPoint(x: size.width*0.5, y:size.height*0.5)
        lowerDoor.name = "lowerDoor"
        lowerDoor.alpha = 0.01
        lowerDoor.xScale = 0.4
        lowerDoor.yScale = 0.4
        lowerDoor.physicsBody = SKPhysicsBody(texture: lowerDoor.texture!, size: lowerDoor.size)
        lowerDoor.physicsBody?.affectedByGravity = false
        lowerDoor.physicsBody?.restitution = 0
        lowerDoor.physicsBody?.allowsRotation = false
        lowerDoor.physicsBody?.isDynamic = false
        lowerDoor.physicsBody?.categoryBitMask = PhysicsCategories.LowerDoor
        lowerDoor.physicsBody?.contactTestBitMask = PhysicsCategories.Player
        rightDoor.position = CGPoint(x: size.width*0.5, y:size.height*0.5)
        rightDoor.name = "rightDoor"
        rightDoor.alpha = 0.01
        rightDoor.xScale = 0.4
        rightDoor.yScale = 0.4
        rightDoor.physicsBody = SKPhysicsBody(texture: rightDoor.texture!, size: rightDoor.size)
        rightDoor.physicsBody?.affectedByGravity = false
        rightDoor.physicsBody?.restitution = 0
        rightDoor.physicsBody?.allowsRotation = false
        rightDoor.physicsBody?.isDynamic = false
        rightDoor.physicsBody?.categoryBitMask = PhysicsCategories.LowerDoor
        rightDoor.physicsBody?.contactTestBitMask = PhysicsCategories.Player
    }
}

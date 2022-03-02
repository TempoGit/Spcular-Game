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
    
    let blackCover = SKShapeNode(rectOf: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
    var transitioning: Bool = false
    
    let iButton = SKSpriteNode(imageNamed: "Info")
    let infoText = SKLabelNode(text: LanguageHandler.instance.objectiveEnglish)
    let infoText2 = SKLabelNode(text: LanguageHandler.instance.objectiveEnglish2)
    let infoText3 = SKLabelNode(text: LanguageHandler.instance.objectiveEnglish3)
    let infoText4 = SKLabelNode(text: LanguageHandler.instance.objectiveEnglish4)
    let infoText5 = SKLabelNode(text: LanguageHandler.instance.objectiveEnglish5)
    let infoText6 = SKLabelNode(text: LanguageHandler.instance.objectiveEnglish6)
    let infoOpacityOverlay = SKShapeNode(rectOf: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
    let infoBackground = SKSpriteNode(imageNamed: "Drop Menu 2")
    var infoNavigation: Bool = true
    
    //    cose relative alla chiave nel cassetto
    let Key = SKSpriteNode(imageNamed: "Key")
    let keyLabel = SKLabelNode(fontNamed: "MonoSF")
    let overlayDescription = SKSpriteNode(imageNamed: "DropKey2")
    
    let infoKey = SKLabelNode(text: LanguageHandler.instance.objectiveEnglish11)
//    let infoKey1 = SKLabelNode(text: LanguageHandler.instance.objectiveEnglish21)
//    let infoKey2 = SKLabelNode(text: LanguageHandler.instance.objectiveEnglish31)
    let infoOpacityOverlayKey = SKShapeNode(rectOf: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
    let bigOverlay = SKShapeNode(rectOf: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
    
    var keyObject : Bool = false
    
    //    prova animazione cassettone
    var open: Bool = false
//        var openClose = SKSpriteNode()
//        var TextureAtlas = SKTextureAtlas()
//        var TextureArray = [SKTexture]()
        
    
    //Bottone che apre il menu di pausa
    let pauseButton = SKSpriteNode(imageNamed: "PauseButton")
    
    
    //Divido il personaggio in due parti, una è il collider per i piedi, per gestire le interazioni con gli altri collider per dove il personaggio può camminare, l'altra è l'avatar in sè
    let characterAvatar = SKSpriteNode(imageNamed: "Stop")
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
        addChild(Key)
        cameraNode.addChild(iButton)
        
        
        //Aggiungo la camera di gioco
        addChild(cameraNode)
        camera = cameraNode
        
        //Aggiungo il bottonr per aprire il menu di pausa alla camera di gioco
        cameraNode.addChild(pauseButton)
        
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        blackCover.alpha = 1
        blackCover.fillColor = .black
        blackCover.strokeColor = .black
        blackCover.position = CGPoint(x: -gameArea.size.width*0, y: gameArea.size.height*0)
        blackCover.zPosition = 100
        cameraNode.addChild(blackCover)
        blackCover.run(fadeOutAction, completion: {
            musicHandler.instance.playBackgroundMusic()
        })
                
        
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
                PauseMenuHandler.instance.settingsBackground.xScale = size.width*0.0011
                PauseMenuHandler.instance.settingsBackground.yScale = size.width*0.0011
                
                PauseMenuHandler.instance.pauseLabel.position = CGPoint(x: -gameArea.size.width*0, y: gameArea.size.height*0.32)
                PauseMenuHandler.instance.pauseLabel.xScale = size.width*0.0007
                PauseMenuHandler.instance.pauseLabel.yScale = size.width*0.0007
                PauseMenuHandler.instance.pauseLabelItalian.position = CGPoint(x: -gameArea.size.width*0, y: gameArea.size.height*0.32)
                PauseMenuHandler.instance.pauseLabelItalian.xScale = size.width*0.0007
                PauseMenuHandler.instance.pauseLabelItalian.yScale = size.width*0.0007
                
                PauseMenuHandler.instance.musicIcon.xScale = size.width*0.0005
                PauseMenuHandler.instance.musicIcon.yScale = size.width*0.0005
                PauseMenuHandler.instance.musicIcon.position = CGPoint(x: gameArea.size.width*0.13, y: gameArea.size.height*0.15)
                PauseMenuHandler.instance.musicIconOff.xScale = size.width*0.0005
                PauseMenuHandler.instance.musicIconOff.yScale = size.width*0.0005
                PauseMenuHandler.instance.musicIconOff.position = CGPoint(x: gameArea.size.width*0.13, y: gameArea.size.height*0.15)
                
                PauseMenuHandler.instance.sfxButton.xScale = size.width*0.0005
                PauseMenuHandler.instance.sfxButton.yScale = size.width*0.0005
                PauseMenuHandler.instance.sfxButton.position = CGPoint(x: -gameArea.size.width*0.12, y: gameArea.size.height*0.15)
                PauseMenuHandler.instance.sfxButtonOff.xScale = size.width*0.0005
                PauseMenuHandler.instance.sfxButtonOff.yScale = size.width*0.0005
                PauseMenuHandler.instance.sfxButtonOff.position = CGPoint(x: -gameArea.size.width*0.12, y: gameArea.size.height*0.15)
                
                PauseMenuHandler.instance.languageButton.xScale = size.width*0.00035
                PauseMenuHandler.instance.languageButton.yScale = size.width*0.00035
                PauseMenuHandler.instance.languageButton.position = CGPoint(x: gameArea.size.width*0.01, y: -gameArea.size.height*0.05)
                PauseMenuHandler.instance.languageButtonItalian.xScale = size.width*0.00035
                PauseMenuHandler.instance.languageButtonItalian.yScale = size.width*0.00035
                PauseMenuHandler.instance.languageButtonItalian.position = CGPoint(x: gameArea.size.width*0.01, y: -gameArea.size.height*0.05)
                
                PauseMenuHandler.instance.mainMenuButtonEnglish.xScale = size.width*0.0005
                PauseMenuHandler.instance.mainMenuButtonEnglish.yScale = size.width*0.0005
                PauseMenuHandler.instance.mainMenuButtonEnglish.position = CGPoint(x: gameArea.size.width*0.01, y: -gameArea.size.height*0.25)
                PauseMenuHandler.instance.mainMenuButtonItalian.xScale = size.width*0.0005
                PauseMenuHandler.instance.mainMenuButtonItalian.yScale = size.width*0.0005
                PauseMenuHandler.instance.mainMenuButtonItalian.position = CGPoint(x: gameArea.size.width*0.01, y: -gameArea.size.height*0.25)
                
                PauseMenuHandler.instance.closePauseButtonEnglish.xScale = size.width*0.0007
                PauseMenuHandler.instance.closePauseButtonEnglish.yScale = size.width*0.0007
                PauseMenuHandler.instance.closePauseButtonEnglish.position = CGPoint(x: gameArea.size.width*0.01, y: -gameArea.size.height*0.4)
                PauseMenuHandler.instance.closePauseButtonItalian.xScale = size.width*0.0007
                PauseMenuHandler.instance.closePauseButtonItalian.yScale = size.width*0.0007
                PauseMenuHandler.instance.closePauseButtonItalian.position = CGPoint(x: gameArea.size.width*0.01, y: -gameArea.size.height*0.4)
            }
            
            PauseMenuHandler.instance.initializeNodeSettings()
            
            
            if(musicHandler.instance.mutedMusic == true){
                cameraNode.addChild(PauseMenuHandler.instance.musicIconOff)
            } else if (musicHandler.instance.mutedMusic == false){
                cameraNode.addChild(PauseMenuHandler.instance.musicIcon)
            }
            
            
            if(musicHandler.instance.mutedSFX){
                cameraNode.addChild(PauseMenuHandler.instance.sfxButtonOff)
            } else if (!musicHandler.instance.mutedSFX){
                cameraNode.addChild(PauseMenuHandler.instance.sfxButton)
            }
            
            if(LanguageHandler.instance.language == "English"){
                cameraNode.addChild(PauseMenuHandler.instance.closePauseButtonEnglish)
                cameraNode.addChild(PauseMenuHandler.instance.languageButton)
                cameraNode.addChild(PauseMenuHandler.instance.pauseLabel)
                cameraNode.addChild(PauseMenuHandler.instance.mainMenuButtonEnglish)
            } else if (LanguageHandler.instance.language == "Italian"){
                cameraNode.addChild(PauseMenuHandler.instance.closePauseButtonItalian)
                cameraNode.addChild(PauseMenuHandler.instance.languageButtonItalian)
                cameraNode.addChild(PauseMenuHandler.instance.pauseLabelItalian)
                cameraNode.addChild(PauseMenuHandler.instance.mainMenuButtonItalian)
            }
            
            
            cameraNode.addChild(PauseMenuHandler.instance.backgroundSettings)
            cameraNode.addChild(PauseMenuHandler.instance.settingsBackground)
            
        }
        
        if(touchedNode.name == "musicButton"){
            if(musicHandler.instance.mutedMusic == true){
                musicHandler.instance.unmuteBackgroundMusic()
                PauseMenuHandler.instance.musicIconOff.removeFromParent()
                cameraNode.addChild(PauseMenuHandler.instance.musicIcon)
            } else if (!musicHandler.instance.mutedMusic){
                musicHandler.instance.muteBackgroundMusic()
                PauseMenuHandler.instance.musicIcon.removeFromParent()
                cameraNode.addChild(PauseMenuHandler.instance.musicIconOff)
            }
        }
        
        if(touchedNode.name == "sfxButton"){
            if(musicHandler.instance.mutedSFX == true){
                musicHandler.instance.unmuteSfx()
                PauseMenuHandler.instance.sfxButtonOff.removeFromParent()
                cameraNode.addChild(PauseMenuHandler.instance.sfxButton)
            } else if  (!musicHandler.instance.mutedSFX){
                musicHandler.instance.muteSfx()
                PauseMenuHandler.instance.sfxButton.removeFromParent()
                cameraNode.addChild(PauseMenuHandler.instance.sfxButtonOff)
            }
        }
        
        if(touchedNode.name == "languageButton"){
            if(LanguageHandler.instance.language == "English"){
                LanguageHandler.instance.language = "Italian"
                PauseMenuHandler.instance.closePauseButtonEnglish.removeFromParent()
                PauseMenuHandler.instance.languageButton.removeFromParent()
                PauseMenuHandler.instance.pauseLabel.removeFromParent()
                PauseMenuHandler.instance.mainMenuButtonEnglish.removeFromParent()
                cameraNode.addChild(PauseMenuHandler.instance.closePauseButtonItalian)
                cameraNode.addChild(PauseMenuHandler.instance.languageButtonItalian)
                cameraNode.addChild(PauseMenuHandler.instance.pauseLabelItalian)
                cameraNode.addChild(PauseMenuHandler.instance.mainMenuButtonItalian)
            } else if (LanguageHandler.instance.language == "Italian"){
                LanguageHandler.instance.language = "English"
                PauseMenuHandler.instance.closePauseButtonItalian.removeFromParent()
                PauseMenuHandler.instance.languageButtonItalian.removeFromParent()
                PauseMenuHandler.instance.pauseLabelItalian.removeFromParent()
                PauseMenuHandler.instance.mainMenuButtonItalian.removeFromParent()
                cameraNode.addChild(PauseMenuHandler.instance.closePauseButtonEnglish)
                cameraNode.addChild(PauseMenuHandler.instance.languageButton)
                cameraNode.addChild(PauseMenuHandler.instance.pauseLabel)
                cameraNode.addChild(PauseMenuHandler.instance.mainMenuButtonEnglish)
            }
        }
        
        if (touchedNode.name == "mainMenu"){
            musicHandler.instance.stopLevelBackgroundMusic()
            let newScene = GameScene(size: size)
            view?.presentScene(newScene)
        }
        
        //Se clicco il bottone per chiudere il menu di pausa rimuovo tutti gli oggetti che compongono il menu di pausa dal cameraNode e rimuovo la pausa dalla scena di gioco
        if(touchedNode.name == "closePause"){
            PauseMenuHandler.instance.backgroundSettings.removeFromParent()
            PauseMenuHandler.instance.settingsBackground.removeFromParent()
            
            PauseMenuHandler.instance.pauseLabel.removeFromParent()
            PauseMenuHandler.instance.pauseLabelItalian.removeFromParent()
            
            PauseMenuHandler.instance.musicIcon.removeFromParent()
            PauseMenuHandler.instance.musicIconOff.removeFromParent()
            PauseMenuHandler.instance.sfxButton.removeFromParent()
            PauseMenuHandler.instance.sfxButtonOff.removeFromParent()
            PauseMenuHandler.instance.sfxButton.removeFromParent()
            
            PauseMenuHandler.instance.languageButton.removeFromParent()
            PauseMenuHandler.instance.languageButtonItalian.removeFromParent()
            
            PauseMenuHandler.instance.closePauseButtonEnglish.removeFromParent()
            PauseMenuHandler.instance.closePauseButtonItalian.removeFromParent()
            
            PauseMenuHandler.instance.mainMenuButtonEnglish.removeFromParent()
            PauseMenuHandler.instance.mainMenuButtonItalian.removeFromParent()

            self.isPaused = false
        }
        
        //Se tocco il cassettone si apre, se ritocco si chiude, TO DO: Aggiungere una condizione che permette di aprire e chiudere il cassettone solamente se si è nelle vicinanz del cassettone
        if(touchedNode.name == "furniture"){
            if(!open && !keyObject){
                keyObject = true
                open = true
                furniture.run(SKAction.setTexture(SKTexture(imageNamed: "Level0-Room4-FurnitureOpen")))
                cameraNode.addChild(keyLabel)
                keyLabel.run(SKAction.fadeOut(withDuration: 5))
                Key.zPosition = 11
                if(LanguageHandler.instance.language == "English"){
                    keyLabel.text = "Such a small key..."
                }else
                if(LanguageHandler.instance.language == "Italian"){
                    keyLabel.text = "È una chave molto piccola..."
                }
            } else if (open && keyObject){
                furniture.run(SKAction.setTexture(SKTexture(imageNamed: "Level0-Room4-Furniture")))
                open = false
                keyLabel.removeFromParent()
                keyObject = false
                Key.zPosition = 1
            }
        }
        
        if(touchedNode.name == "key" && !Level0VariableHadnler.instance.keyOpenSmall){
            print("chiave presa")
            Level0VariableHadnler.instance.keyOpenSmall = true
            if(LanguageHandler.instance.language == "English"){
                infoKey.text = LanguageHandler.instance.objectiveEnglish11
//                infoKey1.text = LanguageHandler.instance.objectiveEnglish21
//                infoKey2.text = LanguageHandler.instance.objectiveEnglish31
            }else
            if(LanguageHandler.instance.language == "Italian"){
                infoKey.text = LanguageHandler.instance.objectiveItalian11
//                infoKey1.text = LanguageHandler.instance.objectiveItalian21
//                infoKey2.text = LanguageHandler.instance.objectiveItalian21
            }
            cameraNode.addChild(infoOpacityOverlayKey)
            cameraNode.addChild(overlayDescription)
            cameraNode.addChild(infoKey)
//            cameraNode.addChild(infoKey1)
//            cameraNode.addChild(infoKey2)
            cameraNode.addChild(bigOverlay)
//            keyLabel1.run(SKAction.fadeOut(withDuration: 5))
            Key.removeFromParent()
            self.isPaused = true
            keyLabel.removeFromParent()
        }
        
        if(touchedNode.name == "overlayDescription"){
//            self.isPaused = false
            infoOpacityOverlayKey.removeFromParent()
            infoKey.removeFromParent()
//            infoKey1.removeFromParent()
//            infoKey2.removeFromParent()
            overlayDescription.removeFromParent()
            bigOverlay.removeFromParent()
            self.isPaused = false
        }
        
        
        if(touchedNode.name == "infoButton"){
            self.isPaused = true
            if (LanguageHandler.instance.language == "English"){
                infoText.text = LanguageHandler.instance.infoTextOneEnglish
                infoText2.text = LanguageHandler.instance.infoTextTwoEnglish
            } else if (LanguageHandler.instance.language == "Italian"){
                infoText.text = LanguageHandler.instance.infoTextOneItalian
                infoText2.text = LanguageHandler.instance.infoTextTwoItalian
            }
            cameraNode.addChild(infoOpacityOverlay)
            cameraNode.addChild(infoBackground)
            cameraNode.addChild(infoText)

        }
        if(touchedNode.name == "closeInfo"){
            if(infoNavigation){
                infoText.removeFromParent()
                cameraNode.addChild(infoText2)
                infoNavigation = false
            } else {
                infoOpacityOverlay.removeFromParent()
                infoBackground.removeFromParent()
                infoText.removeFromParent()
                infoText2.removeFromParent()
                infoNavigation = true
                self.isPaused = false
            }
        }
        
        
        //Se clicco in un punto qulasiasi dello schermo la cui posizione è diversa da quella del personaggio allora inizio il movimento del personaggio impostando la variabile moveSingle a true. Questo movimento del personaggio sul tap singolo dello schermo mi serve per fare una transizione fluida dal "non tocco" (quando il personaggio è fermo) dello schermo al "tocco continuo dello schermo" (quando il personaggio è in movimento e posso direzionare il suo spostamento muovendo il dito sullo schermo)
        //Assegno il valore della posizione del tocco alla variabile "location" così posso usare questo valore anche fuori da questa funzione, lo uso in particolare nella funzione di "update"
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
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactA = contact.bodyA.node?.name
        let contactB = contact.bodyB.node?.name
        
        //Se la collisione che si è verificata ha come protagonisti il personaggio e la porta sul lato inferiore della stanza allora avvia la transizione alla nuova stanza
        if(contactA == "player" || contactB == "player"){
            if(contactA == "lowerDoor" || contactB == "lowerDoor"){
//                print("Lower")
                //TO DO: transizione verso la nuova stanza, stanza precedente
//                let nextRoom = Level00_3(size: size)
//                view?.presentScene(nextRoom)
                if(!transitioning){
                    transitioning = true
                    blackCover.removeFromParent()
                    let fadeInAction = SKAction.fadeIn(withDuration: 0.5)
                    blackCover.alpha = 0
                    cameraNode.addChild(blackCover)
                    blackCover.run(fadeInAction)
                    
                    musicHandler.instance.pauseBackgroundMusic()

                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        let nextRoom = Level00_3(size: self.size)
                        self.view?.presentScene(nextRoom)
                    }
                }
            } else if(contactA == "rightDoor" || contactB == "rightDoor"){
//                print("Right")
                //TO DO: transizione verso la nuova stanza, sgabuzzino
//                let nextRoom = Level00_5(size: size)
//                view?.presentScene(nextRoom)
                if(!transitioning){
                    transitioning = true
                    blackCover.removeFromParent()
                    let fadeInAction = SKAction.fadeIn(withDuration: 0.5)
                    blackCover.alpha = 0
                    cameraNode.addChild(blackCover)
                    blackCover.run(fadeInAction)
                    
                    musicHandler.instance.pauseBackgroundMusic()

                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        let nextRoom = Level00_5(size: self.size)
                        self.view?.presentScene(nextRoom)
                        
                    }
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
        characterAvatar.xScale = 0.14
        characterAvatar.yScale = 0.14
        characterAvatar.zPosition = 5
        characterAvatar.name = "player"
        if(previousRoom == "Room3"){
            characterFeetCollider.position = CGPoint(x: size.width*0.25,y: size.height*0.13)
            characterAvatar.run(SKAction.setTexture(SKTexture(imageNamed: "StopBackRight")))
        } else {
            characterFeetCollider.position = CGPoint(x: size.width*0.89,y: size.height*0.13)
            characterAvatar.run(SKAction.setTexture(SKTexture(imageNamed: "StopBackLeft")))
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
        characterFeetCollider.alpha = 0.01
        //Impostazioni riguardanti il bottone che apre il menu di pausa
        pauseButton.name = "pause"
        pauseButton.position = CGPoint(x: -gameArea.size.width*0.4, y: gameArea.size.height*0.9 + CGFloat(10))
        pauseButton.zPosition = 20
        pauseButton.xScale = 0.05
        pauseButton.yScale = 0.05
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
        
        iButton.name = "infoButton"
        iButton.zPosition = 20
        iButton.position = CGPoint(x: gameArea.size.width*0.4, y: gameArea.size.height*0.9 + CGFloat(10))
        iButton.xScale = 0.05
        iButton.yScale = 0.05
        
        infoOpacityOverlay.zPosition = 100
        infoOpacityOverlay.name = "closeInfo"
        infoOpacityOverlay.strokeColor = .black
        infoOpacityOverlay.fillColor = .black
        infoOpacityOverlay.alpha = 0.6
        infoBackground.zPosition = 101
        infoBackground.name = "closeInfo"
        infoBackground.xScale = size.width*0.0017
        infoBackground.yScale = size.width*0.0008
        infoBackground.position = CGPoint(x: -gameArea.size.width*0.02, y: gameArea.size.height*0)
        infoText.zPosition = 102
        infoText.name = "closeInfo"
        infoText.fontSize = size.width*0.05
        infoText.position = CGPoint(x: -gameArea.size.width*0, y: gameArea.size.height*0.2)
        infoText2.zPosition = 102
        infoText2.name = "closeInfo"
        infoText2.fontSize = size.width*0.05
        infoText2.position = CGPoint(x: -gameArea.size.width*0, y: gameArea.size.height*0.1)
//        infoText3.zPosition = 102
//        infoText3.name = "closeInfo"
//        infoText3.fontSize = size.width*0.05
//        infoText3.position = CGPoint(x: -gameArea.size.width*0, y: gameArea.size.height*0)
//        infoText4.zPosition = 102
//        infoText4.name = "closeInfo"
//        infoText4.fontSize = size.width*0.05
//        infoText4.position = CGPoint(x: -gameArea.size.width*0, y: -gameArea.size.height*0.1)
//        infoText5.zPosition = 102
//        infoText5.name = "closeInfo"
//        infoText5.fontSize = size.width*0.05
//        infoText5.position = CGPoint(x: -gameArea.size.width*0, y: -gameArea.size.height*0.2)
//        infoText6.zPosition = 102
//        infoText6.name = "closeInfo"
//        infoText6.fontSize = size.width*0.05
//        infoText6.position = CGPoint(x: -gameArea.size.width*0, y: -gameArea.size.height*0.3)
        if(LanguageHandler.instance.language == "English"){
            infoText.text = LanguageHandler.instance.infoTextOneEnglish
            infoText2.text = LanguageHandler.instance.infoTextTwoEnglish
        } else if (LanguageHandler.instance.language == "Italian"){
            infoText.text = LanguageHandler.instance.infoTextOneItalian
            infoText2.text = LanguageHandler.instance.infoTextTwoItalian
        }
        infoText.preferredMaxLayoutWidth = size.width*0.9
        infoText.numberOfLines = 0
        infoText.verticalAlignmentMode = SKLabelVerticalAlignmentMode.baseline
        infoText.position = CGPoint(x: -gameArea.size.width*0, y: -gameArea.size.height*0.32)
        infoText2.preferredMaxLayoutWidth = size.width*0.9
        infoText2.numberOfLines = 0
        infoText2.verticalAlignmentMode = SKLabelVerticalAlignmentMode.baseline
        infoText2.position = CGPoint(x: -gameArea.size.width*0, y: -gameArea.size.height*0.2)
        
        Key.position = CGPoint(x: size.width*0.05, y: size.height*0.45)
        Key.xScale = 0.04
        Key.yScale = 0.04
        Key.name = "key"
        
        keyLabel.fontColor = SKColor.white
        keyLabel.position = CGPoint(x: -gameArea.size.width*0, y: -gameArea.size.height*0.9)
        keyLabel.fontSize = size.width*0.04
        keyLabel.zPosition = 150
        
        infoOpacityOverlayKey.strokeColor = .black
        infoOpacityOverlayKey.fillColor = .black
        infoOpacityOverlayKey.alpha = 0.6
        infoOpacityOverlayKey.zPosition = 50
        infoOpacityOverlayKey.position = CGPoint(x: size.width*0, y: size.height*0)
        
        overlayDescription.zPosition = 51
        overlayDescription.position = CGPoint(x: -gameArea.size.width*0, y: gameArea.size.height*0)
        overlayDescription.xScale = size.width*0.0012
        overlayDescription.yScale = size.width*0.0012
        overlayDescription.name = "overlayDescription"
        
        
        bigOverlay.strokeColor = .black
        bigOverlay.fillColor = .black
        bigOverlay.alpha = 0.01
        bigOverlay.zPosition = 100
        bigOverlay.position = CGPoint(x: size.width*0, y: size.height*0)
        bigOverlay.name = "overlayDescription"
        
        
        infoKey.preferredMaxLayoutWidth = size.width*0.9
        infoKey.numberOfLines = 0
        infoKey.verticalAlignmentMode = SKLabelVerticalAlignmentMode.baseline
        infoKey.fontSize = size.width*0.05
        infoKey.fontColor = SKColor.white
        infoKey.zPosition = 52
        infoKey.position = CGPoint(x: -gameArea.size.width*0, y: -gameArea.size.height*0.4)
        
        
//        infoKey.fontSize = size.width*0.05
//        infoKey.fontColor = SKColor.white
//        infoKey.zPosition = 52
//        infoKey.position = CGPoint(x: -gameArea.size.width*0, y: -gameArea.size.height*0.2)
//        infoKey1.fontSize = size.width*0.05
//        infoKey1.zPosition = 52
//        infoKey1.fontColor = SKColor.white
//        infoKey1.position = CGPoint(x: -gameArea.size.width*0, y: -gameArea.size.height*0.3)
//        infoKey2.fontSize = size.width*0.05
//        infoKey2.fontColor = SKColor.white
//        infoKey2.zPosition = 52
//        infoKey2.position = CGPoint(x: -gameArea.size.width*0, y: -gameArea.size.height*0.4)

    }
}

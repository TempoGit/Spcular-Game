
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
    
    let room2 = SKSpriteNode(imageNamed: "Level0-Room2")
    let lamp = SKSpriteNode(imageNamed: "Level0-Room2-Lamp")
    let lampCollider = SKSpriteNode(imageNamed: "Level0-Room2-FurnitureLampCollider")
    let lampTransparencyCollider = SKSpriteNode(imageNamed: "Level0-Room2-FurnitureLampTransparencyCollider")
    let bookshelf = SKSpriteNode(imageNamed: "Level0-Room2-bookshelf")
    let bookshelfCollider = SKSpriteNode(imageNamed: "Level0-Room2-BookshelfCollider")
    let bookshelfTransparencyCollider = SKSpriteNode(imageNamed: "Level0-Room2-BookshelfTransparencyCollider")
    let door = SKSpriteNode(imageNamed: "Level0-Room2-DoorOpen")
    let characterAvatar = SKSpriteNode(imageNamed: "Stop")
    let characterFeetCollider = SKSpriteNode(imageNamed: "CharacterFeet2")
    let lampInteractionCollider = SKSpriteNode(imageNamed: "Level0-Room4-FurnitureInteractionCollider")
    let lampZoneInteractionCollider: SKShapeNode
    let lampZoneInteractionCollider2: SKShapeNode
    
    let cameraNode = SKCameraNode()
    
    let barrieraSX = SKSpriteNode( imageNamed: "Level0-Room2-LeftBarrier")
    let barrieraSU = SKSpriteNode(imageNamed: "Level0-Room2-TopBarrier")
    let barrieraGIU = SKSpriteNode(imageNamed: "Level0-Room2-BottomBarrier")
    let barrieraDX = SKSpriteNode(imageNamed: "Level0-Room2-RightBarrier")
    let barrieraPortaSu = SKSpriteNode(imageNamed: "Level0-Room2-TopDoorCollider")
    let barrieraPortaDx = SKSpriteNode(imageNamed: "Level0-Room2-RightDoorCollider")
    
    var interaction: Bool = false
    var move: Bool = false
    var moveSingle: Bool = false
    var location = CGPoint.zero
    
    //Variabili per gestire la trasparenza e livelli degli oggetti
    var bookshelfCollided: Bool = false
    var lampCollided: Bool = false
    
    //Variabili per gestire le animazioni
    var walkingRight: Bool = false
    var walkingLeft: Bool = false
    var walkingUp: Bool = false
    var walkingDown: Bool = false
    
//    frame info
    let frame1 = SKSpriteNode(imageNamed: "Frame")
    let infoOpacityOverlayDiary = SKShapeNode(rectOf: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
    let overlayDescription = SKSpriteNode(imageNamed: "DropFrame")
    let infoFrame = SKLabelNode(text: LanguageHandler.instance.objectiveEnglishFrame)
    
    var worldGroup = SKSpriteNode()

    let pauseButton = SKSpriteNode(imageNamed: "PauseButton")
    
    var stopScene: Bool = false
    
    let gameArea: CGRect
    override init(size: CGSize) {
        lampZoneInteractionCollider = SKShapeNode(rectOf: CGSize(width: size.width*0.8, height: size.height*0.2))
        lampZoneInteractionCollider2 = SKShapeNode(rectOf: CGSize(width: size.width*0.5, height: size.height*0.05))
        
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
        addChild(bookshelfCollider)
        addChild(bookshelfTransparencyCollider)
        addChild(lampCollider)
        addChild(lampTransparencyCollider)
        addChild(lampInteractionCollider)
        addChild(lampZoneInteractionCollider)
        addChild(lampZoneInteractionCollider2)
        cameraNode.addChild(iButton)
        cameraNode.addChild(pauseButton)
        addChild(frame1)
                
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = characterAvatar.position
        
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
        if(touchedNode.name == "goToMenu"){
            musicHandler.instance.stopLevelBackgroundMusic()
            let gameScene = GameScene(size: size)
            view?.presentScene(gameScene)
        }
        
        if(touchedNode.name == "frame"){
            print("cornice")
            stopScene = true
            let xScaleInfo = SKAction.scaleX(to: size.width*0.0012, duration: 0.3)
            let yScaleInfo = SKAction.scaleY(to: size.width*0.0012, duration: 0.3)
            if(LanguageHandler.instance.language == "English"){
                infoFrame.text = LanguageHandler.instance.objectiveEnglishFrame
            }else
            if(LanguageHandler.instance.language == "Italian"){
                infoFrame.text = LanguageHandler.instance.objectiveItalianFrame
            }
            overlayDescription.xScale = 0
            overlayDescription.yScale = 0
            cameraNode.addChild(infoOpacityOverlayDiary)
            cameraNode.addChild(overlayDescription)
            overlayDescription.run(xScaleInfo)
            overlayDescription.run(yScaleInfo, completion: {
                self.cameraNode.addChild(self.infoFrame)
            })
        }
        
        if(touchedNode.name == "overlayDescription"){
            stopScene = false
            infoOpacityOverlayDiary.removeFromParent()
            overlayDescription.removeFromParent()
            infoFrame.removeFromParent()
//            tappableQuit.removeFromParent()
        }
        
        if(touchedNode.name == "interaction" && (characterFeetCollider.frame.intersects(lampZoneInteractionCollider.frame) || characterFeetCollider.frame.intersects(lampZoneInteractionCollider2.frame))){
            if(!interaction){
                interaction = true
                lamp.run(SKAction.setTexture(SKTexture(imageNamed: "FurnitureOpenRoom2")))
            } else {
                if(interaction){
                lamp.run(SKAction.setTexture(SKTexture(imageNamed: "Level0-Room2-Lamp")))
                interaction = false
                }
            }
        } else if(touchedNode.name == "infoButton"){
            stopScene = true
            print(stopScene)
            let xScaleAction = SKAction.scaleX(to: self.size.width*0.0017, duration: 0.3)
            let yScaleAction = SKAction.scaleY(to: self.size.width*0.0008, duration: 0.3)
//            self.isPaused = true
            if (LanguageHandler.instance.language == "English"){
                infoText.text = LanguageHandler.instance.infoTextOneEnglish
                infoText2.text = LanguageHandler.instance.infoTextTwoEnglish
            } else if (LanguageHandler.instance.language == "Italian"){
                infoText.text = LanguageHandler.instance.infoTextOneItalian
                infoText2.text = LanguageHandler.instance.infoTextTwoItalian
            }
            cameraNode.addChild(infoOpacityOverlay)
            cameraNode.addChild(infoBackground)
            infoBackground.xScale = 0
            infoBackground.yScale = 0
            self.infoBackground.run(xScaleAction)
            self.infoBackground.run(yScaleAction, completion: {
                self.cameraNode.addChild(self.infoText)
            })
//            cameraNode.addChild(infoText)

        } else if(touchedNode.name == "closeInfo"){
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
//                self.isPaused = false
                stopScene = false
            }
        }
        
        //Se premo sul bottone di pausa vado a mettere la scena in pausa, dopodichè faccio un controllo: nel caso in cui la variabile firstSet sia impostata a falsa significa che da quando ho aperto l'applicazione ancora non ho impostato nessuna volta la posizione degli elementi del menu di pausa, quindi procedo a farlo e dopodichè richiamo la funzione initializeNodeSettings() che nel caso in cui sia la prima volta che è richiamata fa tutte le impostazioni del caso del menu di pausa e poi mette la variabile firstSet a true, altrimenti si occupa solamente di impostare la trasparenza dei bottoni dell'attivazione e disattivazione della musica.
        //Fatto questo quello che faccio è caricare il menu di pausa nella scena aggiungengo i nodi al cameraNode
         else if(touchedNode.name == "pause"){
             stopScene = true
//            self.isPaused = true
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
        
        else if(touchedNode.name == "musicButton"){
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
        
        else if(touchedNode.name == "sfxButton"){
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
        
        else if(touchedNode.name == "languageButton"){
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
        
        else if (touchedNode.name == "mainMenu"){
            musicHandler.instance.stopLevelBackgroundMusic()
            let newScene = GameScene(size: size)
            view?.presentScene(newScene)
        }
        
        //Se clicco il bottone per chiudere il menu di pausa rimuovo tutti gli oggetti che compongono il menu di pausa dal cameraNode e rimuovo la pausa dalla scena di gioco
       else if(touchedNode.name == "closePause"){
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

           stopScene = false
//            self.isPaused = false
        }
        //Se clicco in un punto qulasiasi dello schermo la cui posizione è diversa da quella del personaggio allora inizio il movimento del personaggio impostando la variabile moveSingle a true. Questo movimento del personaggio sul tap singolo dello schermo mi serve per fare una transizione fluida dal "non tocco" (quando il personaggio è fermo) dello schermo al "tocco continuo dello schermo" (quando il personaggio è in movimento e posso direzionare il suo spostamento muovendo il dito sullo schermo)
        //Assegno il valore della posizione del tocco alla variabile "location" così posso usare questo valore anche fuori da questa funzione, lo uso in particolare nella funzione di "update"
        if(touchLocation != characterFeetCollider.position){
            if(touchedNode.name != "closePause" && touchedNode.name != "closeInfo" && !(touchedNode.name == "interaction" && (characterFeetCollider.frame.intersects(lampZoneInteractionCollider.frame) || characterFeetCollider.frame.intersects(lampZoneInteractionCollider2.frame)))){
                if(!stopScene){
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
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        //Se almeno una delle due variabili responsabili del movimento sono impostate a "true" allora inizia il movimento
        //Controllo se la posizione del tocco dello schermo è in alto, in basso, a sinistra o a destra rispetto alla posizione corrente del personaggio ed effettuo il movimento di conseguenza.
        //N.B.: Per cambiare la velocità di movimento basta cambiare il valore dopo i +=
        if(!stopScene){
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
            checkCollisions()

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
    
    
    func roomSetup(){
        room2.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        room2.xScale = 0.4
        room2.yScale = 0.4
        
        lamp.position = CGPoint(x: size.width*0.5,y: size.height*0.5)
        lamp.xScale = 0.4
        lamp.yScale = 0.4
        lamp.zPosition = 4
        
        frame1.position = CGPoint(x: size.width*0.01, y: size.height*0.45)
        frame1.xScale = 0.07
        frame1.yScale = 0.07
        frame1.zPosition = 13
        frame1.name = "frame"
        
        lampCollider.position = CGPoint(x: size.width*0.5,y: size.height*0.5)
        lampCollider.xScale = 0.4
        lampCollider.yScale = 0.4
        lampCollider.alpha = 0.01
        lampCollider.physicsBody = SKPhysicsBody(texture: lampCollider.texture!, size: lampCollider.size)
        lampCollider.physicsBody?.affectedByGravity = false
        lampCollider.physicsBody?.restitution = 0
        lampCollider.physicsBody?.allowsRotation = false
        lampCollider.physicsBody?.isDynamic = false
        lampCollider.zPosition = 3
        
        lampTransparencyCollider.position = CGPoint(x: size.width*0.27,y: size.height*0.4)
        lampTransparencyCollider.xScale = 0.4
        lampTransparencyCollider.yScale = 0.4
        lampTransparencyCollider.alpha = 0.01
        
        lampInteractionCollider.position = CGPoint(x: size.width*0.05, y: size.height*0.5)
        lampInteractionCollider.xScale = 0.4
        lampInteractionCollider.yScale = 0.4
        lampInteractionCollider.zPosition = 12
        lampInteractionCollider.alpha = 0.01
        lampInteractionCollider.name = "interaction"
        
        lampZoneInteractionCollider.strokeColor = .red
        lampZoneInteractionCollider.fillColor = .red
        lampZoneInteractionCollider.zPosition = 3
        lampZoneInteractionCollider.position = CGPoint(x: size.width*0.05, y: size.height*0.4)
        lampZoneInteractionCollider.alpha = 0.01
        lampZoneInteractionCollider2.strokeColor = .red
        lampZoneInteractionCollider2.fillColor = .red
        lampZoneInteractionCollider2.zPosition = 3
        lampZoneInteractionCollider2.position = CGPoint(x: size.width*0.03, y: size.height*0.3)
        lampZoneInteractionCollider2.alpha = 0.01
        
        bookshelf.position = CGPoint(x: size.width*0.5,y: size.height*0.5)
        bookshelf.xScale = 0.4
        bookshelf.yScale = 0.4
        
        bookshelfCollider.position = CGPoint(x: size.width*0.5,y: size.height*0.5)
        bookshelfCollider.xScale = 0.4
        bookshelfCollider.yScale = 0.4
        bookshelfCollider.alpha = 0.01
        bookshelfCollider.physicsBody = SKPhysicsBody(texture: bookshelfCollider.texture!, size: bookshelfCollider.size)
        bookshelfCollider.physicsBody?.affectedByGravity = false
        bookshelfCollider.physicsBody?.restitution = 0
        bookshelfCollider.physicsBody?.allowsRotation = false
        bookshelfCollider.physicsBody?.isDynamic = false
        bookshelfCollider.zPosition = 3
        
        bookshelfTransparencyCollider.position = CGPoint(x: size.width*0.57,y: size.height*0.43)
        bookshelfTransparencyCollider.xScale = 0.4
        bookshelfTransparencyCollider.yScale = 0.4
        bookshelfTransparencyCollider.alpha = 0.01
        
        door.position = CGPoint(x: size.width*0.5,y: size.height*0.5)
        door.xScale = 0.4
        door.yScale = 0.4
        door.zPosition = 7
        
        
        characterAvatar.anchorPoint = CGPoint(x: 0.5,y: 0)
        characterAvatar.name = "player"
        characterAvatar.xScale = 0.14
        characterAvatar.yScale = 0.14
        characterAvatar.zPosition = 8
        
        if(previousRoom == "Room1"){
            characterFeetCollider.position = CGPoint(x: size.width*1.1,y: size.height*0.25)
        } else {
            characterFeetCollider.position = CGPoint(x: size.width*0.86, y: size.height*0.13)
            characterAvatar.run(SKAction.setTexture(SKTexture(imageNamed: "StopBackLeft")))
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
        characterFeetCollider.alpha = 0.01
        
        barrieraPortaSu.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5 )
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
        pauseButton.position = CGPoint(x: -gameArea.size.width*0.4, y: gameArea.size.height*0.9 + CGFloat(10))
        pauseButton.zPosition = 20
        pauseButton.xScale = 0.05
        pauseButton.yScale = 0.05
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
        infoText2.zPosition = 102
        infoText2.name = "closeInfo"
        infoText2.fontSize = size.width*0.05

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
        
        overlayDescription.zPosition = 121
        overlayDescription.position = CGPoint(x: -gameArea.size.width*0, y: gameArea.size.height*0)
        overlayDescription.xScale = size.width*0.0012
        overlayDescription.yScale = size.width*0.0012
        overlayDescription.name = "overlayDescription"
        
        infoOpacityOverlayDiary.strokeColor = .black
        infoOpacityOverlayDiary.fillColor = .black
        infoOpacityOverlayDiary.alpha = 0.6
        infoOpacityOverlayDiary.zPosition = 120
        infoOpacityOverlayDiary.position = CGPoint(x: size.width*0, y: size.height*0)
        
        infoFrame.preferredMaxLayoutWidth = size.width*0.9
        infoFrame.numberOfLines = 0
        infoFrame.verticalAlignmentMode = SKLabelVerticalAlignmentMode.baseline
        infoFrame.fontSize = size.width*0.05
        infoFrame.fontColor = SKColor.white
        infoFrame.zPosition = 122
        infoFrame.position = CGPoint(x: -gameArea.size.width*0, y: -gameArea.size.height*0.4)
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactA = contact.bodyA.node?.name
        let contactB = contact.bodyB.node?.name
        
        
        //Se la collisione che si è verificata ha come protagonisti il personaggio e la porta sul lato inferiore della stanza allora avvia la transizione alla nuova stanza
        if(contactA == "player" || contactB == "player"){
            if(contactA == "PortaSu" || contactB == "PortaSu"){
                if(!transitioning){
                    transitioning = true
                    blackCover.removeFromParent()
                    let fadeInAction = SKAction.fadeIn(withDuration: 0.5)
                    blackCover.alpha = 0
                    cameraNode.addChild(blackCover)
                    blackCover.run(fadeInAction)
                    
                    musicHandler.instance.pauseBackgroundMusic()

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        let room1 = Level00(size: self.size)
                        self.view?.presentScene(room1)
                    }
                }
            }
        }
        if(contactA == "player" || contactB == "player"){
            if(contactA == "PortaDx" || contactB == "PortaDx"){
                if(!transitioning){
                    transitioning = true
                    blackCover.removeFromParent()
                    let fadeInAction = SKAction.fadeIn(withDuration: 0.5)
                    blackCover.alpha = 0
                    cameraNode.addChild(blackCover)
                    blackCover.run(fadeInAction)
                    
                    musicHandler.instance.pauseBackgroundMusic()

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        let room3 = Level00_3(size: self.size)
                        self.view?.presentScene(room3)
                    }
                }
            }
        }

    }
    
    func checkCollisions(){
        if(characterFeetCollider.frame.intersects(bookshelfTransparencyCollider.frame)){
            bookshelfCollided = true
            characterAvatar.zPosition = 10
            bookshelf.zPosition = 11
        } else {
            if(bookshelfCollided){
                bookshelfCollided = false
                characterAvatar.zPosition = 11
                bookshelf.zPosition = 10
            }
        }
        
        if(characterFeetCollider.frame.intersects(lampTransparencyCollider.frame)){
            lampCollided = true
            characterAvatar.zPosition = 10
            lamp.zPosition = 11
        } else {
            if(lampCollided){
                lampCollided = false
                characterAvatar.zPosition = 11
                lamp.zPosition = 10
            }
        }
        
        
    }
    
    
}




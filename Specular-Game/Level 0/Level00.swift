//
//  Level00.swift
//  Specular-Game
//
//  Created by Salvatore Manna on 18/02/22.
//

import UIKit
import SpriteKit


import AVFoundation


let walkingAnimationFrames: [SKTexture] = [SKTexture(imageNamed: "Frame1"), SKTexture(imageNamed: "Frame2")]
let walkingAnimation: SKAction = SKAction.animate(with: walkingAnimationFrames, timePerFrame: 0.2)


struct PhysicsCategories {
    static let Player : UInt32 = 0x1 << 0
    static let MapEdge : UInt32 = 0x1 << 1
    static let LowerDoor : UInt32 = 0x1 << 2
//    static let Redball : UInt32 = 0x1 << 2
}

class Level00: SKScene, SKPhysicsContactDelegate {
    
    //Bottone che apre il menu di pausa
    let pauseButton = SKSpriteNode(imageNamed: "Pause")
    
    //Definisco i nodi che creano la stanza di gioco
    let room = SKSpriteNode(imageNamed: "Level0-Room1")
    let rightBarrier = SKSpriteNode(imageNamed: "Level0-Room1-RightBarrier")
    let lowerBarrier = SKSpriteNode(imageNamed: "Level0-Room1-LowerBarrier")
    let topBarrier = SKSpriteNode(imageNamed: "Level0-Room1-TopBarrier")
    let leftBarrier = SKSpriteNode(imageNamed: "Level0-Room1-LeftBarrier")
    let lowerDoor = SKSpriteNode(imageNamed: "Level0-Room1-LowerDoor")
    let wardrobe = SKSpriteNode(imageNamed: "Level0-Room1-Wardrobe")
    let wardrobeCollider = SKSpriteNode(imageNamed: "Level0-Room1-WardrobeCollider")
    let wardrobeTransparencyCollider = SKSpriteNode(imageNamed: "Level0-Room1-WardrobeTransparencyCollider")
    let wardrobeShadow = SKSpriteNode(imageNamed: "Level0-Room1-WardrobeShadow")
    let box2andShadow = SKSpriteNode(imageNamed: "Level0-Room1-Box2AndShadow")
    let box2Single = SKSpriteNode(imageNamed: "Level0-Room1-Box2part2")
    let box2Collider = SKSpriteNode(imageNamed: "Level0-Room1-Box2Collider")
    let box2TransparencyCollider = SKSpriteNode(imageNamed: "Level0-Room1-Box2TransparencyCollider")
    let box1Left = SKSpriteNode(imageNamed: "Level0-Room1-Box1Left")
    let box1Right = SKSpriteNode(imageNamed: "Level0-Room1-Box1Right")
    let box1Shadow = SKSpriteNode(imageNamed: "Level0-Room1-Box1Shadow")
    let box1TransparencyColliderLeft = SKSpriteNode(imageNamed: "Level0-Room1-Box1TransparencyColliderLeft")
    let box1TransparencyColliderRight = SKSpriteNode(imageNamed: "Level0-Room1-Box1TransparencyColliderRight")
    let box1Collider = SKSpriteNode(imageNamed: "Level0-Room1-Box1Collider")
    
    //Macronodo che contiene tutti gli oggetti del mondo di gioco
    var worldGroup = SKSpriteNode()
    
    //Divido il personaggio in due parti, una è il collider per i piedi, per gestire le interazioni con gli altri collider per dove il personaggio può camminare, l'altra è l'avatar in sè
    let characterAvatar = SKSpriteNode(imageNamed: "Character")
    let characterFeetCollider = SKSpriteNode(imageNamed: "CharacterFeet2")
    
    //Variabili usate per il movimento del personaggio
    var move: Bool = false
    var moveSingle: Bool = false
    var location = CGPoint.zero
    
    //Variabili usate per gestire le collisioni con gli oggetti della stanza
    var wardrobeCollided: Bool = false
    var box2Collided: Bool = false
    var box1LeftCollided: Bool = false
    var box1RightCollided: Bool = false
    
    //Camera di gioco
    let cameraNode = SKCameraNode()
    
    //Variabili per testare delle cose DA CANCELLARE IN SEGUITO
    let squareTest1 = SKShapeNode(rectOf: CGSize(width: 100,height: 100))
    var tappedObject: Bool = false
    let object = SKSpriteNode(imageNamed: "PlayerBox")
    
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
        //Per non imputtanire troppo il codice, metto le impostazioni più lunghe in un'altra funzione definita sempre nella classe e la richiamo qui, così almeno sembra un po' più pulito
        roomSetup()

        //Inserisco poi gli oggetti effettivamente nella scena
        addChild(room)
        addChild(rightBarrier)
        addChild(lowerBarrier)
        addChild(topBarrier)
        addChild(leftBarrier)
        addChild(lowerDoor)
        addChild(wardrobe)
        addChild(wardrobeCollider)
        addChild(wardrobeShadow)
        addChild(wardrobeTransparencyCollider)
        addChild(box2andShadow)
        addChild(box2Single)
        addChild(box2Collider)
        addChild(box2TransparencyCollider)
        addChild(box1Left)
        addChild(box1Right)
        addChild(box1Shadow)
        addChild(box1Collider)
        addChild(box1TransparencyColliderLeft)
        addChild(box1TransparencyColliderRight)
        
        
//        worldGroup.addChild(room)
//        worldGroup.addChild(rightBarrier)
//        worldGroup.addChild(lowerBarrier)
//        worldGroup.addChild(topBarrier)
//        worldGroup.addChild(leftBarrier)
//        worldGroup.addChild(lowerDoor)
        
//        addChild(worldGroup)
        
        addChild(characterAvatar)
        addChild(characterFeetCollider)

        
        //Aggiungo la camera di gioco
        addChild(cameraNode)
        camera = cameraNode
        //Aggiungo il bottonr per aprire il menu di pausa alla camera di gioco
        cameraNode.addChild(pauseButton)
        
        
        //Avvio la musica del livello
        musicHandler.instance.playBackgroundMusic()
        
        //Per abilitare le collisioni nella scena
        self.scene?.physicsWorld.contactDelegate = self
    }
    
    //Funzione che rileva il tocco
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        //Ricavo la posizione sullo schermo del tocco e di eventuali nodi toccati
        let touchLocation = touch.location(in: self)
        let touchedNode = atPoint(touchLocation)

        
        if (touchedNode.name == "tappedObject"){
            for touch in touches {
                location = touch.location(in: self)
                let removeObject = SKAction.sequence([SKAction.removeFromParent()])
                object.run(removeObject)
            }
       
        }
        
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
        //Se clicco il botton per disattivare il volume e la musica non è già disattivata allora quello che faccio è impostare la trasparenza per i bottoni della musica nel menu di pausa e dopodichè chiamo la funzione sulla classe musicHandler che si occupa di disattivare il volume della musica
        if(touchedNode.name == "volumeOff"){
            if(musicHandler.instance.mutedMusic == false){
                PauseMenuHandler.instance.volumeOnButton.alpha = 0.5
                PauseMenuHandler.instance.volumeOffButton.alpha = 1
                musicHandler.instance.muteBackgroundMusic()
            }
        }
        //Se clicco il bottone per attivare il volume e la musica non è già attivata allora quello che faccio è impostare la trasparenza per i bottoni della musica nel menu di apusa e dopodichè chiamo la funzione sulla classe musicHandler che si occupa di attivare il volume della musica
        if(touchedNode.name == "volumeOn"){
            if(musicHandler.instance.mutedMusic == true){
                PauseMenuHandler.instance.volumeOnButton.alpha = 1
                PauseMenuHandler.instance.volumeOffButton.alpha = 0.5
                musicHandler.instance.unmuteBackgroundMusic()
            }
        }
        //Se clicco il bottone per chiudere il menu di pausa rimuovo tutti gli oggetti che compongono il menu di pausa dal cameraNode e rimuovo la pausa dalla scena di gioco
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
            //Così faccio iniziare l'animazione della camminata che si ripete per sempre e viene interrotta solamente quando finisce il movimento, cioè quando alzo il dito dallo schermo
            characterAvatar.run(SKAction.repeatForever(walkingAnimation))
            
        }
    }

    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        tappedObject = true
        
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
        characterAvatar.run(SKAction.setTexture(SKTexture(imageNamed: "Character")))
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
        checkCollisions()
        
    
    }
    
    //Funzione che controlla le collisioni tra i nodi che hanno physics object come proprietà
    func didBegin(_ contact: SKPhysicsContact) {
        let contactA = contact.bodyA.node?.name
        let contactB = contact.bodyB.node?.name
        
        //Se la collisione che si è verificata ha come protagonisti il personaggio e la porta sul lato inferiore della stanza allora avvia la transizione alla nuova stanza
        if(contactA == "player" || contactB == "player"){
            if(contactA == "lowerDoor" || contactB == "lowerDoor"){
                //TO DO: transizione verso la nuova stanza
                let room2 = Level00_2(size: size)
                view?.presentScene(room2)
            }
        }
    }
    
    func checkCollisions(){
        //Verifico se ci sono state collisioni tra il personaggio e il collider che gestisce la trasparenza dell'armadio
        if(characterFeetCollider.frame.intersects(self.wardrobeTransparencyCollider.frame)){
            wardrobeCollided = true
            wardrobe.alpha = 0.3
            characterAvatar.alpha = 0.85
        } else {
            //Quando la collisione finisce resetto i valori di trasparenza, uso la variabile wadrobeCollided così non eseguo sempre queste azioni, ma solamente se c'è stata una modifica a questi valori in precedenza, se quindi il personaggio è andato dietro all'armadio e ora ne sta uscendo
            if(wardrobeCollided){
                wardrobeCollided = false
                wardrobe.alpha = 1
                characterAvatar.alpha = 1
            }
        }
        
        if(characterFeetCollider.frame.intersects(self.box2TransparencyCollider.frame)){
            box2Collided = true
            box2Single.alpha = 0.3
            characterAvatar.alpha = 0.85
        } else {
            if(box2Collided){
               box2Collided = false
                box2Single.alpha = 1
                characterAvatar.alpha = 1
            }
        }
        
        if(characterFeetCollider.frame.intersects(self.box1TransparencyColliderLeft.frame)){
            box1LeftCollided = true
            box1Left.alpha = 0.3
            characterAvatar.alpha = 0.85
        } else {
            if(box1LeftCollided){
                box1LeftCollided = false
                box1Left.alpha = 1
                characterAvatar.alpha = 1
            }
        }
        
        if(characterFeetCollider.frame.intersects(self.box1TransparencyColliderRight.frame)){
            box1RightCollided = true
            box1Right.alpha = 0.3
            characterAvatar.alpha = 0.85
        } else {
            if(box1RightCollided){
                box1RightCollided = false
                box1Right.alpha = 1
                characterAvatar.alpha = 1
            }
        }
    }
    
    //Funzione per creare definire le impostazioni dei nodi della stanza
    func roomSetup(){
        //Impostazioni relativa alla stanza in quanto background
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
        //Imposto il collider per il cambio stanza della porta in basso
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
        //Impostazioni riguardanti il guardaroba ed il suo collider
        wardrobeCollider.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        wardrobeCollider.xScale = 0.4
        wardrobeCollider.yScale = 0.4
        wardrobeCollider.alpha = 0.01
        wardrobeCollider.physicsBody = SKPhysicsBody(texture: wardrobeCollider.texture!, size: wardrobeCollider.size)
        wardrobeCollider.physicsBody?.affectedByGravity = false
        wardrobeCollider.physicsBody?.restitution = 0
        wardrobeCollider.physicsBody?.allowsRotation = false
        wardrobeCollider.physicsBody?.isDynamic = false
        wardrobeCollider.zPosition = 3
        wardrobe.position = CGPoint(x: size.width*1.05, y: size.height*0.42)
        wardrobe.xScale = 0.4
        wardrobe.yScale = 0.4
        wardrobe.zPosition = 3
        wardrobeShadow.position = CGPoint(x: size.width*1.05, y: size.height*0.42)
        wardrobeShadow.xScale = 0.4
        wardrobeShadow.yScale = 0.4
        wardrobeShadow.zPosition = 3
        wardrobeTransparencyCollider.position = CGPoint(x: size.width*0.93, y: size.height*0.33)
        wardrobeTransparencyCollider.xScale = 0.4
        wardrobeTransparencyCollider.yScale = 0.4
        wardrobeTransparencyCollider.zPosition = 3
        wardrobeTransparencyCollider.alpha = 0.01
        //Impostazioni riguardanti le scatole in alto
        box2andShadow.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        box2andShadow.xScale = 0.4
        box2andShadow.yScale = 0.4
        box2andShadow.zPosition = 3
        box2Single.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        box2Single.xScale = 0.4
        box2Single.yScale = 0.4
        box2Single.zPosition = 3
        box2Collider.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        box2Collider.xScale = 0.4
        box2Collider.yScale = 0.4
        box2Collider.alpha = 0.01
        box2Collider.physicsBody = SKPhysicsBody(texture: box2Collider.texture!, size: box2Collider.size)
        box2Collider.physicsBody?.affectedByGravity = false
        box2Collider.physicsBody?.restitution = 0
        box2Collider.physicsBody?.allowsRotation = false
        box2Collider.physicsBody?.isDynamic = false
        box2Collider.zPosition = 3
        box2TransparencyCollider.position = CGPoint(x: size.width*0.37, y: size.height*0.41)
        box2TransparencyCollider.xScale = 0.4
        box2TransparencyCollider.yScale = 0.4
        box2TransparencyCollider.zPosition = 3
        box2TransparencyCollider.alpha = 0.01
        //Impostazioni riguardanti le scatole in basso
        box1Left.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        box1Left.xScale = 0.4
        box1Left.yScale = 0.4
        box1Left.zPosition = 3
        box1Right.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        box1Right.xScale = 0.4
        box1Right.yScale = 0.4
        box1Right.zPosition = 3
        box1Shadow.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        box1Shadow.xScale = 0.4
        box1Shadow.yScale = 0.4
        box1Shadow.zPosition = 3
        box1Collider.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        box1Collider.xScale = 0.4
        box1Collider.yScale = 0.4
        box1Collider.alpha = 0.01
        box1Collider.physicsBody = SKPhysicsBody(texture: box1Collider.texture!, size: box1Collider.size)
        box1Collider.physicsBody?.affectedByGravity = false
        box1Collider.physicsBody?.restitution = 0
        box1Collider.physicsBody?.allowsRotation = false
        box1Collider.physicsBody?.isDynamic = false
        box1Collider.zPosition = 3
        box1TransparencyColliderLeft.position = CGPoint(x: size.width*0.62, y: size.height*0.18)
        box1TransparencyColliderLeft.xScale = 0.4
        box1TransparencyColliderLeft.yScale = 0.4
        box1TransparencyColliderLeft.zPosition = 3
        box1TransparencyColliderLeft.alpha = 0.01
        box1TransparencyColliderRight.position = CGPoint(x: size.width*0.77, y: size.height*0.205)
        box1TransparencyColliderRight.xScale = 0.4
        box1TransparencyColliderRight.yScale = 0.4
        box1TransparencyColliderRight.zPosition = 3
        box1TransparencyColliderRight.alpha = 0.01
        //Impostazioni riguardanti il collider dei piedi e il personaggio stesso
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
        //TO DO: Far partire il personaggio da vicino alla porta in alto
        //Impostazioni riguardanti il bottone che apre il menu di pausa
        pauseButton.name = "pause"
        pauseButton.position = CGPoint(x: -gameArea.size.width/3 + CGFloat(10), y: gameArea.size.height*0.9 + CGFloat(10))
        pauseButton.zPosition = 20
        pauseButton.xScale = 0.2
        pauseButton.yScale = 0.2
    }
}


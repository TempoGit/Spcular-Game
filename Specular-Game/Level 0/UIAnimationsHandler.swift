//
//  UIAnimationsHandler.swift
//  Specular-Game
//
//  Created by Salvatore Manna on 04/03/22.
//

import Foundation
import SpriteKit


class UIAnimationsHandler {
    
    static let instance = UIAnimationsHandler()
    
    public var dollInteractible: Bool = false
    
    func itemPopUpAnimation(size: CGSize, cameraNode: SKCameraNode, overlayNode: SKSpriteNode, infoText: SKLabelNode, infoOpacityOverlay: SKShapeNode){
        dollInteractible = true
        
        let popUpXscale = SKAction.scaleX(to: size.width*0.0012, duration: 0.3)
        let popUpYScale = SKAction.scaleY(to: size.width*0.0012, duration: 0.3)
        
        cameraNode.addChild(infoOpacityOverlay)
        cameraNode.addChild(overlayNode)
        overlayNode.xScale = 0
        overlayNode.yScale = 0
        overlayNode.run(popUpXscale)
        overlayNode.run(popUpYScale, completion: {
            cameraNode.addChild(infoText)
        })
    }
    
    func removePopUpAnimation(overlayNode: SKSpriteNode, infoText: SKLabelNode, infoOpacityOverlay: SKShapeNode){
        
        infoText.removeFromParent()
        overlayNode.removeFromParent()
        infoOpacityOverlay.removeFromParent()
        dollInteractible = false
//        overlayNode.run(SKAction.scale(to: 0, duration: 0.3), completion: {
//            overlayNode.removeFromParent()
//            infoOpacityOverlay.removeFromParent()
//            self.dollInteractible = false
//        })
        
    }
    
}

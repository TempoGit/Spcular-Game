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
    
    public var itemInteractible: Bool = false
    public var fullOpen: Bool = false
    
    func infoOverlayPopUpAnimation(size: CGSize, cameraNode: SKCameraNode, infoBackground: SKSpriteNode, infoText: SKLabelNode, infoOpacityOverlay: SKShapeNode){
        self.itemInteractible = true
        let xScaleAction = SKAction.scaleX(to: size.width*0.0017, duration: 0.3)
        let yScaleAction = SKAction.scaleY(to: size.width*0.0008, duration: 0.3)
        cameraNode.addChild(infoOpacityOverlay)
        cameraNode.addChild(infoBackground)
        infoBackground.xScale = 0
        infoBackground.yScale = 0
        infoBackground.run(xScaleAction)
        infoBackground.run(yScaleAction, completion: {
            cameraNode.addChild(infoText)
            self.fullOpen = true
        })
    }
    
    
    func infoOverlayRemoveAnimation(infoBackground: SKSpriteNode, infoText: SKLabelNode, infoOpacityOverlay: SKShapeNode){
        self.itemInteractible = false
        infoText.removeFromParent()
        infoBackground.run(SKAction.scale(to: 0, duration: 0.3), completion: {
            infoBackground.removeFromParent()
            infoOpacityOverlay.removeFromParent()
            self.fullOpen = false
        })
    }
    
    func itemPopUpAnimation(size: CGSize, cameraNode: SKCameraNode, overlayNode: SKSpriteNode, infoText: SKLabelNode, infoOpacityOverlay: SKShapeNode){
        UIAnimationsHandler.instance.itemInteractible = true
        
        let popUpXscale = SKAction.scaleX(to: size.width*0.0012, duration: 0.3)
        let popUpYScale = SKAction.scaleY(to: size.width*0.0012, duration: 0.3)
        
        cameraNode.addChild(infoOpacityOverlay)
        cameraNode.addChild(overlayNode)
        overlayNode.xScale = 0
        overlayNode.yScale = 0
        overlayNode.run(popUpXscale)
        overlayNode.run(popUpYScale, completion: {
            cameraNode.addChild(infoText)
            self.fullOpen = true
        })
    }
    
    func removePopUpAnimation(overlayNode: SKSpriteNode, infoText: SKLabelNode, infoOpacityOverlay: SKShapeNode){
        UIAnimationsHandler.instance.itemInteractible = false
        infoText.removeFromParent()
        overlayNode.run(SKAction.scale(to: 0, duration: 0.3), completion: {
            overlayNode.removeFromParent()
            infoOpacityOverlay.removeFromParent()
            self.fullOpen = false
        })
        
    }
    
}

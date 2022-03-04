//
//  CharacterMovementHandler.swift
//  Specular-Game
//
//  Created by Salvatore Manna on 04/03/22.
//

import Foundation
import SpriteKit
import SwiftUI


class CharacterMovementHandler {
    static let instance = CharacterMovementHandler()
    
    func characterMovement(location: CGPoint, characterFeetCollider: SKSpriteNode, walkingRight: inout Bool, walkingLeft: inout Bool, walkingUp: inout Bool, walkingDown: inout Bool, characterAvatar: SKSpriteNode){
        
        
        if(location.x > characterFeetCollider.position.x) {
            characterFeetCollider.position.x += movementSpeed
            if(location.y > characterFeetCollider.position.y){
                characterFeetCollider.position.y += movementSpeed
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
                characterFeetCollider.position.y -= movementSpeed
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
            characterFeetCollider.position.x -= movementSpeed
            if(location.y > characterFeetCollider.position.y){
                characterFeetCollider.position.y += movementSpeed
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
                characterFeetCollider.position.y -= movementSpeed
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
            characterFeetCollider.position.y += movementSpeed
        } else if (location.y < characterFeetCollider.position.y){
            characterFeetCollider.position.y -= movementSpeed
        }
        
    }
    
    
    
}

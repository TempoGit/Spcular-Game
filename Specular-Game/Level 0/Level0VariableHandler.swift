//
//  Level0VariableHandler.swift
//  Specular-Game
//
//  Created by Salvatore Manna on 01/03/22.
//

import Foundation
import SwiftUI

class Level0VariableHadnler {
    static let instance = Level0VariableHadnler()
    
//  suoni mutati
    public var muto: Bool = false
//    chiave nella room1 level00
    public var bigKeyVar: Bool = false
    public var bigKeyPick: Bool = false
    public var smallKeyPick: Bool = false
//    var per aprire la porticina in room1 level00
    public var smallDorTouched: Bool = false
    public var smallDoorOpen: Bool = false
//  var per far spostare gli scatoloni in room1 level00
    public var boxLeftTouched: Bool = false
//  var di controllo per le posizioni degli scatoloni room1 level00
    public var controlloBox: Bool = false
//    var aprire porta finale
    public var keyOpen: Bool = false
//    var aprire porta piccola level0
    public var keyOpenSmall: Bool = false
//    var interazione frame level002
    public var frameInteractio: Bool = false
//    doll interaction
    var dollObject: Bool = false
//     wardrobe interactio
    var interaction: Bool = false
//variabile per la luce stanza 3
    var once: Bool = false


}



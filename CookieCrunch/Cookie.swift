//
//  Cookie.swift
//  CookieCrunch
//
//  Created by Matthew Jacome on 7/4/17.
//  Copyright © 2017 matthew. All rights reserved.
//

import SpriteKit

enum CookieType: Int {
    case unknown = 0, croissant, cupcake, danish, donut, macaroon, sugarCookie
    
    var spriteName: String {
    let spriteNames = [
        "Croissant",
        "Cupcake",
        "Danish",
        "Donut",
        "Macaroon",
        "SugarCookie"]
        
        return spriteNames[rawValue - 1]
    }
    
    var highlightedSpriteName: String {
        return spriteName + "-Highlighted"
    }
}

class Cookie {
    var column: Int
    var row: Int
    let cookieType: CookieType
    var sprite: SKSpriteNode?
    
    init(column: Int, row: Int, cookieType: CookieType){
        self.column = column
        self.row = row
        self.cookieType = cookieType
    }
}

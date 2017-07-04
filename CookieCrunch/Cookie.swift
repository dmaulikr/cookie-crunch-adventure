//
//  Cookie.swift
//  CookieCrunch
//
//  Created by Matthew Jacome on 7/4/17.
//  Copyright © 2017 matthew. All rights reserved.
//

import SpriteKit

// MARK: - enum cookieType
enum CookieType: Int, CustomStringConvertible {
    case unknown = 0, croissant, cupcake, danish, donut, macaroon, sugarCookie
    
    // Returns the filename of the corresponding sprite image in the texture atlas
    // The highlighted version appears when the user taps on the cookie
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
    // Computed properties
    var description: String {
        return spriteName
    }
    
    var highlightedSpriteName: String {
        return spriteName + "-Highlighted"
    }
    
    // Generates a random number between 1 and 6
    static func random() -> CookieType {
        return CookieType(rawValue: Int(arc4random_uniform(6)) + 1)!
    }
}
// MARK: - Cookie class
class Cookie: CustomStringConvertible, Hashable {
    // Properties
    var column: Int
    var row: Int
    let cookieType: CookieType
    var sprite: SKSpriteNode?
    
    init(column: Int, row: Int, cookieType: CookieType){
        self.column = column
        self.row = row
        self.cookieType = cookieType
    }
    // Computed property
    var description: String {
        return "type: \(cookieType) square:(\(column), \(row))"
    }
    
    var hashValue: Int {
        return row*10 + column
    }
}

// MARK: - Functions
func ==(lhs: Cookie, rhs: Cookie) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row
}

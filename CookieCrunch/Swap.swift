//
//  Swap.swift
//  CookieCrunch
//
//  Created by Matthew Jacome on 7/4/17.
//  Copyright © 2017 matthew. All rights reserved.
//

struct Swap: CustomStringConvertible {
    let cookieA: Cookie
    let cookieB: Cookie
    
    init(cookieA: Cookie, cookieB: Cookie){
        self.cookieA = cookieA
        self.cookieB = cookieB
    }
    
    var description: String {
        return "swap \(cookieA) with \(cookieB)"
    }
}

//
//  Level.swift
//  CookieCrunch
//
//  Created by Matthew Jacome on 7/4/17.
//  Copyright © 2017 matthew. All rights reserved.
//

import Foundation
// properties
let NumColumns = 9
let NumRows = 9
// MARK: - Level class
class Level {
    fileprivate var cookies = Array2D<Cookie>(columns: NumColumns, rows: NumRows)
    
    // MARK: - Functions
    func cookieAt(column: Int, row: Int) -> Cookie? {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return cookies[column, row]
    }
    /// Fills the level with ramdom cookies
    func shuffle() -> Set<Cookie> {
        return createInitialCookies()
    }
    // TODO: Explain 1...4 with comments
    private func createInitialCookies() -> Set<Cookie> {
        var set = Set<Cookie>()
        
        // 1
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                
                // 2
                var cookieType = CookieType.random()
                
                // 3
                let cookie = Cookie(column: column, row: row, cookieType: cookieType)
                cookies[column, row] = cookie
                
                // 4
                set.insert(cookie)
            }
        }
        return set
    }
}

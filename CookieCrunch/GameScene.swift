//
//  GameScene.swift
//  CookieCrunch
//
//  Created by Matthew Jacome on 7/3/17.
//  Copyright © 2017 matthew. All rights reserved.
//

import SpriteKit

// MARK: - class
class GameScene: SKScene {
    // MARK: - Properties
    // level
    var level: Level!
    // tiles
    let TileWidth: CGFloat = 32.0
    let TileHeight: CGFloat = 36.0
    let tilesLayer = SKNode()
    // layers
    let gameLayer = SKNode()
    let cookiesLayer = SKNode()
    // swipes
    private var swipeFromColumn: Int?
    private var swipeFromRow: Int?
    var swipeHandler: ((Swap) -> ())?
    // highlighted
    var selectionSprite = SKSpriteNode()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let background = SKSpriteNode(imageNamed: "Background")
        background.size = size
        addChild(background)
        addChild(gameLayer)
        
        let layerPosition = CGPoint(
            x: -TileWidth * CGFloat(NumColumns) / 2,
            y: -TileHeight * CGFloat(NumRows) / 2)
        
        tilesLayer.position = layerPosition
        gameLayer.addChild(tilesLayer)
        cookiesLayer.position = layerPosition
        gameLayer.addChild(cookiesLayer)
        
        swipeFromColumn = nil
        swipeFromRow = nil
        
    }
    // MARK: - Functions
    // TODO: Explain functions
    func animateInvalidSwap(_ swap: Swap, completion: @escaping () -> ()) {
        let spriteA = swap.cookieA.sprite!
        let spriteB = swap.cookieB.sprite!
        
        spriteA.zPosition = 100
        spriteB.zPosition = 90
        
        let duration: TimeInterval = 0.2
        
        let moveA = SKAction.move(to: spriteB.position, duration: duration)
        moveA.timingMode = .easeOut
        
        let moveB = SKAction.move(to: spriteA.position, duration: duration)
        moveB.timingMode = .easeOut
        
        spriteA.run(SKAction.sequence([moveA, moveB]), completion: completion)
        spriteB.run(SKAction.sequence([moveB, moveA]))
    }
    func hideSelectionIndicator() {
        selectionSprite.run(SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.3),
            SKAction.removeFromParent()]))
    }
    func showSelectionIndicatorForCookie(cookie: Cookie) {
        if selectionSprite.parent != nil {
            selectionSprite.removeFromParent()
        }
        
        if let sprite = cookie.sprite {
            let texture = SKTexture(imageNamed: cookie.cookieType.highlightedSpriteName)
            selectionSprite.size = CGSize(width: TileWidth, height: TileHeight)
            selectionSprite.run(SKAction.setTexture(texture))
            
            sprite.addChild(selectionSprite)
            selectionSprite.alpha = 1.0
        }
    }
    func addSprites(for cookies: Set<Cookie>) {
        for cookie in cookies {
            let sprite = SKSpriteNode(imageNamed: cookie.cookieType.spriteName)
            sprite.size = CGSize(width: TileWidth, height: TileHeight)
            sprite.position = pointFor(column: cookie.column, row: cookie.row)
            cookiesLayer.addChild(sprite)
            cookie.sprite = sprite
        }
    }
    // TODO: Fill this description
    func convertPoint(point: CGPoint) -> (success: Bool, column: Int, row: Int) {
        if point.x >= 0 && point.x < CGFloat(NumColumns)*TileWidth && point.y >= 0 && point.y < CGFloat(NumRows)*TileHeight {
            return (true, Int(point.x / TileWidth), Int(point.y / TileHeight))
        } else {
            return (false, 0, 0) // invalid location
        }
    }
    
    func pointFor(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column)*TileWidth + TileWidth/2,
            y: CGFloat(row)*TileHeight + TileHeight/2)
    }
    
    func addTiles() {
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                if level.tileAt(column: column, row: row) != nil {
                    let tileNode = SKSpriteNode(imageNamed: "Tile")
                    tileNode.size = CGSize(width: TileWidth, height: TileHeight)
                    tileNode.position = pointFor(column: column, row: row)
                    tilesLayer.addChild(tileNode)
                }
            }
        }
    }
    // TODO: Explain 1...4
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 1
        guard let touch = touches.first else { return }
        let location = touch.location(in: cookiesLayer)
        // 2
        let (success, column, row) = convertPoint(point: location)
        if success {
            // 3
            if let cookie = level.cookieAt(column: column, row: row) {
                // 4
                swipeFromColumn = column
                swipeFromRow = row
                showSelectionIndicatorForCookie(cookie: cookie)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 1
        guard swipeFromColumn != nil else { return }
        
        // 2
        guard let touch = touches.first else { return }
        let location = touch.location(in: cookiesLayer)
        
        let (success, column, row) = convertPoint(point: location)
        if success {
            
            // 3
            var horzDelta = 0, vertDelta = 0
            if column < swipeFromColumn! {
                horzDelta = -1          // swipe left
            } else if column > swipeFromColumn! {
                horzDelta = 1           // swipe right
            } else if row < swipeFromRow! {
                vertDelta = -1          // swipe down
            } else if row > swipeFromRow! {
                vertDelta = 1           // swipe up
            }
            
            // 4
            if horzDelta != 0 || vertDelta != 0 {
                trySwap(horizontal: horzDelta, vertical: vertDelta)
                hideSelectionIndicator()
                // 5
                swipeFromColumn = nil
            }
        }
    }
    // TODO: Explain 1...4
    func trySwap(horizontal horzDelta: Int, vertical vertDelta: Int) {
        // 1
        let toColumn = swipeFromColumn! + horzDelta
        let toRow = swipeFromRow! + vertDelta
        // 2
        guard toColumn >= 0 && toColumn < NumColumns else { return }
        guard toRow >= 0 && toRow < NumColumns else { return }
        // 3
        if let toCookie = level.cookieAt(column: toColumn, row: toRow),
            let fromCookie = level.cookieAt(column: swipeFromColumn!, row: swipeFromRow!) {
            // 4
            if let handler = swipeHandler {
                let swap = Swap(cookieA: fromCookie, cookieB: toCookie)
                handler(swap)
            }
        }
    }
    
    func animate(_ swap: Swap, completion: @escaping () -> ()) {
        let spriteA = swap.cookieA.sprite!
        let spriteB = swap.cookieB.sprite!
        
        spriteA.zPosition = 100
        spriteB.zPosition = 90
        
        let duration: TimeInterval = 0.3
        
        let moveA = SKAction.move(to: spriteB.position, duration: duration)
        moveA.timingMode = .easeOut
        spriteA.run(moveA, completion: completion)
        
        let moveB = SKAction.move(to: spriteA.position, duration: duration)
        moveB.timingMode = .easeOut
        spriteB.run(moveB)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if selectionSprite.parent != nil && swipeFromColumn != nil {
            hideSelectionIndicator()
        }
        swipeFromColumn = nil
        swipeFromRow = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }

}





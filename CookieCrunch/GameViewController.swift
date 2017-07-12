//
//  GameViewController.swift
//  CookieCrunch
//
//  Created by Matthew Jacome on 7/3/17.
//  Copyright © 2017 matthew. All rights reserved.
//

import UIKit
import SpriteKit


class GameViewController: UIViewController {
    // Properties
    var scene: GameScene!
    var level: Level!
    // MARK: - Functions
    func handleMatches() {
        let chains = level.removeMatches()
        
        scene.animateMatchedCookies(for: chains) {
            self.view.isUserInteractionEnabled = true
        }
    }
    
    func beginGame() {
        shuffle()
    }
    
    func shuffle() {
        let newCookies = level.shuffle()
        scene.addSprites(for: newCookies)
    }
    
    func handleSwipe(_ swap: Swap) {
        view.isUserInteractionEnabled = false
        
        if level.isPossibleSwap(swap) {
            level.performSwap(swap: swap)
            scene.animate(swap, completion: handleMatches) //{
                //self.view.isUserInteractionEnabled = true
            //}
        } else {
            scene.animateInvalidSwap(swap) {
            self.view.isUserInteractionEnabled = true
            }
        }
    }
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Configure the view
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
        
        // MARK: Create and configure the scene. 
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        
        // MARK: Level
        level = Level(filename: "Level_1")
        scene.level = level
        scene.addTiles()
        scene.swipeHandler = handleSwipe
        // MARK: Present the scene.
        skView.presentScene(scene)
        
        // MARK: Game 
        beginGame()
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .portraitUpsideDown]
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

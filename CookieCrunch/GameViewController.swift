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
    func beginGame() {
        shuffle()
    }
    
    func shuffle() {
        let newCookies = level.shuffle()
        scene.addSprites(for: newCookies)
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

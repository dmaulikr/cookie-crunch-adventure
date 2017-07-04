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
    var scene: GameScene!
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Configure the view
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
        
        // MARK: Create and configure the scene. 
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        
        // MARK: Present the scene.
        skView.presentScene(scene)
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

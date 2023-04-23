//
//  ViewController.swift
//  GameBoyEmulatorSeniorProject2023
//
//  Created by Frank Salgado on 2/21/23.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {

    @IBOutlet var skView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.skView {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill;
                scene.size = CGSize(width: 300, height: 300);
                // Present the scene
                view.presentScene(scene);
            }
            
            view.ignoresSiblingOrder = true;
            
            view.showsFPS = true;
            view.showsNodeCount = true;
        }
    }
}

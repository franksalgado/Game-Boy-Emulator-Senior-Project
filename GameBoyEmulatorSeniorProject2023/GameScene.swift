//
//  GameScene.swift
//  GameBoyEmulatorSeniorProject2023
//
//  Created by Frank Salgado on 2/21/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func sceneDidLoad() {
        
        self.lastUpdateTime = 0
        renderTilemap();
        /*
        let pixelNode = SKSpriteNode(color: .red, size: CGSize(width: 1, height: 1));
        pixelNode.position = CGPoint(x: 0, y: 0);
        pixelNode.zPosition = 1;
        self.addChild(pixelNode);
         
        let pixelNode = SKSpriteNode(color: .red, size: CGSize(width: 1, height: 1));
        pixelNode.position = CGPoint(x: -80, y: 72);
        pixelNode.zPosition = 5;
        self.addChild(pixelNode);
        let pixelNodea = SKSpriteNode(color: .red, size: CGSize(width: 1, height: 1));
        pixelNodea.position = CGPoint(x: 48, y: -120);
        pixelNodea.zPosition = 5;
        self.addChild(pixelNodea);
         */
    }
    
    func getPixelColor(value: UInt8) -> SKColor {
        switch value {
        case 0:
            return SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0);  // White
            case 1:
            return SKColor(red: 0.0, green: 0.4, blue: 0.8, alpha: 1.0);  // Light blue
            case 2:
            return SKColor(red: 0.0, green: 0.4, blue: 0.8, alpha: 1.0);   // Dark blue
            case 3:
            return SKColor(red: 0.0, green: 0.1, blue: 0.3, alpha: 1.0);    // Navy blue
        default:
            print("Invalid color index");
            exit(-5);
            }
        }
    
    
    func renderTile(atPoint pos : CGPoint, tileIndex: UInt16, colorValue: UInt8) {
       // let tileSize = CGSize(width: 8, height: 8);
        // Loop through each pixel in the tile and set its color based on the UInt8 value
        for y in (0..<8) {
            var tileOffset:UInt16 = tileIndex * 16;
            let rowOffset:UInt16  = UInt16(y * 2);
            let address:UInt16 = 0x8000 + tileOffset + rowOffset;
            var firstByte: UInt8 = BusRead(address: address);
            var secondByte: UInt8 = BusRead(address: 0x8000 + (tileIndex * 16) + (y * 2) + 1);
            let colorValue: [UInt8] = GetTileLineBytes(firstByte: firstByte, secondByte: secondByte);
            for x in 0..<8 {
                let pixelColor: SKColor = getPixelColor(value: colorValue[x]);
                let pixelNode = SKSpriteNode(color: pixelColor, size: CGSize(width: 1, height: 1));
                pixelNode.position = CGPoint(x: x + Int(pos.x), y:  Int(pos.y) - y);
                pixelNode.zPosition = -1;
                self.addChild(pixelNode);
            }
        }
    }
    
    func renderTilemap() {
        var x = -80;
        var y = 72;
        var tileIndex:UInt16 = 0;
        while y != -120 {
            x = -80;
            while x != 48 {
                renderTile(atPoint: CGPoint(x: x, y: y), tileIndex: tileIndex);
                tileIndex += 1;
                x += 8;
            }
            y -= 8;
        }
    }
    
    
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        self.touchDown(atPoint: event.location(in: self))
    }
    
    override func mouseDragged(with event: NSEvent) {
        self.touchMoved(toPoint: event.location(in: self))
    }
    
    override func mouseUp(with event: NSEvent) {
        self.touchUp(atPoint: event.location(in: self))
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 0x31:
            if let label = self.label {
                label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
            }
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}

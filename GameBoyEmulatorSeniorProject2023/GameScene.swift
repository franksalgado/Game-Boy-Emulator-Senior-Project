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
    private var pixelNodes = [SKSpriteNode]();
    
    override func sceneDidLoad() {
           self.lastUpdateTime = 0
        createTileMap();
        //renderTilemap();
       }

    func createTileMap() {
        var x = -80;
        var y = 72;
        var tileIndex:UInt16 = 0;
        while y != -120 {
            x = -80;
            while x != 48 {
                createTile(atPoint: CGPoint(x: x, y: y), tileIndex: tileIndex);
                tileIndex += 1;
                x += 8;
            }
            y -= 8;
        }
    }
    func createTile(atPoint pos : CGPoint, tileIndex: UInt16) {
       // let tileSize = CGSize(width: 8, height: 8);
        // Loop through each pixel in the tile and set its color based on the UInt8 value
        for y in (0..<8) {
            let colorValue: UInt8 = 0;
            for x in 0..<8 {
                let pixelColor: SKColor = getPixelColor(value: colorValue);
                let pixelNode = SKSpriteNode(color: pixelColor, size: CGSize(width: 1, height: 1));
                pixelNode.position = CGPoint(x: x + Int(pos.x), y:  Int(pos.y) - y);
                pixelNode.zPosition = -0.1;
                pixelNodes.append(pixelNode);
                self.addChild(pixelNode);
            }
        }
    }
    
    func getPixelColor(value: UInt8) -> SKColor {
        switch value {
        case 0:
            return LCDStateInstance.backGroundColors[0];  // Lightest Green
        case 1:
            return  LCDStateInstance.backGroundColors[1];  // Light Green
        case 2:
            return  LCDStateInstance.backGroundColors[2];  // Dark Green
        case 3:
            return  LCDStateInstance.backGroundColors[3];  // Darkest Green
        default:
            print("Invalid color index");
            exit(-5);
        }
    }

    //Used in GameScene class to get the bytes to render all 8 pixels for a tile.
    let binaryNumbers: [UInt8] = [0b10000000, 0b01000000, 0b00100000, 0b00010000, 0b00001000, 0b00000100, 0b00000010, 0b00000001];
    func GetTileLineBytes(firstByte: UInt8, secondByte: UInt8) -> [UInt8] {
        var i = 0;
        var number: UInt8 = 0;
        var array: [UInt8] = Array<UInt8>(repeating: 0 , count: 8);
        while i < 8 {
            number = 0;
            if firstByte & binaryNumbers[i] != 0 {
                number |= (1 <<  1);
            }
            if secondByte & binaryNumbers[i] != 0 {
                number |= 1;
            }
            array[i] = number
            i += 1;
        }
        return array;
    }
    
    //Each tile is composed of 16 bytes. Each line is 2 bytes vram starts at address 0x8000
    func tileByteCalculaion(tileIndex: UInt16, y: Int) -> UInt8 {
        let tileOffset:UInt16 = tileIndex * 16;
        let rowOffset:UInt16  = UInt16(y * 2);
        let address:UInt16 = tileOffset + rowOffset;
        return PPUStateInstance.vram[Int(address)];
    }
    
    func renderTile( tileIndex: UInt16) {
       // let tileSize = CGSize(width: 8, height: 8);
        // Loop through each pixel in the tile and set its color based on the UInt8 value
        for y in 0..<8 {
            let firstByte: UInt8 = tileByteCalculaion(tileIndex: tileIndex, y: y);
            let secondByte: UInt8 = tileByteCalculaion(tileIndex: tileIndex, y: y + 1);
            let colorValue: [UInt8] = GetTileLineBytes(firstByte: firstByte, secondByte: secondByte);
            for x in 0..<8 {
                let pixelColor: SKColor = getPixelColor(value: colorValue[x]);
                let index = (y * 8) + x + (Int(tileIndex) * 64);
                pixelNodes[index].color = pixelColor;
            }
        }
    }
    
    func renderTilemap() {
        var tileIndex:UInt16 = 0;
        while tileIndex * 64 < pixelNodes.count {
            renderTile(tileIndex: tileIndex);
            tileIndex += 1;
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
        
        self.lastUpdateTime = currentTime;
        renderTilemap();
        //print(pixelNodes.count)
    }
}

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
        /*
        var x = 0;
        var y = 0;
        var tileIndex:UInt16 = 0;
        while y != -144 {
            x = 0;
            while x != 160 {
                createTile(atPoint: CGPoint(x: x, y: y), tileIndex: tileIndex);
                tileIndex += 1;
                x += 8;
            }
            y -= 8;
        }
         */
        var x = 0;
        var y = 0;
        var tileIndex:UInt16 = 0;
        while y != -144 {
            x = 0;
            while x != 160 {
                let pixelColor: SKColor = getPixelColor(value: 0);
                let pixelNode = SKSpriteNode(color: pixelColor, size: CGSize(width: 1, height: 1));
                pixelNode.position = CGPoint(x: x, y:  y);
                pixelNode.zPosition = -0.1;
                pixelNodes.append(pixelNode);
                self.addChild(pixelNode);
                tileIndex += 1;
                x += 1;
            }
            y -= 1;
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
    
    
    //Only used for viewing tiles in memory
    func renderTile( tileIndex: UInt16) {
        //let tileSize = CGSize(width: 8, height: 8);
        // Loop through each pixel in the tile and set its color based on the UInt8 value
        for y in 0..<8 {
            //let firstByte: UInt8 = tileByteCalculaion(tileIndex: tileIndex, y: y);
            //let secondByte: UInt8 = tileByteCalculaion(tileIndex: tileIndex, y: y + 1);
            //let colorValue: [UInt8] = GetTileLineBytes(firstByte: firstByte, secondByte: secondByte);
            for x in 0..<8 {
                //let pixelColor: SKColor = getPixelColor(value: colorValue[x]);
                let index = (y * 8) + x + (Int(tileIndex) * 64);
                pixelNodes[index].color = PPUStateInstance.videoBuffer[index];
            }
        }
    }
    
    func renderTilemap() {
        /*
        var tileIndex:UInt16 = 0;
        while tileIndex * 64 < pixelNodes.count {
            renderTile(tileIndex: tileIndex);
            tileIndex += 1;
        }*/
        var i = 0;
        //print(PPUStateInstance.videoBuffer.count)
        while i < PPUStateInstance.videoBuffer.count {
            pixelNodes[i].color = PPUStateInstance.videoBuffer[i];
            i += 1;
        }
    }
    
    /*
     Bit 7 - Not used
     Bit 6 - Not used
     Bit 5 - P15 Select Action buttons    (0=Select)
     Bit 4 - P14 Select Direction buttons (0=Select)
     Bit 3 - P13 Input: Down  or Start    (0=Pressed) (Read Only)
     Bit 2 - P12 Input: Up    or Select   (0=Pressed) (Read Only)
     Bit 1 - P11 Input: Left  or B        (0=Pressed) (Read Only)
     Bit 0 - P10 Input: Right or A        (0=Pressed) (Read Only)

     */
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case GameBoyButtons.DOWN.rawValue:
            JoypadInstance.buttons.down = true;
        case GameBoyButtons.UP.rawValue:
            JoypadInstance.buttons.up = true;
        case GameBoyButtons.LEFT.rawValue:
            JoypadInstance.buttons.left = true;
        case GameBoyButtons.RIGHT.rawValue:
            JoypadInstance.buttons.right = true;
        case GameBoyButtons.START.rawValue:
            JoypadInstance.buttons.start = true;
        case GameBoyButtons.SELECT.rawValue:
            JoypadInstance.buttons.select = true;
        case GameBoyButtons.A.rawValue:
            JoypadInstance.buttons.a = true;
        case GameBoyButtons.B.rawValue:
            JoypadInstance.buttons.b = true;
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }

    override func keyUp(with event: NSEvent) {
        switch event.keyCode {
        case GameBoyButtons.DOWN.rawValue:
            JoypadInstance.buttons.down = false;
        case GameBoyButtons.UP.rawValue:
            JoypadInstance.buttons.up = false;
        case GameBoyButtons.LEFT.rawValue:
            JoypadInstance.buttons.left = false;
        case GameBoyButtons.RIGHT.rawValue:
            JoypadInstance.buttons.right = false;
        case GameBoyButtons.START.rawValue:
            JoypadInstance.buttons.start = false;
        case GameBoyButtons.SELECT.rawValue:
            JoypadInstance.buttons.select = false;
        case GameBoyButtons.A.rawValue:
            JoypadInstance.buttons.a = false;
        case GameBoyButtons.B.rawValue:
            JoypadInstance.buttons.b = false;
        default:
            break
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

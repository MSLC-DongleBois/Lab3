//
//  GameScene.swift
//  Commotion
//
//  Created by Eric Larson on 9/6/16.
//  Copyright © 2016 Eric Larson. All rights reserved.
//

import UIKit
import SpriteKit
import CoreMotion

class GameScene: SKScene {
    
    

    
    // MARK: Raw Motion Functions
    let motion = CMMotionManager()
    
    func startMotionUpdates(){
        // some internal inconsistency here: we need to ask the device manager for device
        
        if self.motion.isDeviceMotionAvailable{
            self.motion.deviceMotionUpdateInterval = 0.1
            self.motion.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: self.handleMotion )
        }
    }
    
    func handleMotion(_ motionData:CMDeviceMotion?, error:Error?){
        if let gravity = motionData?.gravity {
            self.physicsWorld.gravity = CGVector(dx: CGFloat(20.8*gravity.x), dy: CGFloat(20.8*gravity.y))
        }
    }
    

    
    // MARK: View Hierarchy Functions
    override func didMove(to view: SKView) {
        
        //backgroundColor = SKColor.green
        let background = SKSpriteNode(imageNamed: "background_leaf.jpg")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        addChild(background)
        
        //backgroundColor = SKColor.white
        
        // start motion for gravity
        self.startMotionUpdates()
        
        // make sides to the screen
        self.addGameBoundaries()
        
        self.addBoi()
        self.addObstacle(CGPoint(x: size.width/2, y: size.height * 0.33))
        self.addObstacle(CGPoint(x: size.width/2, y: size.height * 0.66))
        self.addApple()
        self.addSpinner()
    }
    
    
    // MARK: Create Sprites Functions
    func addBoi(){
        
        let boi = SKSpriteNode(imageNamed: "kellen.png")
        
        boi.size = CGSize(width:size.width*0.13,height:size.height * 0.11492169)
        
        boi.position = CGPoint(x: size.width/2, y: size.height * 0.18)
        
        boi.physicsBody = SKPhysicsBody(rectangleOf:boi.size)
        //boi.physicsBody?.restitution = random(min: CGFloat(1.0), max: CGFloat(1.5))
        boi.physicsBody?.restitution = 0.15

        boi.physicsBody?.isDynamic = true
        boi.zPosition = 1
        
        self.addChild(boi)
    }
    
    func addObstacle(_ point:CGPoint){
        
        let wall = SKSpriteNode(imageNamed: "wall.jpg")
        
        wall.size = CGSize(width:size.width*0.4,height: size.height * 0.07 )
        
        wall.position = point
        
        wall.physicsBody = SKPhysicsBody(rectangleOf:wall.size)
        wall.physicsBody?.restitution = random(min: CGFloat(1.0), max: CGFloat(1.5))
        wall.physicsBody?.restitution = 1
        
        wall.physicsBody?.isDynamic = false
        wall.zPosition = 1
        
        self.addChild(wall)
    }
    
    func addSpinner(){
        
        let boi = SKSpriteNode(imageNamed: "spinner")
        
        boi.size = CGSize(width:size.width*0.15,height:size.height * 0.09)
        
        boi.position = CGPoint(x: size.width/3, y: size.height * 0.18)
        
        boi.physicsBody = SKPhysicsBody(circleOfRadius: boi.size.width/2)
        //boi.physicsBody?.restitution = random(min: CGFloat(1.0), max: CGFloat(1.5))
        boi.physicsBody?.restitution = 0.15
        
        boi.physicsBody?.isDynamic = true
        boi.zPosition = 1
        
        self.addChild(boi)
    }
    
    func addApple(){
        
        let boi = SKSpriteNode(imageNamed: "apple")
        
        boi.size = CGSize(width:size.width*0.11,height:size.height * 0.07)
        
        boi.position = CGPoint(x: size.width/2, y: size.height * 0.75)
        
        boi.physicsBody = SKPhysicsBody(rectangleOf:boi.size)
        //boi.physicsBody?.restitution = random(min: CGFloat(1.0), max: CGFloat(1.5))
        boi.physicsBody?.restitution = 0.9
        
        boi.physicsBody?.isDynamic = true
        boi.zPosition = 1
        
        self.addChild(boi)
        
    }
    
    func addGameBoundaries(){
        let left = SKSpriteNode()
        let right = SKSpriteNode()
        let top = SKSpriteNode()
        let bottom = SKSpriteNode()
        
        left.size = CGSize(width:size.width*0.1,height:size.height)
        left.position = CGPoint(x:0, y:size.height*0.5)
        
        right.size = CGSize(width:size.width*0.1,height:size.height)
        right.position = CGPoint(x:size.width, y:size.height*0.5)
        
        top.size = CGSize(width:size.width,height:size.height*0.1)
        top.position = CGPoint(x:size.width*0.5, y:size.height)
        
        bottom.size = CGSize(width:size.width,height:size.height*0.1)
        bottom.position = CGPoint(x:size.width*0.5, y:0)
        
        for obj in [left,right,top,bottom]{
            obj.color = UIColor.brown
            obj.physicsBody = SKPhysicsBody(rectangleOf:obj.size)
            obj.physicsBody?.isDynamic = true
            obj.physicsBody?.pinned = true
            obj.physicsBody?.allowsRotation = false
            self.addChild(obj)
        }
        
        
    }
    
    // MARK: UI Delegate Functions
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.addBoi()
    }
    
    // MARK: Utility Functions (thanks ray wenderlich!)
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
}

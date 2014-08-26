//
//  GameScene.swift
//  swift-meetup
//
//  Created by Hugo Almeida on 8/25/14.
//  Copyright (c) 2014 Hugo Almeida. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
  
  var cat:SKSpriteNode!
  var door:SKSpriteNode!
  
    override func didMoveToView(view: SKView) {
      
      cat = SKSpriteNode(imageNamed:"catrunx2.png")
      cat.xScale = 1
      cat.yScale = 1

      door = SKSpriteNode(imageNamed:"sign_door.jpg")
      door.xScale = 0.1
      door.yScale = 0.1
      
      var map = Map(gridSize: CGSize(width:16, height:16))
      
      cat.position = map.spawnPoint
      cat.physicsBody = SKPhysicsBody(rectangleOfSize: cat.size)
      cat.physicsBody.collisionBitMask = 1
      cat.physicsBody.contactTestBitMask = 1
      self.addChild(cat)

      door.position = map.exitPoint
      door.physicsBody = SKPhysicsBody(rectangleOfSize: door.size)
      door.physicsBody.dynamic = false
      door.physicsBody.collisionBitMask = 2
      door.physicsBody.contactTestBitMask = 1
      self.addChild(door)
      self.physicsWorld.gravity = CGVector(0,0)
      self.physicsWorld.contactDelegate = self
    }
  
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
      for touch: AnyObject in touches {
        let location = touch.locationInNode(self)
        let touchX = location.x
        let touchY = location.y
        
        //above
        if(touchY > (self.frame.size.height+1)/2) {
          cat.runAction(SKAction.moveBy(CGVector(0, 20), duration: NSTimeInterval(0.5)))
          //cat.position = CGPoint(x: cat.position.x, y: cat.position.y + 1)
        }
        
        //below
        if(touchY < (self.frame.size.height-1)/2) {
          cat.runAction(SKAction.moveBy(CGVector(0, -20), duration: NSTimeInterval(0.5)))
        }
        
        // left
        if(touchX > (self.frame.size.width-1)/2) {
          cat.runAction(SKAction.moveBy(CGVector(20, 0), duration: NSTimeInterval(0.5)))
        }
        
        // right
        if(touchX < (self.frame.size.width+1)/2) {
          cat.runAction(SKAction.moveBy(CGVector(-20, 0), duration: NSTimeInterval(0.5)))
        }
      }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
 
  func didBeginContact(contact: SKPhysicsContact!)  {
    var label = SKLabelNode(text: "CRASH!!!!")
    label.position = CGPoint(x:Map.randomNumberBetween(300, max:600), y:Map.randomNumberBetween(300, max:600))
    self.addChild(label)
    
    self.runAction(SKAction.playSoundFileNamed("bb.mp3", waitForCompletion: false))
  }
}

class Map {
  let size:CGSize
  let spawnPoint:CGPoint
  let exitPoint:CGPoint
  
  init(gridSize: CGSize) {
    size = gridSize
    spawnPoint = CGPoint(x:Map.randomNumberBetween(300, max:600), y:Map.randomNumberBetween(300, max:600))
    exitPoint = CGPoint(x:Map.randomNumberBetween(300, max:600), y:Map.randomNumberBetween(300, max:600))
  }
  
  class func randomNumberBetween(min:Int, max:Int) -> Int {
    // Returns a random number between min and max both included
    return min + Int(arc4random_uniform(UInt32(max - min)))
  }
  
}

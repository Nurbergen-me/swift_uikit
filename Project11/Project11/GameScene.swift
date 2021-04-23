//
//  GameScene.swift
//  Project11
//
//  Created by Nurbergen Yeleshov on 01.01.2021.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var balls = ["ballRed","ballBlue","ballCyan","ballGreen","ballGrey","ballPurple","ballYellow"]
    var scoreLabel: SKLabelNode!
    var editlabel: SKLabelNode!
    var deleteLabel: SKLabelNode!
    var limitLable: SKLabelNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var limit = 5 {
        didSet {
            limitLable.text = "Balls: \(limit)"
        }
    }
    
    var editingMode = false {
        didSet {
            if editingMode {
                editlabel.text = "Done"
            } else {
                editlabel.text = "Edit"
            }
        }
    }
    
    var delete = false {
        didSet {
            if delete {
                deleteLabel.text = "Done"
            } else {
                deleteLabel.text = "Delete"
            }
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        limitLable = SKLabelNode(fontNamed: "Chalkduster")
        limitLable.text = "Balls: 5"
        limitLable.horizontalAlignmentMode = .right
        limitLable.position = CGPoint(x: 750, y: 700)
        addChild(limitLable)
        
        deleteLabel = SKLabelNode(fontNamed: "Chalkduster")
        deleteLabel.text = "Delete"
        deleteLabel.horizontalAlignmentMode = .left
        deleteLabel.position = CGPoint(x: 200, y: 700)
        addChild(deleteLabel)
        
        editlabel = SKLabelNode(fontNamed: "Chalkduster")
        editlabel.text = "Edit"
        editlabel.horizontalAlignmentMode = .left
        editlabel.position = CGPoint(x: 80, y: 700)
        addChild(editlabel)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
        createBouncer(at: CGPoint(x: 0, y: 0))
        createBouncer(at: CGPoint(x: 256, y: 0))
        createBouncer(at: CGPoint(x: 512, y: 0))
        createBouncer(at: CGPoint(x: 768, y: 0))
        createBouncer(at: CGPoint(x: 1024, y: 0))
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)
        
        let object = nodes(at: location)
        
        if object.contains(editlabel) {
            editingMode.toggle()
            delete = false
        } else if object.contains(deleteLabel) {
            delete.toggle()
            editingMode = false
        } else {
            if editingMode {
                let size = CGSize(width: Int.random(in: 16...128), height: 16)
                let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                box.zRotation = CGFloat.random(in: 0...3)
                box.position = location
                
                box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                box.physicsBody?.isDynamic = false
                box.name = "box"
                addChild(box)
                
            } else if delete {
                let box = nodes(at: location)
                if box[0].name == "box" {
                    box[0].removeFromParent()
                }
            } else {
                if limit > 0 {
                    if location.y < 500 { location.y = 500 }
                    let ball = SKSpriteNode(imageNamed: balls.randomElement()!)
                    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                    ball.physicsBody?.restitution = 0.4
                    ball.physicsBody?.contactTestBitMask = ball.physicsBody!.collisionBitMask
                    ball.position = location
                    ball.name = "ball"
                    addChild(ball)
                    limit -= 1
                }
            }
        }
    }
    
    func createBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        slotBase.position = position
        slotGlow.position = position
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    func collisionBetween(between ball: SKNode, object: SKNode) {
        
        if object.name == "good" {
            destroy(ball: ball)
            score += 1
            limit += 1
            
            guard let removingBox = childNode(withName: "box") else { return }
            destroy(ball: removingBox)
            
        } else if object.name == "bad" {
            destroy(ball: ball)
            score -= 1
            limit -= 1
        }
    }
    
    func destroy(ball: SKNode) {
        if let fireParticle = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticle.position = ball.position
            addChild(fireParticle)
        }
        ball.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball" {
            collisionBetween(between: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collisionBetween(between: nodeB, object: nodeA)
        }
    }
}

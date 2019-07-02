//
//  GameScene.swift
//  noops-vexbot
//
//  Created by Peter Kos on 7/2/19.
//  Copyright © 2019 UW. All rights reserved.
//

import SpriteKit
import GameplayKit

import Alamofire
import PromiseKit
import PMKAlamofire

class GameScene: SKScene {

	// MARK: Models
	struct Noop: Decodable {
		var vectors: [NoopVector]
	}

	struct NoopVector: Decodable {
		var a: Coordinate
		var b: Coordinate
		var speed: Int
	}

	struct Coordinate: Decodable {
		var x: Int
		var y: Int
	}


	// MARK: Drawing models
	var vectors = [SKShapeNode]()

	let actions = SKAction.sequence([
		SKAction.rotate(byAngle: 0.1, duration: 0.3),
		SKAction.rotate(byAngle: -0.1, duration: 0.3),
		SKAction.wait(forDuration: 0.5) // @FIXME: Wait does not work?
	])

	var currentVector: SKShapeNode?


	// MARK: SpriteKit functions
    override func didMove(to view: SKView) {


		// Configure scene anchor point to DEVICE bottom-left
		// @FIXME: insets are 0?
//		let insets = view.safeAreaInsets
		let bounds = UIScreen.main.bounds
//		self.anchorPoint = CGPoint(x: insets.left, y: insets.bottom)
//		print("bottom: \(insets.bottom)")
//		print("left: \(insets.left)")
//		print("top: \(insets.top)")

		// Workaround: manual offsets
		self.anchorPoint = CGPoint(x: 0.1, y: 0.1)


		// This is outside firstly becuase I am bad at promises
		// (Need to decode the syntax a bit)
		let params = ["count": 10, "connected": true, "width": bounds.maxX, "height": bounds.maxY] as Parameters

		// Grab the data
		// (this took way too long to learn)
		firstly {

			Alamofire.request("https://api.noopschallenge.com/vexbot",
							  method: .get,
							  parameters: params).responseDecodable(Noop.self)

		}.done { noop in

			// Draw the noop!
			self.drawVectors(noop.vectors)

		}.catch { error in

			// Expert error handling
			print(error)
			return
		}

    }


	// Helper function to do actual drawing
	func drawVectors(_ vectors: [NoopVector]) {

		// Draw things
		for (index, vector) in vectors.enumerated() {

			let vectorNode = SKShapeNode()
			let path = CGMutablePath()

			path.move(to: CGPoint(x: vector.a.x, y: vector.a.y))
			path.addLine(to: CGPoint(x: vector.b.x, y: vector.b.y))

			print(path)

			vectorNode.path = path
			vectorNode.strokeColor = .white
			vectorNode.lineWidth = 5.0

			// Configure vector metadata
			vectorNode.name = "vector \(index + 1)"
			self.addChild(vectorNode)

			// Finally, append to our collection of nodes
			self.vectors.append(vectorNode)

		}

		print("got the lines!")
	}


	// MARK: Interaction functions
    func touchDown(atPoint pos : CGPoint) {

		for node in self.children {

			guard let node = node as? SKShapeNode else {
				return
			}

			currentVector = node

			node.run(actions)
			print("unhid node \(node.name!)")
		}

    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

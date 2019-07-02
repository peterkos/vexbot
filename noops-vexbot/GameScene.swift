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

	var vectors = [SKShapeNode]()

	let actions = SKAction.sequence([
		SKAction.fadeAlpha(to: 0.0, duration: 0.1),
		SKAction.fadeAlpha(to: 1.0, duration: 0.5),
		SKAction.fadeAlpha(to: 0.5, duration: 0.1),
		SKAction.wait(forDuration: 0.5),
	])

	var currentVector: SKShapeNode?

    override func didMove(to view: SKView) {

		// Grab the data
		// (this took way too long to learn)
		firstly {
			Alamofire.request("https://api.noopschallenge.com/vexbot", method: .get, parameters: ["count": 100]).responseDecodable(Noop.self)
		}.done { noop in

			// Draw things
			for (index, vector) in noop.vectors.enumerated() {

				let vectorNode = SKShapeNode()
				let path = CGMutablePath()
				path.move(to: CGPoint(x: vector.a.x, y: vector.a.y))
				path.addLine(to: CGPoint(x: vector.b.x, y: vector.b.y))
				vectorNode.path = path
				vectorNode.strokeColor = .white

				// Configure vector metadata
				vectorNode.name = "vector \(index + 1)"
				self.addChild(vectorNode)

				// Finally, append ot our collection of nodes
				self.vectors.append(vectorNode)

			}

			print("got the lines!")



		}.catch { error in
			print(error)
			return
		}

    }


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

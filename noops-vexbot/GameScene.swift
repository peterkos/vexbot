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
    
    override func didMove(to view: SKView) {

		let rectNode = SKShapeNode(rectOf: CGSize(width: 300, height: 300))
		rectNode.position = CGPoint(x: frame.midX, y: frame.midY)
		rectNode.fillColor = .white

		self.addChild(rectNode)

		// Grab the data
		// (this took way too long to learn)
		firstly {
			Alamofire.request("https://api.noopschallenge.com/vexbot", method: .get).responseDecodable(Noop.self)
		}.done { noop in
			print(noop)
		}.catch { error in
			print(error)
			return
		}

    }


    func touchDown(atPoint pos : CGPoint) {
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

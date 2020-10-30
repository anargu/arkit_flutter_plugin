//
//  ARPostCardUIView.swift
//  arkit_plugin
//
//  Created by Anargu on 9/3/20.
//

import UIKit
import SpriteKit


class PostCALayer {
    let container : UIView
    let lay : CALayer
    
    init() {
        container = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        container.animation
        lay = container.layer
        lay.backgroundColor = UIColor.red.cgColor
        
        let author = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        author.text = "AUTHOR"
        container.addSubview(author)
        lay.addSublayer(author.layer)
        
        let raw = UILabel(frame: CGRect(x: 0, y: 20, width: 100, height: 20))
        raw.text = "RAW"
        container.addSubview(raw)
        lay.addSublayer(raw.layer)
        
        lay.displayIfNeeded()
    }
}

class CardSKView {
    let skView : SKScene
    init() {
        skView = SKScene(size: CGSize(width: 100, height: 100))
        skView.backgroundColor = .cyan
        let labelAuthor = SKLabelNode(text: "AUTHOR")
        labelAuthor.horizontalAlignmentMode = .right
        labelAuthor.color = .red
        labelAuthor.position = CGPoint(x: 0.0, y: 0.0)
        skView.addChild(labelAuthor)
//        skView.didMove(to: <#T##SKView#>)
    }
}

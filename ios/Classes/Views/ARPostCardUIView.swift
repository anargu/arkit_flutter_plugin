//
//  ARPostCardUIView.swift
//  arkit_plugin
//
//  Created by Anargu on 9/3/20.
//

import UIKit
import PureLayout
import SpriteKit

class ARPostCardUIView: UIView {
    
    let authorLabel : UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        label.backgroundColor = UIColor.purple
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.borderWidth = 1.0
        label.layer.cornerRadius = 5.0
        label.textColor = .yellow
        label.text = "AUTHOR"


        label.autoSetDimension(.width, toSize: 124.0)
        label.autoSetDimension(.height, toSize: 124.0)
        
        return label
    }()

    let rawLabel : UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        label.backgroundColor = UIColor.blue
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.borderWidth = 1.0
        label.layer.cornerRadius = 5.0
        label.textColor = .yellow
        label.text = "RAW"

        label.autoSetDimension(.width, toSize: 124.0)
        label.autoSetDimension(.height, toSize: 124.0)

        return label
    }()
    
    
    let contentView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.backgroundColor = .red

        return view
    }()
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        setupViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white

//        self.author = author
//        self.raw = raw
//        (authorLabel as! UILabel).text = author
//        (rawLabel as! UILabel).text = raw
        setupViews()
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
//        self.addSubview(contentView)
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGray.cgColor
//        self.backgroundColor = .brown
        self.layer.insertSublayer(authorLabel.layer, at: 0)
//        self.addSubview(authorLabel)
//        self.addSubview(rawLabel)
    }
    
    
    
    
}

class ArPostCardController : UIViewController {
    
    let postView : ARPostCardUIView! = ARPostCardUIView()
    
    override func loadView() {
        self.view = postView
    }
    override func viewDidLoad() {
        self.view.setNeedsLayout()
    }

//    var shouldSetupConstraints = true
//    override func updateViewConstraints() {
//        if(shouldSetupConstraints) {
////            NSLayoutConstraint.activate([
////                postView.authorLabel.leftAnchor.constraint(equalTo: self.postView.leftAnchor),
////                postView.rawLabel.leftAnchor.constraint(equalTo: self.postView.leftAnchor),
////                postView.rawLabel.bottomAnchor.constraint(equalTo: self.postView.authorLabel.topAnchor)
////            ])
//
////            postView.authorLabel.autoSetDimension(.height, toSize: 50)
////            postView.authorLabel.autoMatch(.width, to: .width, of: postView)
//
//            shouldSetupConstraints = false
//        }
//        super.updateViewConstraints()
//    }
}


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

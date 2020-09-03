//
//  ARPostCardUIView.swift
//  arkit_plugin
//
//  Created by Anargu on 9/3/20.
//

import UIKit

class ARPostCardUIView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupViews()
//        setupConstraints()
//        addActions()
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        self.addSubview(contentView)
//        self.addSubview(likeButton)
    }
    
    let contentView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.backgroundColor = .red
        return view
    }()
}

class ArPostCardController : UIViewController {
    
    override func loadView() {
        
        let view = ARPostCardUIView()
        view.backgroundColor = .white
        self.view = view
    }
}

//
//  ScrollLabel.swift
//  ScrollingLabel
//
//  Created by Pablo Balduz on 29/05/2019.
//  Copyright © 2019 Pablo Balduz. All rights reserved.
//

import UIKit

class ScrollLabel: UIView {
    
    var animationDelay: CFTimeInterval = 1
    var scrollSpeed: CFTimeInterval = 0.1 {
        didSet {
            scrollSpeed = min(1, max(0, scrollSpeed))
        }
    }
    
    var text: String? {
        didSet {
            label.text = text
        }
    }
    
    private let label = UILabel()
    
    private var expectedLabelSize: CGSize {
        return label.sizeThatFits(CGSize(width: CGFloat.infinity, height: frame.height))
    }
    
    private var animationOffset: CGFloat {
        return abs(expectedLabelSize.width)
    }
    
    private var animationDuration: CFTimeInterval {
        return CFTimeInterval(animationOffset) / (scrollSpeed * ScrollLabel.maxSpeedValue)
    }
    
    private var textNeedsScroll: Bool {
        return frame.width < expectedLabelSize.width
    }
    
    init() {
        super.init(frame: .zero)
        
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.heightAnchor.constraint(equalTo: self.heightAnchor),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor)
            ])
        
//        self.layer.contents = label.layer.contents
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.masksToBounds = true
        
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.instanceCount = 2
        replicatorLayer.instanceTransform = CATransform3DMakeTranslation(expectedLabelSize.width, 0, 0)
        replicatorLayer.addSublayer(label.layer)
        layer.addSublayer(replicatorLayer)
        
        if textNeedsScroll {
            let forthAnimation = CABasicAnimation(keyPath: "position.x")
            forthAnimation.byValue = -animationOffset
            forthAnimation.duration = animationDuration
            forthAnimation.fillMode = .forwards
//            forthAnimation.beginTime = animationDelay

            let backAnimation = CABasicAnimation(keyPath: "position.x")
            backAnimation.byValue = animationOffset
            backAnimation.duration = animationDuration
            backAnimation.fillMode = .forwards
            backAnimation.beginTime = animationDuration + 2 * animationDelay

            let animations = CAAnimationGroup()
            animations.animations = [forthAnimation]
//            animations.duration = 2 * animationDuration + 2 * animationDelay
            animations.duration = animationDuration
            animations.repeatCount = Float.infinity

            label.layer.add(animations, forKey: "scroll")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ScrollLabel {
    
    static let maxSpeedValue: Double = 300
}

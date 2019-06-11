//
//  ScrollLabel.swift
//  ScrollingLabel
//
//  Created by Pablo Balduz on 29/05/2019.
//  Copyright © 2019 Pablo Balduz. All rights reserved.
//

import UIKit

class ScrollLabel: UIView {
    
    static let maxSpeedValue: Double = 300
    
    var animationStyle: AnimationStyle = .continuous
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
    
    private let replicatorLayer = CAReplicatorLayer()
    
    private var expectedLabelSize: CGSize {
        return label.sizeThatFits(CGSize(width: CGFloat.infinity, height: frame.height))
    }
    
    private var animationOffset: CGFloat {
        switch animationStyle {
        case .continuous:
            return abs(expectedLabelSize.width)
        case .backForth:
            return abs(frame.width - expectedLabelSize.width)
        }
    }
    
    private var animationDuration: CFTimeInterval {
        switch animationStyle {
        case .continuous:
            return CFTimeInterval(animationOffset) / (scrollSpeed * ScrollLabel.maxSpeedValue)
        case .backForth:
            return CFTimeInterval(animationOffset) / (scrollSpeed * ScrollLabel.maxSpeedValue)
        }
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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.masksToBounds = true
        
        replicatorLayer.instanceCount = animationStyle.replicatorInstances
        replicatorLayer.instanceTransform = CATransform3DMakeTranslation(expectedLabelSize.width, 0, 0)
        replicatorLayer.addSublayer(label.layer)
        layer.addSublayer(replicatorLayer)
        
        if textNeedsScroll {
            let animation = currentAnimation()
            label.layer.add(animation, forKey: "scroll")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func currentAnimation() -> CAAnimation {
        var animation: CAAnimation!
        switch animationStyle {
        case .continuous:
            let continuousAnimation = CABasicAnimation(keyPath: "position.x")
            continuousAnimation.byValue = -animationOffset
            continuousAnimation.duration = animationDuration
            continuousAnimation.repeatCount = Float.infinity
            animation = continuousAnimation
        case .backForth:
            let forthAnimation = CABasicAnimation(keyPath: "position.x")
            forthAnimation.byValue = -animationOffset
            forthAnimation.duration = animationDuration
            forthAnimation.fillMode = .forwards
            forthAnimation.beginTime = animationDelay
            
            let backAnimation = CABasicAnimation(keyPath: "position.x")
            backAnimation.byValue = animationOffset
            backAnimation.duration = animationDuration
            backAnimation.fillMode = .forwards
            backAnimation.beginTime = animationDuration + 2 * animationDelay
            
            let animationGroup = CAAnimationGroup()
            animationGroup.animations = [forthAnimation, backAnimation]
            animationGroup.duration = 2 * animationDuration + 2 * animationDelay
            animationGroup.repeatCount = Float.infinity
            
            animation = animationGroup
        }
        
        return animation
    }
}

enum AnimationStyle {
    case continuous
    case backForth
}

private extension AnimationStyle {
    
    var replicatorInstances: Int {
        switch self {
        case .continuous: return 2
        case .backForth: return 1
        }
    }
}

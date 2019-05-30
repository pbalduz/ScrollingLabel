//
//  ViewController.swift
//  ScrollingLabel
//
//  Created by Pablo Balduz on 27/05/2019.
//  Copyright © 2019 Pablo Balduz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let label = ScrollLabel()
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.widthAnchor.constraint(equalToConstant: 300),
            label.heightAnchor.constraint(equalToConstant: 40)
            ])
    }
}

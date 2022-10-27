//
//  LaunchScreenViewController.swift
//  BNomad
//
//  Created by yeekim on 2022/10/27.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    
    let logoImg: UIImageView = {
        let img = UIImageView()
        
        img.image = Contents.resizeImage(image: UIImage(named: "Splash") ?? UIImage(), targetSize: CGSize(width: 150, height: 150))
        return img
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(logoImg)
        logoImg.translatesAutoresizingMaskIntoConstraints = false
        logoImg.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImg.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}


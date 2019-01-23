//
//  ViewController.swift
//  TransformableView
//
//  Created by 吴剑斌 on 2019/1/8.
//  Copyright © 2019年 stevenWu. All rights reserved.
//

import UIKit
import SWTransformableImgV

class ViewController: UIViewController {
    
    var imgV: SWTransformableImgV?

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func addImgV(_ sender: UIButton) {
        
        self.imgV = SWTransformableImgV(image: UIImage.init(named: "airline.png"))
        self.imgV?.center = self.view.center
        self.imgV?.pointColor = UIColor.yellow
        self.imgV?.controlPointDiameter = 30
        self.view.addSubview(imgV!)
    }
    
    @IBAction func confirmImgV(_ sender: UIButton) {
        self.imgV?.removePoint()
    }
    
//    @objc func panAction(_ panGes:UIPanGestureRecognizer) {
//        print(panGes.translation(in: self.view))
//    }
}


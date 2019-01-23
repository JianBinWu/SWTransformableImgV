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
        //change the control point color, default is white.
        self.imgV?.pointColor = UIColor.yellow
        //change the control point width, default is 20.
        self.imgV?.controlPointDiameter = 30
        self.view.addSubview(imgV!)
    }
    
    @IBAction func confirmImgV(_ sender: UIButton) {
        self.imgV?.removePoint()
    }

}


//
//  Tool.swift
//  TransformableView
//
//  Created by 吴剑斌 on 2019/1/11.
//  Copyright © 2019年 stevenWu. All rights reserved.
//

import UIKit

class SWTool: NSObject {
    class func distance(between firstPoint: CGPoint, and secondPoint: CGPoint) -> CGFloat {
        let deltaX = secondPoint.x - firstPoint.x
        let deltaY = secondPoint.y - firstPoint.y
        return sqrt(deltaX * deltaX + deltaY * deltaY)
    }
    
    class func center(between firstPoint: CGPoint, and secondPoint: CGPoint) -> CGPoint {
        return CGPoint(x: (firstPoint.x + secondPoint.x) / 2, y: (firstPoint.y + secondPoint.y) / 2)
    }
    

}

//
//  TransformableImgV.swift
//  TransformableView
//
//  Created by 吴剑斌 on 2019/1/8.
//  Copyright © 2019年 stevenWu. All rights reserved.
//

import UIKit

open class SWTransformableImgV: UIImageView {
    
    //control point color
    private var _pointColor: UIColor? = UIColor.white
    public var pointColor: UIColor? {
        set {
            _pointColor = newValue
            self.firstPoint?.backgroundColor = newValue
            self.secondPoint?.backgroundColor = newValue
            self.thirdPoint?.backgroundColor = newValue
            self.forthPoint?.backgroundColor = newValue
            self.rotatePoint?.backgroundColor = newValue
        }
        get {
            return _pointColor
        }
    }
    
    //control point diameter
    private var _controlPointDiameter: CGFloat? = 20
    public var controlPointDiameter: CGFloat? {
        set {
            _controlPointDiameter = newValue
            self.firstPoint?.frame.size = CGSize(width: _controlPointDiameter!, height: _controlPointDiameter!)
            self.secondPoint?.frame.size = CGSize(width: _controlPointDiameter!, height: _controlPointDiameter!)
            self.thirdPoint?.frame.size = CGSize(width: _controlPointDiameter!, height: _controlPointDiameter!)
            self.forthPoint?.frame.size = CGSize(width: _controlPointDiameter!, height: _controlPointDiameter!)
            self.rotatePoint?.frame.size = CGSize(width: _controlPointDiameter!, height: _controlPointDiameter!)
            self.firstPoint?.center = CGPoint(x: 0, y: 0)
            self.secondPoint?.center = CGPoint(x: self.viewWidth , y: 0)
            self.thirdPoint?.center = CGPoint(x: self.viewWidth, y: self.viewHeight)
            self.forthPoint?.center = CGPoint(x: 0, y: self.viewHeight)
            self.rotatePoint?.center = CGPoint(x: self.viewWidth / 2, y: -self.controlPointDiameter!)
            self.firstPoint?.layer.cornerRadius = self.controlPointDiameter! / 2;
            self.secondPoint?.layer.cornerRadius = self.controlPointDiameter! / 2;
            self.thirdPoint?.layer.cornerRadius = self.controlPointDiameter! / 2;
            self.forthPoint?.layer.cornerRadius = self.controlPointDiameter! / 2;
            self.rotatePoint?.layer.cornerRadius = self.controlPointDiameter! / 2;
        }
        
        get {
            return _controlPointDiameter
        }
    }
    
    //control point
    private var firstPoint: UIView?
    private var secondPoint: UIView?
    private var thirdPoint: UIView?
    private var forthPoint: UIView?
    private var rotatePoint: UIView?
    
    //view's parameter
    private var rotationAngle: CGFloat = 0
    private var viewCenter: CGPoint = CGPoint.zero
    private var viewWidth: CGFloat = 100
    private var viewHeight: CGFloat = 0
    
    
    //override method
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public init(image: UIImage?) {
        
        super.init(image: image)
        
        self.viewHeight = viewWidth / image!.size.width * image!.size.height
        self.frame.size = CGSize(width: viewWidth, height: viewHeight)
        
        self.isUserInteractionEnabled = true;
        let pinch = UIPanGestureRecognizer(target: self, action: #selector(panAction(_:)))
        self.addGestureRecognizer(pinch)
        
        self.initPoint()
        
    }
    
    override open var center: CGPoint {
        set {
            super.center = newValue
            self.viewCenter = newValue
        }
        get {
            return super.center
        }
    }
    
    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == nil {
            for subView in self.subviews {
                let myPoint = subView.convert(point, from: self)
                if subView.bounds.contains(myPoint) {
                    return subView
                }
            }
        }
        return view
    }
    
    //init method
    private func initPoint() {
        
        self.firstPoint = UIView(frame: CGRect(x: 0, y: 0, width: self.controlPointDiameter!, height: self.controlPointDiameter!))
        self.firstPoint?.center = CGPoint(x: 0, y: 0)
        self.configPoint(point: self.firstPoint!)
        let firstPan = UIPanGestureRecognizer(target: self, action: #selector(firstPanAction(_:)))
        self.firstPoint!.addGestureRecognizer(firstPan)
        
        self.secondPoint = UIView(frame: CGRect(x: 0, y: 0, width: self.controlPointDiameter!, height: self.controlPointDiameter!))
        self.secondPoint?.center = CGPoint(x: self.viewWidth , y: 0)
        self.configPoint(point: self.secondPoint!)
        let secondPan = UIPanGestureRecognizer(target: self, action: #selector(secondPanAction(_:)))
        self.secondPoint!.addGestureRecognizer(secondPan)
        
        self.thirdPoint = UIView(frame: CGRect(x: 0, y: 0, width: self.controlPointDiameter!, height: self.controlPointDiameter!))
        self.thirdPoint?.center = CGPoint(x: self.viewWidth, y: self.viewHeight)
        self.configPoint(point: self.thirdPoint!)
        let thirdPan = UIPanGestureRecognizer(target: self, action: #selector(thirdPanAction(_:)))
        self.thirdPoint!.addGestureRecognizer(thirdPan)
        
        self.forthPoint = UIView(frame: CGRect(x: 0, y: 0, width: self.controlPointDiameter!, height: self.controlPointDiameter!))
        self.forthPoint?.center = CGPoint(x: 0, y: self.viewHeight)
        self.configPoint(point: self.forthPoint!)
        let forthPan = UIPanGestureRecognizer(target: self, action: #selector(forthPanAction(_:)))
        self.forthPoint!.addGestureRecognizer(forthPan)
        
        self.rotatePoint = UIView(frame: CGRect(x: 0, y: 0, width: self.controlPointDiameter!, height: self.controlPointDiameter!))
        self.rotatePoint?.center = CGPoint(x: self.viewWidth / 2, y: -self.controlPointDiameter!)
        self.configPoint(point: self.rotatePoint!)
        let rotatePan = UIPanGestureRecognizer(target: self, action: #selector(rotatePanAction(_:)))
        self.rotatePoint!.addGestureRecognizer(rotatePan)
        
    }
    
    private func configPoint(point: UIView) {
        point.layer.cornerRadius = self.controlPointDiameter! / 2;
        point.layer.masksToBounds = true
        point.layer.borderColor = UIColor.black.cgColor
        point.layer.borderWidth = 1
        point.backgroundColor = self.pointColor
        self.addSubview(point)
    }
    
    //gesture method
    @objc func panAction(_ panGes:UIPanGestureRecognizer) {
        
        let translation = panGes.translation(in: self.superview)
        self.center = CGPoint(x: self.center.x + translation.x, y: self.center.y + translation.y)
        panGes.setTranslation(CGPoint.zero, in: self)
        
    }
    
    @objc func rotatePanAction(_ panGes:UIPanGestureRecognizer) {
        
        let pointLocation = panGes.location(in: self.superview)
        let xDistance = pointLocation.x - self.center.x
        let yDistance = pointLocation.y - self.center.y
        let distance = sqrt(xDistance * xDistance + yDistance * yDistance)
        self.rotationAngle = asin(xDistance / distance)
        
        if (yDistance > 0) {
            if (self.rotationAngle >= 0){
                self.rotationAngle = CGFloat.pi - self.rotationAngle;
            } else {
                self.rotationAngle = -CGFloat.pi - self.rotationAngle;
            }
        }
        self.changeViewFrame()
        
    }
    
    @objc func firstPanAction(_ panGes:UIPanGestureRecognizer) {
        
        let point = panGes.location(in: self)
        self.firstPoint?.center = point
        self.panFirstOrThirdGetHeightAndWidth()
        
    }
    
    @objc func thirdPanAction(_ panGes:UIPanGestureRecognizer) {
        
        let point = panGes.location(in: self)
        self.thirdPoint?.center = point
        self.panFirstOrThirdGetHeightAndWidth()
        
    }
    
    @objc func secondPanAction(_ panGes:UIPanGestureRecognizer) {
        
        let point = panGes.location(in: self)
        self.secondPoint?.center = point
        self.panSecondOrForthGetHeightAndWidth()
        
    }
    
    @objc func forthPanAction(_ panGes:UIPanGestureRecognizer) {
        
        let point = panGes.location(in: self)
        self.forthPoint?.center = point
        self.panSecondOrForthGetHeightAndWidth()
        
    }
    
    private func panFirstOrThirdGetHeightAndWidth() {
        
        let first:CGPoint! = self.firstPoint?.center
        let third:CGPoint! = self.thirdPoint?.center
        
        self.viewCenter = SWTool.center(between: first, and: third)
        self.viewCenter = self.convert(self.viewCenter, to: self.superview)
        self.viewWidth = third.x - first.x
        self.viewWidth = self.viewWidth > self.controlPointDiameter! ? self.viewWidth : self.controlPointDiameter!
        self.viewHeight = third.y - first.y
        self.viewHeight = self.viewHeight > self.controlPointDiameter! ? self.viewHeight : self.controlPointDiameter!
        self.changeViewFrame()
        
    }
    
    private func panSecondOrForthGetHeightAndWidth() {
        
        let second:CGPoint! = self.secondPoint?.center
        let forth:CGPoint! = self.forthPoint?.center
        
        self.viewCenter = SWTool.center(between: second, and: forth)
        self.viewCenter = self.convert(self.viewCenter, to: self.superview)
        self.viewWidth = second.x - forth.x
        self.viewWidth = self.viewWidth > self.controlPointDiameter! ? self.viewWidth : self.controlPointDiameter!
        self.viewHeight = forth.y - second.y
        self.viewHeight = self.viewHeight > self.controlPointDiameter! ? self.viewHeight : self.controlPointDiameter!
        self.changeViewFrame()
        
    }
    
    private func changeViewFrame() {
        
        self.transform = CGAffineTransform.identity
        self.frame = CGRect(x: 0, y: 0, width: self.viewWidth, height: self.viewHeight)
        self.center = self.viewCenter
        self.transform = CGAffineTransform.init(rotationAngle: self.rotationAngle)
        
        
        self.firstPoint?.center = CGPoint(x: 0, y: 0);
        self.secondPoint?.center = CGPoint(x: self.bounds.size.width, y: 0)
        self.thirdPoint?.center = CGPoint(x: self.bounds.size.width, y: self.bounds.size.height)
        self.forthPoint?.center = CGPoint(x: 0, y: self.bounds.size.height)
        self.rotatePoint?.center = CGPoint(x: self.bounds.width / 2, y: -self.controlPointDiameter!)
    }
    
    //remove control point
    public func removePoint() {
        self.firstPoint?.removeFromSuperview()
        self.secondPoint?.removeFromSuperview()
        self.thirdPoint?.removeFromSuperview()
        self.forthPoint?.removeFromSuperview()
        self.rotatePoint?.removeFromSuperview()
        self.isUserInteractionEnabled = false
    }
    
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

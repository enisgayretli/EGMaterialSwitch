//
//  EGMaterialSwitch.swift
//  EGMaterialSwitch
//
//  Created by Enis Gayretli on 11/8/15.
//
//

import Foundation
import UIKit
import QuartzCore


public enum EGMaterialSwitchStyle {
    case Default
    case Light
    case Dark
}

public enum EGMaterialSwitchState{
    case On
    case Off
}
public enum EGMaterialSwitchSize{
    case Small
    case Normal
    case Big
}

protocol EGMaterialSwitchDelegate {
    func switchStateChanged(currentState:EGMaterialSwitchState)
}


public class EGMaterialSwitch: UIControl {

    private var trackThickness: Float!
    private var thumbSize:Float!
    private var thumbOnPosition:Float!
    private var thumbOffPosition:Float!
    private var bounceOffset:Float!
    private var thumbStyle:EGMaterialSwitchStyle!
    private var rippleLayer:CAShapeLayer!
    var delegate:EGMaterialSwitchDelegate!
    var isOn:Bool!
    var isEnabled:Bool!
    var isBounceEnabled:Bool!
    var isRippleEnabled:Bool!
    var thumbOnTintColor:UIColor!
    var thumbOffTintColor:UIColor!
    var trackOnTintColor:UIColor!
    var trackOffTintColor:UIColor!
    var thumbDisabledTintColor:UIColor!
    var trackDisabledTintColor:UIColor!
    var rippleFillColor:UIColor!
    var switchThumb:UIButton!
    var track:UIView!
    
    
    
    override public var enabled:Bool{
        didSet{
            UIView.animateWithDuration(0.1) { () -> Void in
                if (self.enabled == true) {
                    if (self.isOn == true) {
                        self.switchThumb.backgroundColor = self.thumbOnTintColor
                        self.track.backgroundColor = self.trackOnTintColor
                    }
                    else {
                        self.switchThumb.backgroundColor = self.thumbOffTintColor
                        self.track.backgroundColor = self.trackOffTintColor
                    }
                    self.isEnabled = true
                }
                    
                else {
                    self.switchThumb.backgroundColor = self.thumbDisabledTintColor
                    self.track.backgroundColor = self.trackDisabledTintColor
                    self.isEnabled = false
                }
            }
            
        }
    }
    
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    public convenience init(size:EGMaterialSwitchSize, state:EGMaterialSwitchState){
        self.init()
        
        thumbOnTintColor = UIColor(red: 52/255, green: 109/255, blue: 241/255, alpha: 1.0)
        thumbOffTintColor = UIColor (red: 249/255, green: 249/255, blue: 249/255, alpha: 1.0)
        trackOnTintColor = UIColor(red: 143/255, green: 179/255, blue: 247/255, alpha: 1.0)
        trackOffTintColor = UIColor(red: 193/255, green: 193/255, blue: 193/255, alpha: 1.0)
        thumbDisabledTintColor = UIColor(red: 174/255, green: 174/255, blue: 174/255, alpha: 1.0)
        trackDisabledTintColor = UIColor(red: 203/255, green: 203/255, blue: 203/255, alpha: 1.0)
        isEnabled = true
        isRippleEnabled = true
        isBounceEnabled=true
        rippleFillColor = UIColor.blueColor()
        bounceOffset = 3.0
        var frame  = CGRectZero
        var trackFrame = CGRectZero
        var thumbFrame = CGRectZero
        
        if(size == .Small){
            frame = CGRectMake(0, 0, 30, 25)
            trackThickness = 23.0
            thumbSize = 18.0
        }else if(size == .Normal){
            frame = CGRectMake(0, 0, 40, 30)
            trackThickness = 23.0
            thumbSize = 24.0
        }else if(size == .Big){
            frame = CGRectMake(0, 0, 50, 40)
            trackThickness = 23.0
            thumbSize = 31.0
        }
        
        trackFrame.size.height = CGFloat(trackThickness)
        trackFrame.size.width = frame.size.width
        trackFrame.origin.x = 0.0
        trackFrame.origin.y = (frame.size.height-trackFrame.size.height)/2
        thumbFrame.size.height = CGFloat(thumbSize)
        thumbFrame.size.width = thumbFrame.size.height
        thumbFrame.origin.x = 0.0
        thumbFrame.origin.y = (frame.size.height-thumbFrame.size.height)/2
        
        self.frame = frame
        
        self.track = UIView.init(frame: trackFrame)
        self.track.backgroundColor = UIColor.grayColor()
        self.track.layer.cornerRadius = min(self.track.frame.size.height, self.track.frame.size.width)/2
        self.addSubview(self.track)
        
        self.switchThumb = UIButton.init(frame: thumbFrame)
        self.switchThumb.backgroundColor = UIColor.whiteColor()
        self.switchThumb.layer.cornerRadius = self.switchThumb.frame.size.height/2
        self.switchThumb.layer.shadowOpacity = 0.5
        self.switchThumb.layer.shadowOffset = CGSizeMake(0.0, 1.0)
        self.switchThumb.layer.shadowColor = UIColor.blackColor().CGColor
        self.switchThumb.layer.shadowRadius = 2.0
        
        self.switchThumb.addTarget(self, action: Selector("onTouchDown:withEvent:"), forControlEvents: .TouchDown)
        self.switchThumb.addTarget(self, action: Selector("onTouchUpOutsideOrCanceled:withEvent:"), forControlEvents: .TouchUpOutside)
        self.switchThumb.addTarget(self, action: Selector("switchThumbTapped:"), forControlEvents: .TouchUpInside)
        self.switchThumb.addTarget(self, action: Selector("onTouchDragInside:withEvent:"), forControlEvents: .TouchDragInside)
        self.switchThumb.addTarget(self, action: Selector("onTouchUpOutsideOrCanceled:withEvent:"), forControlEvents: .TouchCancel)
        self.addSubview(self.switchThumb)
        
        
        thumbOnPosition = Float(self.frame.size.width - self.switchThumb.frame.size.width)
        thumbOffPosition = Float(self.switchThumb.frame.origin.x)
        
        
        if(state == .On){
            self.isOn = true
            self.switchThumb.backgroundColor = self.thumbOnTintColor
            var thumbFrame = self.switchThumb.frame
            thumbFrame.origin.x = CGFloat(thumbOnPosition)
            self.switchThumb.frame = thumbFrame
        }else if(state == .Off){
            self.isOn = false
            self.switchThumb.backgroundColor = self.thumbOffTintColor
        }else{
            self.isOn = false
            self.switchThumb.backgroundColor = self.thumbOffTintColor
        }
        
        let singleTap = UITapGestureRecognizer(target: self, action: Selector("switchAreaTapped:"))
        self .addGestureRecognizer(singleTap)
    }
    public convenience init(size:EGMaterialSwitchSize,state:EGMaterialSwitchState,style:EGMaterialSwitchStyle){
        self.init(size: size,state: state)
        
        thumbStyle = style;
        
        if (style == .Light) {
            self.thumbOnTintColor  = UIColor(red: 0/255, green: 134/255, blue: 117/255, alpha: 1.0)
            self.thumbOffTintColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0)
            self.trackOnTintColor = UIColor(red: 90/255, green: 178/255, blue: 169.255, alpha: 1.0)
            self.trackOffTintColor = UIColor(red: 129/255, green: 129/255, blue: 129/255, alpha: 1.0)
            self.thumbDisabledTintColor = UIColor(red: 175/255, green: 175/255, blue: 175/255, alpha: 1.0)
            self.trackDisabledTintColor = UIColor(red: 203/255, green: 203/255, blue: 203/255, alpha: 1.0)
            self.rippleFillColor = UIColor.grayColor()
            
        }else if (style == .Dark) {
            self.thumbOnTintColor  = UIColor(red: 109/255, green: 194/255, blue: 184/255, alpha: 1.0)
            self.thumbOffTintColor = UIColor(red: 175/255, green: 175/255, blue: 175/255, alpha: 1.0)
            self.trackOnTintColor = UIColor(red: 72/255, green: 109/255, blue: 105/255, alpha: 1.0)
            self.trackOffTintColor = UIColor(red: 94/255, green: 94/255, blue: 94/255, alpha: 1.0)
            self.thumbDisabledTintColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0)
            self.trackDisabledTintColor = UIColor(red: 56/255, green: 56/255, blue: 56/255, alpha: 1.0)
            self.rippleFillColor = UIColor.grayColor()
            
        }else{
            self.thumbOnTintColor  = UIColor(red: 52/255, green: 109/255, blue: 241/255, alpha: 1.0)
            self.thumbOffTintColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1.0)
            self.trackOnTintColor = UIColor(red: 143/255, green: 179/255, blue: 247/255, alpha: 1.0)
            self.trackOffTintColor = UIColor(red: 193/255, green: 193/255, blue: 193/255, alpha: 1.0)
            self.thumbDisabledTintColor = UIColor(red: 174/255, green: 174/255, blue: 174/255, alpha: 1.0)
            self.trackDisabledTintColor = UIColor(red:203/255, green: 203/255, blue: 203/255, alpha: 1.0)
            self.rippleFillColor = UIColor.grayColor()
        }
    }
    
    
    
    
 
    
    
    
    func setOnAnimated(on:Bool,animated:Bool){
        if (on == true) {
            if (animated == true) {
                 self.changeThumbStateONwithAnimation()
            }
            else {
                 self.changeThumbStateONwithoutAnimation()
            }
        }
        else {
            if (animated == true) {
                 self.changeThumbStateOFFwithAnimation()
            }
            else {
                 self.changeThumbStateOFFwithoutAnimation()
            }
        }
    }
    
    
    func switchAreaTapped(recognizer:UITapGestureRecognizer){
        
        if let del = self.delegate {
            
            if (self.isOn == true) {
                del.switchStateChanged(.Off)
            }
            else{
                del.switchStateChanged(.On)
            }
        }
        
        self.changeThumbState()
    }
    
  
    public override func willMoveToSuperview(newSuperview: UIView?) {
        
        super.willMoveToSuperview(newSuperview)
        
         if(self.isOn == true) {
            self.switchThumb.backgroundColor = self.thumbOnTintColor
            self.track.backgroundColor = self.trackOnTintColor
        }
        else {
            self.switchThumb.backgroundColor = self.thumbOffTintColor
            self.track.backgroundColor = self.trackOffTintColor
        }
        
        if (self.isEnabled == false) {
            self.switchThumb.backgroundColor = self.thumbDisabledTintColor
            self.track.backgroundColor = self.trackDisabledTintColor
        }
        
        if (self.isBounceEnabled == true) {
            bounceOffset = 3.0
        }
        else {
            bounceOffset = 0.0
        }
    }
}



extension EGMaterialSwitch {
    
    func changeThumbState(){
        if (self.isOn == true) {
            self.changeThumbStateOFFwithAnimation()
        }
        else {
            self.changeThumbStateONwithAnimation()
        }
        
        if (self.isRippleEnabled == true) {
            self.animateRippleEffect()
        }
    }
    func changeThumbStateONwithAnimation(){
       
        UIView .animateWithDuration(
            0.15, delay: 0.05, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                
                var thumbFrame = self.switchThumb.frame
                thumbFrame.origin.x = CGFloat(self.thumbOnPosition + self.bounceOffset)
                self.switchThumb.frame = thumbFrame
                if (self.isEnabled == true) {
                    self.switchThumb.backgroundColor = self.thumbOnTintColor
                    self.track.backgroundColor = self.trackOnTintColor
                }
                else {
                    self.switchThumb.backgroundColor = self.thumbDisabledTintColor
                    self.track.backgroundColor = self.trackDisabledTintColor
                }
                self.userInteractionEnabled = false;
                
            }) { (Bool finished) -> Void in
                 if (self.isOn == false) {
                    self.isOn = true;
                     self.sendActionsForControlEvents(.ValueChanged)
                }
                self.isOn = true;
                
                UIView.animateWithDuration(0.15, animations: { () -> Void in
                    var thumbFrame = self.switchThumb.frame
                    thumbFrame.origin.x = CGFloat(self.thumbOnPosition)
                    self.switchThumb.frame = thumbFrame
                    
                    }, completion: { (Bool fi) -> Void in
                        self.userInteractionEnabled = true

                })

        }
    }
    
    func changeThumbStateOFFwithAnimation(){
        UIView .animateWithDuration(
            0.15, delay: 0.05, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                
                var thumbFrame = self.switchThumb.frame
                thumbFrame.origin.x = CGFloat(self.thumbOffPosition-self.bounceOffset)
                self.switchThumb.frame = thumbFrame
                if (self.isEnabled == true) {
                    self.switchThumb.backgroundColor = self.thumbOffTintColor
                    self.track.backgroundColor = self.trackOffTintColor
                }
                else {
                    self.switchThumb.backgroundColor = self.thumbDisabledTintColor
                    self.track.backgroundColor = self.trackDisabledTintColor
                }
                self.userInteractionEnabled = false
                
                
            }) { (Bool finished) -> Void in
                 if (self.isOn == true) {
                    self.isOn = false
                     self.sendActionsForControlEvents(.ValueChanged)
                }
                self.isOn = false;
                
                UIView.animateWithDuration(0.15, animations: { () -> Void in
                     var thumbFrame = self.switchThumb.frame
                    thumbFrame.origin.x = CGFloat(self.thumbOffPosition)
                    self.switchThumb.frame = thumbFrame
                    }, completion: { (Bool fi) -> Void in
                        self.userInteractionEnabled = true;
                })
                
        }
    }
    
    func changeThumbStateONwithoutAnimation(){
        var thumbFrame = self.switchThumb.frame
        thumbFrame.origin.x = CGFloat(self.thumbOnPosition)
        self.switchThumb.frame = thumbFrame
        if (self.isEnabled == true) {
            self.switchThumb.backgroundColor = self.thumbOnTintColor
            self.track.backgroundColor = self.trackOnTintColor
        }
        else {
            self.switchThumb.backgroundColor = self.thumbDisabledTintColor
            self.track.backgroundColor = self.trackDisabledTintColor
        }
        
        if (self.isOn == false) {
            self.isOn = true;
             self.sendActionsForControlEvents(.ValueChanged)
        }
        self.isOn = true
    }
    
    func changeThumbStateOFFwithoutAnimation(){
        var thumbFrame = self.switchThumb.frame
        thumbFrame.origin.x = CGFloat(self.thumbOffPosition)
        self.switchThumb.frame = thumbFrame
        if (self.isEnabled == true) {
            self.switchThumb.backgroundColor = self.thumbOffTintColor
            self.track.backgroundColor = self.trackOffTintColor
        }
        else {
            self.switchThumb.backgroundColor = self.thumbDisabledTintColor
            self.track.backgroundColor = self.trackDisabledTintColor
        }
        
        if (self.isOn == true) {
            self.isOn = false;
            self.sendActionsForControlEvents(.ValueChanged)
         }
        self.isOn = false
    }
    
    func initializeRipple(){
        
        let rippleScale = 2
        var rippleFrame = CGRectZero
        rippleFrame.origin.x = -self.switchThumb.frame.size.width/CGFloat(rippleScale * 2)
        rippleFrame.origin.y = -self.switchThumb.frame.size.height/CGFloat(rippleScale * 2)
        rippleFrame.size.height = self.switchThumb.frame.size.height * CGFloat(rippleScale)
        rippleFrame.size.width = rippleFrame.size.height
        
        
        let path = UIBezierPath(roundedRect: rippleFrame, cornerRadius: self.switchThumb.layer.cornerRadius*2)
        
        rippleLayer = CAShapeLayer()
        rippleLayer.path = path.CGPath
        rippleLayer.frame = rippleFrame
        rippleLayer.opacity = 0.2
        rippleLayer.strokeColor = UIColor.clearColor().CGColor
        rippleLayer.fillColor = self.rippleFillColor.CGColor
        rippleLayer.lineWidth = 0
        self.switchThumb.layer .insertSublayer(rippleLayer, above: self.switchThumb.layer)
    }
    
    func animateRippleEffect(){
        
        if (self.rippleLayer == nil) {
            self.initializeRipple()
        }
        
        rippleLayer.opacity = 0.0
        CATransaction.begin()
        
        
        CATransaction.setCompletionBlock { () -> Void in
            self.rippleLayer.removeFromSuperlayer()
            self.rippleLayer = nil
        }
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0.5
        scaleAnimation.toValue = 1.25
        
        let alphaAnimation = CABasicAnimation(keyPath: "opacity")
        alphaAnimation.fromValue = 0.4
        alphaAnimation.toValue = 0
        
        let animation = CAAnimationGroup()
        animation.animations = [scaleAnimation, alphaAnimation]
        animation.duration = 0.4;
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        rippleLayer.addAnimation(animation, forKey: nil)
        
        CATransaction.commit()
    }
    func onTouchDown(btn:UIButton, withEvent:UIEvent){
       
        if (self.isRippleEnabled == true) {
            self.initializeRipple()
        }
        
        CATransaction.begin()
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0.0
        scaleAnimation.toValue = 1.0
        
        let alphaAnimation = CABasicAnimation(keyPath: "opacity")
        alphaAnimation.fromValue = 0
        alphaAnimation.toValue = 0.2
        
        let animation = CAAnimationGroup()
        animation.animations = [scaleAnimation, alphaAnimation]
        animation.duration = 0.4
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        rippleLayer.addAnimation(animation, forKey: nil)
        
        CATransaction.commit()
    }
    func switchThumbTapped(sender:AnyObject){
        
        if  let del = self.delegate {
            if(self.isOn == true){
                
                del.switchStateChanged(.Off)
            }else{
                del.switchStateChanged(.On)
            }
        }
        self.changeThumbState()
    }
    func onTouchUpOutsideOrCanceled(btn:UIButton,withEvent event:UIEvent){
        
        
        let touch = event.touchesForView(btn)?.first
        let prevPos = touch?.previousLocationInView(btn)
        let pos = touch?.locationInView(btn)
        
        let dX = (pos?.x)! - (prevPos?.x)!
        let newXOrigin = btn.frame.origin.x + dX
        
        if newXOrigin > (self.frame.size.width - self.switchThumb.frame.size.width)/2 {
            self.changeThumbStateONwithAnimation()
        }else {
            self.changeThumbStateOFFwithAnimation()
        }
        
        if self.isRippleEnabled == true {
            self.animateRippleEffect()
        }
    }
    func onTouchDragInside(btn: UIButton, withEvent event: UIEvent){
        
        let touch = event.touchesForView(btn)?.first
        let prevPos = touch?.previousLocationInView(btn)
        let pos = touch?.locationInView(btn)
        let dX = (pos?.x)! - (prevPos?.x)!
        
        var thumbFrame = btn.frame
        
        thumbFrame.origin.x += dX
        thumbFrame.origin.x = min(thumbFrame.origin.x, CGFloat(thumbOnPosition))
        thumbFrame.origin.x = max(thumbFrame.origin.x, CGFloat(thumbOffPosition))
    
        if thumbFrame.origin.x != btn.frame.origin.x {
            btn.frame = thumbFrame
        }
    }
}
    
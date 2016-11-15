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
    case `default`
    case light
    case dark
}

public enum EGMaterialSwitchState{
    case on
    case off
}
public enum EGMaterialSwitchSize{
    case small
    case normal
    case big
}

protocol EGMaterialSwitchDelegate {
    func switchStateChanged(_ currentState:EGMaterialSwitchState)
}


open class EGMaterialSwitch: UIControl {
    
    fileprivate var trackThickness: Float!
    fileprivate var thumbSize:Float!
    fileprivate var thumbOnPosition:Float!
    fileprivate var thumbOffPosition:Float!
    fileprivate var bounceOffset:Float!
    fileprivate var thumbStyle:EGMaterialSwitchStyle!
    fileprivate var rippleLayer:CAShapeLayer!
    var delegate:EGMaterialSwitchDelegate!
    var isOn:Bool = false
    //    open var isEnabled:Bool!
    var isBounceEnabled:Bool = true
    var isRippleEnabled:Bool = true
    var thumbOnTintColor:UIColor? = nil
    var thumbOffTintColor:UIColor? = nil
    var trackOnTintColor:UIColor? = nil
    var trackOffTintColor:UIColor? = nil
    var thumbDisabledTintColor:UIColor? = nil
    var trackDisabledTintColor:UIColor? = nil
    var rippleFillColor:UIColor? = nil
    var switchThumb:UIButton? = nil
    var track:UIView? = nil
    
    
    
    
    
    override open var isEnabled:Bool{
        didSet{
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                if (self.isEnabled == true) {
                    if (self.isOn == true) {
                        self.switchThumb?.backgroundColor = self.thumbOnTintColor
                        self.track?.backgroundColor = self.trackOnTintColor
                    }
                    else {
                        self.switchThumb?.backgroundColor = self.thumbOffTintColor
                        self.track?.backgroundColor = self.trackOffTintColor
                    }
                    super.isEnabled = true
                }
                    
                else {
                    self.switchThumb?.backgroundColor = self.thumbDisabledTintColor
                    self.track?.backgroundColor = self.trackDisabledTintColor
                    super.isEnabled = false
                }
            })
            
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
        rippleFillColor = UIColor.blue
        bounceOffset = 3.0
        var frame  = CGRect.zero
        var trackFrame = CGRect.zero
        var thumbFrame = CGRect.zero
        
        if(size == .small){
            frame = CGRect(x: 0, y: 0, width: 30, height: 25)
            trackThickness = 23.0
            thumbSize = 18.0
        }else if(size == .normal){
            frame = CGRect(x: 0, y: 0, width: 40, height: 30)
            trackThickness = 23.0
            thumbSize = 24.0
        }else if(size == .big){
            frame = CGRect(x: 0, y: 0, width: 50, height: 40)
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
        self.track?.backgroundColor = UIColor.gray
        self.track?.layer.cornerRadius = min((self.track?.frame.size.height)!, (self.track?.frame.size.width)!)/2
        self.addSubview(self.track!)
        
        self.switchThumb = UIButton.init(frame: thumbFrame)
        self.switchThumb!.backgroundColor = UIColor.white
        self.switchThumb!.layer.cornerRadius = (self.switchThumb?.frame.size.height)!/2
        self.switchThumb!.layer.shadowOpacity = 0.5
        self.switchThumb!.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.switchThumb!.layer.shadowColor = UIColor.black.cgColor
        self.switchThumb!.layer.shadowRadius = 2.0
        
        self.switchThumb!.addTarget(self, action: #selector(EGMaterialSwitch.onTouchDown(_:withEvent:)), for: .touchDown)
        self.switchThumb!.addTarget(self, action: #selector(EGMaterialSwitch.onTouchUpOutsideOrCanceled(_:withEvent:)), for: .touchUpOutside)
        self.switchThumb!.addTarget(self, action: #selector(EGMaterialSwitch.switchThumbTapped(_:)), for: .touchUpInside)
        self.switchThumb!.addTarget(self, action: #selector(EGMaterialSwitch.onTouchDragInside(_:withEvent:)), for: .touchDragInside)
        self.switchThumb!.addTarget(self, action: #selector(EGMaterialSwitch.onTouchUpOutsideOrCanceled(_:withEvent:)), for: .touchCancel)
        self.addSubview(self.switchThumb!)
        
        
        thumbOnPosition = Float(self.frame.size.width - (self.switchThumb?.frame.size.width)!)
        thumbOffPosition = Float((self.switchThumb?.frame.origin.x)!)
        
        
        if(state == .on){
            self.isOn = true
            self.switchThumb?.backgroundColor = self.thumbOnTintColor
            var thumbFrame = self.switchThumb?.frame
            thumbFrame?.origin.x = CGFloat(thumbOnPosition)
            self.switchThumb?.frame = thumbFrame!
        }else if(state == .off){
            self.isOn = false
            self.switchThumb?.backgroundColor = self.thumbOffTintColor
        }else{
            self.isOn = false
            self.switchThumb?.backgroundColor = self.thumbOffTintColor
        }
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(EGMaterialSwitch.switchAreaTapped(_:)))
        self .addGestureRecognizer(singleTap)
    }
    public convenience init(size:EGMaterialSwitchSize,state:EGMaterialSwitchState,style:EGMaterialSwitchStyle){
        self.init(size: size,state: state)
        
        thumbStyle = style;
        
        if (style == .light) {
            self.thumbOnTintColor  = UIColor(red: 0/255, green: 134/255, blue: 117/255, alpha: 1.0)
            self.thumbOffTintColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0)
            self.trackOnTintColor = UIColor(red: 90/255, green: 178/255, blue: 169.255, alpha: 1.0)
            self.trackOffTintColor = UIColor(red: 129/255, green: 129/255, blue: 129/255, alpha: 1.0)
            self.thumbDisabledTintColor = UIColor(red: 175/255, green: 175/255, blue: 175/255, alpha: 1.0)
            self.trackDisabledTintColor = UIColor(red: 203/255, green: 203/255, blue: 203/255, alpha: 1.0)
            self.rippleFillColor = UIColor.gray
            
        }else if (style == .dark) {
            self.thumbOnTintColor  = UIColor(red: 109/255, green: 194/255, blue: 184/255, alpha: 1.0)
            self.thumbOffTintColor = UIColor(red: 175/255, green: 175/255, blue: 175/255, alpha: 1.0)
            self.trackOnTintColor = UIColor(red: 72/255, green: 109/255, blue: 105/255, alpha: 1.0)
            self.trackOffTintColor = UIColor(red: 94/255, green: 94/255, blue: 94/255, alpha: 1.0)
            self.thumbDisabledTintColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0)
            self.trackDisabledTintColor = UIColor(red: 56/255, green: 56/255, blue: 56/255, alpha: 1.0)
            self.rippleFillColor = UIColor.gray
            
        }else{
            self.thumbOnTintColor  = UIColor(red: 52/255, green: 109/255, blue: 241/255, alpha: 1.0)
            self.thumbOffTintColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1.0)
            self.trackOnTintColor = UIColor(red: 143/255, green: 179/255, blue: 247/255, alpha: 1.0)
            self.trackOffTintColor = UIColor(red: 193/255, green: 193/255, blue: 193/255, alpha: 1.0)
            self.thumbDisabledTintColor = UIColor(red: 174/255, green: 174/255, blue: 174/255, alpha: 1.0)
            self.trackDisabledTintColor = UIColor(red:203/255, green: 203/255, blue: 203/255, alpha: 1.0)
            self.rippleFillColor = UIColor.gray
        }
    }
    
    
    
    
    
    
    
    
    func setOnAnimated(_ on:Bool,animated:Bool){
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
    
    
    func switchAreaTapped(_ recognizer:UITapGestureRecognizer){
        
        if let del = self.delegate {
            
            if (self.isOn == true) {
                del.switchStateChanged(.off)
            }
            else{
                del.switchStateChanged(.on)
            }
        }
        
        self.changeThumbState()
    }
    
    
    open override func willMove(toSuperview newSuperview: UIView?) {
        
        super.willMove(toSuperview: newSuperview)
        
        if(self.isOn == true) {
            self.switchThumb?.backgroundColor = self.thumbOnTintColor
            self.track?.backgroundColor = self.trackOnTintColor
        }
        else {
            self.switchThumb?.backgroundColor = self.thumbOffTintColor
            self.track?.backgroundColor = self.trackOffTintColor
        }
        
        if (self.isEnabled == false) {
            self.switchThumb?.backgroundColor = self.thumbDisabledTintColor
            self.track?.backgroundColor = self.trackDisabledTintColor
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
        
        UIView .animate(
            withDuration: 0.15, delay: 0.05, options: UIViewAnimationOptions(), animations: { () -> Void in
                
                var thumbFrame = self.switchThumb?.frame
                thumbFrame?.origin.x = CGFloat(self.thumbOnPosition + self.bounceOffset)
                self.switchThumb?.frame = thumbFrame!
                if (self.isEnabled == true) {
                    self.switchThumb?.backgroundColor = self.thumbOnTintColor
                    self.track?.backgroundColor = self.trackOnTintColor
                }
                else {
                    self.switchThumb?.backgroundColor = self.thumbDisabledTintColor
                    self.track?.backgroundColor = self.trackDisabledTintColor
                }
                self.isUserInteractionEnabled = false;
                
        }) { (finished) -> Void in
            if (self.isOn == false) {
                self.isOn = true;
                self.sendActions(for: .valueChanged)
            }
            self.isOn = true;
            
            UIView.animate(withDuration: 0.15, animations: { () -> Void in
                var thumbFrame = self.switchThumb?.frame
                thumbFrame?.origin.x = CGFloat(self.thumbOnPosition)
                self.switchThumb?.frame = thumbFrame!
                
            }, completion: { (fi) -> Void in
                self.isUserInteractionEnabled = true
                
            })
            
        }
    }
    
    func changeThumbStateOFFwithAnimation(){
        UIView .animate(
            withDuration: 0.15, delay: 0.05, options: UIViewAnimationOptions(), animations: { () -> Void in
                
                var thumbFrame = self.switchThumb?.frame
                thumbFrame?.origin.x = CGFloat(self.thumbOffPosition-self.bounceOffset)
                self.switchThumb?.frame = thumbFrame!
                if (self.isEnabled == true) {
                    self.switchThumb?.backgroundColor = self.thumbOffTintColor
                    self.track?.backgroundColor = self.trackOffTintColor
                }
                else {
                    self.switchThumb?.backgroundColor = self.thumbDisabledTintColor
                    self.track?.backgroundColor = self.trackDisabledTintColor
                }
                self.isUserInteractionEnabled = false
                
                
        }) { (finished) -> Void in
            if (self.isOn == true) {
                self.isOn = false
                self.sendActions(for: .valueChanged)
            }
            self.isOn = false;
            
            UIView.animate(withDuration: 0.15, animations: { () -> Void in
                var thumbFrame = self.switchThumb?.frame
                thumbFrame?.origin.x = CGFloat(self.thumbOffPosition)
                self.switchThumb?.frame = thumbFrame!
            }, completion: { (fi) -> Void in
                self.isUserInteractionEnabled = true;
            })
            
        }
    }
    
    func changeThumbStateONwithoutAnimation(){
        var thumbFrame = self.switchThumb?.frame
        thumbFrame?.origin.x = CGFloat(self.thumbOnPosition)
        self.switchThumb?.frame = thumbFrame!
        if (self.isEnabled == true) {
            self.switchThumb?.backgroundColor = self.thumbOnTintColor
            self.track?.backgroundColor = self.trackOnTintColor
        }
        else {
            self.switchThumb?.backgroundColor = self.thumbDisabledTintColor
            self.track?.backgroundColor = self.trackDisabledTintColor
        }
        
        if (self.isOn == false) {
            self.isOn = true;
            self.sendActions(for: .valueChanged)
        }
        self.isOn = true
    }
    
    func changeThumbStateOFFwithoutAnimation(){
        var thumbFrame = self.switchThumb?.frame
        thumbFrame?.origin.x = CGFloat(self.thumbOffPosition)
        self.switchThumb?.frame = thumbFrame!
        if (self.isEnabled == true) {
            self.switchThumb?.backgroundColor = self.thumbOffTintColor
            self.track?.backgroundColor = self.trackOffTintColor
        }
        else {
            self.switchThumb?.backgroundColor = self.thumbDisabledTintColor
            self.track?.backgroundColor = self.trackDisabledTintColor
        }
        
        if (self.isOn == true) {
            self.isOn = false;
            self.sendActions(for: .valueChanged)
        }
        self.isOn = false
    }
    
    func initializeRipple(){
        
        let rippleScale = 2
        var rippleFrame = CGRect.zero
        rippleFrame.origin.x = -(self.switchThumb!.frame.size.width) / CGFloat(rippleScale * 2)
        rippleFrame.origin.y = -(self.switchThumb!.frame.size.height) / CGFloat(rippleScale * 2)
        rippleFrame.size.height = (self.switchThumb!.frame.size.height) * CGFloat(rippleScale)
        
        rippleFrame.size.width = rippleFrame.size.height
        
        
        let path = UIBezierPath(roundedRect: rippleFrame, cornerRadius: (self.switchThumb?.layer.cornerRadius)!*2)
        
        rippleLayer = CAShapeLayer()
        rippleLayer.path = path.cgPath
        rippleLayer.frame = rippleFrame
        rippleLayer.opacity = 0.2
        rippleLayer.strokeColor = UIColor.clear.cgColor
        rippleLayer.fillColor = self.rippleFillColor?.cgColor
        rippleLayer.lineWidth = 0
        self.switchThumb?.layer .insertSublayer(rippleLayer, above: self.switchThumb?.layer)
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
        rippleLayer.add(animation, forKey: nil)
        
        CATransaction.commit()
    }
    
    func onTouchDown(_ btn:UIButton, withEvent:UIEvent){
        
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
        rippleLayer.add(animation, forKey: nil)
        
        CATransaction.commit()
    }
    
    func switchThumbTapped(_ sender:AnyObject){
        
        if  let del = self.delegate {
            if(self.isOn == true){
                
                del.switchStateChanged(.off)
            }else{
                del.switchStateChanged(.on)
            }
        }
        self.changeThumbState()
    }
    
    func onTouchUpOutsideOrCanceled(_ btn:UIButton,withEvent event:UIEvent){
        
        
        let touch = event.touches(for: btn)?.first
        let prevPos = touch?.previousLocation(in: btn)
        let pos = touch?.location(in: btn)
        
        let dX = (pos?.x)! - (prevPos?.x)!
        let newXOrigin = btn.frame.origin.x + dX
        
        if newXOrigin > (self.frame.size.width - (self.switchThumb?.frame.size.width)!)/2 {
            self.changeThumbStateONwithAnimation()
        }else {
            self.changeThumbStateOFFwithAnimation()
        }
        
        if self.isRippleEnabled == true {
            self.animateRippleEffect()
        }
    }
    
    func onTouchDragInside(_ btn: UIButton, withEvent event: UIEvent){
        
        let touch = event.touches(for: btn)?.first
        let prevPos = touch?.previousLocation(in: btn)
        let pos = touch?.location(in: btn)
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


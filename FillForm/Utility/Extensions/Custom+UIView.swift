//
//  Custom+UIView.swift
//  MARKETS
//
//  Created by CognizantMcBook on 11/28/18.
//

import Foundation
import QuartzCore
import UIKit

extension UIView {
    
    enum ViewSide {
        case Left, Right, Top, Bottom
    }

    @IBInspectable var layerOppacity: Float {
        get {
            return layer.opacity
        }
        set {
            
            layer.opacity = newValue
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue!.cgColor
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        set {
            layer.shadowColor = newValue!.cgColor
        }
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor:color)
            }
            else {
                return nil
            }
        }
    }
    
    /* The opacity of the shadow. Defaults to 0. Specifying a value outside the
     * [0,1] range will give undefined results. Animatable. */
    @IBInspectable var shadowOpacity: Float {
        set {
            layer.shadowOpacity = newValue
        }
        get {
            return layer.shadowOpacity
        }
    }
    
    /* The shadow offset. Defaults to (0, -3). Animatable. */
    @IBInspectable var shadowOffset: CGPoint {
        set {
            layer.shadowOffset = CGSize(width: newValue.x, height: newValue.y)
        }
        get {
            return CGPoint(x: layer.shadowOffset.width, y:layer.shadowOffset.height)
        }
    }
    
    /* The blur radius used to create the shadow. Defaults to 3. Animatable. */
    @IBInspectable var shadowRadius: CGFloat {
        set {
            layer.shadowRadius = newValue
        }
        get {
            return layer.shadowRadius
        }
    }
    
    @IBInspectable open var shadowOffsetY: CGFloat {
        set {
            layer.shadowOffset.height = newValue
        }
        get {
            return layer.shadowOffset.height
        }
    }
    
    func addBottomShadow(view:UIView?)  {
        
        let shadowPath = UIBezierPath()
        shadowPath.move(to: CGPoint(x: self.bounds.origin.x, y: self.frame.size.height))
        shadowPath.addLine(to: CGPoint(x: self.bounds.width / 2, y: self.bounds.height + 7.0))
        shadowPath.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height))
        shadowPath.close()
        
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 1
        self.layer.masksToBounds = false
        self.layer.shadowPath = shadowPath.cgPath
        self.layer.shadowRadius = 5
    }
    
    //MARK:- Helper Methods
    
    func addTopShadow(_ width : CGFloat = UIScreen.main.bounds.width , shadowColor: UIColor = UIColor.lightGray) {
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 10
        layer.shadowPath = UIBezierPath(rect: CGRect(x: self.bounds.origin.x, y: self.bounds.minY - 5 , width: width, height: 10)).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = true ? UIScreen.main.scale : 1
        superview?.bringSubviewToFront(self)
    }
    
    //MARK:- Animation Methods

    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.5
        pulse.fromValue = 0.8
        pulse.toValue = 1.0
        pulse.autoreverses = false
        pulse.repeatCount = 1
        pulse.initialVelocity = 0.6
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: "pulse")
    }

    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.5
        animation.values = [-15.0, 15.0, -15.0, 15.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    
    func startProgressAnimation(_ color: UIColor)
    {
        let layer = CALayer()
        layer.backgroundColor = color.cgColor
        layer.masksToBounds = true
        layer.anchorPoint = .zero
        

        layer.frame = CGRect.init(x: 0,
                                  y: 0,
                                  width: self.frame.width,
                                  height: self.frame.height)
        self.layer.addSublayer(layer)

        
        let boundsAnim:CABasicAnimation = CABasicAnimation(keyPath: "bounds.size.width")
        boundsAnim.fromValue = 0
        boundsAnim.toValue = self.frame.size.width
        let anim = CAAnimationGroup()
        anim.animations = [boundsAnim]
        anim.isRemovedOnCompletion = false
        anim.duration = 0.8
        
        layer.add(anim, forKey: "bounds.size.width")
    }
    
    func setNewLayer() {
        let layer = CALayer()
        layer.backgroundColor = UIColor.lightGray.cgColor
        layer.masksToBounds = true
        layer.anchorPoint = .zero
        

        layer.frame = CGRect.init(x: 0,
                                  y: 0,
                                  width: self.frame.width,
                                  height: self.frame.height)
        self.layer.addSublayer(layer)
    }
}




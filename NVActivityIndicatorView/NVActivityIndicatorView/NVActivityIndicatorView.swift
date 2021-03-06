//
//  NVActivityIndicatorView.swift
//  NVActivityIndicatorView
//
// The MIT License (MIT)

// Copyright (c) 2016 Vinh Nguyen

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import UIKit
import Lottie

/// Activity indicator view with nice animations
public final class NVActivityIndicatorView: UIView {
    public static var DEFAULT_ANIMATION_NAME = ""
    
    /// Default color of activity indicator. Default value is UIColor.white.
    public static var DEFAULT_COLOR = UIColor.white
    
    /// Default color of text. Default value is UIColor.white.
    public static var DEFAULT_TEXT_COLOR = UIColor.white
    
    /// Default padding. Default value is 0.
    public static var DEFAULT_PADDING: CGFloat = 0
    
    /// Default size of activity indicator view in UI blocker. Default value is 60x60.
    public static var DEFAULT_BLOCKER_SIZE = CGSize(width: 60, height: 60)
    
    /// Default display time threshold to actually display UI blocker. Default value is 0 ms.
    public static var DEFAULT_BLOCKER_DISPLAY_TIME_THRESHOLD = 0
    
    /// Default minimum display time of UI blocker. Default value is 0 ms.
    public static var DEFAULT_BLOCKER_MINIMUM_DISPLAY_TIME = 0
    
    /// Default message displayed in UI blocker. Default value is nil.
    public static var DEFAULT_BLOCKER_MESSAGE: String?
    
    /// Default message spacing to activity indicator view in UI blocker. Default value is 8.
    public static var DEFAULT_BLOCKER_MESSAGE_SPACING = CGFloat(8.0)
    
    /// Default font of message displayed in UI blocker. Default value is bold system font, size 20.
    public static var DEFAULT_BLOCKER_MESSAGE_FONT = UIFont.boldSystemFont(ofSize: 20)
    
    /// Default background color of UI blocker. Default value is UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    public static var DEFAULT_BLOCKER_BACKGROUND_COLOR = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    
    /// Color of activity indicator view.
    @IBInspectable public var color: UIColor = NVActivityIndicatorView.DEFAULT_COLOR
    
    /// Padding of activity indicator view.
    @IBInspectable public var padding: CGFloat = NVActivityIndicatorView.DEFAULT_PADDING
    
    var lottieView:LOTAnimationView?
    
    /// Current status of animation, read-only.
    @available(*, deprecated: 3.1)
    public var animating: Bool { return isAnimating }
    
    /// Current status of animation, read-only.
    private(set) public var isAnimating: Bool = false
    
    /**
     Returns an object initialized from data in a given unarchiver.
     self, initialized using the data in decoder.
     
     - parameter decoder: an unarchiver object.
     
     - returns: self, initialized using the data in decoder.
     */
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
        isHidden = true
    }
    
    /**
     Create a activity indicator view.
     
     Appropriate NVActivityIndicatorView.DEFAULT_* values are used for omitted params.
     
     - parameter frame:   view's frame.
     - parameter type:    animation type.
     - parameter color:   color of activity indicator view.
     - parameter padding: padding of activity indicator view.
     
     - returns: The activity indicator view.
     */
    public init(frame: CGRect, color: UIColor? = nil, padding: CGFloat? = nil) {
        super.init(frame: frame)
        lottieView = LOTAnimationView(name: NVActivityIndicatorView.DEFAULT_ANIMATION_NAME)
        if let l = lottieView {
            self.addSubview(l)
        }
        isHidden = true
    }
    
    // Fix issue #62
    // Intrinsic content size is used in autolayout
    // that causes mislayout when using with MBProgressHUD.
    /**
     Returns the natural size for the receiving view, considering only properties of the view itself.
     
     A size indicating the natural size for the receiving view based on its intrinsic properties.
     
     - returns: A size indicating the natural size for the receiving view based on its intrinsic properties.
     */
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.width, height: bounds.height)
    }
    
    public override var bounds: CGRect {
        didSet {
            // setup the animation again for the new bounds
            if oldValue != bounds && isAnimating {
                setUpAnimation()
            }
        }
    }
    
    /**
     Start animating.
     */
    public final func startAnimating() {
        self.setUpAnimation()
        isHidden = false
        isAnimating = true
        layer.speed = 1
        lottieView?.loopAnimation = true
        lottieView?.play()
    }
    
    /**
     Stop animating.
     */
    public final func stopAnimating() {
        isHidden = true
        isAnimating = false
        lottieView?.stop()
    }
    
    // MARK: Privates
    
    private final func setUpAnimation() {
        let animationRect = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(padding, padding, padding, padding))
        let minEdge = min(animationRect.width, animationRect.height)
        guard let l = self.lottieView else {
            return
        }
        if (l.frame.size.width > l.frame.size.height) {
            let h = l.frame.size.height * (minEdge / l.frame.size.width)
            l.frame = CGRect(x: 0.0, y: (minEdge - h) / 2.0, width: minEdge, height: h)
        }
        else {
            let w = l.frame.size.width * (minEdge / l.frame.size.height)
            l.frame = CGRect(x: (minEdge - w) / 2.0, y: 0.0, width: w, height: minEdge)
        }
    }
}

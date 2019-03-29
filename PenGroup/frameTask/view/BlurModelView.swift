//
//  BlurModelView.swift
//  frametsest
//
//  Created by yaojinhai on 2019/3/4.
//  Copyright © 2019年 yaojinhai. All rights reserved.
//

import UIKit
import Foundation

class BlurModelView: UIView {

    private var label: UILabel!
    private var activity: UIActivityIndicatorView!
    private static let instance = BlurModelView(frame: CGRect.zero);
    
    private var text: String {
        set{
            label.text = newValue;
            setNeedsLayout();
        }
        get{
            return label.text ?? "";
        }
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame);
        label = createLabel();
        label.numberOfLines = 1;
        activity = UIActivityIndicatorView(style: .gray);
        addSubview(activity);
        activity.hidesWhenStopped = true;
        backgroundColor = rgbColor(rgb: 234);
        layer.cornerRadius = 8;
        layer.masksToBounds = true;
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        label.sizeToFit();
        var sFrame = label.frame;
        sFrame.size.width += 40;
        sFrame.size.height += 60;
        sFrame.origin = CGPoint(x: (ScreenData.width - sFrame.width)/2, y: (ScreenData.height - sFrame.height)/2);
        frame = sFrame;
        
        label.frame.origin = CGPoint(x: (width - label.width)/2, y: 18);
        activity.center = CGPoint(x: sFrame.width/2, y: sFrame.height - 22);
        
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview();
        self.activity.stopAnimating();

    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview();
        activity.startAnimating();
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func showTextTime(text: String,duration: TimeInterval) {
        let windows = UIApplication.shared.windows;
        guard let keyWindow = windows.last else {
            return;
        }
        keyWindow.addSubview(self);
        keyWindow.bringSubviewToFront(self);
        self.text = text;
        if duration > 0 {
            let times = DispatchTime.now() + duration;
            DispatchQueue.main.asyncAfter(deadline: times) {
                self.removeFromSuperview();
            }
        }
        
    }
    private func showTextTime(text: String) {
        showTextTime(text: text, duration:  0);
    }

    
}

extension BlurModelView {
    class func showText(text: String) -> Void {
        instance.showTextTime(text: text);
    }
    class func showText(text: String,duration: TimeInterval) {
        instance.showTextTime(text: text, duration: duration);
    }
    class func dimss() -> Void {
        instance.removeFromSuperview();
    }
}

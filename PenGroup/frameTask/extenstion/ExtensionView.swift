//
//  ExtensionView.swift
//  StudyApp
//
//  Created by yaojinhai on 2017/4/11.
//  Copyright © 2017年 yaojinhai. All rights reserved.
//

import UIKit
extension UIView {

    var minX: CGFloat{
        return frame.minX;
    }
    var maxY: CGFloat{
        return frame.maxY;
    }
    var minY: CGFloat {
        return frame.minY;
    }
    var midX: CGFloat {
        return frame.midX;
    }
    var midY: CGFloat {
        return frame.midY;
    }
    var maxX: CGFloat{
        return frame.maxX;
    }
    
    var height: CGFloat {
        return self.frame.height;
    }
    var width: CGFloat {
        return self.frame.width;
    }
    var size: CGSize {
        return bounds.size;
    }
}


extension UIView {
    var snapImage: UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0);
        let context = UIGraphicsGetCurrentContext();
        layer.draw(in: context!);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
}

extension UIView {
    
    @discardableResult
    func addTapGesture(target: Any,selector: Selector) -> UITapGestureRecognizer {
        let tap = UITapGestureRecognizer(target: target, action: selector);
        addGestureRecognizer(tap);
        self.isUserInteractionEnabled = true;
        return tap;
    }
    
    
    func addActionToButton(target: Any,action:Selector) -> Void {
        for item in subviews {
            if let btn = item as? UIButton {
                btn.addTarget(target, action: action);
            }
        }
    }
}




extension UIView {
    

    func createButton(rect: CGRect = CGRect.zero,title: String = "") -> UIButton {
        let btn = UIButton(frame: rect);
        btn.setTitle(title, for: .normal);
        addSubview(btn);
        btn.titleLabel?.font = UIFont.fitSize(size: 14);
        btn.backgroundColor = UIColor.white;
        btn.setTitleColor(UIColor.white, for: .normal);
        return btn;
    }
    
    
    
    
    func createImageView(rect: CGRect = CGRect.zero) -> UIImageView {
        let imageView = UIImageView(frame: rect);
        addSubview(imageView);
        imageView.backgroundColor = UIColor.white;
        imageView.clipsToBounds = true;
        imageView.contentMode = .scaleAspectFill;
        return imageView;
    }
    
    func createView(rect: CGRect = CGRect.zero) -> UIView {
        let view = UIView(frame: rect);
        addSubview(view);
        return view;
    }
    
    func createLabel(rect: CGRect = CGRect.zero,text: String = "") -> UILabel {
        let label = UILabel(frame: rect);
        label.backgroundColor = .white;
        label.font = UIFont.fitSize(size: 14);//fontSize(size: 14);
        label.textColor = .darkGray;
        addSubview(label);
        label.text = text;
        label.clipsToBounds = true;
        return label;
    }
    
    func createTextField(rect: CGRect = CGRect.zero) -> UITextField {
        let field = UITextField(frame: rect);
        addSubview(field);
        field.borderStyle = .none;
        field.autocapitalizationType = .none;
        field.spellCheckingType = .no;
        field.autocorrectionType = .no;
        field.backgroundColor = UIColor.white;
        return field;
    }
    
}

extension UIButton {
    
    func changeImageTitle() -> Void {
        titleLabel?.numberOfLines = 0;
        titleLabel?.textAlignment = .center;
        titleEdgeInsets = UIEdgeInsets(top: imageView!.height + 4, left: -imageView!.width, bottom: 0, right: 0);
        imageEdgeInsets = UIEdgeInsets(top: -titleLabel!.height, left: 0, bottom: 0, right: -titleLabel!.width);
    }
    
    func addTarget(_ target: Any?, action: Selector) {
        addTarget(target, action: action, for: .touchUpInside);
    }
}




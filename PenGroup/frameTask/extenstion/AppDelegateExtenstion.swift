//
//  AppDelegateExtenstion.swift
//  StudyApp
//
//  Created by yaojinhai on 2019/2/23.
//  Copyright © 2019年 yaojinhai. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

@objc
protocol NotificationActionDelegate {
    @objc func noticationAction(_ notification: NSNotification) -> Void
}

protocol NotificationNameDelegate {
    var customName: NSNotification.Name{get}
}

protocol CreateViewDelegate: class ,NSObjectProtocol {
    func createLabel(rect: CGRect) -> UILabel

}


extension CreateViewDelegate where Self: UIView {
    
    func createLabel(rect: CGRect) -> UILabel {
        let label = UILabel(frame: rect);
        label.backgroundColor = .clear;
        label.textColor = .darkGray;
        addSubview(label);
        label.clipsToBounds = true;
        return label;
    }

}
extension CreateViewDelegate where Self: UIViewController {
    func createLabel(rect: CGRect) -> UILabel {
        let label = UILabel(frame: rect);
        label.backgroundColor = .clear;
        label.textColor = .darkGray;
        view.addSubview(label);
        label.clipsToBounds = true;
        return label;
    }
}



// user detual set UserDefaults

enum UserDefaultsKey: String {
    case dayOfCount
}


extension UIApplication {
    func topViewController() -> UIViewController? {
        var rootCtroller: UIViewController!
        let windows = UIApplication.shared.windows;
        for item in windows.reversed() {
            if let ctrl = item.rootViewController {
                rootCtroller = ctrl;
                break;
            }
        }
        return childViewController(ctroller: rootCtroller);
    }
    private func childViewController(ctroller: UIViewController?) -> UIViewController? {
        if let ctrl = ctroller?.presentedViewController {
            return childViewController(ctroller: ctrl);
        }else if let ctrl = ctroller as? UINavigationController {
            return childViewController(ctroller: ctrl.topViewController);
        }else if let ctrl = ctroller as? UITabBarController {
            return childViewController(ctroller: ctrl.selectedViewController);
        }
        return ctroller;
    }
}

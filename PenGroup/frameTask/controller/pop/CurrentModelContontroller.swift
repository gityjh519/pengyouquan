//
//  CurrentModelContontroller.swift
//  StudyApp
//
//  Created by yaojinhai on 2017/6/8.
//  Copyright © 2017年 yaojinhai. All rights reserved.
//

import UIKit

class CurrentModelContontroller: UIPresentationController {

//    var mainView: UIView = {
//        $0.backgroundColor = UIColor.red;
//        return $0;
//    }(UIView())
    
    override func presentationTransitionWillBegin() {
        guard let container = containerView else {
            return;
        }
        container.backgroundColor = UIColor.black.withAlphaComponent(0.4);
//        mainView.frame = CGRect(x: 0, y: 70, width: container.width, height: container.height - 140);
//        container.addSubview(mainView);
        
//        let translate = presentingViewController.transitionCoordinator;
//        translate?.animate(alongsideTransition: { (coordinate) in
//        }, completion: { (context) in
//            
//        });
        
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
//        if !completed {
//            mainView.removeFromSuperview();
//        }
    }
    
    override func dismissalTransitionWillBegin() {
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
//        if completed {
//            mainView.removeFromSuperview();
//        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        return self.containerView!.frame;
    }
    
}

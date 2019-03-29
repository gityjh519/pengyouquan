//
//  TransitionManger.swift
//  StudyApp
//
//  Created by yaojinhai on 2017/6/8.
//  Copyright © 2017年 yaojinhai. All rights reserved.
//

import UIKit

class TransitionManger: NSObject,UIViewControllerAnimatedTransitioning {

    var isPresenting = false;
    

    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4;
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView;
        containerView.clipsToBounds = true;
        if isPresenting {
            
            let presentedCtrl = transitionContext.viewController(forKey: .to);
            let presentedView = transitionContext.view(forKey: .to);
            presentedView?.clipsToBounds = true;
            
            containerView.addSubview(presentedView!);
            
            presentedView?.frame = transitionContext.finalFrame(for: presentedCtrl!);
            
            presentedView?.frame = containerView.frame;//CGRect(x: 0, y: 0, width: 20, height: 20);
//            presentedView?.center = containerView.center;
            
            
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseOut, animations: {
                
                presentedView?.frame = containerView.frame;

                
            }, completion: { (finished) in
                
                transitionContext.completeTransition(finished);
                
            })
            
        }else {
            
            transitionContext.completeTransition(true);

//            let presentedView = transitionContext.view(forKey: .from);
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseOut, animations: { 
//                presentedView?.frame = CGRect(x: 0, y: 0, width: 20, height: 20);
//                presentedView?.center = containerView.center;
            }, completion: { (finished) in
//                transitionContext.completeTransition(finished);
            })
            
        }
        
        
    }
    
    
}

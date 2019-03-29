//
//  FMScrollView.swift
//  frametsest
//
//  Created by yaojinhai on 2019/3/4.
//  Copyright © 2019年 yaojinhai. All rights reserved.
//

import UIKit

class FMScrollView: UIScrollView {

    override init(frame: CGRect) {
        super.init(frame: frame);
        backgroundColor = UIColor.clear;
        showsVerticalScrollIndicator = false;
        showsHorizontalScrollIndicator = false;
        keyboardDismissMode = .onDrag;
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

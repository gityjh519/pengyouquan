//
//  JHSBaseView.swift
//  PenGroup
//
//  Created by yaojinhai on 2019/3/21.
//  Copyright © 2019年 yaojinhai. All rights reserved.
//

import UIKit

class JHSBaseView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame);
        backgroundColor = UIColor.white;
        configSubView();
        
    }
    func configSubView() -> Void {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

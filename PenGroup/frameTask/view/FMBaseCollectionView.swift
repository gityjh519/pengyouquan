//
//  FMBaseCollectionView.swift
//  KuaiJi
//
//  Created by yaojinhai on 2017/6/20.
//  Copyright © 2017年 yaojinhai. All rights reserved.
//

import UIKit

class FMBaseCollectionView: UICollectionView {

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout);
        showsVerticalScrollIndicator = false;
        showsHorizontalScrollIndicator = false;
        backgroundColor = UIColor.clear;
        keyboardDismissMode = .onDrag
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

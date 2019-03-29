//
//  FMBaseTableView.swift
//  KuaiJi
//
//  Created by yaojinhai on 2017/6/20.
//  Copyright © 2017年 yaojinhai. All rights reserved.
//

import UIKit

class FMBaseTableView: UITableView {
    
    convenience init(frame: CGRect) {
        self.init(frame: frame, style: .plain);
    }

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style);
        self.showsVerticalScrollIndicator = false;
        keyboardDismissMode = .onDrag
        separatorStyle = .none
        clipsToBounds = true;
        backgroundColor = UIColor.clear;
        autoresizingMask = [.flexibleWidth,.flexibleHeight]
        tableFooterView = UIView();
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        }


    }
    
    convenience init(frame: CGRect, delegate: UITableViewDelegate & UITableViewDataSource) {
        self.init(frame: frame);
        self.dataSource = delegate;
        self.delegate = delegate;
        backgroundColor = UIColor.clear;
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
   

}
extension UITableView {
    func insertSection(section: Int) -> Void {
        insertSections(.init(integersIn: Range.init(uncheckedBounds: (lower: section, upper: section + 1))), with: .none);
    }
    func deleteSection(section: Int) -> Void {
        deleteSections(.init(integersIn: Range.init(uncheckedBounds: (lower: section, upper: section + 1))), with: .none);
    }
    func insertRows(indexPaths: [IndexPath]) -> Void {
        insertRows(at: indexPaths, with: .fade);
    }
    func deleteRows(indexPaths: [IndexPath]) -> Void {
        deleteRows(at: indexPaths, with: .fade);
    }
}

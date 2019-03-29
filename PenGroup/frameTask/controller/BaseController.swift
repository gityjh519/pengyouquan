//
//  BaseController.swift
//  StudyApp
//
//  Created by yaojinhai on 2018/4/27.
//  Copyright © 2018年 yaojinhai. All rights reserved.
//

import UIKit
import CoreGraphics

class BaseController: UIViewController {
    
    

    var isFirstApprence = true;
    var baseTable: FMBaseTableView!
    var baseCollectionView: FMBaseCollectionView!
    var contentScrollView: FMScrollView!
    
    var barStyle = UIStatusBarStyle.default {
        didSet{
            setNeedsStatusBarAppearanceUpdate();
        }
    }
    var hiddenBar = false {
        didSet{
            setNeedsStatusBarAppearanceUpdate();
        }
    }

    var backColor: UIColor! {
        didSet{
            view.backgroundColor = backColor;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white;
    }
    
    override var prefersStatusBarHidden: Bool {
        return hiddenBar;
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return barStyle;
    }
//    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
//        return UIStatusBarAnimation.slide;
//    }
    
    
}




// MARK: action event for item

extension BaseController {
    
    @discardableResult
    func addTapGestureToView(toView: UIView) -> UITapGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureEvent(_:)));
        toView.addGestureRecognizer(tap);
        toView.isUserInteractionEnabled = true;
        return tap;
        
    }
    
   @objc func touchUpButtonAction(_ btn: UIButton) -> Void {
        
    }
    
    @objc func tapGestureEvent(_ tap: UITapGestureRecognizer) -> Void {
        
    }
    
    @objc func buttonItemAction(_ item: UIBarButtonItem) -> Void {
        
    }
    
}




// MARK: - create sub view

extension BaseController {
    
    func addRefresh(scrollView: UIScrollView) -> Void {
        let refreshView = UIRefreshControl();
        refreshView.addTarget(self, action: #selector(beginRefreshData(_:)), for: .valueChanged);
        scrollView.refreshControl = refreshView;
    }

    
    @objc func beginRefreshData(_ refreshView: UIRefreshControl) -> Void {
        
    }
    
    
    func addSubview(subView: UIView) -> Void {
        view.addSubview(subView);
    }
}





// MARK: - create scroll view

extension BaseController {
    
    func setContentScrollView(rect: CGRect?) -> Void {
        
        let cRect = rect ?? navigateRect;
        contentScrollView = FMScrollView(frame: cRect);
        view.insertSubview(contentScrollView, at: 0);
        
        
    }
}

// MARK: - collection view delegate

extension BaseController {
    
    func createCollection(frame: CGRect,layout: UICollectionViewLayout,delegate: UICollectionViewDelegate & UICollectionViewDataSource) -> Void {
        
        baseCollectionView = FMBaseCollectionView(frame: frame, collectionViewLayout: layout);
        addView(tempView: baseCollectionView);
        baseCollectionView.delegate = delegate;
        baseCollectionView.dataSource = delegate;
    }
    
}


// MARK: - view frame

extension BaseController {
    var navigateRect: CGRect {
        return CGRect(x: 0, y: 64, width: width(), height: height() - 64);
    }
    
    var tabbarRect: CGRect {
        return CGRect(x: 0, y: 64, width: width(), height: height() - 64 - 49);
    }
}


// MARK: - table view and delegate or datasource implement

extension BaseController : UITableViewDelegate,UITableViewDataSource {
    
    func createTable(delegate: UITableViewDataSource & UITableViewDelegate) {
        createTable(frame: navigateRect, delegate: delegate);
    }
    
    
    func createTable(frame: CGRect,delegate: UITableViewDataSource&UITableViewDelegate) -> Void {
        
        baseTable = FMBaseTableView(frame: frame);
        baseTable.delegate = delegate;
        baseTable.dataSource = delegate;
        view.addSubview(baseTable);
        baseTable.estimatedSectionHeaderHeight = 0;
        baseTable.estimatedRowHeight = 0;
    
    }
    
    // MAEK: - table view delegate implement
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath);
        return cell;
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
}

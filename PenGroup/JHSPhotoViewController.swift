//
//  JHSPhotoViewController.swift
//  PenGroup
//
//  Created by yaojinhai on 2019/3/28.
//  Copyright © 2019年 yaojinhai. All rights reserved.
//

import UIKit

class JHSPhotoViewController: JHSBaseViewController {

    var images: [UIImage]!
    var index = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout();
        layout.itemSize = CGSize(width: width(), height: height());
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = .horizontal;
        createCollection(frame: navigateRect, layout: layout, delegate: self);
        baseCollectionView.register(JHSPhotoCell.self, forCellWithReuseIdentifier: "cell");
        baseCollectionView.isPagingEnabled = true;
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        baseCollectionView.scrollToItem(at: .init(row: index, section: 0), at: .centeredHorizontally, animated: false);
    }
    
}
extension JHSPhotoViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    // MARK: - collection view delegate and dataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images?.count ?? 0;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! JHSPhotoCell;
        cell.imageView.image = images[indexPath.row];
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

class JHSPhotoCell: UICollectionViewCell {
    var imageView: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame);
        imageView = createImageView(rect: bounds);
        imageView.contentMode = .scaleAspectFit;
        imageView.clipsToBounds = true;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

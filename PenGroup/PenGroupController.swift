//
//  PenGroupController.swift
//  PenGroup
//
//  Created by yaojinhai on 2019/3/21.
//  Copyright © 2019年 yaojinhai. All rights reserved.
//

import UIKit

class PenGroupController: JHSBaseViewController {
    

    let list = createData();
    
    var cellsIdentifier = [MessageModelType]();

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        createTable(delegate: self);
        cellsIdentifier.append(.text);
        cellsIdentifier.append(.image);
        cellsIdentifier.append(.mutableImage);
        cellsIdentifier.append(.new);
        cellsIdentifier.append(.ad);
        cellsIdentifier.append(.video);
        
        baseTable.separatorStyle = .singleLine;
        
        registerCellToTable();
        

    }
    
    func registerCellToTable() -> Void {
        for item in cellsIdentifier {
            if let cls = item.rawValue.clsType {
                baseTable.register(cls, forCellReuseIdentifier: item.rawValue);
            }
        }
    }
    
    // MAEK: - table view delegate implement
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = list[indexPath.row];
        return model.rowHeight + 30;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = list[indexPath.row];
        let cell = tableView.dequeueReusableCell(withIdentifier: model.modelType.rawValue, for: indexPath) as! JHSGroupCell;
        cell.configMessage(model: model);
        cell.actionTarget = self;
        cell.selector = #selector(cellActionItem(_:));
        return cell;
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @objc func cellActionItem(_ any: Any) -> Void {

        guard let dict = any as? [JHSCellKey:Any],
            let cell = dict[.cell] as? JHSGroupCell,
        let indexPath = baseTable.indexPath(for: cell) else{
            return;
        }
        
        if let mImageCell = cell as? JHSMutableImageCell {
            let index = (dict[.imgIndex] as? Int) ?? 0;
            let ctrl = JHSPhotoViewController();
            ctrl.images = mImageCell.mutableImages;
            ctrl.index = index
            navigationController?.pushViewController(ctrl, animated: true);
            return;
        }
        let item  = list[indexPath.row];
        if let model = item as? JHSNewModel {
            let ctrl = JHSHTMLViewController();
            ctrl.urlString = model.link;
            navigationController?.pushViewController(ctrl, animated: true);
            return;
        }
        
        
        
        
    }
}






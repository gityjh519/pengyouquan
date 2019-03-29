//
//  DataBaseManager.swift
//  CathAssist
//
//  Created by yaojinhai on 2018/7/3.
//  Copyright © 2018年 CathAssist. All rights reserved.
//

import UIKit

enum DataBaseType: String {
    case known
}

class DataBaseManager: NSObject,NotificationActionDelegate {
    
    
    fileprivate static let instance = DataBaseManager();
    private let paramter = NSMutableDictionary();
    private let maxCount = 100;
    private override init() {
        super.init();
        NotificationCenter.addTo(observer: self, name: UIApplication.didReceiveMemoryWarningNotification);
        
    }
    
    fileprivate subscript(key: DataBaseType) -> Any? {
        set {
            if paramter.count > maxCount {
                paramter.removeAllObjects();
            }
            paramter[key.rawValue] = newValue;
        }
        get{
            return paramter[key.rawValue];
        }
    }
    
    func noticationAction(_ notification: NSNotification) {
        paramter.removeAllObjects();
    }


}

extension DataBaseManager {
    class func set(key: DataBaseType,value: Any) {
        instance[key] = value;
    }
    class func value(_ key: DataBaseType) -> Any? {
        return instance[key];
    }

}

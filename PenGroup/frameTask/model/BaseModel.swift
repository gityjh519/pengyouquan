//
//  BaseModel.swift
//  CathAssist
//
//  Created by yaojinhai on 2017/7/22.
//  Copyright © 2017年 CathAssist. All rights reserved.
//

import UIKit

enum ResultCodeType: Int {
    case success = 200
}

class BaseModel: NSObject {
    
    @objc var result_msg = "";
    @objc var result_code = 0;
    var isSuccess: Bool {
        return result_code == ResultCodeType.success.rawValue;
    }
    
    private var anyCls: AnyClass!
    
    var baseDataModel: BaseModel!
    var baseDataList: [BaseModel]!

    override init() {
        super.init();

    }
    convenience init(dict: [String:Any]){
        self.init();
        configModel(dict: dict);
        setData();
    }
    
    class func createModel(dict: NSDictionary) -> BaseModel {
        let model = BaseModel();
        model.result_msg = dict["result_msg"] as! String;
        if let code = dict["result_code"] as? Int{
            model.result_code = code;
        }else if let code = dict["result_code"] as? String{
            model.result_code = Int(code)!;
        }
        
        return model;
    }
    
    convenience init(anyCls: AnyClass,dict: NSDictionary){
        self.init();
        self.anyCls = anyCls;
        configModel(dict: dict as! [String : Any]);
        setData();
    }
    required convenience init(dictM: NSDictionary){
        self.init(dict: dictM as! [String : Any]);
        
    }
    
    required convenience init(anyData: Any) {
        self.init(dict: anyData as! [String:Any]);
    }
    
    func setData() -> Void {
        
    }

    
    
    
    func configModel(dict: [String:Any]) -> Void {
        self.setValuesForKeys(dict);
        
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        switch key {
        case "result":
            guard let dataItem = anyCls as? BaseModel.Type else {
                return;
            }
            
            if let list = value as? NSArray {
                baseDataList = [BaseModel]();
                for item in list {
                    let model = dataItem.init(anyData: item);
                    baseDataList.append(model);
                }
            }else if let dict = value as? NSDictionary {
                baseDataModel = dataItem.init(dictM: dict);
            }
            
        default:
            if value != nil {
                super.setValue(value, forKey: key);
            }
        }
    }
    

    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

extension BaseModel {
    
    var modelDict: NSDictionary {
        
        var counts: UInt32 = 0;
        let propertis = class_copyPropertyList(classForCoder, &counts);
        
        let keyValueDict = NSMutableDictionary();
        for idx in 0..<Int(counts) {
            guard let property = propertis?[idx] else{
                continue;
            }

            if let pty = property_getAttributes(property) {
                let attribute = String(cString: pty);
                if attribute.contains("R") || attribute.contains("NSAttributedString") {
                    continue;
                }
            }
            let cName = property_getName(property);
            let name = String(cString: cName);
            var value = self.value(forKey: name);
            if value == nil {
                value = self.value(forKeyPath: name);
            }
            
            guard let keyValue = value else{
                continue;
            }
            
            if let model = keyValue as? BaseModel{
                let dict = model.modelDict;
                if dict.count > 0 {
                    keyValueDict[name] = model.modelDict;
                }
                
            }else if (keyValue is String) || (keyValue is NSNumber){
                
                keyValueDict[name] = keyValue;
                
            }else if let list = keyValue as? NSArray{
                if let tempList = forArray(array: list) {
                    keyValueDict[name] = tempList;
                }
            }
        }
        
        return keyValueDict;
    }
    
    private func forArray(array: NSArray) -> NSArray? {
        if array.count == 0 {
            return nil;
        }
        let tempArray = NSMutableArray();
        for item in array {
            if let model = item as? BaseModel {
                let dict = model.modelDict;
                if dict.count > 0 {
                    tempArray.add(model.modelDict);
                }
            }else if let listArray = item as? NSArray {
                if let tempList = forArray(array: listArray) {
                    tempArray.addObjects(from: tempList as! [Any]);
                }
            }else if (item is String) || (item is NSNumber){
                tempArray.add(item);
            }
        }
        if tempArray.count > 0 {
            return tempArray;
        }
        return nil;
    }
}

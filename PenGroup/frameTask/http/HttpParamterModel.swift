//
//  HttpParamterModel.swift
//  StudyApp
//
//  Created by yaojinhai on 2018/4/12.
//  Copyright © 2018年 yaojinhai. All rights reserved.
//

import UIKit

enum HttpViaType {
    case other
    case image
}


class HttpParamterModel: NSObject {

    var isBodyPrammter = false;
    var key = "";
    var value = "";
    var dataValue: Data!
    var isData = false;
    var fileType = HttpViaType.image;
    var typeStrl: String {
        return "Content-Type=image/png";
    }

    
    convenience init(key: String,value: String,isBody: Bool = false) {
        self.init();
        self.key = key;
        self.value = value;
        self.isBodyPrammter = isBody;
    }
    convenience init(key: String,valueData: Data) {
        self.init();
        self.key = key;
        self.dataValue = valueData;
        self.isData = true;
        self.isBodyPrammter = true;
    }
    
    
    class func getHttpBodyData(paramterList: [HttpParamterModel],bodyBoundary:String) -> Data? {
        
        let listModel = getBodyParamter(list: paramterList, isBody: true);
        
        if listModel.count == 0 {
            return nil;
        }
        var bodyData = Data();
        let debugDataString = NSMutableString();
        
        
        let boundLine = "--" + bodyBoundary + "\r\n";
        bodyData.append(boundLine.data);
        debugDataString.append(boundLine);
        
        for item in listModel {
            
            
            if item.isData {
                
//                let bodyLine = "--" + bodyBoundary + "\r\n";
//                bodyData.append(bodyLine.data);
//                debugDataString.append(bodyLine);
                
                let inputKey = """
                Content-Disposition: form-data;name="\(item.key)";filename="\(item.key).png"\r\n\(item.typeStrl)\r\n
                """;
                
                bodyData.append(inputKey.data);
                debugDataString.append(inputKey);
                
                
                let endFlag = "\r\n";
                bodyData.append(endFlag.data);
                debugDataString.append(endFlag);
                
                
                bodyData.append(item.dataValue);
                
//                let images = UIImage(data: item.dataValue);
//                print("images =\(images)");
                
                debugDataString.append(item.key);
                
                bodyData.append(endFlag.data);
                debugDataString.append(endFlag);
                
            }else {
                
                let inputKey = "Content-Disposition: form-data; name=\"\(item.key)\"" + "\r\n\r\n";
                bodyData.append(inputKey.data);
                debugDataString.append(inputKey);
                
                bodyData.append(item.value.data);
                debugDataString.append(item.value);
                
                let endFlag = "\r\n";
                bodyData.append(endFlag.data);
                debugDataString.append(endFlag);
                
            }
            
        }
        
        
        
        let endBound = "--" + bodyBoundary + "--\r\n";
        bodyData.append(endBound.data);
        
        debugDataString.append(endBound);
        
        printObject("http body type: \n\(debugDataString)")
        
        
        return bodyData;
    }
    
    
    class func getBodyParamter(list: [HttpParamterModel],isBody: Bool) -> [HttpParamterModel] {
        
        var tempList = [HttpParamterModel]();
        for item in list {
            if item.isBodyPrammter && isBody {
                tempList.append(item);
            }else if !isBody && !item.isBodyPrammter{
                tempList.append(item);
            }
        }
        return tempList;
    }
    class func getPairKeyAndValue(list: [HttpParamterModel]) -> String {
        var tempStrl = "?";
        for item in list {
            if item.isBodyPrammter{
                continue;
            }
            let valueString = item.key.encode + "=" + item.value.encode + "&";
            tempStrl.append(valueString);
        }
        if tempStrl.count > 0 {
            tempStrl = String(tempStrl.dropLast());
        }
        return tempStrl;
    }
    
    
    
    private override init() {
        super.init();
    }
}

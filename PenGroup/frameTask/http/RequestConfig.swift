
//
//  RequestConfig.swift
//  StudyApp
//
//  Created by yaojinhai on 2018/4/4.
//  Copyright © 2018年 yaojinhai. All rights reserved.
//

import Foundation

struct RequestConfigList {
    
    static let timesamp = "timestamp";
    static let assetionkey = "assetionkey";
    
    static let baseURLAPI = "http://dangjian.yaoyu-soft.com/langur/api"
    static let miyao = """
GLwIRjUyRHCbK8wtcOtZJ3flAfTgPkKEGXRI9v8wvcWXd//ZWzn1n3=H+4UAMsE==+9+pjuawFrCoqqRS4DmDC2I4Xy2+Oxqqw7VWb8fgaxXsv3a/AhPG1jEUDQHYYD7F5NrfnkIu+jloVRA03Hc50V8En4BbE/XxOgASVc+RJYqG0ySP/JdjYZouRYfJpS4luUDU1F42r21e5Ah5fiPhjqKL5EsfyT28v5NE0BYEWxC3vVSakmFQbZvvQM1P5HpoiEzg3WEtWB=k0OUQcFuHg0EPXPY0EyFYQQmF8AfEwepPtzk13XghQji8mqzqNCChNWb38c7VDes/cPBhMfzAFzmSg66
"""
    
   static func getTokenValue(time: String) -> String {
        let value = miyao + time;
        let tokenValue = value.data(using: String.Encoding.utf8)!.base64EncodedString()
        return tokenValue;
    }
    
}

extension Date {
    static var formate: DateFormatter = {
        let f = DateFormatter();
        f.dateFormat = "yyyyMMddHHmmss";
        return f;
    }();
    var timestamp: String {
        return Date.formate.string(from: self);
    }
}


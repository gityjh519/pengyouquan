//
//  DefineSwiftFunc.swift
//  StudyApp
//
//  Created by yaojinhai on 2019/3/4.
//  Copyright © 2019年 yaojinhai. All rights reserved.
//

import Foundation
import UIKit


func UIEdge(size: CGFloat) -> UIEdgeInsets {
    return UIEdgeInsets(top: size, left: size, bottom: size, right: size);
}

// MARK: debug print

//MARK: - debug log

func printObject(_ content: String, file: String = #file,funName: String = #function, line: Int = #line) {
    #if DEBUG
    print("\n++++++++++++++++++++++++++++++++<begin>++++++++++++++++++++++++++++++++\n文件路径:" + file + "\n函数名字:" + funName + "\n第\(line)行" + "\n\n" + content + "\n++++++++++++++++++++++++++++++++<end>++++++++++++++++++++++++++++++++\n");
    #endif
    
}

// MARK: - is pad

let IS_PAD: Bool = {
    return $0;
}(UIDevice.current.userInterfaceIdiom == .pad)


//MARK: - 颜色配置

func rgbColor(rgb: Int) -> UIColor {
    return rgbColor(r: rgb, g: rgb, b: rgb);
}

func rgbColor(r: Int,g: Int,b: Int) -> UIColor {
    
    if #available(iOS 10.0, *) {
        return UIColor(displayP3Red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1)
    }
    
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1)
}

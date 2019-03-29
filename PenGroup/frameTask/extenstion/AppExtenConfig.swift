//
//  AppExtenConfig.swift
//  StudyApp
//
//  Created by yaojinhai on 2017/9/1.
//  Copyright © 2017年 yaojinhai. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

// UI Extenstion
// MARK: - UIColor 颜色
extension UIColor {
    convenience init(hexString: String) {
        
        assert(hexString.count > 5, "这不是一个十六进制的字符串: \(hexString)")
        
        var subHex = hexString;
        if hexString.count > 6 {
            subHex = String(hexString[hexString.index(after: hexString.index(hexString.endIndex, offsetBy: -7))...]);
        }
        let scanner = Scanner(string: subHex);
        var rgbValue: UInt64 = 0;
        scanner.scanHexInt64(&rgbValue);
        let r = (rgbValue & 0xff0000) >> 16;
        let g = (rgbValue & 0xff00) >> 8;
        let b = (rgbValue & 0xff);
        
        if #available(iOS 10.0, *) {
            self.init(displayP3Red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1)
        } else {
            // Fallback on earlier versions
            self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1);
        };
    }
    
    class var random: UIColor {
        let color = rgbColor(r: Int(arc4random_uniform(255)), g: Int(arc4random_uniform(255)), b: Int(arc4random_uniform(255)));
        return color;
    }
    
}
// MARK: - UIImage 图片
extension UIImage {
    
//    func drawImageColor(_ image: UIImage,color: UIColor) -> UIImage {
//
//        UIGraphicsBeginImageContextWithOptions(image.size, false, UIScreen.main.scale);
//        color.setFill();
//        let bounds = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height);
//        UIRectFill(bounds);
//        //    image.drawInRect(bounds, blendMode: CGBlendMode.Overlay, alpha: 1);
//        image.draw(in: bounds, blendMode: CGBlendMode.destinationIn, alpha: 1);
//
//        let newImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//
//        return newImage!;
//    }
    
    convenience init(color: UIColor) {
        let rect = CGRect.init(x: 0, y: 0, width: 1, height: 1);
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: 1, height: 1), false, 0);
        let context = UIGraphicsGetCurrentContext();
        context?.setFillColor(color.cgColor);
        context?.addRect(rect);
        context?.fillPath();
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        if let cgImg = image?.cgImage {
            self.init(cgImage: cgImg);
        }else {
            self.init();
        }
    }
    
    
    var screenImage: UIImage{
        let scale = size.width/(ScreenData.width*2);
        let rect = CGRect.init(x: 0, y: 0, width: size.width/scale, height: size.height/scale);
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0);
        draw(in: rect);
        let img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return img!;
    }

  
    
    class func getGIFDataName(name: String) -> [UIImage]? {
        
        guard let gifPath = Bundle.main.url(forResource: name, withExtension: "gif"),let sourceImages = CGImageSourceCreateWithURL(gifPath as CFURL, nil) else {
            return nil;
        }
        
        let count = CGImageSourceGetCount(sourceImages);
        var images = [UIImage]();
        for idx in 0..<count {
            let cgImage = CGImageSourceCreateImageAtIndex(sourceImages, idx, nil);
            let image = UIImage(cgImage: cgImage!);
            images.append(image);
        }
        return images;
    }
    
    func drawRectWithRroundedCorner(_ randius : CGFloat,sizeFit : CGSize) -> UIImage {
        let rect = CGRect(origin: CGPoint.zero, size: sizeFit);
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale);
        let context = UIGraphicsGetCurrentContext()
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: randius, height: randius));
        context?.addPath(path.cgPath);
        context?.clip();
        self.draw(in: rect);
        context?.drawPath(using: CGPathDrawingMode.fillStroke);
        let outImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return outImg!;
    }
    
    func clipSize(_ size : CGSize) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale);
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height));
        let outImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return outImg!;
    }
    
    
}

// MARK: - UIFont 字体
extension UIFont {
    class func fitSize(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize:size);
    }
}

// MARK: - NSNotification.Name
extension NSNotification.Name: NotificationNameDelegate {
    var customName: NSNotification.Name {
        return self;
    }
}

// MARK: - NotificationCenter 通知中心

extension NotificationCenter{
    
    static func post(name:NotificationNameDelegate,userInfo:[AnyHashable:Any]?,object:Any? = nil){
        NotificationCenter.default.post(name: name.customName, object: object, userInfo: userInfo);
    }
    static func post(named: NotificationNameDelegate){
        post(name: named, userInfo: nil);
    }
    
    static func post(name: NotificationNameDelegate,object:Any?,queue:OperationQueue?,block: @escaping (Notification) -> Void) -> NSObjectProtocol{
        
        return NotificationCenter.default.addObserver(forName: name.customName, object: object, queue: queue) { (notication) in
            block(notication);
        };
    }
    
    static func add(observer: Any,selector:Selector,name:NotificationNameDelegate){
        NotificationCenter.default.addObserver(observer, selector: selector, name: name.customName, object: nil);
    }
    static func addTo<T: NotificationActionDelegate>(observer: T,name: NotificationNameDelegate) -> Void {
        let selector = NSSelectorFromString("noticationAction:");
        NotificationCenter.add(observer: observer, selector: selector, name: name);
    }
    
    
    static func remove(observer: Any) {
        NotificationCenter.default.removeObserver(observer);
    }
    
}


/// CG Extenstion

//MARK: - CGSize size 位置
extension CGSize {
    static func convertIphone5Size(cSize: CGSize,scale: CGFloat = 0.84) -> CGSize{
        let newScale: CGFloat = iOSIPhoneInfoData.isIphone1_5 ? scale : 1;
        return CGSize.init(width: cSize.width * newScale, height: cSize.height * newScale);
        
    }
}

//MARK: - CGFloat 浮点型

extension CGFloat {
    var intValue: Int {
        return Int(self);
    }
    
}

//MARK: - Int 整型

extension Int {
    var cgFloat: CGFloat {
        return CGFloat(self);
    }
}


// Foundation Extenstion

// MARK: - Locale 中文
extension Locale {
    var cnLocale: Locale {
        return Locale(identifier: "zh_Hans_CN");
    }

}

// MARK: - String 字符串
extension String {
    
    private static let clsPrex = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String;
    var clsType: AnyClass? {
        if let cName = String.clsPrex {
            return NSClassFromString(cName + "." + self);
        }
        return nil;
    }
    
    var isPhone: Bool {
        let regex = "^1[3578][0-9]{9}$";
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex);
        return predicate.evaluate(with:self);
    }
    
    var MD5String: String {
        let cStrl = cString(using: String.Encoding.utf8);
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16);
        CC_MD5(cStrl, CC_LONG(strlen(cStrl!)), buffer);
        var md5String = "";
        for idx in 0...15 {
            let obcStrl = String.init(format: "%02x", buffer[idx]);
            md5String.append(obcStrl);
        }
        free(buffer);
        return md5String;
    }
    
    var textPinYin: String {
        if self.count > 0 {
            let pinYin = NSMutableString(string: "\(first!)");
            
            
            CFStringTransform(pinYin as CFMutableString, nil, kCFStringTransformMandarinLatin, false);
            
            CFStringTransform(pinYin as CFMutableString, nil, kCFStringTransformStripCombiningMarks, false);
            return pinYin as String;
        }
        return "";
    }
    var firstPinYin: String {
        if !textPinYin.isEmpty {
            return String.init(textPinYin.first!).uppercased();
        }
        return "";
    }
    
    var isPassword: Bool {
        let i = ".*[0-9]+.*";
        let a = ".*[a-z]+.*";
        let A = ".*[A-Z]+.*";
        let l = ".{6,12}";
        let iprdicate = NSPredicate(format: "SELF MATCHES %@", i);
        let apredicate = NSPredicate(format: "SELF MATCHES %@", a);
        let Apredicate = NSPredicate(format: "SELF MATCHES %@", A);
        let lpredicate = NSPredicate(format: "SELF MATCHES %@", l);
        
        let compone = NSCompoundPredicate(andPredicateWithSubpredicates: [iprdicate,apredicate,Apredicate,lpredicate]);
        return compone.evaluate(with: self);
    }
    
    var isPassWordFormater: Bool {
        let i = "[0-9]";
        let a = "[a-z]";
        let A = "[A-Z]";
        
        let iprdicate = NSPredicate(format: "SELF MATCHES %@", i);
        let apredicate = NSPredicate(format: "SELF MATCHES %@", a);
        let Apredicate = NSPredicate(format: "SELF MATCHES %@", A);
        
        let compone = NSCompoundPredicate(orPredicateWithSubpredicates: [iprdicate,apredicate,Apredicate]);
        for item in self {
            if !compone.evaluate(with: "\(item)") {
                return false;
            }
        }
        return true;
    }
    
    var data: Data {
        return data(using: String.Encoding.utf8)!;
    }
    var unicodeData: Data{
        return data(using: String.Encoding.unicode)!;
    }
    var encode: String {
        let otherSet = CharacterSet.init(charactersIn: "{}@!*.~<>'^’%();:@&=+$,\\/?%#[]\" ").inverted;
        let encodeStrl = addingPercentEncoding(withAllowedCharacters: otherSet);
        return encodeStrl ?? "";
    }
    var decode: String {
        return removingPercentEncoding ?? "";
    }
    
    
    // add func to string
    
    func textSize(fitWidth: CGFloat,fontSize: CGFloat) -> CGSize {
        let size = CGSize(width: fitWidth, height: CGFloat.greatestFiniteMagnitude);
        return textSize(size: size, font: UIFont.fitSize(size: fontSize));
    }
    
    func textSize(size: CGSize,font: UIFont) -> CGSize {
        let md5Key = MD5String;
        if let boundSize = RelationManager.value(key: md5Key) as? CGSize {
            return boundSize;
        }
        let bounds = NSString(string: self).boundingRect(with: size, options: [NSStringDrawingOptions.usesFontLeading,NSStringDrawingOptions.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font:font], context: nil);
        RelationManager.setKey(key: md5Key, value: bounds.size);
        return bounds.size;
    }
}

// MARK: - UserDefaults 用户保存

extension UserDefaults {
    class func setKey(key: UserDefaultsKey,value: Any?){
        UserDefaults.standard.set(value, forKey: key.rawValue);
    }
    class func getKey(key: UserDefaultsKey) -> Any?{
        return UserDefaults.standard.value(forKey: key.rawValue);
    }
    class func setKey(key: UserDefaultsKey,value: Int){
        UserDefaults.standard.set(value, forKey: key.rawValue);
    }
    class func getInteger(key: UserDefaultsKey) -> Int {
        return UserDefaults.standard.integer(forKey: key.rawValue);
    }
    class func getString(key: UserDefaultsKey) -> String? {
        return UserDefaults.standard.string(forKey: key.rawValue);
    }
}



// Text styles

//MARK: - 结构体
struct iOSIPhoneInfoData {
    static let iphone5: CGFloat = 568;
    static let iphone6: CGFloat = 750;
    static let isIphone1_5 = ScreenData.height <= iOSIPhoneInfoData.iphone5;
    static let isStatanderModel = UIScreen.main.nativeScale == UIScreen.main.scale;
    static let scale = UIScreen.main.scale;
}

struct ScreenData {
    static var bounds: CGRect{ return UIScreen.main.bounds;}
    static var width: CGFloat { return bounds.width;}
    static var height: CGFloat{ return ScreenData.bounds.height;}
    
    
}





// MARK: - 枚举
enum UserOperationType {
    case login
    case alterPass
    case register
    case forgetPass
    case alterUser
}

enum ViewTagSense: Int {
    case searchTag = 1
    case addTag
    
    case noPerson
    case saveTag
    case saveTaskTag
    case refreshTag
    case backTag
    case messageTag
    case fullScreenVedioTag
    case playOrStopTag
    case sendVertifyTag
    case forgetPassTag
    case loginAppTag
    case sendMsgTag
    case sendMsgFlagTag
    case writeCommentTag
    case summarizeTag
    case supTag // 点赞
    case shareTag
    case qqTag
    case wxTag
    case editText
    case doneTag
    case cancelTag
    case nextTag
    case preTag

    case changeDays
    case subViewTag
    
    // ranage
    case selectedAll
    case deleteAll
}


enum BANotificationName: String,NotificationNameDelegate {
    
    case userLogin
    case register
    case tabbarIndexChange
    case beginEditPrint
    case endEditPrint
    case changeValue
    case webSize
    case title
    
    var customName: NSNotification.Name{
        return NSNotification.Name("bat_1_"+rawValue);
    }
}

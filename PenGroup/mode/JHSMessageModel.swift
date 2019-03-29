//
//  JHSMessageModel.swift
//  PenGroup
//
//  Created by yaojinhai on 2019/3/21.
//  Copyright © 2019年 yaojinhai. All rights reserved.
//

import UIKit

enum MessageModelType : String {
    case text = "JHSTextCell" // 只显示文字
    case image = "JHSImageCell" // 只显示一张图片
    case mutableImage = "JHSMutableImageCell" // 多张图片 按照九宫格排列
    case new = "JHSNewCell" // 新闻
    case video = "JHSVideoCell"// 视频
    case ad // 广告
}

class JHSMessageModel: NSObject {

    var name = "张三";
    var modelType: MessageModelType!
    var contentText: String!
    
    init(type: MessageModelType) {
        super.init();
        modelType = type;
        self.configData();
    }
    func configData() -> Void {
        
    }
    
    private var _contextSize: CGSize!
    var contextSize: CGSize {
        if contentText == nil {
            return CGSize.zero;
        }
        if _contextSize != nil {
            return _contextSize;
        }
        
        _contextSize = contentText.textSize(size: CGSize(width: PengConfigParamter.maxWidth, height: CGFloat.greatestFiniteMagnitude), font: PengConfigParamter.textFont);
        return _contextSize;
    }
    var nameSize: CGSize {
        let size = name.textSize(size: CGSize(width: PengConfigParamter.maxWidth, height: CGFloat.greatestFiniteMagnitude), font: PengConfigParamter.textFont);
        return size;
    }
    
    var topHeight: CGFloat {
        let ht = (contextSize.height + 8) + nameSize.height + 12;
        return ht;
//        let ht = contextSize.height + nameSize.height + 14;
//        return ht < 60 ? 60 : ht;
    }
    private var _cHeight: CGFloat = 0;
    var commentHeight: CGFloat {
        if comment == nil || comment.count == 0 {
            return 0;
        }
        if _cHeight != 0 {
            return _cHeight;
        }
        
        for (_,item) in comment.enumerated() {
            _cHeight += (item.size.height + 4)
        }
        _cHeight += 20;
        return _cHeight;
    }
    
    var rowHeight: CGFloat {
        return topHeight + commentHeight + 6;
    }
    
    
    var comment: [JHSCommentModel]!

}

class JHSTextModel: JHSMessageModel {
    
}

// MARK: - 单张图片
class JHSImageModel: JHSMessageModel {
    var urlString = "https://gss2.bdstatic.com/9fo3dSag_xI4khGkpoWK1HF6hhy/baike/c0%3Dbaike80%2C5%2C5%2C80%2C26/sign=194165df51afa40f28cbc68fca0d682a/37d3d539b6003af350360e8d3e2ac65c1138b64b.jpg";
    var image = UIImage(named: "1.jpg");

    override var topHeight: CGFloat {
        let ht = super.topHeight;
        return ht + 200;
    }
    var supHeight: CGFloat {
        return super.topHeight;
    }
}

// MARK: - 单张图片 多张图片 按照九空格排练
class JHSMutableImageModel: JHSMessageModel {
    var images: [UIImage]!
    var count = 8 {
        didSet{
            count = count > 8 ? 8: count;
            images.removeAll();
            for idx in 0...count {
                images.append(UIImage(named: "\(idx).jpg")!);
            }
        }
    }
    
    override func configData() {
        images = [UIImage]();
        for idx in 0...count {
            images.append(UIImage(named: "\(idx).jpg")!);
        }
    }
    override var topHeight: CGFloat {
        if images == nil {
            return super.topHeight;
        }
        let perWidth = (PengConfigParamter.maxWidth - 8 - 40) / 3 + 4;
        let row = ceil(Double(images.count) / 3.0)
        return super.topHeight + perWidth * CGFloat(row);
    }
    var supTopHeight: CGFloat {
        return super.topHeight;
    }
    
    var cellImageHeight: CGFloat {
        return topHeight - super.topHeight;
    }
}
// MARK: - 链接
class JHSNewModel: JHSMessageModel {
    
    override var topHeight: CGFloat {
        return super.topHeight + 48;
    }
    var link = "https://baike.baidu.com/item/%E6%9D%8E%E8%BF%9E%E6%9D%B0/202569?fr=aladdin";
    var linkTitle = "李连杰（Jet Li），1963年4月26日生于北京市，华语影视男演员、导演、制作人 、武术运动员、商人。";
    var lineImage = UIImage(named: "1.jpg");
    
}

class JHSVideoModel: JHSImageModel {
    var videoURL: String!
    var locaionPath: String!
    
//    override var topHeight: CGFloat {
//        let ht = super.topHeight;
//        return ht + 200;
//    }
//    var supHeight: CGFloat {
//        return super.topHeight;
//    }
}

enum CommentItemSelectedType {
    case known
    case name
    case text
}

class JHSCommentModel: NSObject {
    var person: JHSCommentItemModel! // 评论的人
    var endPeseron: JHSCommentItemModel! // // 被评论的人
    
    private let highlitedDict = [NSAttributedString.Key.foregroundColor:UIColor.red];
    
    private let reply = "回复";
    private var replayRange: NSRange {
        return NSRange(location: pmRange.upperBound, length: reply.count);
    }
    
    private var replySize: CGSize {
        return getContentText().attributedSubstring(from: replayRange).boundSize();
    }
    
    var content = "";

    
    var pmRange: NSRange {
        return NSRange(location: 0, length: person.name.count);
    }
    var endRange: NSRange? {
        if endPeseron != nil {
            return NSRange(location: pmRange.upperBound + reply.count, length: endPeseron.name.count);
        }
        return nil;
    }
    var contentRange: NSRange {
        if endRange == nil {
            return NSRange(location: pmRange.upperBound, length: content.count);
        }
        return NSRange(location: endRange!.upperBound, length: content.count);
    }
    private var contentAttribute: NSAttributedString!
    func getContentText() -> NSAttributedString {
        if contentAttribute != nil {
            return contentAttribute;
        }

        if endRange == nil {
            let attirbute = NSMutableAttributedString(string: person.name + "：" + content);
            attirbute.addAttributes(highlitedDict, range: pmRange);
            contentAttribute = attirbute;
            return attirbute;
            
        }else {
            
            let attirbute = NSMutableAttributedString(string: person.name + reply + endPeseron.name + "：" + content);
            attirbute.addAttributes(highlitedDict, range: pmRange);
            attirbute.addAttributes(highlitedDict, range: endRange!);
            contentAttribute = attirbute;
            return attirbute;
        }
        
    }
    
    private var _size: CGSize!;
    var size: CGSize {
        if _size != nil {
            return _size;
        }
        let size = getContentText().boundSize();
        _size = size;
        return _size;
    }
    
    var nameSize: CGSize {
        return getContentText().attributedSubstring(from: pmRange).boundSize();
    }
    var endNameSize: CGSize {
        if endPeseron == nil {
            return CGSize.zero;
        }
        let size = getContentText().attributedSubstring(from: endRange!).boundSize();
        return size;
    }
    
    var orgin: CGPoint!

    func containsPoint(point: CGPoint) -> (JHSCommentItemModel,CGRect,CommentItemSelectedType)? {
        if orgin == nil {
            return nil;
        }
        let cRect = CGRect(origin: orgin, size: size);
        guard cRect.contains(point) else {
            return nil
        }
        let nRect = CGRect(origin: orgin, size: nameSize);
        if  nRect.contains(point) {
//            return (person,pmRange);
            return (person,nRect,CommentItemSelectedType.name);

        }
        let endRect = CGRect(origin: CGPoint(x: nRect.maxX + replySize.width, y: nRect.minY), size: endNameSize);
        if endRect.contains(point) {
            return (endPeseron,endRect,CommentItemSelectedType.name);
        }
        return endPeseron == nil ? (person,cRect,CommentItemSelectedType.text) : (endPeseron,cRect,CommentItemSelectedType.text);
    }
 
    
}

class JHSCommentItemModel: NSObject {
    var name = ""; //姓名
    var id = ""; // 用户id
    var profile = ""// 头像
}

extension JHSCommentModel {
    //    var personRange: Range<Int> {
    //        return Range(uncheckedBounds: (lower: 0, upper: person.name.count));
    //    }
    //    var endPersonRange: Range<Int>? {
    //        if endPeseron == nil {
    //            return nil;
    //        }
    //        return Range(uncheckedBounds: (lower: personRange.upperBound + reply.count, upper: endPeseron.name.count));
    //    }
}


extension NSAttributedString {
    func boundSize() -> CGSize {
        
        if let size = RelationManager.value(key: mainKey) as? CGSize {
            return size;
        }
        let size = boundingRect(with: CGSize(width: PengConfigParamter.maxWidth - 8, height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading,.usesLineFragmentOrigin], context: nil).size;
        RelationManager.setKey(key: mainKey, value: size);
        return size;
    }
    var mainKey: String {
        return string.MD5String;
    }
}

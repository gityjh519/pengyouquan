//
//  ConfigCell.swift
//  PenGroup
//
//  Created by yaojinhai on 2019/3/21.
//  Copyright © 2019年 yaojinhai. All rights reserved.
//

import Foundation
import UIKit

enum JHSCellKey {
    case cell
    case index
    case imgIndex
    
}

class JHSGroupCell: UITableViewCell {
    var entity: JHSMessageModel!
    
    var leftImage: UIImageView!
    
    var nameLabel: UILabel!
    
    var contextLabel: UILabel!
    
    var tabBarView: JHSOperationView!
    
    var actionTarget: Any!
    var selector: Selector!
    
    
    fileprivate var commentView: JHSCommentItemView!
    var comments: [JHSCommentModel]! {
        didSet{
            configComment();
        }
    }
    
    
    var leftPointX: CGFloat {
        return leftImage.maxX + 10;
    }
    var topPointY: CGFloat {
        return nameLabel.maxY + 8;
    }
    var maxWidth: CGFloat {
        return PengConfigParamter.maxWidth
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        backgroundColor = UIColor.white;
        selectionStyle = .none;
        leftImage = createImageView(rect: .init(x: 10, y: 10, width: 40, height: 40));
        leftImage.contentMode = .scaleAspectFill;
        leftImage.clipsToBounds = true;
        leftImage.layer.masksToBounds = true;
        leftImage.layer.cornerRadius = 4;
        leftImage.image = UIImage(named: "1.jpg");
        
        
        nameLabel = createLabel(rect: .init(x: leftPointX, y: 10, width: 20, height: 14), text: "姓名");
        nameLabel.font = PengConfigParamter.textFont;
        nameLabel.textColor = PengConfigParamter.textColor;
        
        tabBarView = JHSOperationView(frame: .init(x: leftPointX, y: topPointY, width: PengConfigParamter.maxWidth, height: 30));
        addSubview(tabBarView);
        
        
        configSubView();
    }
    func configSubView() -> Void {
        
    }
    
    private func configComment() {
        if comments != nil && commentView == nil {
            commentView = JHSCommentItemView(frame: .init(x: leftPointX, y: nameLabel.maxY, width: maxWidth, height: 40));
            addSubview(commentView);
        }
        commentView?.comments = comments;
        commentView?.isHidden = comments == nil;
        
    }
    

    
    private func configContent(context: String?) -> Void {
        if context == nil {
            contextLabel?.text = "";
            return;
        }
        if contextLabel == nil {
            contextLabel = createLabel(rect: .init(x: leftPointX, y: topPointY, width: maxWidth, height: 20), text: "");
            contextLabel.numberOfLines = 0;
            contextLabel.font = PengConfigParamter.textFont;
            contextLabel.textColor = PengConfigParamter.textColor;
        }
        contextLabel.text = context;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configMessage(model: JHSMessageModel) -> Void {
        entity = model;
        nameLabel.text = model.name;
        configContent(context: model.contentText);
        comments = model.comment;
        
    }
    
    func addTarget(t: Any,sel: Selector) -> Void {
        self.actionTarget = t;
        selector = sel;
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        
        if entity == nil {
            return;
        }
        
        var rect = nameLabel.frame;
        rect.size = entity.nameSize;
        nameLabel.frame = rect;
        
        if let label = contextLabel {
            rect = label.frame;
            rect.size = entity.contextSize;
            label.frame = rect;
        }
        
        if let cell = self as? JHSVideoCell {
            
            
            guard let imageModel = entity as? JHSVideoModel else{
                return;
            }
            rect = cell.backImage.frame;
            rect.origin.y = imageModel.supHeight;
            cell.backImage.frame = rect;
            
            rect = tabBarView.frame;
            rect.origin.y = cell.backImage.maxY;
            tabBarView.frame = rect;
            
            cell.backImage.image = UIImage(named: "1.jpg");
            
        }else if self is JHSTextCell {
            
            var rect = tabBarView.frame;
            rect.origin.y = entity.topHeight;
            tabBarView.frame = rect;
            
        }else if let cell = self as? JHSImageCell {
            
            if let imageModel = entity as? JHSImageModel {
                
                
                rect = cell.backImage.frame;
                rect.origin.y = imageModel.supHeight;
                cell.backImage.frame = rect;
                
                rect = tabBarView.frame;
                rect.origin.y = cell.backImage.maxY;
                tabBarView.frame = rect;
            }
        }else if let cell = self as? JHSMutableImageCell {
            
            
            
            guard let imgs = cell.mutableImages else {
                return;
            }
            let perWidth = (PengConfigParamter.maxWidth - 8 - 40) / 3;
            
            for item in imgs.enumerated() {
                let row = item.offset / 3;
                let column = item.offset % 3;
                let drawRect = CGRect(x: column.cgFloat * (perWidth + 4) + leftPointX, y: row.cgFloat * (perWidth + 4) + cell.topHeight, width: perWidth, height: perWidth);
                let img = cell.getImageBy(index: item.offset, rect: drawRect);
                img.image = item.element;
                img.isHidden = false;
                
            }
            if imgs.count < 9 {
                for idx in imgs.count...8 {
                    let img = cell.getImageBy(index: idx, rect: CGRect.zero);
                    img.isHidden = true;
                }
            }
            
            
            if let model = entity as? JHSMutableImageModel {
                var rect = tabBarView.frame;
                rect.origin.y = model.topHeight;
                tabBarView.frame = rect;
            }
            
        }else if let cell = self as? JHSNewCell {
            
            rect = cell.linkView.frame;
            rect.origin.y = entity.topHeight - 48;
            cell.linkView.frame = rect;
            
            rect = tabBarView.frame;
            rect.origin.y = entity.topHeight;
            tabBarView.frame = rect;
            
            
        }
        

        if let cView = commentView {
            rect = cView.frame;
            rect.origin.y = tabBarView.maxY;
            rect.size.height = entity.commentHeight;
            cView.frame = rect;
            
        }
        
    }
}

// MARK: - 只显示文字

class JHSTextCell: JHSGroupCell {
    
    
}

// MARK: - 链接类型的

class JHSNewCell: JHSGroupCell {
    
    var linkView: JHSLinkView!
    
    override func configSubView() {
        linkView = JHSLinkView(frame: .init(x: leftPointX, y: topPointY, width: PengConfigParamter.maxWidth, height: 48));
        addSubview(linkView);
    }
    override func configMessage(model: JHSMessageModel) {
        super.configMessage(model: model);
        if let lModel = model as? JHSNewModel {
            linkView.content = lModel.linkTitle;
            linkView.leftImg.image = lModel.lineImage;
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else {
            return;
        }
        if linkView.frame.contains(point),let sel = selector {
            let obj = actionTarget as? NSObject;
            obj?.perform(sel, with: [JHSCellKey.cell:self]);
        }
    }
    
    
}

// MARK: - 按照九宫格排列 图片

class JHSMutableImageCell: JHSGroupCell {
    
    var mutableImages: [UIImage]! {
        didSet{
            setNeedsLayout();
        }
    }
    var topHeight: CGFloat {
        if let model = entity as? JHSMutableImageModel {
            return model.supTopHeight;
        }
        return 0;
    }
    
    
    private var imageTag = 12345;

    override func configSubView() {
        backgroundColor = UIColor.white;
    }
    
    
    override func configMessage(model: JHSMessageModel) {
        super.configMessage(model: model);
        if let imgsModel = model as? JHSMutableImageModel {
            mutableImages = imgsModel.images;
        }
    }
    
    func getImageBy(index: Int,rect: CGRect) -> UIImageView {
        
        
        var img = viewWithTag(index + imageTag) as? UIImageView;
        if img == nil {
            
            img = createImageView();
            img?.tag = index + imageTag;
            img?.contentMode = .scaleAspectFill;
            img?.clipsToBounds = true;
        }
        if !rect.isNull {
            img?.frame = rect;
        }
        return img!;
    }
    
    override func addTarget(t: Any, sel: Selector) {
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        fetchImageIndex(touches, isEnd: false);
        
    }
    func fetchImageIndex(_ touches: Set<UITouch>,isEnd: Bool) -> Void {
        guard let point = touches.first?.location(in: self) else{
            return;
        }
        var index = -1;
        for idx in 0...8 {
            let rect = getImageBy(index: idx, rect: CGRect.null).frame;
            if !rect.isNull && rect.contains(point) {
                index = idx;
                break;
            }
        }
        if index != -1 ,let sel = selector , isEnd{
            let obs = actionTarget as? NSObject;
            obs?.perform(sel, with: [JHSCellKey.cell:self,JHSCellKey.imgIndex:index]);
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        fetchImageIndex(touches, isEnd: true);
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        fetchImageIndex(touches, isEnd: false);
    }

}
// MARK: - 只显示一张图片

class JHSImageCell: JHSGroupCell {
    
    var backImage: UIImageView!
    
    override func configMessage(model: JHSMessageModel) {
        super.configMessage(model: model);
        if let cModel = model as? JHSImageModel {
            backImage.image = cModel.image;
        }
    }
    
    
    override func configSubView() {
        backImage = createImageView(rect: .init(x: leftPointX, y: topPointY, width: 160, height: 200));
        addSubview(backImage);
        backImage.contentMode = .scaleAspectFill;
        backImage.clipsToBounds = true;
        
    }
}

class JHSVideoCell: JHSImageCell {
    var playFlag: UIImageView!
    override func configSubView() {
        super.configSubView();
        playFlag = createImageView(rect: .init(x:(backImage.width - 30)/2, y: (backImage.height-30)/2, width: 30, height: 30));
        playFlag.backgroundColor = UIColor.clear;
        backImage.addSubview(playFlag);
        playFlag.image = UIImage(named: "play_item");
    }
}

// MARK: -
// MARK: --------------------------------  JHSCell 自定义下的 view

// MARK: - 评论视图
class JHSCommentItemView: JHSBaseView {
    

    private var selecteItem: (model: JHSCommentItemModel,selectedRect: CGRect,selectedType:CommentItemSelectedType)?

    override func configSubView() {
        backgroundColor = UIColor.white;
        contentMode = .redraw;
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let point = touches.first!.location(in: self);
        
        for item in  comments{
            guard  let model = item.containsPoint(point: point) else{
                continue;
            }
            selecteItem = model;
            break;
        }
        if let drawRect = selecteItem?.selectedRect{
            setNeedsDisplay(drawRect);
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        selecteItem = nil;
        setNeedsDisplay();
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event);
    }
    
    fileprivate var comments: [JHSCommentModel]!{
        didSet{
            
            setNeedsDisplay();
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect);
        
        if comments == nil {
            return;
        }
        
        
        if let drawRect = selecteItem?.selectedRect {
            let context = UIGraphicsGetCurrentContext();
            context?.setFillColor(rgbColor(rgb: 224).cgColor);
            context?.addRect(drawRect);
            context?.fillPath();
        }else{
            
            let context = UIGraphicsGetCurrentContext();
            let path = CGMutablePath();
            path.move(to: CGPoint(x: 0, y: 10));
            path.addLine(to: CGPoint(x: 10, y: 10));
            path.addLine(to: CGPoint(x: 20, y: 0));
            path.addLine(to: CGPoint(x: 30, y: 10));
            path.addLine(to: CGPoint(x: width, y: 10));
            path.addLine(to: CGPoint(x: width, y: height));
            path.addLine(to: CGPoint(x: 0, y: height));
            path.addLine(to: CGPoint(x: 0, y: 10));
            context?.addPath(path);
            context?.setFillColor(rgbColor(rgb: 245).cgColor);
            context?.fillPath();
        }
        drawTextContent(rect: rect);
    }
    
    func drawTextContent(rect: CGRect) -> Void {
        
        var py: CGFloat = 14;
        
        for (_,item) in comments.enumerated() {
            
            let content = item.getContentText();
            let sRect = CGRect(x: 4, y: py, width: item.size.width, height: item.size.height);
            content.draw(with:  sRect, options: [.usesFontLeading,.usesLineFragmentOrigin], context: nil);
            py += item.size.height + 4;
            item.orgin = sRect.origin;
        }
    }
}

// MARK: - 显示链接的视图

class JHSLinkView: JHSBaseView {
    var leftImg: UIImageView!
    private var rightLabel: UILabel!
    
    var content: String!{
        didSet{
            rightLabel?.text = content;
            let size = rightLabel.sizeThatFits(CGSize(width: width - leftImg.maxX - 12, height: height));
            var rect = rightLabel.frame;
            rect.size = size;
            rect.origin.y = (height - size.height)/2;
            rightLabel.frame = rect;
        }
    }
    
    // height = 48
    override func configSubView() {
        
        backgroundColor = PengConfigParamter.textBackColor;
        leftImg = createImageView(rect: .init(x: 4, y: 4, width: 40, height: 40));
        leftImg.image = UIImage(named: "1.png");
        leftImg.contentMode = .scaleAspectFill;
        leftImg.clipsToBounds = true;
        
        rightLabel = createLabel(rect: .init(x: leftImg.maxX + 8, y: 0, width: width - leftImg.maxX - 12, height: 20), text: "");
        rightLabel.numberOfLines = 2;
        rightLabel.backgroundColor = UIColor.clear;
        rightLabel.font = PengConfigParamter.textFont;
        rightLabel.textColor = PengConfigParamter.textColor;
        
        
    }
    

   
}


// MARK: - 显示时间和点赞视图

class JHSOperationView: JHSBaseView {
    
    var leftTime: UILabel!
    var rightBar: UIButton!
    var rightLabel: UILabel!
    override func configSubView() {
        
        
        leftTime = createLabel(rect: .init(x: 0, y: 0, width: width/2, height: height), text: "3分钟前");
        leftTime.textColor = PengConfigParamter.textColor;
        leftTime.font = PengConfigParamter.textFont;
        
        
        rightLabel = createLabel(rect: .init(x: leftTime.maxX, y: 0, width: width/2, height: height), text: "点赞");
        rightLabel.textAlignment = .right;
        rightLabel.textColor = PengConfigParamter.textColor;
        rightLabel.font = PengConfigParamter.textFont;
        
        
    }
}

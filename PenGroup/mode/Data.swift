
//
//  Data.swift
//  PenGroup
//
//  Created by yaojinhai on 2019/3/21.
//  Copyright © 2019年 yaojinhai. All rights reserved.
//

import Foundation

func createData() -> [JHSMessageModel] {
    
    var list = [JHSMessageModel]();
    
    let text = JHSMessageModel(type: .text);
    text.contentText = """
    亚马逊已经或正在申请注册的品牌商标达到800余个
"""
    text.comment = createCommts();
    list.append(text);
    
    
    let image = JHSImageModel(type: .image);
    image.contentText = "2009年，亚马逊推出了自营家居用品。"
    list.append(image);
    image.comment = createCommts();
    
//
//    let mutableImage = JHSMutableImageModel(type: .mutableImage);
//    mutableImage.contentText = """
//    2009年，亚马逊推出了自营家居用品、电子产品品牌AmazonBasics，几年间便已占据近的电池在线市场份额。据订阅服务公司TJI数据，亚马逊目前已有138个自营品牌——此前Quartz报道称，。
//"""
//    mutableImage.comment = createCommts();
//    list.append(mutableImage);


//    let qiImg = JHSMutableImageModel(type: .mutableImage);
//    qiImg.contentText = """
//    2009年，亚马逊推出了自营家居用品。
//    """
//    qiImg.count = 7;
//    qiImg.comment = createCommts();
//    list.append(qiImg);
    
//    let wuImg = JHSMutableImageModel(type: .mutableImage);
//    wuImg.contentText = """
//    2009年，亚马逊推出了自营家居用品。
//    """
//    wuImg.count = 5;
//    wuImg.comment = createCommts();
//    list.append(wuImg);
    
    
    let sanImg = JHSMutableImageModel(type: .mutableImage);
    sanImg.contentText = """
    新华社法国尼斯3月24日电
    """
    sanImg.count = 3;
    sanImg.comment = createCommts();
    print("top = \(sanImg.supTopHeight)");
    list.append(sanImg);
    
    
    
    let link = JHSNewModel(type: .new);
    link.contentText = """
    2009年，亚马逊推出了自营家居用品。
    """
    link.comment = createCommts();
    list.append(link);
    
    
    let videoItem = JHSVideoModel.init(type: .video);
    videoItem.videoURL = "";
    list.append(videoItem);
    
    return list;
}


func createCommts() -> [JHSCommentModel] {
    var list = [JHSCommentModel]();
    
    let first = JHSCommentModel();
    let firstPerson = JHSCommentItemModel();
    firstPerson.name = "李四";
    firstPerson.id = "1";
    first.content = "素材天下（sucaitianxia）2007年7月成立";
    first.person = firstPerson;
    list.append(first);
    
    let second = JHSCommentModel();
    let secondPerson = JHSCommentItemModel();
    secondPerson.name = "小王";
    secondPerson.id = "2";
    second.person = secondPerson;
    let secondEnd = JHSCommentItemModel();
    secondEnd.name = "小李";
    secondEnd.id = "3";
    second.endPeseron = secondEnd;
    second.content = "素材天下是一个网站"
    
    list.append(second);
    
    
    return list;
}

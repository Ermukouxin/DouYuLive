//
//  CycleModel.swift
//  DouYuLive
//
//  Created by ZXC on 2018/10/27.
//  Copyright © 2018年 ZXC. All rights reserved.
//

import UIKit

@objcMembers
class CycleModel: NSObject {
    // MARK: - 定义属性
    // 标题
    var title : String = ""
    // 封面图片
    var pic_url : String = ""
    // 对应的直播房间
    var room : [String : Any]? {
        didSet {
            guard let room = room else { return }
            anchorModel = AnchorModel(dict: room)
        }
    }
    // MARK: - 定义模型属性
    var anchorModel : AnchorModel?
    
    // MARK: - 创建字典转模型的构造函数
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    // MARK: - 重写系统回调函数
    override func setValue(_ value: Any?, forUndefinedKey key: String) { }
    
    
    
}

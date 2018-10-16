//
//  AnchorModel.swift
//  DouYuLive
//
//  Created by ZXC on 2018/10/12.
//  Copyright © 2018年 ZXC. All rights reserved.
//

import UIKit
// 统一给成员属性加@objc，不加的话，转出来的模型的属性全部为空
@objcMembers
class AnchorModel: NSObject {
    // MARK: - 定义成员属性
    
    /// 房间id
    var room_id : Int = 0    
    
    /// 房间封面URL
    var vertical_src : String = ""
    
    /// 房间名称
    var room_name : String = ""
    
    /// 游戏名称
    var game_name : String = ""
    
    /// 是否是手机直播，0表示是电脑直播，1表示手机直播
    var isVertical : Int = 0
    
    /// 主播昵称
    var nickname : String = ""
    
    /// 在线观看人数
    var online : Int = 0
    
    /// 所在城市
    var anchor_city : String = ""
    
    
    
    // MARK: 定义字典转模型的构造函数
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
 
}

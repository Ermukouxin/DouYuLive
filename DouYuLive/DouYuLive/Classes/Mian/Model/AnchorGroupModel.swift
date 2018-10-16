//
//  AnchorGroupModel.swift
//  DouYuLive
//
//  Created by ZXC on 2018/10/11.
//  Copyright © 2018年 ZXC. All rights reserved.
//

import UIKit
// 统一给成员属性加@objc，不加的话，转出来的模型的属性全部为空
@objcMembers
class AnchorGroupModel: NSObject {
    // MARK: - 定义成员属性
    
    /// 组显示的图标URL
    var icon_url : String = "home_header_phone"
    /// 组的名称
    var tag_name : String = ""
    /// 组的id号
    var tag_id : Int = 0
    /// 房间列表
    // 利用属性监听器来模型化数据
    var room_list : [[String : Any]]? {
        didSet {
            guard let room_list = room_list else { return }
            for dict in room_list {
                let anchorModel = AnchorModel(dict: dict)
                self.anchorListModelArray.append(anchorModel)
            }
        }
    }
    

    
    // MARK: - 嵌套模型属性
    lazy var anchorListModelArray : [AnchorModel] = [AnchorModel]()
    
    
    // MARK: 定义字典转模型的构造函数
    init(dict : [String : Any]) {
        room_list = nil
        super.init()
        setValuesForKeys(dict)
    }
    
    // 重写了该方法，在外面使用AnchorModel()来创建本对象，才不会报错，因为下面在创建字典转模型的时候，重载了init方法，覆盖了
    override init() {
        super.init()
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    /*
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "room_list" {
            if let listArray = value as? [[String : Any]] {
                for dict in listArray {
                    let anchorModel = AnchorModel(dict: dict)
                    self.AnchorListModelArray.append(anchorModel)
                }
            }
            
        }
    }
    */
}

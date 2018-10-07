//
//  UIBarButtonItem-Extension.swift
//  DouYuLive
//
//  Created by ZXC on 2018/9/28.
//  Copyright © 2018年 ZXC. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    // MARK: 类方法 创建UIBarButtonItem
    
    class func createBarButtonItem (image : String, highImage : String, size : CGSize) -> UIBarButtonItem {
        let btn = UIButton()
        btn.setImage(UIImage(named: image), for: .normal)
        btn.setImage(UIImage(named: highImage), for: .highlighted)
        btn.frame = CGRect(origin: CGPoint.zero, size: size)

        return UIBarButtonItem(customView: btn)
    }
    
    
    // MARK: 创建便利构造函数 创建UIBarButtonItem

    // swift非常建议使用构造函数来创创建控件
    // 创建便利的构造函数，需要满足：1，以开头，2，构造函数内必须使用到一个明确的构造函数，使用self去调用
    convenience init(image : String, highImage : String = "", size : CGSize = CGSize(width: 0, height: 0)) {
        
        // 1, 创建button
        let itemBtn = UIButton()
        
        // 2,设置button图片
        itemBtn.setImage(UIImage(named: image), for: .normal)
        if highImage != "" {
            itemBtn.setImage(UIImage(named: highImage), for: .highlighted)
        }
        
        // 3,设置button尺寸
        if size == CGSize(width: 0, height: 0) {
            itemBtn.sizeToFit()
        } else {
            itemBtn.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        }
        
        // 4,创建UIBarButtonItem
        self.init(customView: itemBtn)
    }
    
    
}

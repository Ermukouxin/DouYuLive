//
//  CollectionViewPrettyCell.swift
//  DouYuLive
//
//  Created by ZXC on 2018/10/9.
//  Copyright © 2018年 ZXC. All rights reserved.
//

import UIKit

class CollectionViewPrettyCell: UICollectionViewCell {

    // MARK: - 控件属性
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var onlineButton: UIButton!
    
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var cityButton: UIButton!
    
    // MARK: - 定义模型属性
    var anchorModel : AnchorModel? {
        didSet {
            //1,校验模型
            guard let model = anchorModel else { return }
            
            //2,设置图片
            let iconURL = URL(string: model.vertical_src)
            iconImageView.kf.setImage(with: iconURL)
            
            //3,设置在线人数
            var onlineText : String = ""
            if model.online >= 10000 {
                onlineText = "\(model.online / 10000)万人在线"
            } else {
                onlineText = "\(model.online)人在线"
            }
            onlineButton.setTitle(onlineText, for: .normal)
            
            //4,昵称
            nickNameLabel.text = model.nickname
            
            //5,城市
            cityButton.setTitle(model.anchor_city, for: .normal)
            
        }
    }

}

//
//  CollectionViewGameCell.swift
//  DouYuLive
//
//  Created by ZXC on 2018/10/29.
//  Copyright © 2018年 ZXC. All rights reserved.
//

import UIKit
import Kingfisher
class CollectionViewGameCell: UICollectionViewCell {

    // MARK: - 控件属性
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    
    // MARK: - 定义模型属性
    var anchorGroupModel : AnchorGroupModel? {
        didSet {
            // 1，设置游戏名称
            nameLabel.text = anchorGroupModel?.tag_name
            // 2，设置游戏图片
            iconView.kf.setImage(with: URL(string: anchorGroupModel?.icon_url ?? ""), placeholder: UIImage(named: "home_more_btn"), options: nil, progressBlock: nil, completionHandler: nil)
        }
    }

}

//
//  CollectionHeaderView.swift
//  DouYuLive
//
//  Created by ZXC on 2018/10/9.
//  Copyright © 2018年 ZXC. All rights reserved.
//

import UIKit
import Kingfisher
class CollectionHeaderView: UICollectionReusableView {

    // MARK: - 定义属性
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var tagLabel: UILabel!
    
    var anchorGroup : AnchorGroupModel? {
        didSet {
            tagLabel.text = anchorGroup?.tag_name
            
            let iconURL = URL(string: (anchorGroup?.icon_url) ?? "")
            iconImageView.kf.setImage(with: iconURL, placeholder: UIImage(named: "home_header_normal"), options: nil, progressBlock: nil, completionHandler: nil)
        }
    }
    
}

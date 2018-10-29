//
//  RecommendCycleViewCell.swift
//  DouYuLive
//
//  Created by ZXC on 2018/10/16.
//  Copyright © 2018年 ZXC. All rights reserved.
//

import UIKit
import Kingfisher
class RecommendCycleViewCell: UICollectionViewCell {

    // MARK: - 控件属性
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - 定义模型属性
    var cycleModel : CycleModel? {
        didSet {
            titleLabel.text = cycleModel?.title
            iconImageView.kf.setImage(with: URL(string: cycleModel?.pic_url ?? ""), placeholder: UIImage(named: "Img_default"), options: nil, progressBlock: nil, completionHandler: nil)
        }
    }
    

}

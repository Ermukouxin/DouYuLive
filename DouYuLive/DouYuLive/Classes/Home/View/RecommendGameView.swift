//
//  RecommendGameView.swift
//  DouYuLive
//
//  Created by ZXC on 2018/10/29.
//  Copyright © 2018年 ZXC. All rights reserved.
//

import UIKit

// MARK: - 定义常量
private let kGameCellID = "kGameCellID"
private let kInsetMargin : CGFloat = 10
class RecommendGameView: UIView {
    
    // MARK: - 定义数据属性
    var anchorGroupModelArray : [AnchorGroupModel]? {
        didSet {
            // 1,移除热门和颜值数据
            anchorGroupModelArray?.removeFirst()
            anchorGroupModelArray?.removeFirst()
            // 2,添加最后的“更多”模型
            let moreGroupModel = AnchorGroupModel()
            moreGroupModel.tag_name = "更多"
            
            // 3,将“更多”模型添加到数组中
            anchorGroupModelArray?.append(moreGroupModel)
            
            // 4,刷新数据
            collectionView.reloadData()
        }
    }
    
    // MARK: - 控件属性
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 设置控件不随着父控件的变化而变化
        autoresizingMask = UIViewAutoresizing()
        
        // 注册cell
        collectionView.register(UINib(nibName: "CollectionViewGameCell", bundle: nil), forCellWithReuseIdentifier: kGameCellID)
        
        // 设置内边距
        collectionView.contentInset = UIEdgeInsets(top: 0, left: kInsetMargin, bottom: 0, right: kInsetMargin)
    }
}

// MARK: - 创建快速创建view的方法
extension RecommendGameView {
    class func gameView() -> RecommendGameView {
        return Bundle.main.loadNibNamed("RecommendGameView", owner: self, options: nil)?.last as! RecommendGameView
    }
}

// MARK: - 遵守CollectionView的数据源协议
extension RecommendGameView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return anchorGroupModelArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kGameCellID, for: indexPath) as! CollectionViewGameCell
        let groupModel = anchorGroupModelArray![indexPath.row]
        cell.anchorGroupModel = groupModel
        return cell
    }
}




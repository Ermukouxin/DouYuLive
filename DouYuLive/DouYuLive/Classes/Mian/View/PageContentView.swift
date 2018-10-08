//
//  PageContentView.swift
//  DouYuLive
//
//  Created by ZXC on 2018/10/8.
//  Copyright © 2018年 ZXC. All rights reserved.
//

import UIKit

// MARK: - 定义常量
let ContentCellID : String = "contentCellID"

class PageContentView: UIView {

    // MARK: - 定义属性
    private var childVCs : [UIViewController]
    private var parentViewController : UIViewController

    // MARK: - 懒加载属性
    private lazy var collectionView : UICollectionView = {
        // 1, 创建布局类layout
        var layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        // 2,创建UICollectionView
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.bounces = false // 禁止弹簧效果
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentCellID)
        
        return collectionView
    }()
    
    // MARK: - 自定义构造函数
    init(frame: CGRect, childVCs : [UIViewController], parentViewController : UIViewController) {
        self.childVCs = childVCs
        self.parentViewController = parentViewController
        super.init(frame: frame)
        
        // 设置UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - 设置UI
extension PageContentView {
    fileprivate func setupUI () {
        // 添加CollectionView
        addSubview(collectionView)
    }
}



extension PageContentView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVCs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1, 取出cell
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCellID, for: indexPath)
        
        // 2,防止多次添加,用视图层级结构来看，确保每次只显示一个子控制器的view在cell的contentView上，如果去掉这一步判断，就会出现两个子控制器的view添加在cell的contentView上面
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        // 3,设置cell
        let childVC = childVCs[indexPath.row]
        cell.contentView.addSubview(childVC.view)
        childVC.view.frame = self.bounds
        
        return cell
    }
}



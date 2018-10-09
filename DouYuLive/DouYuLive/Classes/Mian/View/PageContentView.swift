//
//  PageContentView.swift
//  DouYuLive
//
//  Created by ZXC on 2018/10/8.
//  Copyright © 2018年 ZXC. All rights reserved.
//

import UIKit
// MARK: - 定义协议代理
protocol PageContentViewDelegate : class {
    func pageContentView(contentView : PageContentView, sourceIndex : Int, targetIndex : Int, scrollProgress : CGFloat)
}
// MARK: - 定义常量
let ContentCellID : String = "contentCellID"

class PageContentView: UIView {

    // MARK: - 定义属性
    private var childVCs : [UIViewController]
    private weak var parentViewController : UIViewController?
    private var collectionViewStarOffset : CGFloat = 0
    weak var delegate : PageContentViewDelegate?
    private var isForbidScrollViewDelegatePerform : Bool = false

    // MARK: - 懒加载属性
    private lazy var collectionView : UICollectionView = { [weak self] in
        // 1, 创建布局类layout
        var layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        // 2,创建UICollectionView
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.bounces = false // 禁止弹簧效果
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentCellID)
        
        return collectionView
    }()
    
    // MARK: - 自定义构造函数
    init(frame: CGRect, childVCs : [UIViewController], parentViewController : UIViewController?) {
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


// MARK: - 遵守UICollectionViewDataSource
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

// MARK: - 遵守UICollectionViewDelegate
extension PageContentView : UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidScrollViewDelegatePerform = false // 拖动时，允许执行此代理方法
        collectionViewStarOffset  = collectionView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 0, 判断是否是点击造成的滚动，如果是点击造成的滚动，直接返回
        if isForbidScrollViewDelegatePerform { return }
        
        // 1,定义需要获取的数据
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
        var scrollProgress : CGFloat = 0.0
        
        
        // 2,判断是左滑还是右滑
        let collectionViewCurrentOffset = scrollView.contentOffset.x
        let scrollViewW = scrollView.frame.width
        
        if collectionViewCurrentOffset > collectionViewStarOffset  { // 左滑
            // 1,计算scrollProgress
            scrollProgress = collectionViewCurrentOffset / scrollViewW - floor(collectionViewCurrentOffset / scrollViewW)
            
            // 2,计算sourceIndex
            sourceIndex = Int(collectionViewCurrentOffset / scrollViewW)
            
            // 3,计算targetIndex
            targetIndex = sourceIndex + 1
            if targetIndex >= childVCs.count {
                targetIndex = childVCs.count - 1
            }
            
            if collectionViewCurrentOffset - collectionViewStarOffset == scrollViewW {
                scrollProgress = 1.0
                targetIndex = sourceIndex
            }
            
        } else { // 右滑
            // 1,计算scrollProgress
            scrollProgress = 1 - (collectionViewCurrentOffset / scrollViewW - floor(collectionViewCurrentOffset / scrollViewW))
            
            // 2,计算targetIndex
            targetIndex = Int(collectionViewCurrentOffset / scrollViewW)
            
            // 3,计算sourceIndex
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVCs.count {
                sourceIndex = childVCs.count - 1
            }
        }
        
        // 3,将sourceIndex， targetIndex， scrollProgress传递给pageTitleView
        delegate?.pageContentView(contentView: self, sourceIndex: sourceIndex, targetIndex: targetIndex, scrollProgress: scrollProgress)
    }
}


// MARK: - 对外暴露的方法
extension PageContentView {
    func setCurrentIndex(currentIndex : Int) {
        // 禁止点击titleLabel触发执行scrollView的代理
        isForbidScrollViewDelegatePerform = true
        
        let offset = CGFloat(currentIndex) * bounds.width
        collectionView.setContentOffset(CGPoint(x: offset, y: 0), animated: false)
    }
}

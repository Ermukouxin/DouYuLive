//
//  RecommendCycleView.swift
//  DouYuLive
//
//  Created by ZXC on 2018/10/16.
//  Copyright © 2018年 ZXC. All rights reserved.
//

import UIKit

// MARK: - 定义常量
private let kCycleCellID : String = "kCycleCellID"

class RecommendCycleView: UIView {
    
    // MARK: - 控件属性
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageView: UIPageControl!
    
    // MARK: - 定义属性
    var cycleTimer : Timer?// 定义timer
    var cycleModelArray : [CycleModel]? {
        didSet {
            // 1，刷新集合视图
            self.collectionView.reloadData()
            // 2，设置pageView
            self.pageView.numberOfPages = cycleModelArray?.count ?? 0
            // 3，设置默认滚动到中间某个位置，使得轮播图往前滚动也是有内容的了
            let index = NSIndexPath(item: (cycleModelArray?.count ?? 0) * 10, section: 0)
            self.collectionView.scrollToItem(at: index as IndexPath, at: .left, animated: false)
            // 4，添加定时器
            removeTimer()// 为了防止错乱，添加之前先移除定时器
            addTimer()
        }
    }
    
    
    // MARK: - 系统回调方法
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 设置本控件不随着父控件的尺寸变化而变化
        // 如果没有设置的，子控件就会随着父控件尺寸变化而变化，最终会缩小到看不见的视图
        autoresizingMask = UIViewAutoresizing()
        
        // 注册cell
        //collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kCellID)
        collectionView.register(UINib(nibName: "RecommendCycleViewCell", bundle: nil), forCellWithReuseIdentifier: kCycleCellID)
          
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 设置flowLayout
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.isPagingEnabled = true
    }
}

// MARK: - 加载xib
extension RecommendCycleView{
    class func recommendCycleView() -> RecommendCycleView {
        return Bundle.main.loadNibNamed("RecommendCycleView", owner: nil, options: nil)?.first as! RecommendCycleView
    }
}

// MARK:- CollectionView数据源协议方法
extension RecommendCycleView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 有6万个item，基本不会滚完了
        return (cycleModelArray?.count ?? 0) * 10000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCycleCellID, for: indexPath) as! RecommendCycleViewCell
        let cycleModel = cycleModelArray![(indexPath.row % (cycleModelArray?.count)!)]
        cell.cycleModel = cycleModel
        return cell
    }
    
}
// MARK: - CollectionView的代理协议方法
extension RecommendCycleView : UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 1,获取滚动的偏移量
        let offsetX = scrollView.contentOffset.x + scrollView.bounds.width * 0.5
        // 2,设置pageController的page
        pageView.currentPage = Int(offsetX / scrollView.bounds.width) % (cycleModelArray?.count ?? 1) // 如果count==0，就返回1，因为不能对0取模
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeTimer()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addTimer()
    }
}

// MARK: - 对定时器的操作的方法
extension RecommendCycleView {
    private func addTimer() {
        cycleTimer = Timer(timeInterval: 3, target: self, selector: #selector(scrollToNext), userInfo: nil, repeats: true)
        RunLoop.main.add(cycleTimer!, forMode: .commonModes)
    }
    private func removeTimer() {
        cycleTimer?.invalidate()// 从循环中移除
        cycleTimer = nil // 置空定时器
    }
    @objc func scrollToNext() {
        let currentOffsetX = collectionView.contentOffset.x
        let nextOffsetX = currentOffsetX + collectionView.bounds.width
        collectionView.setContentOffset(CGPoint(x: nextOffsetX, y: 0), animated: true)
    }
}



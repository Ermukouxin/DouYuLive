//
//  RecommendViewController.swift
//  DouYuLive
//
//  Created by ZXC on 2018/10/9.
//  Copyright © 2018年 ZXC. All rights reserved.
//

import UIKit

// MARK: - 定义常量
private let kItemMargin : CGFloat = 10
private let kItemW : CGFloat = (kScreenW - 3 * kItemMargin) / 2
private let kNormalItemH : CGFloat = kItemW * 3 / 4
private let kPrettyItemH : CGFloat = kItemW * 4 / 3

private let kHeaderH : CGFloat = 50
private let kCycleViewH : CGFloat = kScreenW * 3 / 8
private let kGameViewH : CGFloat = 90

private let kNormalCellID : String = "kNormalCellID"
private let kPrettyCellID : String = "kPrettyCellID"
private let kHeaderViewID : String = "kHeaderViewID"

class RecommendViewController: UIViewController {

    // MARK: - 懒加载属性
    private lazy var recommendVM : RecommendViewModel = RecommendViewModel()
    private lazy var recommendCycleView : RecommendCycleView = {
        let cycleView = RecommendCycleView.recommendCycleView()
        cycleView.frame = CGRect(x: 0, y: -(kCycleViewH + kGameViewH), width: kScreenW, height: kCycleViewH)
        return cycleView
    }()
    private lazy var recommendGameView : RecommendGameView = {
        let gameView = RecommendGameView.gameView()
        gameView.frame = CGRect(x: 0, y: -kGameViewH, width: kScreenW, height: kGameViewH)
        return gameView
    }()
    private lazy var collectionView : UICollectionView = { [weak self] in
        // 1.创建布局类
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = kItemMargin
        layout.headerReferenceSize = CGSize(width: kScreenW, height: kHeaderH)
        layout.sectionInset = UIEdgeInsets(top: 0, left: kItemMargin, bottom: 0, right: kItemMargin)
        
        // 2.创建CollectionView
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // 开始拿到的view.bounds是整一个屏幕的尺寸，设置了这个属性，子控件就可以随着父控件的尺寸变化而变化了
        
        // 3.注册cell
        collectionView.register(UINib(nibName: "CollectionViewNormalCell", bundle: nil), forCellWithReuseIdentifier: kNormalCellID)
        collectionView.register(UINib(nibName: "CollectionViewPrettyCell", bundle: nil), forCellWithReuseIdentifier: kPrettyCellID)

        // 4.注册header
        //collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kHeaderViewID)
        collectionView.register(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kHeaderViewID)
        
        return collectionView
    }()
    
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置UI
        setupUI()
        
        // 请求数据
        loadData()
    }

  
}

// MARK: - 设置UI界面
extension RecommendViewController {
    private func setupUI() {
        //1.添加collectionview
        view.addSubview(collectionView)
        
        //2,添加录播图到collectionView上
        collectionView.addSubview(recommendCycleView)
        
        //3,添加gameView
        collectionView.addSubview(recommendGameView)
        
        //4,设置collectionView的inset，使得cycleView可以显示出来
        // 这种设置方法，及时collectionView加了头部视图，还可以在头部视图上面加上其他的视图
        collectionView.contentInset = UIEdgeInsetsMake(kCycleViewH + kGameViewH, 0, 0, 0)
    }
}

// MARK: - 请求网络数据
extension RecommendViewController {
    func loadData() {
        // 1,请求推荐数据
        recommendVM.requestData {
            // a,刷新表格
            self.collectionView.reloadData()
            // b,将数据传给gameView
            self.recommendGameView.anchorGroupModelArray = self.recommendVM.anchorGroupModelArray
        }
        // 2,请求轮播图数据
        recommendVM.retquetCycleData {
            print("请求到数据了")
            self.recommendCycleView.cycleModelArray = self.recommendVM.cycleModelArray
        }
        
    }
}

// MARK: - 遵守UICollectionViewDataSource
extension RecommendViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.recommendVM.anchorGroupModelArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let group = recommendVM.anchorGroupModelArray[section]
        return group.anchorListModelArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1,取出对应的anchorModel
        let groupModel = recommendVM.anchorGroupModelArray[indexPath.section]
        let anchorModel = groupModel.anchorListModelArray[indexPath.row]
        
        
        //2,取出不同类型的cell
        if indexPath.section == 1 {
            let prettyCell = collectionView.dequeueReusableCell(withReuseIdentifier: kPrettyCellID, for: indexPath) as! CollectionViewPrettyCell
            prettyCell.anchorModel = anchorModel
            return prettyCell
        } else {
            let normalCell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellID, for: indexPath) as! CollectionViewNormalCell
            normalCell.anchorModel = anchorModel
            return normalCell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // 1.取出headerView
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHeaderViewID, for: indexPath) as! CollectionHeaderView
        headerView.anchorGroup = self.recommendVM.anchorGroupModelArray[indexPath.section]
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1 {
            return CGSize(width: kItemW, height: kPrettyItemH)
        }
        
        return CGSize(width: kItemW, height: kNormalItemH)
    }
}









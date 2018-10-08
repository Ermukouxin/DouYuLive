//
//  PageTitleView.swift
//  DouYuLive
//
//  Created by ZXC on 2018/10/7.
//  Copyright © 2018年 ZXC. All rights reserved.
//

import UIKit

// MARK: 定义常量
let kScrollViewLineH : CGFloat = 2.0


class PageTitleView: UIView {

    // MARK: 定义属性
    private var titlesArray : [String]
    
    // MARK: 懒加载属性
    private lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        // 如果要做点击导航栏回弹到顶部的功能，其他的scrollView都必须设置为false
        scrollView.scrollsToTop = false
        
        scrollView.frame = bounds
        
        return scrollView
    }()
    
    private lazy var titleLabelsArray : [UILabel] = [UILabel]()
    
    private lazy var scrollViewLine : UIView = {
        let scrollViewLine = UIView()
        scrollViewLine.backgroundColor = UIColor.orange
        return scrollViewLine
    }()
    
    // MARK: 自定义构造函数
    init(frame: CGRect, titlesArray : [String]) {
        self.titlesArray = titlesArray
        super.init(frame: frame)
        
        // 设置UI
        setUpUI()
    }
    // 自定义构造函数必须实现的一个方法
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PageTitleView {
    private func setUpUI () {
        // 1, 添加scrollView
        addSubview(scrollView)
        
        // 2, 添加titleLabel
        setUpTitleLabels ()
        
        // 3,添加底部分割线以及滚动指示视图
        setUpBottomLineAndScrollIndicator ()
    }
    
    
    private func setUpTitleLabels () {
        
        let labelW : CGFloat = frame.width / CGFloat(titlesArray.count)
        let labelH : CGFloat = frame.height - kScrollViewLineH
        let labelY : CGFloat = 0
        for (index, title) in titlesArray.enumerated() {
            // 1,创建label
            let label = UILabel()
            
            // 2, 设置label属性
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.textColor = UIColor.darkGray
            label.textAlignment = .center
            label.text = title
            label.tag = index
            
            // 3, 设置label的frame
            let labelX : CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            // 4, 添加到scrollView上
            scrollView.addSubview(label)
            
            titleLabelsArray.append(label)
        }
    }

    private func setUpBottomLineAndScrollIndicator () {
        // 1,创建设置BottomLine
        let bottomLine : UIView = UIView()
        bottomLine.backgroundColor = UIColor.darkGray
        let bottomLineH : CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height - bottomLineH, width: frame.width, height: bottomLineH)
        addSubview(bottomLine)
        
        // 2,创建设置ScrollIndicator
        scrollView.addSubview(scrollViewLine)
        guard let firstLabel = titleLabelsArray.first else { return }
        firstLabel.textColor = UIColor.orange
        scrollViewLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kScrollViewLineH, width: firstLabel.frame.width, height: kScrollViewLineH)
    }
}




//
//  PageTitleView.swift
//  DouYuLive
//
//  Created by ZXC on 2018/10/7.
//  Copyright © 2018年 ZXC. All rights reserved.
//

import UIKit

// MARK: - 定义协议
protocol PageTitleViewDelegate : class {
    func pageTitleView(titleView : PageTitleView, selectIndex index : Int)
}

// MARK: 定义常量
private let kScrollViewLineH : CGFloat = 2.0
private let kLabelTextNormalColor : (CGFloat, CGFloat, CGFloat) = (85, 85, 85)
private let kLabelTextSelectColor : (CGFloat, CGFloat, CGFloat) = (255, 128, 0)

class PageTitleView: UIView {

    // MARK: 定义属性
    private var currentLableIndex : Int = 0
    private var titlesArray : [String]
    weak var delegate : PageTitleViewDelegate? // 定义代理属性，weak修饰
    
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
            label.textColor = UIColor(r: kLabelTextNormalColor.0, g: kLabelTextNormalColor.1, b: kLabelTextNormalColor.2)
            label.textAlignment = .center
            label.text = title
            label.tag = index
            
            // 3, 设置label的frame
            let labelX : CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            // 4, 添加到scrollView上
            scrollView.addSubview(label)
            
            // 5, 给label添加手势
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick(tapGes:)))
            label.addGestureRecognizer(tapGes)
            
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
        firstLabel.textColor = UIColor(r: kLabelTextSelectColor.0, g: kLabelTextSelectColor.1, b: kLabelTextSelectColor.2)
        scrollViewLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kScrollViewLineH, width: firstLabel.frame.width, height: kScrollViewLineH)
    }
}
// MARK: - label的点击事件
extension PageTitleView {
    @objc private func titleLabelClick(tapGes : UITapGestureRecognizer) {
                
        // 1,获取当前点击的label
        guard let currentLabel = tapGes.view as? UILabel else { return }
        
        // 2,获取之前保存的label
        let oldLabel = titleLabelsArray[currentLableIndex]
        
        // 3,label状态的切换
        if currentLabel == oldLabel { return }
        oldLabel.textColor = UIColor(r: kLabelTextNormalColor.0, g: kLabelTextNormalColor.1, b: kLabelTextNormalColor.2)
        currentLabel.textColor = UIColor(r: kLabelTextSelectColor.0, g: kLabelTextSelectColor.1, b: kLabelTextSelectColor.2)
        
        // 4,更新最新的label的tag
        currentLableIndex = currentLabel.tag

        // 5,底部指示器视图的滑动， 执行动画
        let scrollLineX = CGFloat(currentLableIndex) * currentLabel.frame.width
        UIView.animate(withDuration: 0.15) {
            self.scrollViewLine.frame.origin.x = scrollLineX
        }
        
        // 6,通知代理
        delegate?.pageTitleView(titleView: self, selectIndex: currentLableIndex)
    }
}

// MARK: - 对外暴露的方法
extension PageTitleView {
    func setTitleViewWithScrollProgress(scrollProgress : CGFloat, sourceIndex : Int, targetIndex : Int) {
        
        // 1,获取对应的label
        let sourceLabel = titleLabelsArray[sourceIndex]
        let targetLabel = titleLabelsArray[targetIndex]

        // 2,计算滑块需要移动的距离
        let totalMoveX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let needMoveX = totalMoveX * scrollProgress
        
        // 3,设置滑块的frame
        scrollViewLine.frame.origin.x = sourceLabel.frame.origin.x + needMoveX
        
        // 4,设置titleLabel的颜色渐变
        // 4.1 计算颜色渐变的范围
        let deltaColor = (kLabelTextSelectColor.0 - kLabelTextNormalColor.0, kLabelTextSelectColor.1 - kLabelTextNormalColor.1, kLabelTextSelectColor.2 - kLabelTextNormalColor.2)
        
        // 4.2 计算sourceLabel渐变
        sourceLabel.textColor = UIColor(r: kLabelTextSelectColor.0 - deltaColor.0 * scrollProgress, g: kLabelTextSelectColor.1 - deltaColor.1 * scrollProgress, b: kLabelTextSelectColor.2 - deltaColor.2 * scrollProgress)
        
        // 4.3 计算targetLabel渐变
        targetLabel.textColor = UIColor(r: kLabelTextNormalColor.0 + deltaColor.0 * scrollProgress, g: kLabelTextNormalColor.1 + deltaColor.1 * scrollProgress, b: kLabelTextNormalColor.2 + deltaColor.2 * scrollProgress)
        
        // 5,记录最新的index
        currentLableIndex = targetIndex
    }
}



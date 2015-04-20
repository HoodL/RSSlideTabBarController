//
//  RSSlideTabBarController.swift
//  RSSlideTabBarController
//
//  Created by UGolf_Reese on 15/4/20.
//  Copyright (c) 2015年 reese. All rights reserved.
//

import UIKit

private let _StatusBarHeight: CGFloat = 20.0
private let _TabBarHeight: CGFloat = 44.0
private let _MarginOfIndicateView: CGFloat = 0.0

let _DefaultWidthOfCell: CGFloat = 52.0


class RSSlideTabBarController: UIViewController, UIScrollViewDelegate{

    
    var itemWidth: CGFloat = _DefaultWidthOfCell
    var tintColor: UIColor! = UIColor.blueColor()
    var titleColor: UIColor! = UIColor.blackColor()
    var itemsCount: Int {
        return self.titles == nil ? 0 : self.titles.count
    }
    var selectIndex: Int? {
        didSet {
            self.oldSelectIndex = oldValue
            
            if let oldSelectIndex = self.oldSelectIndex {
                if let oldSelectBtn = self.cellForTag(oldSelectIndex) {
                    oldSelectBtn.selected = false
                }
            }
            
            if let newSelectIndex = self.selectIndex {
                
                if !self.isDraggingContent && !self.isDeceleratingContent {
                    self.contentScrollView.setContentOffset(CGPointMake(self.contentWidth * CGFloat(self.selectIndex!), 0), animated: true)
                }
                
                if let newSelectBtn = self.cellForTag(newSelectIndex) {
                    newSelectBtn.selected = true
                }
                
                let newViewController = viewControllers[newSelectIndex]
                newViewController.viewDidLoad()
                let newContentView = newViewController.view
                if newContentView.superview == self.contentScrollView {
                
                }
                else {
                    newViewController.viewWillAppear(true)
                    var frame = newContentView.frame
                    frame.origin.x = self.contentWidth * CGFloat(newSelectIndex)
                    newContentView.frame = frame
                    self.contentScrollView.addSubview(newContentView)
                    newViewController.viewDidAppear(true)
                }
            }
        }
    }
    var oldSelectIndex: Int?
    
    var leftView: UIView? {
        willSet {
            if let view = self.leftView {
                view.removeFromSuperview()
                
                var tabframe = self.tabBarScrollView.frame
                tabframe.origin.x -= view.frame.size.width
                tabframe.size.width += view.frame.size.width
                self.tabBarScrollView.frame = tabframe
                
                var indexframe = self.indexView.frame
                indexframe.origin.x -= view.frame.size.width
                self.indexView.frame = indexframe
                self.indexViewOriginX = self.indexView.frame.origin.x
            }
        }
        didSet {
            if let view = self.leftView {
                
                view.frame = CGRectMake(0, _StatusBarHeight, _TabBarHeight, _TabBarHeight)

                var tabframe = self.tabBarScrollView.frame
                tabframe.origin.x += view.frame.size.width
                tabframe.size.width -= view.frame.size.width
                self.tabBarScrollView.frame = tabframe
                
                var indexframe = self.indexView.frame
                indexframe.origin.x += view.frame.size.width
                self.indexView.frame = indexframe
                self.view.addSubview(view)
                self.indexViewOriginX = self.indexView.frame.origin.x
            }
        }
    }
    
    var rightView: UIView? {
        willSet {
            if let view = self.rightView {
                view.removeFromSuperview()
                
                var tabframe = self.tabBarScrollView.frame
                tabframe.size.width += view.frame.size.width
                self.tabBarScrollView.frame = tabframe
            }
        }
        didSet {
            if let view = self.rightView {
                view.frame = CGRectMake(self.view.frame.width-_TabBarHeight, _StatusBarHeight, _TabBarHeight, _TabBarHeight)
                
                var tabframe = self.tabBarScrollView.frame
                tabframe.size.width -= view.frame.size.width
                self.tabBarScrollView.frame = tabframe
                
                self.view.addSubview(view)
            }
        }
    }
    
    private var titles: [String]!
    private var viewControllers: [UIViewController]!
    
    
    private var tabBarScrollView: UIScrollView!
    private var indexView: UIView!
    private var contentScrollView: UIScrollView!
    
    private var contentWidth: CGFloat {
        return self.view.frame.width
    }
    
    private var contentHeight: CGFloat {
        return self.view.frame.height - _StatusBarHeight - _TabBarHeight
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - private methods
    
    private func setup() {
    
        self.tabBarScrollView = UIScrollView()
        self.tabBarScrollView.frame = CGRectMake(0, _StatusBarHeight, self.view.frame.width, _TabBarHeight)
        self.tabBarScrollView.showsHorizontalScrollIndicator = false
        self.tabBarScrollView.showsVerticalScrollIndicator = false
        self.tabBarScrollView.bounces = false
        self.tabBarScrollView.delegate = self
        self.view.addSubview(self.tabBarScrollView)
        
        self.indexView = UIView()
        self.indexView.frame = CGRectMake(0, 0, self.itemWidth, _TabBarHeight)
        let indicateView = UIView()
        let indicateViewOriginY = self.tabBarScrollView.frame.origin.y + _TabBarHeight - 3
        indicateView.frame = CGRectMake(_MarginOfIndicateView, indicateViewOriginY, CGFloat(self.itemWidth)-_MarginOfIndicateView*2, 3)
        indicateView.backgroundColor = self.tintColor
        self.indexView.addSubview(indicateView)
        self.view.addSubview(self.indexView)
        
        let underLine = UIView()
        let underLineOriginY = self.tabBarScrollView.frame.origin.y + self.tabBarScrollView.frame.height - 1
        underLine.frame = CGRectMake(0, underLineOriginY, self.view.frame.width, 1)
        underLine.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
        self.view.addSubview(underLine)
        
        
        self.contentScrollView = UIScrollView()
        self.contentScrollView.frame = CGRectMake(0, self.tabBarScrollView.frame.origin.y + self.tabBarScrollView.frame.height, self.contentWidth, self.contentHeight)
        self.contentScrollView.showsHorizontalScrollIndicator = false
        self.contentScrollView.showsVerticalScrollIndicator = false
        self.contentScrollView.bounces = false
        self.contentScrollView.delegate = self
        self.contentScrollView.pagingEnabled = true
        self.view.addSubview(self.contentScrollView)
        
        
    }
    
    func onItemClick(sender: UIButton) {
        self.selectIndex = sender.tag
    }
    
    private func cellForTag(tag: Int) -> UIButton? {
        if let btn = self.tabBarScrollView.subviews.filter({ ($0 as! UIView).tag == tag}).first as? UIButton {
            return btn
        }
        return nil
    }
    
    
    // MARK: - public methods
    
    func setTitles(titles: [String], viewControllers: [UIViewController]) {
    
        assert(titles.count == viewControllers.count, "titles count not equal vc count")

        self.titles = titles
        self.viewControllers = viewControllers
        
        
        /* set tabBarItem */
        
        for tabItem in self.tabBarScrollView.subviews {
            if let itemView = tabItem as? UIView {
                itemView.removeFromSuperview()
            }
        }
        
        var tabItemOffset: CGFloat = 0.0
        for i in 0..<self.itemsCount {
            
            let title = UIButton()
            title.setTitle(titles[i], forState: UIControlState.Normal)
            title.setTitleColor(self.titleColor, forState: UIControlState.Normal)
            title.setTitleColor(self.tintColor, forState: UIControlState.Selected)
            title.titleLabel!.font = UIFont.systemFontOfSize(14.0)
            title.tag = i
            title.addTarget(self, action: "onItemClick:", forControlEvents: UIControlEvents.TouchUpInside)
            title.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
            title.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
            title.sizeToFit()
            var frame = title.frame
            frame.origin.x = tabItemOffset
            frame.size.width = self.itemWidth
            frame.size.height = _TabBarHeight
            title.frame = frame
            self.tabBarScrollView.addSubview(title)
            
            tabItemOffset += self.itemWidth
        }
        self.tabBarScrollView.contentSize = CGSizeMake(tabItemOffset, _TabBarHeight)
        
        
        /* set content */
        self.contentScrollView.contentSize = CGSizeMake(self.contentWidth * CGFloat(self.viewControllers.count), self.contentHeight)
        
        
        if titles.count > 0 {
            self.selectIndex = 0
        }
        
    }
    

    
    // MARK: - scroll view delegate 
    
    private var isDraggingContent: Bool = false
    private var isDeceleratingContent: Bool = false
    private var tabBarLastOffset: CGFloat = 0.0
    private var indexViewOriginX: CGFloat = 0.0
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        if self.tabBarScrollView == scrollView {
            
        }
        else{
            self.isDraggingContent = true
            self.isDeceleratingContent = false
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if self.tabBarScrollView == scrollView && !self.isDraggingContent && !self.isDeceleratingContent{
            
            /* tabBar滚动时 索引随着移动 */
            var indexFrame = self.indexView!.frame
            indexFrame.origin.x -= self.tabBarScrollView.contentOffset.x - self.tabBarLastOffset
            self.indexView!.frame = indexFrame
            self.tabBarLastOffset = self.tabBarScrollView.contentOffset.x
            
        }
        else {
            if self.isDeceleratingContent {
                if self.contentScrollView.contentOffset.x > self.contentWidth * CGFloat(self.selectIndex!) + self.contentWidth / 2 {
                    self.selectIndex!++
                }
                else if self.contentScrollView.contentOffset.x < self.contentWidth * CGFloat(self.selectIndex!) - self.contentWidth / 2 {
                    self.selectIndex!--
                }
            }
            
            
            let itemsCount = CGFloat(self.itemsCount)
            let tabBarWidth = self.tabBarScrollView.frame.size.width
            let indexViewMaxOffset = tabBarWidth / itemsCount
            let percentOfContentOffset = self.contentScrollView.contentOffset.x / self.contentScrollView.contentSize.width
            
            /* 索引偏移 */
            var indexframe = self.indexView.frame
            indexframe.origin.x = indexViewOriginX + (tabBarWidth - (itemWidth - indexViewMaxOffset)) * percentOfContentOffset
            self.indexView.frame = indexframe
            
            /* tabBar偏移 */
            let tabBarContentOffset = (self.tabBarScrollView.contentSize.width - tabBarWidth + (itemWidth - indexViewMaxOffset)) * percentOfContentOffset
            self.tabBarScrollView.contentOffset = CGPointMake(tabBarContentOffset, 0)
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if self.tabBarScrollView == scrollView {
            
        }
        else{
            self.isDraggingContent = false
            self.isDeceleratingContent = true
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        self.tabBarLastOffset = self.tabBarScrollView.contentOffset.x
        
        if self.tabBarScrollView == scrollView {
            
        }
        else{
            self.isDeceleratingContent = false
        }
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        
        self.tabBarLastOffset = self.tabBarScrollView.contentOffset.x
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

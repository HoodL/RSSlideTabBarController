//
//  ViewController.swift
//  RSSlideTabBarController
//
//  Created by UGolf_Reese on 15/4/20.
//  Copyright (c) 2015年 reese. All rights reserved.
//

import UIKit

class ViewController: RSSlideTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let titles = ["最新", "快报", "视频", "新闻", "评测", "导购", "行情", "用车", "技术", "文化", "改装", "游记", "说客"]
        var viewControllers = [UIViewController]()
        for i in 0..<titles.count {
            let vc = UIViewController()
            let label = UILabel()
            label.frame = CGRectMake(150, 220, 32, 24)
            label.text = String(i)
            vc.view.addSubview(label)
            viewControllers.append(vc)
        }
        
        self.setTitles(titles, viewControllers: viewControllers)
        
//        self.leftView = UIView()
//        self.leftView!.backgroundColor = UIColor.purpleColor()
//        self.rightView = UIView()
//        self.rightView!.backgroundColor = UIColor.redColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


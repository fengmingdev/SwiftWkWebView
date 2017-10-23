//
//  UIBarButtonItem.swift
//  WKWebViewSwift
//
//  Created by XiaoFeng on 2017/10/20.
//  Copyright © 2017年 XiaoFeng. All rights reserved.
//

import UIKit

///MARK: 分类方法 可以提取到别处使用
extension UIBarButtonItem {
    /// 创建 UIBarButtonItem
    ///
    /// - parameter title:    title
    /// - parameter image:     图片
    /// - parameter imageH:   高亮图
    /// - parameter target:   target
    /// - parameter action:   action
    ///
    /// - returns: UIBarButtonItem
    convenience init(title: String?,image:String?,imageH:String? ,target: AnyObject?, action: Selector) {
        
        let backItemImage = UIImage.init(named: image ?? "")
        let backItemHlImage = UIImage.init(named: imageH ?? "")
        
        let backButton = UIButton.init(type: .system)
        
        backButton .setTitle(title, for: .normal)
        
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        
        backButton .setImage(backItemImage, for: .normal)
        backButton .setImage(backItemHlImage, for: .highlighted)
        
        if #available(iOS 11.0, *) {
            backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -15,0, 0);
            backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -15,0, 0);
        }
        backButton.sizeToFit()
        backButton.addTarget(target, action: action, for: .touchUpInside)
        
        self.init(customView: backButton)
    }
}

//
//  ViewController.swift
//  WKWebViewSwift
//
//  Created by XiaoFeng on 2017/1/5.
//  Copyright © 2017年 XiaoFeng. All rights reserved.
//  QQ群:384089763 欢迎加入
//  github链接:https://github.com/XFIOSXiaoFeng/SwiftWkWebView

import UIKit
import WebKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

}
extension ViewController {


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            
            let webView = WKWebViewController()
            webView.rightBarButtonItemTitle = "刷新"
            webView.rightBarButtonItemTag = "road"
            webView.delegate = self
            
            webView.load_UrlSting(string: "http://www.myei.cc/play/24892/1/35.html")
            navigationController?.pushViewController(webView, animated: true)
            
        case 1:
            
            let webView = WKWebViewController()
            
            webView.load_HTMLSting(string: "test")
            webView.addJavaScriptAry = ["valueName"]
            
            webView.add_rightBarButtonItem(title: "测试", image: nil, imageH: nil, itemTag: "right")
            
            webView.delegate = self
            
            navigationController?.pushViewController(webView, animated: true)
            
        case 2:
            let webView = WKWebViewController()
            
            let url = "https://www.xxxxxx.com"
            
            let postDict = ["user":"xiaofeng","age":24,"hight":166] as [String : Any]

            webView.load_POSTUrlSting(string: url, postString: postDict)
            navigationController?.pushViewController(webView, animated: true)
            
        default:break
        }
        
    }
}

extension ViewController:WKWebViewDelegate{

    func didSelectRightItem(webView: WKWebView, itemTag: String) {
        print("点击了右边按钮")
        if itemTag == "road" {
            webView.reload()
        }
    }
    
    func didRunJavaScript(webView: WKWebView, result: Any?, error: Error?) {
        print("执行JS结果")
    }
    
    func didAddScriptMessage(webView: WKWebView, message: WKScriptMessage) {
        print("=====\(message.body)")
    }
}

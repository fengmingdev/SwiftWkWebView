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

class ViewController: UIViewController {

    @IBOutlet weak var webView: WebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        self.automaticallyAdjustsScrollViewInsets = false
        
        // 配置webView样式
        var config = WkwebViewConfig()
        config.isShowScrollIndicator = false
        config.isProgressHidden = false
        
        webView.delegate = self
        
        // 加载普通URL
        webView.webConfig = config
        webView.webloadType(self, .URLString(url: "https://www.baidu.com"))
        
        // 加载本地URL
//        config.scriptMessageHandlerArray = ["valueName"]
//        webView.webConfig = config
//        webView.delegate = self
//        webView.webloadType(self, .HTMLName(name: "test"))
//
        // POST加载
//        let mobile = ""
//        let pop = ""
//        let auth = ""
//        let param = ["mobile":"\(mobile)","pop":"\(pop)","auth":"\(auth)"];
//        webView.webConfig = config
//        webView.webloadType(self, .POST(url: "http://xxxxx", parameters: param))
        
    }
    @IBAction func refreshClick(_ sender: UIBarButtonItem) {
        webView.reload()
    }
    
}

extension ViewController:WKWebViewDelegate{

    func webViewUserContentController(_ scriptMessageHandlerArray: [String], didReceive message: WKScriptMessage) {
        print(message.body)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("开始加载")
    }
}

//
//  XFWKWebView.swift
//  wkWebView
//
//  Created by XiaoFeng on 2016/12/26.
//  Copyright © 2016年 XiaoFeng. All rights reserved.
//
//  QQ群:384089763 欢迎加入
//  github链接:https://github.com/XFIOSXiaoFeng/SwiftWkWebView

import UIKit
import WebKit


//网页加载类型
enum WkWebLoadType{
    case loadWebURLString
    case loadWebHTMLString
    case POSTWebURLString
}

@objc protocol WKWebViewDelegate:class {
    
    //点击右边按钮执行方法
    @objc optional func didSelectRightItem(webView:WKWebView,itemTag:String)
    
    //注册JS执行代码
    @objc optional func didAddScriptMessage(webView:WKWebView,message:WKScriptMessage)
    
    //页面执行JS方法
    @objc optional func didRunJavaScript(webView:WKWebView,result:Any?,error:Error?)
}

class WKWebViewController: UIViewController{
    
    //设置navigationBarColor的颜色(默认白色)
    var navigationBarColor: UIColor?
    
    //是否隐藏进度条
    var isProgressHidden = false

    //注册MessageHandler 需要实现代理方法
    var addJavaScriptAry = [String]()
    
    //执行JS 需要实现代理方法
    var javaScript = String()
    
    //设置代理
    weak var delegate : WKWebViewDelegate?
    
    //右边按钮的值 ItemTag:区分当前按钮
    //实现代理方法才能调用点击事件
    var rightBarButtonItemTitle  : String?
    var rightBarButtonItemImage  : String?
    var rightBarButtonItemImageH : String?
    var rightBarButtonItemTag    : String?


    //添加视图
    fileprivate var webView: WKWebView!
    fileprivate var progressView: UIProgressView!
    //保存的网址链接
    fileprivate var urltring: String!
    //是否是第一次加载
    fileprivate var needLoadJSPOST:Bool?
    //保存请求链接
    fileprivate var snapShotsArray:Array<Any>?
    //加载类型
    fileprivate var loadWebType: WkWebLoadType?

    override func viewDidLoad() {
        super.viewDidLoad()

        //取消自动布局
        self.automaticallyAdjustsScrollViewInsets = false
        
        //处理nav显示不正常问题
        let bgView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: view.bounds.width, height: 64))
        bgView.backgroundColor = navigationBarColor ?? UIColor.white
        view.addSubview(bgView)
        
        //添加WkWebView
        addWkWebView()

        //添加ProgressView
        addProgressView()
        
        //加载网页类型
        loadType()
        
        //添加右边按钮
        addRightItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.setBarBackgroundColor(navigationBarColor ?? UIColor.white)
    }
    

//MARK:- 懒加载控件
    
    //关闭按钮
    fileprivate lazy var closeButtonItem:UIBarButtonItem = {
        
        let closeButtonItem = UIBarButtonItem.init(title: nil, image: "closeItemImage", imageH: "closeItemImage-hl", target: self, action: #selector(closeItemClicked))
        
        return closeButtonItem
        
    }()
    
    //返回按钮
    fileprivate lazy var customBackBarItem:UIBarButtonItem = {
        
        let customBackBarItem = UIBarButtonItem.init(title: nil, image: "backItemImage", imageH: "backItemImage-hl", target: self, action: #selector(customBackItemClicked))
        
        return customBackBarItem
    }()

    //相当于OC中的deallo
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
}


// MARK: - 外部方法使用
extension WKWebViewController{
    /// 普通URL加载方式
    ///
    /// Parameter urlString: 需要加载的url字符串
    func load_UrlSting(string:String!) {
        urltring = string;
        loadWebType = .loadWebURLString
    }
    
    /// 加载本地HTML
    ///
    /// Parameter urlString: 需要加载的本地文件名
    func load_HTMLSting(string:String!) {
        loadWebType = .loadWebHTMLString
        urltring = string
    }
    
    /// POST方式请求加载
    ///
    /// urlString: post请求的url字符串
    /// postString: post参数体 详情请搜索swift/oc转义字符（注意格式："\"username\":\"aaa\",\"password\":\"123\""）
    func load_POSTUrlSting(string:String!,postString:String!) {
        
        loadWebType = .POSTWebURLString
        urltring = string
        javaScript = "post('\(string!)', {\(postString!)});"
    }
    
    /// 添加右侧按钮
    ///
    /// Parameter titleStr: title字符串
    /// Parameter imageStr: imgage字符串
    /// Parameter itemTag:  唯一标识
    func add_rightBarButtonItem(title:String?,image:String?,imageH:String?,itemTag:String?) {
        rightBarButtonItemTitle  = title
        rightBarButtonItemImage  = image
        rightBarButtonItemImageH = imageH
        rightBarButtonItemTag    = itemTag
    }
    
    /// 执行JavaScript代码
    /// 例如 run_JavaScript(script:"document.getElementById('someElement').innerText")
    ///
    /// Parameter titleStr: title字符串
    func run_JavaScript(script:String?) {
        javaScript = script ?? ""
    }
}

extension WKWebViewController{

    fileprivate func loadHost(string:String) {
        let path = Bundle.main.path(forResource: string, ofType: "html")
        // 获得html内容
        do {
            let html = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
            // 加载js
            webView.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
        } catch { }
    }

    
    fileprivate func loadType() {
        
        switch loadWebType!{
            
        case .loadWebURLString :
            let urlstr = URL.init(string: urltring!)
            let request = URLRequest.init(url: urlstr!)
            webView.load(request)
            
        case .loadWebHTMLString:
            loadHost(string: urltring!)
            
        case .POSTWebURLString:
            needLoadJSPOST = true
            loadHost(string: "WKJSPOST")
        }
    }
    // 执行JS方法
    fileprivate func runJavaScript() {
        
        if javaScript == "" { return }
        
        webView.evaluateJavaScript(javaScript) { (result, error) in
            self.delegate?.didRunJavaScript!(webView: self.webView, result: result, error: error)
        }
    }
    
    //添加wkWebView
    fileprivate func addWkWebView() {
        // 创建webveiew
        // 创建一个webiview的配置项
        let configuretion = WKWebViewConfiguration()
        
        // Webview的偏好设置
        configuretion.preferences = WKPreferences()
        configuretion.preferences.minimumFontSize = 10
        configuretion.preferences.javaScriptEnabled = true
        
        // 默认是不能通过JS自动打开窗口的，必须通过用户交互才能打开
        configuretion.preferences.javaScriptCanOpenWindowsAutomatically = false
        
        // 通过js与webview内容交互配置
        configuretion.userContentController = WKUserContentController()
        
        // 添加一个名称，就可以在JS通过这个名称发送消息：valueName自定义名字
        // window.webkit.messageHandlers.valueName.postMessage({body: 'xxx'})
        for index in addJavaScriptAry.enumerated() {
            configuretion.userContentController.add(self, name: index.element)
        }
        webView = WKWebView(frame:CGRect.init(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height - 64), configuration: configuretion)
        
        //开启手势交互
        webView.allowsBackForwardNavigationGestures = true

        webView?.navigationDelegate = self
        
        webView?.uiDelegate = self
        
        // 监听支持KVO的属性
        webView?.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        //内容自适应
        webView.sizeToFit();
        
        view.addSubview(webView!);
    }
    //添加进度条
    fileprivate func addProgressView() {
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView?.frame = CGRect(x: 0, y: 64, width: view.bounds.width, height: 3)
        progressView?.trackTintColor = UIColor.clear
        progressView?.progressTintColor = UIColor.green
        progressView?.isHidden = isProgressHidden
        
        view.addSubview(progressView!)
    }
    
    //视图即将消失的时候调用该方法
    override func viewDidDisappear(_ animated: Bool) {
        webView.configuration.userContentController .removeScriptMessageHandler(forName: "AppModel")
        webView.navigationDelegate = nil;
        webView.uiDelegate = nil;
    }
    
    //自定义左边按钮
    @objc fileprivate func customBackItemClicked() {
        if (webView.goBack() != nil) {
            webView.goBack()
        }else{
            _ = navigationController?.popViewController(animated: true)
        }
    }
    //关闭按钮
    @objc fileprivate func closeItemClicked() {
        _ = navigationController?.popViewController(animated: true)
    }

    //KVO监听进度条变化
     override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "estimatedProgress"{
            
            progressView.alpha = 1.0
            let animated = Float(webView.estimatedProgress) > progressView.progress;
    
            progressView .setProgress(Float(webView.estimatedProgress), animated: animated)
            
            print(webView.estimatedProgress)
            self.progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            
            if Float(webView.estimatedProgress) >= 1.0{
                
                //设置动画效果，动画时间长度 1 秒。
                UIView.animate(withDuration: 1, delay:0.01,options:UIViewAnimationOptions.curveEaseOut, animations:{()-> Void in

                    self.progressView.alpha = 0.0
                    
                },completion:{(finished:Bool) -> Void in
                    
                    self.progressView .setProgress(0.0, animated: false)
                })
            }
        }
    }
    
    //请求链接处理
    fileprivate func pushCurrentSnapshotView(_ request: NSURLRequest) -> Void {
        
        guard let urlStr = snapShotsArray?.last else {
            return
        }
        
        let url = URL(string: urlStr as! String)
        
        let lastRequest = NSURLRequest(url: url!)
        
        
        //如果url是很奇怪的就不push
        if request.url?.absoluteString == "about:blank"{
            return;
        }

        //如果url一样就不进行push
        if (lastRequest.url?.absoluteString == request.url?.absoluteString) {
            return;
        }
        
        let currentSnapShotView = webView.snapshotView(afterScreenUpdates: true);
        
        //向数组添加字典
        snapShotsArray = [["request":request,"snapShotView":currentSnapShotView]]

    }
    
    fileprivate func updateNavigationItems(){
    
        if webView.canGoBack {
            let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
            space.width = -10
            
            navigationItem .setLeftBarButtonItems([space,customBackBarItem,closeButtonItem], animated: false)
            
        }else{
            
            navigationController?.interactivePopGestureRecognizer?.isEnabled = true;
            navigationItem .setLeftBarButtonItems([customBackBarItem],animated: false)
        }

    }
    
    fileprivate func addRightItem() {
        guard rightBarButtonItemTag != nil else {
            print("rightBarButtonItemTag不能为空")
            return
        }
        if rightBarButtonItemTitle == nil && rightBarButtonItemImage == nil && rightBarButtonItemImageH == nil {
            return
        }
        if rightBarButtonItemTitle == "" && rightBarButtonItemImage == "" && rightBarButtonItemImageH == "" {
            return
        }
        
        let item = UIBarButtonItem.init(title: rightBarButtonItemTitle, image: rightBarButtonItemImage, imageH: rightBarButtonItemImageH, target: self, action: #selector(rightItemClick))
        //占位控件
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil,
                                     action: nil)
        spacer.width = -10;
        navigationItem.rightBarButtonItems = [spacer,item]
    }
    
    func rightItemClick() {
        self.delegate?.didSelectRightItem!(webView: webView, itemTag: rightBarButtonItemTag ?? "")
    }
    
}


// MARK: - WKScriptMessageHandler
extension WKWebViewController: WKScriptMessageHandler{

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        for _ in addJavaScriptAry.enumerated() {
            
             self.delegate?.didAddScriptMessage!(webView: webView, message: message)
        }
    }
}

// MARK: - WKNavigationDelegate
extension WKWebViewController: WKNavigationDelegate{
    
    //服务器开始请求的时候调用
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        switch navigationAction.navigationType {
        case WKNavigationType.linkActivated:
            pushCurrentSnapshotView(navigationAction.request as NSURLRequest)
            break
        case WKNavigationType.formSubmitted:
            pushCurrentSnapshotView(navigationAction.request as NSURLRequest)
            break
        case WKNavigationType.backForward:
            break
        case WKNavigationType.reload:
            break
        case WKNavigationType.formResubmitted:
            break
        case WKNavigationType.other:
            pushCurrentSnapshotView(navigationAction.request as NSURLRequest)
            break
        }
        //更新左边返回按钮
        updateNavigationItems()
        decisionHandler(.allow);
    }
    
    //进度条代理事件
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print(#function)
    }
    //内容返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print(#function)
    }
    //这个是网页加载完成，导航的变化
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(#function)
        // 判断是否需要加载（仅在第一次加载）
        if needLoadJSPOST == true {
            // 调用使用JS发送POST请求的方法
            runJavaScript()
            // 将Flag置为NO（后面就不需要加载了）
            needLoadJSPOST = false
        }
        updateNavigationItems()
        title = webView.title
    }
    //开始加载
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print(#function)
        progressView.isHidden = false;
    }
    //跳转失败的时候调用
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(#function)
    }
    //服务器请求跳转的时候调用
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print(#function)
    }
    // 内容加载失败时候调用
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(#function)
    }
}

// MARK: - WKUIDelegate 不实现该代理方法 网页内调用弹窗时会抛出异常,导致程序崩溃
extension WKWebViewController: WKUIDelegate{
    
    // 获取js 里面的提示
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) -> Void in
            completionHandler()
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (_) -> Void in
            completionHandler()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // js 信息的交流
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) -> Void in
            completionHandler(true)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (_) -> Void in
            completionHandler(false)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // 交互。可输入的文本。
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        
        let alert = UIAlertController(title: prompt, message: defaultText, preferredStyle: .alert)
        
        alert.addTextField { (textField: UITextField) -> Void in
            textField.textColor = UIColor.red
        }
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) -> Void in
            completionHandler(alert.textFields![0].text!)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}



//MARK: 分类方法 可以提取到别处使用

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
    fileprivate convenience init(title: String?,image:String?,imageH:String? ,target: AnyObject?, action: Selector) {
        
        let backItemImage = UIImage.init(named: image ?? "")
        let backItemHlImage = UIImage.init(named: imageH ?? "")
        
        let backButton = UIButton.init(type: .system)
        
        backButton .setTitle(title, for: .normal)
        
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        
        backButton .setImage(backItemImage, for: .normal)
        backButton .setImage(backItemHlImage, for: .highlighted)
        
        backButton.sizeToFit()
        
        backButton.addTarget(target, action: action, for: .touchUpInside)
        
        self.init(customView: backButton)
    }
}

//处理nav颜色
private var alphaViewKey = "alphaViewKey"
extension UINavigationController {
    
    var alphaView: UIView? {
        set {
            objc_setAssociatedObject(self, &alphaViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &alphaViewKey) as? UIView
        }
    }
    
    fileprivate func setBackgroundColor(_ color: UIColor, alpha: CGFloat) {
        
        if alphaView == nil {
            alphaView = UIView(frame: CGRect(x: 0.0, y: -20.0, width: UIScreen.main.bounds.width, height: 64.0))
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
            navigationBar.insertSubview(alphaView!, at: 0)
        }
        alphaView?.backgroundColor = color.withAlphaComponent(alpha)
        //关闭用户交互
        alphaView?.isUserInteractionEnabled = false
    }
    
    //设置bar的颜色/去除分割线
    fileprivate func setBarBackgroundColor(_ color: UIColor) {
        let image = creatImageWithColor(color: color)
        navigationBar.shadowImage = image
        navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
    }
}

//颜色转图片
extension NSObject{
    
    fileprivate func creatImageWithColor(color:UIColor)->UIImage{
        let rect = CGRect.init(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

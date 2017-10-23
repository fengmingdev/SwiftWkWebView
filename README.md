# WKWebView Swift4.0 一款IOS8以后的web加载神器
WKWebView 支持POST请求 加载本地页面 直接加载网页 JS交互 集成支付宝/微信URL支付功能  仿微信返回按钮

#### 感谢大家的支持 OC版本将不再持续更新  业余爱好 QQ群：384089763
OC版本遗址：https://github.com/XFIOSXiaoFeng/WKWebView

NO1 首先得允许访问HTTP链接
```
HTTPS权限:
<key>NSAppTransportSecurity</key>
<dict>
<key>NSAllowsArbitraryLoads</key>
<true/>
</dict>
```

### API介绍
```
/// WKScriptMessageHandler
/// 添加一个名称，就可以在JS通过这个名称发送消息：valueName自定义名字
/// window.webkit.messageHandlers.valueName.postMessage({body: 'xxx'})
public var scriptMessageHandlerArray: [String] = [String]()

/// 默认最小字体字体
public var minFontSize: CGFloat = 0

/// 显示滚动条
public var isShowScrollIndicator: Bool = true

/// 开启手势交互
public var isAllowsBackForwardGestures: Bool = true

/// 是否允许加载javaScript
public var isjavaScriptEnabled: Bool = true

/// 是否允许JS自动打开窗口的，必须通过用户交互才能打开
public var isAutomaticallyJavaScript: Bool = true

/// 是否影藏进度条
public var isProgressHidden:Bool = false

/// 进度条高度
public var progressHeight:CGFloat = 3

/// 默认颜色
public var progressTrackTintColor:UIColor = UIColor.clear

/// 加载颜色
public var progressTintColor:UIColor = UIColor.green
```
###加载方式
```
/// 加载普通URL
case URLString(url:String)

/// 加载本地HTML(传名字就可以了)
case HTMLName(name:String)

/// 加载POST请求(url:请求URL，parameters：请求参数)
case POST(url:String,parameters: [String:Any])

```
代理方法方法
```
/// 服务器开始请求的时候调用
@objc optional func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)

/// 页面开始加载
@objc optional func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!)

/// 页面加载完成
@objc optional func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)

/// 跳转失败的时候调用
@objc optional func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error)

/// 内容加载失败
@objc optional func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error)

/// 执行JS注入方法
@objc optional func webViewUserContentController(_ scriptMessageHandlerArray:[String], didReceive message: WKScriptMessage)

/// JS执行回调方法
@objc optional func webViewEvaluateJavaScript(_ result:Any?,error:Error?)
```

### API使用方法
加上这句防止页面布局出现的诡异情况
```
self.automaticallyAdjustsScrollViewInsets = false
```
配置wk样式
```
var config = WkwebViewConfig()
config.isShowScrollIndicator = false
config.isProgressHidden = false
```
加载普通URL页面
```
webView.webConfig = config
webView.webloadType(self, .URLString(url: "https://www.baidu.com"))
```
加载本地Html页面(这里本地文件模拟服务器端文件，注册执行JS和添加右边按钮)
```
config.scriptMessageHandlerArray = ["valueName"]
webView.webConfig = config
webView.delegate = self
webView.webloadType(self, .HTMLName(name: "test"))

```
加载带参数的URL页面，即URL->POST传值 非参数的GET拼接
```
let mobile = ""
let pop = ""
let auth = ""
let param = ["mobile":"\(mobile)","pop":"\(pop)","auth":"\(auth)"];
webView.webConfig = config
webView.webloadType(self, .POST(url: "http://xxxxx", parameters: param))

```
附：swift3.0以后常见转义字符
<table>
    <tr>
        <td>\0</td>
        <td>空字符</td>
    </tr>
    <tr>
        <td>\\</td>
        <td>反斜线</td>
    </tr>
    <tr>
        <td>\t</td>
        <td> 水平制表符</td>
    </tr>
    <tr>
        <td>\n</td>
        <td>换行符</td>
    </tr>
    <tr>
        <td>\r</td>
        <td>回车符</td>
    </tr>
    <tr>
        <td>\"</td>
        <td>双引号</td>
    </tr>
    <tr>
        <td>\'</td>
        <td>单引号</td>
    </tr>
</table>



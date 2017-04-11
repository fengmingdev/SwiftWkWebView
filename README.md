# WKWebView Swift3.0 一款IOS8以后的web加载神器
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

API属性
```
//设置navigationBarColor的颜色
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

```
API方法
```
/// 普通URL加载方式
func load_UrlSting(string:String!) {}

/// 加载本地HTML
func load_HTMLSting(string:String!) {}

/// POST方式请求加载
func load_POSTUrlSting(string:String!,postString:String!) {}

/// 添加右侧按钮
func add_rightBarButtonItem(title:String?,image:String?,imageH:String?,itemTag:String?) {}

/// 执行JavaScript代码
func run_JavaScript(script:String?) {}
```
API代理方法
```
//点击右边按钮执行方法
@objc optional func didSelectRightItem(itemTag:String)

//注册JS执行代码
@objc optional func didAddScriptMessage(message:WKScriptMessage)

//页面执行JS方法
@objc optional func didRunJavaScript(result:Any?, error:Error?)

```
### API使用方法
#### WK必须要以navigation为基础 详情请现在Demo查看
加载普通URL页面
```
let webView = WKWebViewController()
webView.load_UrlSting(string: "https://www.baidu.com")
navigationController?.pushViewController(webView, animated: true)
```
加载本地Html页面(这里本地文件模拟服务器端文件，注册执行JS和添加右边按钮)
```
let webView = WKWebViewController()
webView.load_HTMLSting(string: "test")
webView.addJavaScriptAry = ["valueName"]
webView.add_rightBarButtonItem(title: "测试", image: nil, imageH: nil, itemTag: "right")
webView.delegate = self
navigationController?.pushViewController(webView, animated: true)
```
加载带参数的URL页面，即URL->POST传值 非参数的GET拼接
```
let webView = WKWebViewController()
let url = "https://www.xxxxxx.com"
let postData = "\"username\":\"aaa\",\"password\":\"123\""
webView.load_POSTUrlSting(string: url, postString: postData)
navigationController?.pushViewController(webView, animated: true)
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

![Aaron Swartz](https://github.com/XFIOSXiaoFeng/WKWebView/blob/master/testimage.gif)



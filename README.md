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
##### 安利一波swift高阶函数
打开swift高阶函数.playground你会看到不一样的奇迹
```
// 定义一个数组
var arr = [1,2,4,6,9]

// map:转换 (按自己的意淫方式转换成一个新的数组数组)
print("\(arr.map({"我是用map转换得到的新数组===>\($0)"}))" + "\n")

// filter:筛选 (根据条件筛选数组已有的值,返回筛选过后的值)
print("\(arr.filter { $0 % 2 == 0 })" + "\n")

// flatMap:筛选(根据条件筛选数组已有的值,返回筛选的布尔值)
print("\(arr.flatMap { $0 % 2 == 0 })" + "\n")

// 集合操作 (字典)
var dict = ["userinfo":"yasuo","age":"18","higeht":"165"]

// 给每一个key，value前后加上一个“
var dictMap = dict.map ({"\"\($0.key)\":\"\($0.value)\""})

// 转换结果
print("\(dictMap.map({"\($0)"}))" + "\n")

// 转换成字符串
print(dictMap.joined(separator: ","))

```
### API介绍

![Aaron Swartz](https://github.com/XFIOSXiaoFeng/SwiftWkWebView/blob/master/demo2.png)

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

/// 优雅的POST方式请求加载
func load_POSTUrlSting(string:String!,postString:[String:Any]!) {}

/// 添加右侧按钮
func add_rightBarButtonItem(title:String?,image:String?,imageH:String?,itemTag:String?) {}

/// 执行JavaScript代码
func run_JavaScript(script:String?) {}
```
API代理方法
```
//点击右边按钮执行方法
@objc optional func didSelectRightItem(webView:WKWebView,itemTag:String)
    
//注册JS执行代码
@objc optional func didAddScriptMessage(webView:WKWebView,message:WKScriptMessage)
    
//页面执行JS方法
@objc optional func didRunJavaScript(webView:WKWebView,result:Any?,error:Error?)

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
let postDict = ["user":"xiaofeng","age":24,"hight":166] as [String : Any]
webView.load_POSTUrlSting(string: url, postString: postDict)
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

![Aaron Swartz](https://github.com/XFIOSXiaoFeng/SwiftWkWebView/blob/master/demo.gif)



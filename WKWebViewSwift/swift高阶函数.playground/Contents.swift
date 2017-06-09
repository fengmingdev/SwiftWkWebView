//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, Wellcome Swift Advanced Function"
print("\(str)"+"\n")


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











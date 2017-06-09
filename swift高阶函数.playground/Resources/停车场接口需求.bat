
停车场接口需求

   "【版权所有，翻版必究】"
 "【create by : XiaoFeng】"

1>. 已添加车辆列表接口 

 接口："http://120.77.176.19/carManager/userCarList.php"
 入参："mobile","pop","auth","communityId"


 // 个人建议设计风格
 //
 // "code"     :状态码('1'代表成功 '2'代表参数错误 '3'代表xxx)
 // "data"     :正确数据
 // "id"       :车辆ID
 // "carbrand" :车牌号码
 // "status"   :锁车状态('1',代表已锁车，'0'代表未锁车)

 { "code":1,"data":{"carId":0,"carBrand":"川A00000000","status":"1"}
				   {"carId":1,"carBrand":"川A01111111","status":"0"}
				   {"carId":2,"carBrand":"川A22222222","status":"1"}}

2>. 锁车接口

 接口："http://120.77.176.19/carManager/lockCar.php"
 入参："mobile","pop","auth","communityId","carid"

 // 个人建议设计风格
 //
 // "code" :状态码('1'代表锁车成功 '2'代表已锁车 '3'代表参数错误 '4'代表xxx)

 { "code":1}

3>. 开锁接口

 接口："http://120.77.176.19/carManager/unLockCar.php"
 入参："mobile","pop","auth","communityId","carid"

 // 个人建议设计风格
 //
 // "code" :状态码('1'代表开锁成功 '2'代表已开锁 '3'代表参数错误 '4'代表xxx)

 { "code":1}

4>. 删除旗下车辆

 接口："http://120.77.176.19/carManager/deleteLockCar.php"
 入参："mobile","pop","auth","communityId","carid"

 // 个人建议设计风格
 //
 // "code" :状态码('1'代表删除成功 '2'代表代表删除失败 '3'代表参数错误 '4'代表xxx)

 { "code":3}

5>. 添加车辆

 接口："http://120.77.176.19/carManager/addCar.php"
 入参："mobile","pop","auth","communityId","carBrand","isMonth"

 // 个人建议设计风格
 //
 // "code" :状态码('1'代表添加成功 '2'代表代表添加失败 '3'代表参数错误 '4'代表xxx)

 { "code":3}


6>. 认证车辆

 接口："http://120.77.176.19/carManager/authorCar.php"
 入参："mobile","pop","auth","communityId","carBrand","isMonth","drivingCard","authorCode"

 // 个人建议设计风格
 //
 // "code" :状态码('1'代表认证成功 '2'代表代表添加失败 '3'代表参数错误 '4'代表xxx)

 { "code":3}

7>. 用户消息

 接口："http://120.77.176.19/carManager/userMessageCar.php"
 入参："mobile","pop","auth","communityId"

 // 个人建议设计风格
 //
 // "messageId"  : 消息ID 
 // "message"	 : 消息标题
 // "createTime" : 消息创建时间
 // "body"		 : 消息体
 // "code"    	 : 状态码('1'代表认证成功 '2'代表代表添加失败 '3'代表参数错误 '4'代表xxx)

 { "code":1,"data":{"messageId":"0","message":车辆入场,"createTime":"2017-01-20 12:00","body":"11:02:33,车辆川A0000000进入环球中心"}
				   {"messageId":"1","message":车辆出场,"createTime":"2017-01-20 16:00","body":"15:52:33,车辆川A0000000离开环球中心"}}

8>. 删除消息

 接口："http://120.77.176.19/carManager/deleteMessageCar.php"
 入参："mobile","pop","auth","communityId","messageId"

 // 个人建议设计风格
 //
 // "code" :状态码('1'代表删除成功 '2'代表删除失败 '3'代表参数错误 '4'代表xxx)

 { "code":1}








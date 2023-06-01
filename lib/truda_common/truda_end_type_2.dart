class TrudaEndType2 {
  // 用户主叫超时	10001
  static const int callingTimeOut = 10001;

  // 用户主叫取消	10002
  static const int callingCancel = 10002;

  // 用户主叫拒绝	10003
  static const int callingRefused = 10003;

  // 用户主叫失败	10004
  static const int callingFailed = 10004;

  // 用户被叫拒绝	10005
  static const int calledRefuse = 10005;

  // 用户被叫对方取消	10006
  static const int calledCanceled = 10006;

  // 用户被叫超时	10007
  static const int calledTimeOut = 10007;

  // 用户余额不足(还没有开始通话)	10008
  static const int noMoney = 10008;

  // 用户连接异常	10009
  static const int linkErr = 10009;

  // 用户连接取消	10010
  static const int linkCancel = 10010;

  // 对方异常	10011
  static const int otherErr = 10011;

  // 用户等待对端进入频道超时	10012
  static const int otherJoinTimeOut = 10012;

  // 用户等待 begin指令超时	10013
  static const int beginTimeOut = 10013;

  // 用户主动挂断	10014
  static const int userHang = 10014;

  // 通话中续key用户余额不足	10015
  static const int keyNoMoney = 10015;

  // 用户续key接口调用失败	10016
  static const int keyErr = 10016;

  // 对方离线	10017
  static const int otherOff = 10017;

  // 对方挂断	10018
  static const int otherHang = 10018;

  // 主播封禁	10019
  static const int hostBan = 10019;

  // 用户网络异常挂断	10020
  static const int netErr = 10020;
}

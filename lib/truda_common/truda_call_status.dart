class TrudaCallStatus {
  // 自己挂断
  static const int MY_HANG_UP = 1001;

  // 对方挂断
  static const int OTHER_HANG_UP = 1002;

  // 未接起
  static const int NOT_PICK_UP = 1003;

  // 接通电话
  static const int PICK_UP = 1004;

  // 忙碌中
  static const int USER_BUSY = 1005;

  // 离线
  static const int USER_OFF = 1006;

  // 网络问题失败
  static const int NET_ERR = 1007;

  // 使用视频卡
  static const int USE_VIDEO_CARD = 1008;

  // 使用视频卡 + 钻石
  static const int USE_CARD_AND_PAY = 1009;

  // 用户余额不足
  static const int USER_NOT_DIAMONDS = 1020;

  // 用户不是VIP
  static const int USER_NOT_VIP = 1021;

  // RTM  no_answer
  static const int RTM_NO_ANSWER = 2003;

  // RTM  no_answer
  static const int RTM_BUSY = 2005;
}

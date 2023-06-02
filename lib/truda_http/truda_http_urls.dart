import 'package:truda/truda_common/truda_constants.dart';

import '../truda_services/newhita_storage_service.dart';

class TrudaHttpUrls {
  // 预发版本
  static const String socketBaseUrl_pre = "ws://pre.hitatop.com/socket";
  static const String configBaseUrl_pre = "https://pre.hitatop.com/v2";
  static const String baseUrl_pre = "$configBaseUrl_pre/api";
  // 内网
  static const String socketBaseUrl_test = "ws://test.hanilink.com/socket";
  static const String configBaseUrl_test = "https://test.hanilink.com";
  static const String baseUrl_test = "$configBaseUrl_test/api";

  // 正式
  static const String socketBaseUrl = "wss://api.hitalinks.com/socket";
  static const String configBaseUrl = "https://api.hitalinks.com";
  static const String baseUrl = "$configBaseUrl/api";

  static String getConfigBaseUrl() {
    String url = configBaseUrl;
    if (!TrudaConstants.isTestMode) {
      return url;
    }
    //test mode 0线上，1预发布，2测试
    switch (NewHitaStorageService.to.getTestStyle) {
      case 0:
        url = configBaseUrl;
        break;
      case 1:
        url = configBaseUrl_pre;
        break;
      case 2:
        url = configBaseUrl_test;
        break;
      default:
        url = TrudaConstants.isTestMode ? configBaseUrl_test : configBaseUrl;
        break;
    }
    return url;
  }

  static String getSocketBaseUrl() {
    String url = socketBaseUrl;
    if (!TrudaConstants.isTestMode) {
      return url;
    }
    switch (NewHitaStorageService.to.getTestStyle) {
      case 0:
        url = socketBaseUrl;
        break;
      case 1:
        url = socketBaseUrl_pre;
        break;
      case 2:
        url = socketBaseUrl_test;
        break;
      default:
        url = TrudaConstants.isTestMode ? socketBaseUrl_test : socketBaseUrl;
        break;
    }
    return url;
  }

  static String getBaseUrl() {
    String url = baseUrl;
    if (!TrudaConstants.isTestMode) {
      return url;
    }
    switch (NewHitaStorageService.to.getTestStyle) {
      case 0:
        url = baseUrl;
        break;
      case 1:
        url = baseUrl_pre;
        break;
      case 2:
        url = baseUrl_test;
        break;
      default:
        url = TrudaConstants.isTestMode ? baseUrl_test : baseUrl;
        break;
    }
    return url;
  }

  static const String configApi = "/app/config";
  static const String facebookLoginApi = "/login/facebook";
  static const String googleLoginApi = "/login/google";
  static const String appleLoginApi = "/login/apple";
  // 游客登录
  static const String appRegister = "/app/register";
  // 修改密码
  static const String changePassword = "/user/changePassword";
  // 绑定Google
  static const String bindGoogle = "/user/bindGoogle";

  static const String loginOutApi = "/login/userLogout";
  //注销账号
  static const String delete_current_account = "/user/deleteUser";

  //阿里云上传凭证
  static const String aliOssApi = "/user/storage/upload/apply";

  static const String updateUserInfoApi = "/user/updateUserDetails";

  //主播列表 关注的主播列表...
  static const String upListApi = "/anchor/findAnchors/";
  static const String commandUpListApi = "/anchor/findRecommendAnchors/";
  static const String upDetailApi = "/anchor/findAnchorDetails/";
  static const String followUpApi = "/follow/saveAttention/";
  static const String followUpListApi = "/follow/getFollowList/";

  // 审核模式数据接口
  static const String auditModeData = "/app/auditModeData/0";
  //用户信息
  static const String userInfoApi = "/user/getUserDetails";

  // 获取礼物列表，不包含vip专属
  static const String giftListApi = "/gift/getList";
  // 获取礼物列表，包含vip专属
  static const String allGiftListApi = "/gift/allList";
  // 获取vip专属礼物
  static const String vipGiftListApi = "/gift/vipList";
  static const String giftGetOne = "/gift/getOne/";
  static const String sendGiftApi = "/gift/send";

  //获取用户简要信息
  static const String simpleUserInfoApi = "/anchor/getChatUserInfo/";

  //获取签到配置
  static const String signConfigApi = "/signin/getConfigs";

  //用户进行签到
  static const String userSignApi = "/signin/user/signIn";

  //通话聊天
  //创建频道
  static const String createCallApi = "/call/createCall/";

  static const String createAIBCallApi = "/call/createAIBCall/";

  //获取进入频道的token
  static const String agoraTokenApi = "/call/joinCall/";
  static const String joinCall = "/call/joinCallV2/";

  //对方加入该频道成功后通知服务器开始计时计费
  static const String callReadyApi = "/call/readyCall/";

  //通话结束计费结果
  static const String endCallApi = "/call/endCall/";

  //用户端每计时一分钟时通知扣用户钻石
  static const String refreshCallApi = "/call/refreshCall/";
  static const String refreshCallV2 = "/call/refreshCallV2/";

  //匹配主播
  static const String matchUpsApi = "/anchor/matchAnchors";
  static const String matchOneAnchor = "/anchor/matchOneAnchor";
  static const String matchOneAnchorLimit = "/anchor/matchOneAnchorLimit/";

  //AIB获取主播云录制视频
  static const String upCloudVideoApi = "/anchor/getAnchorVideo";

  //接听AIB视频后使用一张体验卡
  static const String useCardByAIBApi = "/user/callCardDeduction";

  //RTM消息转发
  static const String rtmServerSendApi = "/user/sendMsg";

  //searchup
  static const String searchUpApi = "/anchor/getByUsername/";

  //blacklistaction
  static const String blacklistActionApi = "/blacklist/pullBlack/";

  //blacklistaction
  static const String blacklistApi = "/blacklist/getListByUser";
  static const String calllistApi = "/call/callList";

  //sensitive
  static const String sensitiveWordsApi = "/sensitive/getSensitiveWords";

  //report
  static const String reportUpApi = "/feedback/submitReport";

  //tools
  static const String toolsApi = "/prop/propGroups";

  //refuseCall 用户拒绝主播通话后调用接口
  static const String refuseCallApi = "/call/refuseCall";
  static const String refuseAIBCall = "/call/refuseAIBCall/";

  //cancelCall 用户取消自己的视频申请后调用接口
  static const String cancelCallApi = "/call/cancelCall";

  // 没有频道的通话统计 /appCallStatistics/{raiseType}/{statisticsType}
  // raiseType 0.正常唤起 1.AI唤起
  // statisticsType 1 呼叫 2 客户端忙线 3 用户被叫拒绝 4 用户被叫超时 5 用户余额不足 6 用户被叫对方取消 7 用户连接异常
  static const String appCallStatistics = "/call/appCallStatistics";

  //消费明细
  static const String costListApi = "/user/getBalanceDetails/";

  //支付商品列表
  static const String payListApi = "/channelpay/getChannelPayByApp";

  //折扣商品
  // static const String discountProductApi = "/channelpay/getDiscountProduct";
  static const String discountProductApiV2 =
      "/channelpay/getDiscountProduct/v2";
  //折扣商品 新 type: 1.快捷充值，2.充值中心
  static const String getCompositeProduct = "/channelpay/getCompositeProduct/";

  //创建订单
  static const String createOrderApi = "/order/createOrder";
  //订单列表
  static const String orderListApi = "/order/orderList";

  //屏蔽消息扣费接口
  static const String costMsgFeeApi = "/user/sendMsgDeduction";

  //banner
  static const String bannerApi = "/banner/getBanners";

  //AIA 接通或者挂断
  static const String hanAIA_Api = "/robot/continueRobotMsg";

  //用户回复了机器人消息
  static const String applyRobotApi = "/robot/replyRobotMsg/";

  //初始化机器人消息
  static const String initRobotApi = "/robot/initRobotMsg";

  //谷歌订单回调
  static const String googleNotifyApi = "/notify/googlePay/notify";

  //苹果订单回调
  static const String appleNotifyApi = "/notify/iap/notify";

  //上传成功订单日志
  static const String uploadLogApi = "/app/aol/upload/log";

  //上传成功订单日志
  static const String getOrderStatusApi = "/order/getOrderStatus";

  //app上传发送敏感词记录
  static const String uploadSensitiveRecord =
      "/sensitive/uploadSensitiveRecord";

  //重新获取RTM Token
  static const String genRtmToken = "/user/genRtmToken";

  // 重置用户状态为在线
  static const String resetOnline = "/user/resetOnline";

  // 设置用户已评分
  static const String updateRatedApp = "/user/updateRatedApp";

  // 上传用户归因数据
  static const String attributionData = "/user/upload/attributionData";

  // 账号登录
  static const String accountLogin = "/login/userLogin";

  // 账号注册
  static const String auditModeRegister = "/app/auditModeRegister";

  // AIA视频回调 1.已收到，2.已弹窗
  static const String aiaVideoCallbackApi = "/robot/aiaVideoCallback";

  // AIB视频回调 1.已收到，2.已弹窗 -1丢掉
  static const String aibCallbackApi = "/robot/aibCallback";

  //等级规则/范围/奖品接口
  static const String LevelRuleApi = "/app/getByRankConfigByAreaCode";

  //领取奖品接口
  static const String getLevelUpdateGiftApi = "/user/receiveRankRewards";

  //获取翻译文案
  static const String getTransationsApi = "/app/loadTranslateConfig/0";
  static const String getTransationsV2Api = "/app/loadTranslateConfigV2/0";

  // 通话鉴黄不再提醒
  static const String noLongerReminds = "/call/noLongerReminds";
  // 获取s3上传url
  static const String s3UploadUrl = "/user/s3/storage/upload/pre-signed";

  // firebase
  static const String updateFirebaseToken = "/user/syncUserExtra/";

  ///推送点击回传
  static const String clickeFirebasePush = "/user/push/statistics/";

  // 用户端动态列表
  static const String getMoments = "/moment/user/page";
  // 对动态点赞
  static const String momentsPraise = "/moment/praise/";
  static const String momentsPraiseCancel = "/moment/praise/cancel/";
  // 保存审核内容
  static const String saveReviewContent = "/review/saveReviewContent";
  // /review/getLinkContent/$userId/-1
  static const String getLinkContent = "/review/getLinkContent/";
  static const String delContent = "/review/delContent/";

  // 获取自己的邀请信息
  static const String getInviteInfo = "/user/getInviteInfo";
  static const String bindInviteCode = "/user/bindInviteCode/";
  static const String accumulateShareCount = "/user/accumulateShareCount";

  // vip商品
  static const String getVipProduct = "/channelpay/getVipProduct";
  // 随机返回一条动态
  static const String momentRand = "/moment/rand";
  // 贡献榜
  static const String getExpendRanking = "/ranking/getExpendRanking/";

  static const String vipSignIn = "/signin/vip/signIn";

  // 抽奖
  static const String lotteryConfig = "/draw/getConfig";
  static const String lotteryOne = "/draw/rechargeDraw";
  static const String getDrawUser = "/draw/getDrawUser";

  //上传广告点击事件
  static const String adSpotsCallback = "/adSpots/callback/";
  //获取广告位key 和是否打开
  static const String getAdSpots = "/adSpots/getAdSpots/";

  ///获取 aib 配置
  static const String getAibConfig = "/robot/getAibConfig";

  ///获取 aib 主播信息
  static const String getAibAnchor = "/robot/getAibAnchor";
  static const String getAivAnchor = "/robot/getAivAnchor";

  // 支付选择国家
  static const String getPayCountry = "/channelpay/getPayCountry";
  static const String getCountryProduct = "/channelpay/getCountryProduct";
}

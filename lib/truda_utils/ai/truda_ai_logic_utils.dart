import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:get/get.dart';
import 'package:truda/truda_services/truda_storage_service.dart';
import 'package:truda/truda_utils/truda_loading.dart';

import '../../truda_common/truda_constants.dart';
import '../../truda_database/entity/truda_her_entity.dart';
import '../../truda_entities/truda_ai_config_entity.dart';
import '../../truda_entities/truda_aiv_entity.dart';
import '../../truda_http/truda_http_urls.dart';
import '../../truda_http/truda_http_util.dart';
import '../../truda_pages/call/remote/truda_remote_controller.dart';
import '../../truda_rtm/truda_rtm_msg_entity.dart';
import '../../truda_services/truda_event_bus_bean.dart';
import '../../truda_services/truda_my_info_service.dart';
import '../truda_check_calling_util.dart';

/// 需求：获取到配置后，按接听能力（钻石体验卡）分组，
/// aiv逻辑，次数走完，再走aib
enum TrudaAiType { none, aib, aiv }

class TrudaAiLogicUtils {
  static TrudaAiLogicUtils? _instance;

  factory TrudaAiLogicUtils() {
    _instance ??= TrudaAiLogicUtils._();
    return _instance!;
  }

  TrudaAiLogicUtils._();

  // 计时器
  Timer? _timer;

  // 上一个经过 ai 逻辑调起的 主播uid
  String previousUid = "";

  //下一次ai 间隔
  int nextTime = -1;
  // 重试间隔,默认5s,会增加
  int interceptTime = 5;

  //是否被拦截了
  bool isIntercept = false;

  // 间隔开始时间
  int startingTime = 0;

  //总计时
  int totalTime = 0;

  //拒绝次数
  int rejectCount = 0;

  // aiv接听次数
  int aivShowTimes = 0;

  // aiv接听次数
  int aibShowTimes = 0;

  // 0无配置，1aib,2aiv
  var aiType = TrudaAiType.none;

  TrudaAiConfigEntity? aiConfigEntity;

  //选择的配置
  TrudaAiConfigGroupsItem? aiConfig;
  var configName = '';

  // 当前用户是首次进入吗？
  bool currentUserFirstLogin = true;
  final String hadLoginKey =
      "hadLogin-${TrudaMyInfoService.to.myDetail?.userId}";

  var information = 'wait...'.obs;
  var aiInvokeProcess = '流程';
  // 死掉了
  bool dead = false;

  /// event bus 监听
  StreamSubscription<TruaEventCanCallStateChange>? _sub;

  void init() {
    if (TrudaConstants.isFakeMode) {
      return;
    }
    aivShowTimes = startingTime = totalTime = 0;
    nextTime = rejectCount = 0;
    isIntercept = false;
    aiType = TrudaAiType.none;
    previousUid = "";
    _timer?.cancel();
    _getAibConfig();
    final hadLogin = TrudaStorageService.to.prefs.getBool(hadLoginKey) ?? false;
    if (hadLogin) {
      currentUserFirstLogin = false;
    } else {
      currentUserFirstLogin = true;
      TrudaStorageService.to.prefs.setBool(hadLoginKey, true);
    }

    /// event bus 监听
    _sub = TrudaStorageService.to.eventBus
        .on<TruaEventCanCallStateChange>()
        .listen((event) {
      setNextTimer();
    });
  }

  ///获取 aib 配置
  void _getAibConfig() {
    TrudaHttpUtil()
        .post<TrudaAiConfigEntity>(TrudaHttpUrls.getAibConfig,
            errCallback: (error) {})
        .then((value) {
      _log("返回数据了 ");
      aiConfigEntity = value;
      int delay = value.loginDelay ?? 0;
      _startTimer();
    });
  }

  ///开始定时器
  void _startTimer() {
    setNextTimer(firstCircle: true);
    _log("开启定时");
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (dead) return;
      // 打电话时停止计时
      if (TrudaCheckCallingUtil.checkCalling()) return;
      // NewHitaLog.debug("==============   ${nextTime}     $rejectCount");
      // 本轮间隔时间
      final intervals = totalTime - startingTime;
      // NewHitaLog.debug("==============   $intervals     $nextTime");
      // 需要的下次的间隔时间
      var needNextTime = nextTime;
      if (!isIntercept && (aiType == TrudaAiType.aib)) {
        // aib 有挂断加延时的效果
        needNextTime = nextTime + (rejectCount * (aiConfig?.rejectDelay ?? 0));
      }
      // arrive 小于等于0，说明该拨打了
      final arrive = needNextTime - intervals;
      // 如果不能发起aib,aiv的情况,arrive快到了，先不增加计时
      bool canNotAib = (aiType == TrudaAiType.aib) && !TrudaCheckCallingUtil.checkCanAib();
      bool canNotAic = (aiType == TrudaAiType.aiv) &&
          !TrudaCheckCallingUtil.checkCanAic();
      // 就是说剩下2秒要拨打了，但是此时不能拨打，先不增加计时
      if (canNotAib && arrive < 3) {
        return;
      } else if (canNotAic && arrive < 3) {
        return;
      } else {
        totalTime++;
      }

      if (arrive <= 0) {
        //间隔时间 大于 needNextTime 开始ai 逻辑
        startCall();
        //重新初始化计时
        setNextTimer();
        //重置
        isIntercept = false;
      }

      information.value = getInformation(intervals, needNextTime - intervals);
    });
  }

  void _intercept() {
    aiInvokeProcess += ',i';
    _log("接口没搞到，5s后重试 ");
    if (interceptTime < 30) {
      interceptTime += 2;
    }
    nextTime = interceptTime;
    isIntercept = true;
  }

  ///开始下一个 计时
  void setNextTimer({
    bool isRejectDelay = false,
    bool firstCircle = false,
  }) {
    // _log("==startNextTimer");
    startingTime = totalTime;
    _checkUserAiState(firstCircle: firstCircle);
    if (isRejectDelay) {
      //拒接直接添加延迟就可以了  不用重新初始化
      rejectCount++;
    }
  }

  // 判断用户有无接听能力,配置aib,aiv
  void _checkUserAiState({
    bool firstCircle = false,
  }) {
    var balance =
        TrudaMyInfoService.to.myDetail?.userBalance?.remainDiamonds ?? 0;
    var callCard = TrudaMyInfoService.to.myDetail?.callCardCount ?? 0;
    var willChangeConfig = false;
    if (balance >= (aiConfigEntity?.floorDiamondsThreshold ?? 60)) {
      //用户有接听能力 用户余额足够(用户余额>=floorDiamondsThreshold）
      if (aiConfig != aiConfigEntity?.groups?.aibEnoughBalance) {
        willChangeConfig = true;
      }
      aiConfig = aiConfigEntity?.groups?.aibEnoughBalance;
      configName = '已充值有钻石';
    } else if (callCard >= (aiConfigEntity?.floorCallCardThreshold ?? 1)) {
      //用户有接听能力 用户有体验卡
      if (aiConfig != aiConfigEntity?.groups?.aibEnoughCallCard) {
        willChangeConfig = true;
      }
      aiConfig = aiConfigEntity?.groups?.aibEnoughCallCard;
      configName = '未充值有体验卡';
      // } else if (balance > 0) {
    } else if (TrudaMyInfoService.to.getIsHadCharge()) {
      //付费用户无接听能力(用户余额>0)
      if (aiConfig != aiConfigEntity?.groups?.aibPaidLackBalance) {
        willChangeConfig = true;
      }
      aiConfig = aiConfigEntity?.groups?.aibPaidLackBalance;
      configName = '已充值无钻石';
    } else {
      //未充值用户无接听能力(else 其他)
      if (aiConfig != aiConfigEntity?.groups?.aibLackBalance) {
        willChangeConfig = true;
      }
      aiConfig = aiConfigEntity?.groups?.aibLackBalance;
      configName = '未充值无体验卡';
    }
    _setConfig(willChangeConfig);
    if (aiType == TrudaAiType.aib) {
      // aib间隔
      if (firstCircle) {
        nextTime = aiConfigEntity?.loginDelay ?? 10;
      } else {
        nextTime = aiConfig?.nextAibTime ?? 30;
      }
    } else if (aiType == TrudaAiType.aiv) {
      // 变成了未充值无体验卡，说明是新用户消耗了体验卡，第一通做成首次的10s
      bool changeToAiv = willChangeConfig &&
          aiConfig == aiConfigEntity?.groups?.aibLackBalance;
      // aiv间隔
      if (firstCircle || changeToAiv) {
        nextTime = aiConfig?.aivFirstDelay ?? 10;
      } else {
        if (currentUserFirstLogin) {
          nextTime = _next(aiConfig?.aivMinFirstLoginSeconds ?? 20,
              aiConfig?.aivMaxFirstLoginSeconds ?? 25);
        } else {
          nextTime = _next(aiConfig?.minAivDelaySeconds ?? 30,
              aiConfig?.maxAivDelaySeconds ?? 35);
        }
      }
    } else {
      // 5s后重新检测
      nextTime = 5;
    }
    _log("_checkUserAiState 下次ai aiType=$aiType nextTime=$nextTime ");
  }

  // 最后走aib和aiv还要判断
  void _setConfig(bool willChangeConfig) {
    if (willChangeConfig) {
      // 说明配置发生了变动,把aiv播放次数归零
      aivShowTimes = 0;
      interceptTime = 5;
    }
    if (aiConfig?.aivSendFlag == 1) {
      aiType = TrudaAiType.aiv;
      if (aivShowTimes >= _aivMaxTimes() || (aiConfig?.aivSendFlag == 0)) {
        // 如果aiv关掉或者播放次数够了也搞aib
        aiType = TrudaAiType.aib;
        if (aiConfig?.sendFlag == 0) {
          aiType = TrudaAiType.none;
        }
      }
      return;
    }
    if ((aiConfig?.sendFlag == 1)) {
      aiType = TrudaAiType.aib;
    } else {
      aiType = TrudaAiType.none;
    }
  }

  int _aivMaxTimes() {
    return currentUserFirstLogin
        ? (aiConfig?.aivFirstLoginCount ?? 0)
        : (aiConfig?.aivNextLoginCount ?? 0);
  }

  ///收到虚拟视频 切换为aiv配置
  // void aicStart() {
  //   if (isAibConfig) {
  //     //只有现在使用的配置不是 aiv 的配置才重新开始 不是不用
  //     setNextTimer();
  //   }
  // }

  ///判断是否有虚拟视频  如果有就走 aiv 的逻辑  没有就走 aib 逻辑
  // void _useConfig() {
  //   if (NewHitaStorageService.to.objectBoxCall
  //           .queryAicCanShowExcept(previousUid) !=
  //       null) {
  //     isAibConfig = false;
  //     //判断是否有虚拟视频
  //     nextTime = _next(aiConfig?.minAivDelaySeconds ?? 10,
  //         aiConfig?.maxAivDelaySeconds ?? 15);
  //   }
  // }

  final Random _random = Random();

  /// 获取随机数
  int _next(int min, int max) {
    if (max < min) {
      var tmp = min;
      min = max;
      max = tmp;
    }
    return min + _random.nextInt(max - min);
  }

  ///接通后 减去拒绝次数
  void reduceRejectCount() {
    if (rejectCount != 0) {
      // rejectCount--;
      rejectCount = 0;
    }
  }

  ///取消定时器
  void cancel() {
    information.value = 'wait...';
    _timer?.cancel();
    _sub?.cancel();
    _timer = null;
    _sub = null;
    dead = true;
    _instance = null;
  }

  void _log(String str) {
    print("AiLogicUtils $str");
  }

  ///触发 通话逻辑
  void startCall() {
    _log("======发起 aiType=$aiType previousUid=$previousUid ");
    if (aiType == TrudaAiType.aib) {
      //该次是aib
      aiInvokeProcess += ':b';
      startAibCall();
    } else if (aiType == TrudaAiType.aiv) {
      //逻辑修改  先走 虚拟视频 ，虚拟视频不能调起在走aib
      aiInvokeProcess += ':v';
      startAicCall();
    }

    if (aiInvokeProcess.length > 200) {
      aiInvokeProcess =
          '流程:....${aiInvokeProcess.substring(aiInvokeProcess.length - 100, aiInvokeProcess.length)}';
    }
  }

  ///触发 aib通话逻辑
  void startAibCall() {
    _log("==============   aib");
    if (TrudaCheckCallingUtil.checkCanAib()) {
      //检查是否能调起aib
      TrudaHttpUtil().post<TrudaRTMMsgAIB>(TrudaHttpUrls.getAibAnchor,
          errCallback: (error) {}, doneCallback: (isSuccess, msg) {
        _log("========== aib  $isSuccess");
        if (!isSuccess) {
          //没有拉到主播  缩短到每5秒拉取一次
          _intercept();
        }
      }).then((value) {
        previousUid = value.userId!;
        // if (value.userId != previousUid) {
        //判断 获取到的主播和上一次的不一样才调起被叫
        TrudaRemoteController.startMeAib(value.userId!, json.encode(value));
        aibShowTimes++;
        interceptTime = 5;
        if (TrudaConstants.isTestMode) {
          TrudaLoading.toast('测试提示：aib ');
        }
        // } else {
        //   //否者重新调起
        //   startAibCall();
        // }
        TrudaStorageService.to.objectBoxMsg.putOrUpdateHer(TrudaHerEntity(
            value.nickname ?? '', value.userId!,
            portrait: value.portrait));
      }).onError((error, stackTrace) {
        _intercept();
      });
    } else {
      //aib 被拦截 然后5 秒触发一次
      _intercept();
    }
  }

  // 万一电话被拦截，请求到的这个可以缓存下次用
  TrudaAivBean? _aivBean;

  /// 触发 aic 通话逻辑
  void startAicCall() {
    _log("==============   aic");
    if (TrudaCheckCallingUtil.checkCanAic()) {
      if (_aivBean != null) {
        _startAicBean(_aivBean!);
        _aivBean = null;
        return;
      }
      //检查是否能调起aib
      TrudaHttpUtil().post<TrudaAivBean>(TrudaHttpUrls.getAivAnchor,
          errCallback: (error) {}, doneCallback: (isSuccess, msg) {
        _log("========== aic  $isSuccess");
        if (!isSuccess) {
          //没有拉到主播  缩短到每5秒拉取一次
          _intercept();
        }
      }).then((value) {
        //  不能拨打就缓存一次
        if (!TrudaCheckCallingUtil.checkCanAic()) {
          _aivBean = value;
          _intercept();
          return;
        }
        _startAicBean(value);
      }).onError((error, stackTrace) {
        // _intercept();
        if (error == 0) {
          if (TrudaConstants.isTestMode) {
            TrudaLoading.toast('测试提示：没拉到aiv,先拉aib ',
                duration: const Duration(seconds: 4));
          }
          startAibCall();
        }
      });
    } else {
      //aib 被拦截 然后5 秒触发一次
      _intercept();
    }
  }

  // 拨打aic
  void _startAicBean(TrudaAivBean bean) {
    previousUid = bean.userId!;
    var balance =
        TrudaMyInfoService.to.myDetail?.userBalance?.remainDiamonds ?? 0;
    if (balance >= 60) {
      // 有运营测到了有钻石调起了aiv，没找到原因，这里拦截一下 todo
      return;
    }
    var result = TrudaRemoteController.startMeAiv(bean);
    if (result) {
      aivShowTimes++;
      setNextTimer();
      interceptTime = 5;
      if (TrudaConstants.isTestMode) {
        TrudaLoading.toast('测试：aiv 第$aivShowTimes次 （共${_aivMaxTimes()}）');
      }
    }
    TrudaStorageService.to.objectBoxMsg.putOrUpdateHer(TrudaHerEntity(
        bean.nickname ?? '', bean.userId!,
        portrait: bean.portrait));
  }

  String getInformation(int intervals, int count) {
    return 'Ai提示：\n'
        '目前ai: ${aiType == TrudaAiType.aiv ? 'aiV' : 'aiB'}\n'
        '目前ai组: $configName\n'
        '总计时: $totalTime\n'
        '目前间隔时间: $nextTime\n'
        // '拉取计时: $intervals\n'
        '拉取倒计时: $count\n'
        '拉取失败重置到5s: $isIntercept\n\n'
        'aib拒绝次数: $rejectCount\n'
        'aib拒绝延时: ${rejectCount * (aiConfig?.rejectDelay ?? 0)}\n'
        'aib已拉次数: $aibShowTimes\n'
        'aib开关: ${aiConfig?.sendFlag}\n\n'
        'aiv配置次数: ${_aivMaxTimes()}\n'
        'aiv已拉次数: ${aivShowTimes}\n'
        'aiv开关: ${aiConfig?.aivSendFlag}\n\n'
        '$aiInvokeProcess';
  }

  void testAiv() {
    TrudaAivBean aiv = TrudaAivBean();
    aiv.filename =
        'https://yesme-public.oss-cn-hongkong.aliyuncs.com/app/testMp4.mp4';
    // aiv.id = 445444747474747;
    aiv.userId = '107780488';
    aiv.nickname = '1057644';
    aiv.portrait =
        'https://oss.hanilink.com/users_test/107780487/upload/media/2022-03-29/_1648521386627_sendimg.JPEG';
    aiv.nickname = 'test test';
    // aiv.isCard = 0;
    var result = TrudaRemoteController.startMeAiv(aiv);
    if (result) {
      aivShowTimes++;
      setNextTimer();

      if (TrudaConstants.isTestMode) {
        TrudaLoading.toast('测试提示：aiv 第$aivShowTimes次 （共${_aivMaxTimes()}）');
      }
    }
  }
}

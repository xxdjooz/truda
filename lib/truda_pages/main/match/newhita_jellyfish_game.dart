import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/animation.dart';

// onGameResize : 顶层画布尺寸变化时
// onLoad：资源加载时
// onMount：添加到父节点时
// onRemove：从父节点移除时
// update：跟随 Ticker 不断触发
// render：新帧渲染时触发
class JellyfishGame extends FlameGame with HasTappables {
  // 生成新的的时间差，会逐渐减小到最小值，也就是越来越快
  final int maxSpawnInterval = 1000;
  final int minSpawnInterval = 250;
  final int intervalChange = 3;
  late int currentInterval;

  // 下次增加时间
  int nextSpawn = 0;

  // 屏幕上最多个数
  final int maxFliesOnScreen = 7;
  math.Random rnd = math.Random();
  final Function onClick;
  JellyfishGame(this.onClick);

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
  }

  @override
  Future<void> onLoad() async {
    currentInterval = minSpawnInterval;
    add(Background());
    add(FishType2(onClick, beginInScreen: true));
    add(FishType2(onClick, beginInScreen: true));
  }

  @override
  void update(double dt) {
    super.update(dt);
    int nowTimestamp = DateTime.now().millisecondsSinceEpoch;

    int livingFlies = children.length;
    if (nowTimestamp >= nextSpawn && livingFlies < maxFliesOnScreen) {
      add(FishType2(onClick));
      if (currentInterval < maxSpawnInterval) {
        currentInterval += intervalChange;
        currentInterval += (currentInterval * .02).toInt();
      }
      nextSpawn = nowTimestamp + currentInterval;
    }
  }

  // 随机增加一个
  void addOne() {
    int r = rnd.nextInt(4);
    switch (r) {
      case 0:
        add(FishType2(onClick));
        break;
      case 1:
        add(FishType2(onClick));
        break;
      case 2:
        add(FishType2(onClick));
        break;
      case 3:
        add(FishType2(onClick));
        break;
      default:
        add(FishType2(onClick));
        break;
    }
  }
}

class JellyfishComponent extends SpriteAnimationComponent with Tappable {
  JellyfishComponent(this.onClick, { this.beginInScreen = false }) : super(size: Vector2(150, 150), anchor: const Anchor(0.5, 0.2));

  final Function onClick;
  late Vector2 targetLocation;
  late Vector2 gameSize;
  math.Random rnd = math.Random();

  // 游到目标点次数，某次后让它游出页面
  int timeToDie = 0;
  int maxTimes = 3;

  double speed = 1;
  double direction = -math.pi / 2;
  bool changeDirection = false;
  bool changeDirectionIng = false;
  bool die = false;
  // 一开始它是出现在屏幕内还是外
  bool beginInScreen = false;

  // 为了让只有一个被点击
  static TapDownInfo? handleInfo;

  @override
  bool onTapDown(TapDownInfo info) {
    if (handleInfo == info) {
      return super.onTapDown(info);
    }
    handleInfo = info;
    die = true;
    repeatedEffectController();
    onClick();
    FlameAudio.play('newhita_match_get.mp3');
    return super.onTapDown(info);
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    this.gameSize = gameSize;
    position = getPosition(beginInScreen);
    setTargetLocation();
  }

  // 设置下一个游动的目标点
  void setTargetLocation() {
    // 设置一个会游出屏幕的目标点
    size -= Vector2(10, 10);
    targetLocation = getPosition(timeToDie <= maxTimes);
    timeToDie++;

    changeDirection = true;
    // lookAt(targetLocation);
  }

  Vector2 getPosition(bool inScreen) {
    Vector2 p;
    double x = rnd.nextDouble() * gameSize.x;
    double y = rnd.nextDouble() * gameSize.y;
    p = Vector2(x, y);
    // 设置一个会游出屏幕的目标点
    if (!inScreen) {
      int r = rnd.nextInt(4);
      switch (r) {
        case 0:
          x = -200;
          break;
        case 1:
          y = -200;
          break;
        case 2:
          x = gameSize.x + 200;
          break;
        case 3:
          y = gameSize.y + 200;
          break;
        default:
          x = -200;
          break;
      }
      p = Vector2(x, y);
    }
    return p;
  }

  bool isOutScreen() {
    return position.x < -150 ||
        position.x > gameSize.x + 150 ||
        position.y < -150 ||
        position.y > gameSize.y + 150;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (die) {
      return;
    }
    if (timeToDie > maxTimes && isOutScreen()) {
      removeFromParent();
      return;
    }
    if (changeDirectionIng) {
      return;
    }

    Vector2 toTarget = targetLocation - position;
    Offset toTargetOffset = Offset(toTarget.x, toTarget.y);

    if (changeDirection) {
      addRotateEffectBy(toTargetOffset.direction);
      changeDirection = false;
      return;
    }
    // 让游动速度sin变化
    double stepDistance =
        math.asin((toTargetOffset.distance / 50) % (math.pi / 2));
    if (stepDistance.isNaN) {
      stepDistance = 1;
    } else {
      stepDistance += speed;
    }
    if (stepDistance < toTargetOffset.distance) {
      Offset stepToTarget =
          Offset.fromDirection(toTargetOffset.direction, stepDistance);
      position = position + Vector2(stepToTarget.dx, stepToTarget.dy);
    } else {
      position = position + toTarget;
      setTargetLocation();
    }
  }

  // 一个转向的特效
  void addRotateEffectBy(double direction) {
    var di = direction - this.direction;
    if (di.abs() > math.pi) {
      if (di > 0) {
        di = di - 2 * math.pi;
      } else {
        di = 2 * math.pi + di;
      }
    }
    Effect effect = RotateEffect.by(
      di,
      EffectController(
          duration: di.abs() * 2 / math.pi + 1,
          curve: Curves.easeInOut,
          onMax: () {
            changeDirectionIng = false;
            this.direction = direction;
          }),
    );
    add(effect);
    changeDirectionIng = true;
  }

  void repeatedEffectController() {
    EffectController child = SineEffectController(period: 0.1);
    EffectController ctrl2 = RepeatedEffectController(child, 5);
    Effect effect = MoveByEffect(Vector2(-2, 0), ctrl2, onComplete: () {
      removeFromParent();
    });
    add(effect);
  }
}

class Background extends SpriteComponent {
  Background() : super(size: Vector2(0, 0), anchor: Anchor.center);

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    size = gameSize;
    position = gameSize / 2;
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('game/jellyfish_bg.png');
  }
}

class FishType1 extends JellyfishComponent {
  FishType1(Function onClick, { beginInScreen = false }) : super(onClick, beginInScreen: beginInScreen);

  @override
  Future<void> onLoad() async {
    List<Sprite> sprites = [];
    for (int i = 0; i <= 11; i++) {
      sprites.add(await Sprite.load('game/0000_0000$i.png'));
    }
    animation = SpriteAnimation.spriteList(sprites, stepTime: 0.08);
  }
}

class FishType2 extends JellyfishComponent {
  FishType2(Function onClick, { beginInScreen = false }) : super(onClick, beginInScreen: beginInScreen);

  @override
  Future<void> onLoad() async {
    List<Sprite> sprites = [];
    for (int i = 0; i <= 11; i++) {
      sprites.add(await Sprite.load('game/0000$i.png'));
    }
    animation = SpriteAnimation.spriteList(sprites, stepTime: 0.08);
  }
}

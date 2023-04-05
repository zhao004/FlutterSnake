import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../views/home_view.dart';

///方向
enum Direction { up, down, left, right }

class HomeController extends GetxController {
  //TODO: Implement HomeController
  var context;

  ///上界x坐标和上界y坐标，下届x坐标和下届y坐标;
  late int upperBoundX, upperBoundY, lowerBoundX, lowerBoundY;

  ///屏幕宽-高度
  late double screenWidth, screenHeight;

  ///步长
  int step = 20;

  ///蛇的位置
  List<Offset> positions = [];

  ///蛇默认长度
  int snakeLength = 5;

  ///蛇的方向
  Direction direction = Direction.right;
  Timer? timer;

  ///默认移动速度
  int speed = 200;

  ///食物 位置
  Offset foodPosition = const Offset(0, 0);

  ///食物 组件
  Piece food = const Piece(
    dx: 0,
    dy: 0,
    step: 20,
    color: Colors.red,
  );

  @override
  void onInit() {
    super.onInit();
    if (Get.context != null) {
      context = Get.context;
      //设置宽高度
      screenHeight = MediaQuery.of(context).size.height;
      screenWidth = MediaQuery.of(context).size.width;
      //设置下届
      lowerBoundY = step;
      lowerBoundX = step;
      //设置上界
      upperBoundY = getNearestTens(screenHeight.toInt() - step);
      upperBoundX = getNearestTens(screenWidth.toInt() - step);
    }
    //开始游戏
    restart();
  }

  ///获取随机位置
  Offset getRandomPosition() {
    Offset output;
    int posX = Random().nextInt(upperBoundX) + lowerBoundX;
    int posY = Random().nextInt(upperBoundY) + lowerBoundY;
    output = Offset(
        getNearestTens(posX).toDouble(), getNearestTens(posY).toDouble());
    return output;
  }

  ///获取蛇的块
  List<Piece> getPieces() {
    //临时存储蛇的块
    var pieces = <Piece>[];
    //绘制蛇
    draw();
    //绘制食物
    drawFood();
    //循环添加蛇的块
    for (var i = 1; i < snakeLength; i++) {
      //如果蛇的块超过了蛇的长度，就不绘制了
      if (i > positions.length) {
        continue;
      }
      pieces.add(
        Piece(
          dx: positions[i].dx.toInt(),
          dy: positions[i].dy.toInt(),
          step: step,
          color: i.isEven ? Colors.blue : Colors.green,
        ),
      );
    }
    return pieces;
  }

  ///检测是否碰撞
  bool detectCollision(Offset position) {
    bool output = false;
    //如果蛇的位置超过了屏幕的范围，就返回true
    if (position.dx < lowerBoundX ||
        position.dx > upperBoundX ||
        position.dy < lowerBoundY ||
        position.dy > upperBoundY) {
      output = true;
    }
    //如果蛇的位置和食物的位置重合，就返回true
    if (position.dx == foodPosition.dx && position.dy == foodPosition.dy) {
      output = true;
    }
    return output;
  }

  ///获取下一个位置
  Offset getNextPosition(Offset position) {
    Offset output;
    switch (direction) {
      case Direction.up:
        output = Offset(position.dx, position.dy - step);
        break;
      case Direction.down:
        output = Offset(position.dx, position.dy + step);
        break;
      case Direction.left:
        output = Offset(position.dx - step, position.dy);
        break;
      case Direction.right:
        output = Offset(position.dx + step, position.dy);
        break;
    }

    ///如果碰撞了，就重新开始游戏
    if (detectCollision(position)) {
      //如果碰撞了，就重新开始游戏
      print('碰撞了');
      if (timer != null && timer?.isActive == true) {
        //删除定时器
        timer?.cancel();
      }
//重新开始游戏
      restart();
      return position;
    }
    return output;
  }

  ///绘制蛇
  draw() {
    //如果蛇的位置为空，添加一个随机位置
    if (positions.isEmpty) {
      positions.add(getRandomPosition());
    }
    //如果蛇的位置小于蛇的长度，添加几个默认的随机位置
    while (snakeLength > positions.length) {
      positions.add(positions[positions.length - 1]);
    }
    //移动蛇的位置
    for (var i = positions.length - 1; i > 0; i--) {
      positions[i] = positions[i - 1];
    }
    //获取下一个位置
    positions[0] = getNextPosition(positions[0]);
  }

  ///绘制食物
  void drawFood() {
    //定义随机位置
    if (foodPosition == const Offset(0, 0)) {
      foodPosition = getRandomPosition();
    }
    //如果蛇的位置和食物的位置重合，蛇的长度加一，食物的位置重新定义,速递增加
    if (positions[0] == foodPosition) {
      snakeLength++;
      speed -= 10;
      foodPosition = getRandomPosition();
    }
    //定义食物组件
    food = Piece(
      dx: foodPosition.dx.toInt(),
      dy: foodPosition.dy.toInt(),
      step: step,
      color: Colors.red,
    );
  }

  ///获取最接近的十
  int getNearestTens(int num) {
    int output;
    output = (num ~/ step) * step;
    if (output == 0) {
      output += step;
    }
    return output;
  }

  ///改变速度
  void changeSpeed() {
    if (timer != null) {
      if (timer?.isActive == true) {
        timer?.cancel();
      }
    }
    //每200毫秒更新一次
    timer = Timer.periodic(Duration(milliseconds: speed), (timer) {
      update(['snake']);
    });
  }

  ///随机蛇的方向
  Direction randomDirection() {
    int random = Random().nextInt(4);
    late Direction newDirection;
    switch (random) {
      case 0:
        newDirection = Direction.up;
        break;
      case 1:
        newDirection = Direction.down;
        break;
      case 2:
        newDirection = Direction.left;
        break;
      case 3:
        newDirection = Direction.right;
        break;
    }
    return newDirection;
  }

  ///重置游戏
  void restart() {
    //重置蛇的长度
    snakeLength = 5;
    //重置蛇的速度
    speed = 200;
    //重置蛇的位置
    positions = [];
    //重置食物的位置
    foodPosition = getRandomPosition();
    //重置蛇的方向
    direction = randomDirection();
    changeSpeed();
  }

  ///改变方向
  void changeDirection(Direction newDirection) {
    if (direction == Direction.up && newDirection == Direction.down) {
      return;
    }
    if (direction == Direction.down && newDirection == Direction.up) {
      return;
    }
    if (direction == Direction.left && newDirection == Direction.right) {
      return;
    }
    if (direction == Direction.right && newDirection == Direction.left) {
      return;
    }
    update(['snake']);
    direction = newDirection;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}

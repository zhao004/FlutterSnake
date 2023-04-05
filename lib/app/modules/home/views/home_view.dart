import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.amber,
        child: GetBuilder<HomeController>(
            id: 'snake',
            builder: (logic) {
              return Stack(children: [
                //蛇
                Stack(
                  children: controller.getPieces(),
                ),
                controller.food,
                //移动方向控制
                const DirectionControl(),
              ]);
            }),
      ),
    );
  }
}

///蛇的组件
class Piece extends StatelessWidget {
  final int dx;
  final int dy;
  final int step;
  final Color color;

  const Piece({
    Key? key,
    required this.dx,
    required this.dy,
    required this.step,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: dx.toDouble(),
      top: dy.toDouble(),
      child: Container(
        width: step.toDouble(),
        height: step.toDouble(),
        color: color,
        //边框
        child: const DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(width: 1, color: Colors.black),
              top: BorderSide(width: 1, color: Colors.black),
              right: BorderSide(width: 1, color: Colors.white),
              bottom: BorderSide(width: 1, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

///移动方向控制组件
class DirectionControl extends StatelessWidget {
  const DirectionControl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<HomeController>();
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //上
          ControlButton(
            icon: const Icon(
              Icons.arrow_drop_up,
              size: 40,
            ),
            onPressed: () {
              controller.changeDirection(Direction.up);
            },
          ),
          //左
          ControlButton(
            icon: const Icon(
              Icons.arrow_left,
              size: 40,
            ),
            onPressed: () {
              controller.changeDirection(Direction.left);
            },
          ),
          //右
          ControlButton(
            icon: const Icon(
              Icons.arrow_right,
              size: 40,
            ),
            onPressed: () {
              controller.changeDirection(Direction.right);
            },
          ),
          //下
          ControlButton(
            icon: const Icon(
              Icons.arrow_drop_down,
              size: 40,
            ),
            onPressed: () {
              controller.changeDirection(Direction.down);
            },
          ),
        ],
      ),
    );
  }
}

//方向控制按钮
class ControlButton extends StatelessWidget {
  final Icon icon;
  final Function onPressed;

  const ControlButton({Key? key, required this.icon, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 1,
      child: SizedBox(
        width: 60,
        height: 60,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () => onPressed(),
            child: icon,
          ),
        ),
      ),
    );
  }
}

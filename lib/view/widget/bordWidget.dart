import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trade_practice_tool/element/bord.dart';

class BordWidget extends StatelessWidget {
  final Bord bord;
  final double width = 300;
  final double height = 600;
  final double containerWidth = 100;
  final double containerHeignt = 30;
  final double containerBorderWidth = 0.3;

  BordWidget({
    required this.bord,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> priceList = [
      PriceContainer(value: bord.sell10.price),
      PriceContainer(value: bord.sell9.price),
      PriceContainer(value: bord.sell8.price),
      PriceContainer(value: bord.sell7.price),
      PriceContainer(value: bord.sell6.price),
      PriceContainer(value: bord.sell5.price),
      PriceContainer(value: bord.sell4.price),
      PriceContainer(value: bord.sell3.price),
      PriceContainer(value: bord.sell2.price),
      PriceContainer(value: bord.sell1.price, textColor: Colors.blue),
      PriceContainer(value: bord.buy1.price, textColor: Colors.red),
      PriceContainer(value: bord.buy2.price),
      PriceContainer(value: bord.buy3.price),
      PriceContainer(value: bord.buy4.price),
      PriceContainer(value: bord.buy5.price),
      PriceContainer(value: bord.buy6.price),
      PriceContainer(value: bord.buy7.price),
      PriceContainer(value: bord.buy8.price),
      PriceContainer(value: bord.buy9.price),
      PriceContainer(value: bord.buy10.price),
    ];
    List<Widget> buyList = [
      NullContainer(),
      NullContainer(),
      NullContainer(),
      NullContainer(),
      NullContainer(),
      NullContainer(),
      NullContainer(),
      NullContainer(),
      NullContainer(),
      NullContainer(),
      QtyContainer(value: bord.buy1.qty, textColor: Colors.red),
      QtyContainer(value: bord.buy2.qty),
      QtyContainer(value: bord.buy3.qty),
      QtyContainer(value: bord.buy4.qty),
      QtyContainer(value: bord.buy5.qty),
      QtyContainer(value: bord.buy6.qty),
      QtyContainer(value: bord.buy7.qty),
      QtyContainer(value: bord.buy8.qty),
      QtyContainer(value: bord.buy9.qty),
      QtyContainer(value: bord.buy10.qty),
    ];
    List<Widget> sellList = [
      QtyContainer(value: bord.buy10.qty),
      QtyContainer(value: bord.buy9.qty),
      QtyContainer(value: bord.buy8.qty),
      QtyContainer(value: bord.buy7.qty),
      QtyContainer(value: bord.buy6.qty),
      QtyContainer(value: bord.buy5.qty),
      QtyContainer(value: bord.buy4.qty),
      QtyContainer(value: bord.buy3.qty),
      QtyContainer(value: bord.buy2.qty),
      QtyContainer(value: bord.buy1.qty, textColor: Colors.blue),
      NullContainer(),
      NullContainer(),
      NullContainer(),
      NullContainer(),
      NullContainer(),
      NullContainer(),
      NullContainer(),
      NullContainer(),
      NullContainer(),
      NullContainer(),
    ];

    return Container(
      width: width,
      height: height,
      child: Row(
        children: [
          Column(
            children: sellList,
          ),
          Column(
            children: priceList,
          ),
          Column(
            children: buyList,
          ),
        ],
      ),
    );
  }

  Widget PriceContainer({double? value, Color textColor = Colors.white}) {
    return Container(
      width: containerWidth,
      height: containerHeignt,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: containerBorderWidth,
        ),
      ),
      child: Text(
        '${value ?? ""}',
        style: TextStyle(
          color: textColor,
        ),
      ),
    );
  }

  Widget QtyContainer({int? value, Color textColor = Colors.white}) {
    return Container(
      width: containerWidth,
      height: containerHeignt,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: containerBorderWidth,
        ),
      ),
      child: Text(
        '${value ?? ""}',
        style: TextStyle(
          color: textColor,
        ),
      ),
    );
  }

  Widget NullContainer() {
    return Container(
      width: containerWidth,
      height: containerHeignt,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: containerBorderWidth,
        ),
      ),
    );
  }
}

// class _AnimationTest extends StatefulWidget {
//   @override
//   _AnimationTextState createState() => _AnimationTextState();
// }

// class _AnimationTextState extends State<_AnimationTest>
//     with SingleTickerProviderStateMixin {

//   Animation<Color> animation;
//   AnimationController controller;

//   @override
//   void initState() {
//     super.initState();
//     controller =
//         AnimationController(duration: const Duration(seconds: 1), vsync: this);
//     animation =
//         ColorTween(begin: Colors.indigo, end: Colors.lime).animate(controller)
//           ..addListener(() {
//             setState(() {
//               // The state that has changed here is the animation object’s value.
//             });
//           });
//   }

//   void animateColor() {
//     controller.forward();
//   }
 
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }
  
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
// }

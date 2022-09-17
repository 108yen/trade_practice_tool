import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trade_practice_tool/element/bord.dart';

class BordWidget extends StatelessWidget {
  final Bord bord;
  final double width = 300;
  final double height = 600;
  final double containerWidth = 80;
  final double containerHeignt = 20;
  final double containerBorderWidth = 0.3;

  BordWidget({
    required this.bord,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> priceList = [
      _BordContainer(value: bord.sell10.price),
      _BordContainer(value: bord.sell9.price),
      _BordContainer(value: bord.sell8.price),
      _BordContainer(value: bord.sell7.price),
      _BordContainer(value: bord.sell6.price),
      _BordContainer(value: bord.sell5.price),
      _BordContainer(value: bord.sell4.price),
      _BordContainer(value: bord.sell3.price),
      _BordContainer(value: bord.sell2.price),
      _BordContainer(value: bord.sell1.price, textColor: Colors.blue),
      _BordContainer(value: bord.buy1.price, textColor: Colors.red),
      _BordContainer(value: bord.buy2.price),
      _BordContainer(value: bord.buy3.price),
      _BordContainer(value: bord.buy4.price),
      _BordContainer(value: bord.buy5.price),
      _BordContainer(value: bord.buy6.price),
      _BordContainer(value: bord.buy7.price),
      _BordContainer(value: bord.buy8.price),
      _BordContainer(value: bord.buy9.price),
      _BordContainer(value: bord.buy10.price),
    ];
    List<Widget> buyList = [
      _BordContainer(),
      _BordContainer(),
      _BordContainer(),
      _BordContainer(),
      _BordContainer(),
      _BordContainer(),
      _BordContainer(),
      _BordContainer(),
      _BordContainer(),
      _BordContainer(),
      _BordContainer(value: bord.buy1.qty, textColor: Colors.red),
      _BordContainer(value: bord.buy2.qty),
      _BordContainer(value: bord.buy3.qty),
      _BordContainer(value: bord.buy4.qty),
      _BordContainer(value: bord.buy5.qty),
      _BordContainer(value: bord.buy6.qty),
      _BordContainer(value: bord.buy7.qty),
      _BordContainer(value: bord.buy8.qty),
      _BordContainer(value: bord.buy9.qty),
      _BordContainer(value: bord.buy10.qty),
    ];
    List<Widget> sellList = [
      _BordContainer(value: bord.buy10.qty),
      _BordContainer(value: bord.buy9.qty),
      _BordContainer(value: bord.buy8.qty),
      _BordContainer(value: bord.buy7.qty),
      _BordContainer(value: bord.buy6.qty),
      _BordContainer(value: bord.buy5.qty),
      _BordContainer(value: bord.buy4.qty),
      _BordContainer(value: bord.buy3.qty),
      _BordContainer(value: bord.buy2.qty),
      _BordContainer(value: bord.buy1.qty, textColor: Colors.blue),
      _BordContainer(),
      _BordContainer(),
      _BordContainer(),
      _BordContainer(),
      _BordContainer(),
      _BordContainer(),
      _BordContainer(),
      _BordContainer(),
      _BordContainer(),
      _BordContainer(),
    ];

    return Container(
      width: width,
      height: height,
      child: Column(
        children: [
          Row(
            children: [
              _BordContainer(value: bord.marketOrderSellQty),
              _BordContainer(value: '成行'),
              _BordContainer(value: bord.marketOrderBuyQty),
            ],
          ),
          SizedBox(
            height: 3,
          ),
          Row(
            children: [
              _BordContainer(value: bord.overSellQty),
              _BordContainer(value: 'over'),
              _BordContainer(),
            ],
          ),
          Row(
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
          Row(
            children: [
              _BordContainer(),
              _BordContainer(value: 'under'),
              _BordContainer(value: bord.underBuyQty),
            ],
          ),
        ],
      ),
    );
  }

  Widget _BordContainer({dynamic value, Color textColor = Colors.white}) {
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
//         AnimationController(duration: Duration(seconds: 1), vsync: this);
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trade_practice_tool/element/bord.dart';
import 'package:trade_practice_tool/theme/theme_data.dart';

class BordWidget extends StatelessWidget {
  final Bord bord;
  final double width = 250;
  final double height = 473;
  final double containerWidth = 80;
  final double containerHeignt = 20;
  final double containerBorderWidth = 0.3;

  BordWidget({
    required this.bord,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> priceList = [
      _BordContainer(context: context, value: bord.sell10.price),
      _BordContainer(context: context, value: bord.sell9.price),
      _BordContainer(context: context, value: bord.sell8.price),
      _BordContainer(context: context, value: bord.sell7.price),
      _BordContainer(context: context, value: bord.sell6.price),
      _BordContainer(context: context, value: bord.sell5.price),
      _BordContainer(context: context, value: bord.sell4.price),
      _BordContainer(context: context, value: bord.sell3.price),
      _BordContainer(context: context, value: bord.sell2.price),
      _BordContainer(
          context: context, value: bord.sell1.price, textColor: Colors.blue),
      _BordContainer(
          context: context, value: bord.buy1.price, textColor: Colors.red),
      _BordContainer(context: context, value: bord.buy2.price),
      _BordContainer(context: context, value: bord.buy3.price),
      _BordContainer(context: context, value: bord.buy4.price),
      _BordContainer(context: context, value: bord.buy5.price),
      _BordContainer(context: context, value: bord.buy6.price),
      _BordContainer(context: context, value: bord.buy7.price),
      _BordContainer(context: context, value: bord.buy8.price),
      _BordContainer(context: context, value: bord.buy9.price),
      _BordContainer(context: context, value: bord.buy10.price),
    ];
    List<Widget> buyList = [
      _BordContainer(
        context: context,
      ),
      _BordContainer(
        context: context,
      ),
      _BordContainer(
        context: context,
      ),
      _BordContainer(
        context: context,
      ),
      _BordContainer(
        context: context,
      ),
      _BordContainer(
        context: context,
      ),
      _BordContainer(
        context: context,
      ),
      _BordContainer(
        context: context,
      ),
      _BordContainer(
        context: context,
      ),
      _BordContainer(
        context: context,
      ),
      _BordContainer(
          context: context, value: bord.buy1.qty, textColor: Colors.red),
      _BordContainer(context: context, value: bord.buy2.qty),
      _BordContainer(context: context, value: bord.buy3.qty),
      _BordContainer(context: context, value: bord.buy4.qty),
      _BordContainer(context: context, value: bord.buy5.qty),
      _BordContainer(context: context, value: bord.buy6.qty),
      _BordContainer(context: context, value: bord.buy7.qty),
      _BordContainer(context: context, value: bord.buy8.qty),
      _BordContainer(context: context, value: bord.buy9.qty),
      _BordContainer(context: context, value: bord.buy10.qty),
    ];
    List<Widget> sellList = [
      _BordContainer(context: context, value: bord.buy10.qty),
      _BordContainer(context: context, value: bord.buy9.qty),
      _BordContainer(context: context, value: bord.buy8.qty),
      _BordContainer(context: context, value: bord.buy7.qty),
      _BordContainer(context: context, value: bord.buy6.qty),
      _BordContainer(context: context, value: bord.buy5.qty),
      _BordContainer(context: context, value: bord.buy4.qty),
      _BordContainer(context: context, value: bord.buy3.qty),
      _BordContainer(context: context, value: bord.buy2.qty),
      _BordContainer(
          context: context, value: bord.buy1.qty, textColor: Colors.blue),
      _BordContainer(
        context: context,
      ),
      _BordContainer(
        context: context,
      ),
      _BordContainer(
        context: context,
      ),
      _BordContainer(
        context: context,
      ),
      _BordContainer(
        context: context,
      ),
      _BordContainer(
        context: context,
      ),
      _BordContainer(
        context: context,
      ),
      _BordContainer(
        context: context,
      ),
      _BordContainer(
        context: context,
      ),
      _BordContainer(
        context: context,
      ),
    ];

    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(5),
      color: Theme.of(context).background,
      child: Column(
        children: [
          Row(
            children: [
              _BordContainer(context: context, value: bord.marketOrderSellQty),
              _BordContainer(context: context, value: '成行'),
              _BordContainer(context: context, value: bord.marketOrderBuyQty),
            ],
          ),
          SizedBox(
            height: 3,
          ),
          Row(
            children: [
              _BordContainer(context: context, value: bord.overSellQty),
              _BordContainer(context: context, value: 'over'),
              _BordContainer(
                context: context,
              ),
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
              _BordContainer(
                context: context,
              ),
              _BordContainer(context: context, value: 'under'),
              _BordContainer(context: context, value: bord.underBuyQty),
            ],
          ),
        ],
      ),
    );
  }

  Widget _BordContainer({
    dynamic value,
    Color textColor = Colors.white,
    required BuildContext context,
  }) {
    return Container(
      width: containerWidth,
      height: containerHeignt,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).grayColor,
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

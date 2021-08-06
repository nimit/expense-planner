import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double amt;
  final double perctOfTotal;

  const ChartBar(this.label, this.amt, this.perctOfTotal);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      return Column(
        children: [
          Container(
            height: constraints.maxHeight * 0.15,
            child: FittedBox(
              //Shrinks its child to fit
              child: Text('\$${amt.toStringAsFixed(0)}'),
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          Transform.rotate(
            //So that the bars are in the upright position
            angle: 3.1415, //180 degrees = pi radian
            child: Container(
              height: constraints.maxHeight * 0.6,
              width: 10,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      // color: Theme.of(context).primaryColor,
                      color: Color.fromRGBO(220, 220, 220, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ), //Bottom most
                  FractionallySizedBox(
                    heightFactor: perctOfTotal,
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration: BoxDecoration(
                        // color: Color.fromRGBO(220, 220, 220, 1),
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          Container(
            height: constraints.maxHeight * 0.15,
            child: FittedBox(
              child: Text(label),
            ),
          ),
        ],
      );
    });
  }
}

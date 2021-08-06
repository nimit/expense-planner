import 'package:flutter/material.dart';

import 'package:expense_planner/models/transaction.dart';
import 'transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> _transactions;
  final Function _deleteTransaction;
  TransactionList(this._transactions, this._deleteTransaction);
  @override
  Widget build(BuildContext context) {
    return _transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: [
                Container(
                  height: constraints.maxHeight * 0.15,
                  child: FittedBox(
                    child: Text(
                      'No transactions added yet!',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ),
                SizedBox(
                  height: constraints.maxHeight * 0.1,
                ),
                Container(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          })
        : ListView.builder(
            //The ListView widget is essentially a Column with a Scrollable functionality. It needs an extra wrapper around it which can define its height as it takes infinite height unlike a column which takes all the height it can take(available).
            // For large lists, it is better to use ListView.builder special constructor as it doesn't render the widgets that are offscreen saving memory space i.e., it has special optimizations in place unlike ListView(children: []).
            itemCount: _transactions.length,
            itemBuilder: (context, index) {
              return TransactionItem(
                  transaction: _transactions[index],
                  deleteTransaction: _deleteTransaction);
            },
          );
  }
}

// This is an alternative return method for the ListView.builder method

// return Card(
//   child: Row(
//     children: [
//       Container(
//         child: Text(
//           '\$${_transactions[index].amount.toStringAsFixed(2)}',
//           style: TextStyle(
//               fontSize: 20 * MediaQuery.of(context).textScaleFactor,
//               fontWeight: FontWeight.bold,
//               color: Theme.of(context).primaryColor),
//         ),
//         margin:
//             EdgeInsets.symmetric(vertical: 7.5, horizontal: 15),
//         decoration: BoxDecoration(
//             border: Border.all(
//                 color: Theme.of(context).primaryColor,
//                 width: 2)),
//         padding: EdgeInsets.all(10),
//       ),
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             _transactions[index].title,
//             style: Theme.of(context).textTheme.headline6,
//           ),
//           Text(
//             DateFormat.yMMMd()
//                 .format(_transactions[index].date),
//             style: TextStyle(
//               color: Colors.grey,
//             ),
//           ),
//         ],
//       ),
//     ],
//   ),
// );

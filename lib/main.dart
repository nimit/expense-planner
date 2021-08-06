import 'dart:io'; //For determining which platform the app is running on...

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

import './models/transaction.dart';
import './widgets/chart.dart';
import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);  //This is used to lock the app in portrait mode. Requires services.dart file.
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expenses!',
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amberAccent,
        errorColor: Colors.red,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20, // * MediaQuery.of(context).textScaleFactor,
                //Scales according to the text settings in the device...
                fontWeight: FontWeight.w500,
              ),
              button: TextStyle(color: Colors.white),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 25, // * MediaQuery.of(context).textScaleFactor,
                  fontWeight: FontWeight.w600,
                ),
              ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showChart = false;
  final List<Transaction> _transactions = [
    // Transaction('1', 'New Shoes', 10.99, DateTime.now()),
    // Transaction('2', 'Groceries', 30, DateTime.now()),
  ];

  List<Transaction> get _recentTransactions {
    // return _transactions;
    return _transactions
        .where((tx) => tx.date.isAfter(
              DateTime.now().subtract(
                Duration(days: 7),
              ),
            ))
        .toList();
  }

  void _addNewTransaction(String title, double amount, DateTime date) {
    final newTx = Transaction(DateTime.now().toString(), title, amount, date);
    setState(() => _transactions.add(newTx));
  }

  void _startAtNewTx(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTransaction(_addNewTransaction);
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tx) => tx.id == id);
    });
  }

  List<Widget> _buildLandscape(
      MediaQueryData mediaQuery, AppBar appBar, Widget txList) {
    return [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          'Show Chart',
          style: Theme.of(context).textTheme.headline6,
        ),
        Switch.adaptive(
            //So that it renders differently on iOS
            activeColor: Theme.of(context).accentColor,
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            }),
      ]),
      _showChart //Switch: Show Chart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child: Chart(_recentTransactions),
            )
          : txList,
    ];
  }

  List<Widget> _buildPortrait(
      MediaQueryData mediaQuery, AppBar appBar, Widget txList) {
    return [
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(_recentTransactions),
      ),
      txList,
    ];
  }

  Widget _buildiOSBar() {
    return CupertinoNavigationBar(
      middle: Text(
        'Expenses!',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            child: Icon(CupertinoIcons.add),
            onTap: () => _startAtNewTx(context),
          )
        ],
      ),
    );
  }

  Widget _buildAndroidBar() {
    return AppBar(
      title: Text(
        'Expenses!',
      ),
      actions: [
        IconButton(
            icon: Icon(Icons.add), onPressed: () => _startAtNewTx(context))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar =
        Platform.isIOS ? _buildiOSBar() : _buildAndroidBar();
    final txList = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(_transactions, _deleteTransaction),
    );
    final pageBody = SafeArea(
      child: SingleChildScrollView(
        //Adds scrolling functionality to the app. Only works if it is in the parent of the main widget.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLandscape) ..._buildLandscape(mediaQuery, appBar, txList),
            if (!isLandscape) ..._buildPortrait(mediaQuery, appBar, txList),
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar,
            child: pageBody,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAtNewTx(context),
                  ),
          );
  }
}

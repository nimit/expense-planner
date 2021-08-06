import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import './adaptive_flat_button.dart';

class NewTransaction extends StatefulWidget {
  // String _titleInput;
  // String _amountInput;
//Instead of the above variables and custom return functions, we use a controller.
  final Function _addNewTransaction;
  const NewTransaction(this._addNewTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  void _submitData() {
    if (_amountController.text.isEmpty) return;
    final enteredText = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredText.isEmpty || enteredAmount <= 0 || _selectedDate == null)
      return;
    widget._addNewTransaction(
      //This helps the state access the property of the widget (technically another class).
      enteredText,
      enteredAmount,
      _selectedDate,
    );
    Navigator.of(context).pop(); //To remove the add transaction pop-up.
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 365 * 10 + 2)),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: 10 * MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                // onChanged: (value) => _titleInput = value,
                controller: _titleController,
                onSubmitted: (_) => _submitData(),
                //(_) means that the value received is not used. Not a rule. Just a convention.
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Amount'),
                // onChanged: (value) => _amountInput = value,
                controller: _amountController,
                keyboardType: TextInputType.number,
                // keyboardType: TextInputType.numberWithOptions(decimal: true),  //If the above one doesn't work for decimal inputs.
                onSubmitted: (_) => _submitData(),
              ),
              Container(
                height: 90,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(_selectedDate == null
                          ? 'No Date Chosen!'
                          : DateFormat.yMMMEd().format(_selectedDate)),
                    ),
                    AdaptiveFlatButton.icon(
                      Text(
                        'Choose Date',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      _presentDatePicker,
                      Icon(
                        // Icons.calendar_today_rounded,
                        CupertinoIcons.calendar,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    // FlatButton.icon(
                    //   onPressed: _presentDatePicker,
                    //   icon: Icon(
                    //     // Icons.calendar_today_rounded,
                    //     CupertinoIcons.calendar,
                    //     color: Theme.of(context).primaryColor,
                    //   ),
                    //   label: Text(
                    //     'Choose Date',
                    //     style: Theme.of(context).textTheme.bodyText1,
                    //   ),
                    // )
                    // FlatButton(onPressed: () {}, child: Text('Choose Date')),
                  ],
                ),
              ),
              RaisedButton(
                onPressed: _submitData,
                child: Text('Add Transaction'),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveFlatButton extends StatelessWidget {
  final Widget _msg;
  final Function _btnHandler;
  Icon icon;
  AdaptiveFlatButton(this._msg, this._btnHandler);
  AdaptiveFlatButton.icon(this._msg, this._btnHandler, this.icon);
  @override
  Widget build(BuildContext context) {
    return icon != null
        ? Platform.isIOS
            ? CupertinoButton(child: icon, onPressed: _btnHandler)
            : FlatButton.icon(
                onPressed: _btnHandler,
                label: _msg,
                icon: icon,
              )
        : Platform.isIOS
            ? CupertinoButton(child: _msg, onPressed: _btnHandler)
            : FlatButton(
                onPressed: _btnHandler,
                child: _msg,
              );
  }
}

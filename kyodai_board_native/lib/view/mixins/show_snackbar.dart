import 'package:flutter/material.dart';

abstract class ShowSnackBar{
  static void show(ScaffoldState sccafoldState, String message){
    sccafoldState.showSnackBar(SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'とじる',
        onPressed: () {
          sccafoldState.removeCurrentSnackBar();
        },
      ),
      duration: const Duration(seconds: 3),
    ));
  }
}
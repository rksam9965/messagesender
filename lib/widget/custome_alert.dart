import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

void displayAlert(
    BuildContext context, GlobalKey<ScaffoldState> scaffKey, String message) {
  if (Platform.isAndroid) {
    androidSnackBar(context, scaffKey, message);
  } else {
    print("iOSAlertView");
    iOSAlertView(context, message);
  }
}

void androidSnackBar(
    BuildContext context, GlobalKey<ScaffoldState> scaffKey, String message) {
  final snackBar = SnackBar(
    content: Text(message, textScaleFactor: 1,),
    action: SnackBarAction(
      label: 'Close',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void iOSAlertView(BuildContext context, String message) {
  showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) =>
          CupertinoAlertDialog(content: Text(message, textScaleFactor: 1,), actions: [
            CupertinoDialogAction(
                isDefaultAction: true,
                child: const Text("Close", textScaleFactor: 1,),
                onPressed: () {
                  Navigator.pop(context);
                })
          ]));
}

Container getProgressDialog() {
  if (Platform.isAndroid) {
    return Container(
        decoration: const BoxDecoration(
          color: CupertinoColors.white,
        ),
        child: const Center(child: CircularProgressIndicator()));
  }
  return Container(
      decoration: const BoxDecoration(
        color: CupertinoColors.white,
      ),
      child: const Center(child: CupertinoActivityIndicator(radius: 20)));
}

displayProgress(BuildContext context) {
  return showDialog(
      barrierColor: Colors.transparent,
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
            child: Center(
              child: (Platform.isAndroid)
                  ? const CircularProgressIndicator()
                  : const CupertinoActivityIndicator(radius: 10),
            ),
            onWillPop: () async => false);
      });
}

displayProgress1(BuildContext context) {
  return showDialog(
      barrierColor: Colors.transparent,
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
            child: Center(
              // child: (Platform.isAndroid)
              // ? const CircularProgressIndicator()
              // : const CupertinoActivityIndicator(radius: 10),
            ),
            onWillPop: () async => false);
      });
}

void hideProgress(BuildContext context) {
  Navigator.pop(context);
}

Widget displayActivityIndicator() {
  if (Platform.isAndroid) {
    return const CircularProgressIndicator();
  } else {
    return const CupertinoActivityIndicator(radius: 20);
  }
}

void hideKeyboard() {
  FocusManager.instance.primaryFocus!.unfocus();
}

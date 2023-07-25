


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

class CreateBagState extends BaseGetState{
  int stepsCount = 4;

  var currentStep = 0.obs;

  bool isMnemonicBackuped = false;

  var pages = <Widget>[];

  List<String> mnemonics = [];

  PageController pageController = PageController();
}
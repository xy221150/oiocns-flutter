import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/store/state.dart';

import '../../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class ThingDetailsController extends BaseController<ThingDetailsState>
    with GetTickerProviderStateMixin {
  final ThingDetailsState state = ThingDetailsState();

  ThingDetailsController() {
    state.tabController = TabController(length: tabTitle.length, vsync: this);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    settingCtrl.store.onRecordRecent(
        RecentlyUseModel(type: StoreEnum.thing.label, thing: state.thing));
  }

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
  }
}

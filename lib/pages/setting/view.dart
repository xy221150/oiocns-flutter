import 'package:flutter/material.dart';
import 'package:orginone/dart/core/getx/submenu_list/base_submenu_page_view.dart';
import 'logic.dart';
import 'setting_sub_page/view.dart';
import 'state.dart';

class SettingPage extends BaseSubmenuPage<SettingController, SettingState> {

  @override
  Widget buildPageView(String type) {
    return SettingSubPage(type);
  }
}

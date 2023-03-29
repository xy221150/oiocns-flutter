import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/target/itarget.dart';

class CompanyInfoState extends BaseGetState {

  SettingController settingController = Get.find<SettingController>();

  ICompany? get company => settingController.company;

  var unitMember = <XTarget>[].obs;

  var joinGroup = <IGroup>[].obs;

  late TabController tabController;

  var index = 0.obs;
}

List<String> tabTitle = [
  "单位成员",
  "加入集团",
];

List<String> docTitle = [
  "账号",
  "昵称",
  "姓名",
  "手机号",
  "签名",
];

List<String> groupTitle = [
  "集团简称",
  "集团编码",
  "集团全称",
  "集团代码",
  "集团简介",
];
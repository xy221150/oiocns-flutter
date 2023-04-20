import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/pages/universal_navigator/item.dart';
import 'package:orginone/pages/universal_navigator/state.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';

import 'logic.dart';
import 'state.dart';

class WarehouseManagementPage extends BaseGetView<WarehouseManagementController,WarehouseManagementState>{
  @override
  Widget buildView() {
    return GyScaffold(
      titleName: "仓库",
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.h),
          child: Column(
            children: [
              CommonWidget.commonHeadInfoWidget("个人"),
              ...personalWork.map((e) {
                return NavigatorItem(item: NavigatorModel(title: e),onTap: (){
                  controller.jumpUniversalNavigator(e);
                },);
              }).toList(),
              CommonWidget.commonHeadInfoWidget("组织"),
              ...state.spaces.map((e){
                return NavigatorItem(item: NavigatorModel(title: e.name),onTap: (){
                  controller.jumpUniversalNavigator(e.name);
                },);
              }),
            ],
          ),
        ),
      ),
    );
  }
}
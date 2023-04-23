import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/pages/setting/config.dart';
import 'package:orginone/util/authority.dart';
import 'package:orginone/widget/common_widget.dart';

import 'setting/state.dart';

class PopupMenuWidget<T> extends StatefulWidget {
  final SettingNavModel model;
  final PopupMenuItemSelected<T>? onSelected;

  const PopupMenuWidget(
      {Key? key,
       required this.model,
      this.onSelected})
      : super(key: key);

  @override
  State<PopupMenuWidget> createState() => _PopupMenuWidgetState();
}

class _PopupMenuWidgetState extends State<PopupMenuWidget> {
  var popupMenuItem = <PopupMenuItem>[];

  SettingController get settingController => Get.find<SettingController>();

  ITarget? target;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  void init() {
    popupMenuItem.clear();
    target = (widget.model.source is ITarget)?widget.model.source:null;
    if(widget.model.spaceEnum!=null){
      switch (widget.model.spaceEnum) {
        case SpaceEnum.innerAgency:
          popupMenuItem.add(newPopupMenuItem("新建部门", "create"));
          break;
        case SpaceEnum.outAgency:
          popupMenuItem.add(newPopupMenuItem("新建集团", "create"));
          break;
        case SpaceEnum.stationSetting:
          popupMenuItem.add(newPopupMenuItem("新建岗位", "create"));
          break;
        case SpaceEnum.personGroup:
        case SpaceEnum.companyCohort:
          popupMenuItem.add(newPopupMenuItem("新建群组", "create"));
          break;
      }
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        await initPopupMenuItem();
      });
    }
    if(widget.model.standardEnum!=null){
      switch (widget.model.standardEnum) {
        case StandardEnum.permission:
          // TODO: Handle this case.
          break;
        case StandardEnum.dict:
          if(widget.model.source == null){
            popupMenuItem.add(newPopupMenuItem("新建字典", "create"));
          }else{
            popupMenuItem.add(newPopupMenuItem("编辑字典", "edit"));
            popupMenuItem.add(newPopupMenuItem("删除字典", "delete"));
          }
          break;
        case StandardEnum.attribute:
          // TODO: Handle this case.
          break;
        case StandardEnum.classCriteria:
          // TODO: Handle this case.
          break;
      }
    }
  }

  Future<bool> initPopupMenuItem() async {
    if (target == null) {
      return popupMenuItem.isNotEmpty;
    }
    bool isSuperAdmin = await Auth.isSuperAdmin(target!);
    if (target?.subTeamTypes.isNotEmpty??false) {
      if (isSuperAdmin) {
        popupMenuItem.add(newPopupMenuItem("新建子组织", "create"));
      }
    }
    if (isSuperAdmin) {
      popupMenuItem.add(newPopupMenuItem("编辑", "edit"));
      if (target != settingController.user &&
          target != settingController.company) {
        popupMenuItem.add(newPopupMenuItem("删除", "delete"));
      }
    } else if (await Auth.isSuperAdmin(settingController.space)) {
      if (target != settingController.user &&
          target != settingController.company) {
        popupMenuItem.add(newPopupMenuItem("退出${target!.typeName}", "signOut"));
      }
    }

    setState(() {});
    return popupMenuItem.isNotEmpty;
  }

  PopupMenuItem newPopupMenuItem(String text, String value) {
    return PopupMenuItem(
      child: Text(text),
      value: value,
    );
  }

  @override
  void didUpdateWidget(covariant PopupMenuWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (oldWidget.model != widget.model) {
      init();
    }
  }

  @override
  Widget build(BuildContext context) {
    if(popupMenuItem.isEmpty){
      return Container();
    }
    return CommonWidget.commonPopupMenuButton(
      items: popupMenuItem,
      onSelected: widget.onSelected,
    );
  }
}

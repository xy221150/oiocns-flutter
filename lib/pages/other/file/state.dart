import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';
import 'package:orginone/dart/core/thing/file_info.dart';

class FileState extends BaseBreadcrumbNavState {
  TextEditingController searchController = TextEditingController();

  FileState(){
    model.value = Get.arguments?['data'];
    if (model.value == null) {
      ISysFileInfo? file = Get.arguments?['file'];
      model.value = BaseBreadcrumbNavModel(
        source: file,
        name: file?.metadata?.name??"",
      );
    }

    title = model.value!.name;
  }
}
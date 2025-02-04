import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_multiplex_page.dart';

import 'logic.dart';
import 'state.dart';
import 'store_nav_item.dart';

class StoreTreePage extends BaseBreadcrumbNavMultiplexPage<StoreTreeController,
    StoreTreeState> {
  @override
  Widget body() {
    return SingleChildScrollView(
      child: Obx(() {
        var children = state.model.value!.children
            .where((element) => element.name.contains(state.keyword.value))
            .toList();
        return Column(
          children: children.map((e) {
            return StoreNavItem(
              item: e,
              onTap: () {
                controller.jumpDetails(e);
              },
              onNext: () {
                controller.onNext(e);
              },
              onSelected: (key, item) {
                controller.operation(key, item);
              },
            );
          }).toList(),
        );
      }),
    );
  }

  @override
  StoreTreeController getController() {
    return StoreTreeController();
  }

  @override
  String tag() {
    // TODO: implement tag
    return hashCode.toString();
  }

  @override
  List<PopupMenuItem<PopupMenuKey>> popupMenuItems() {
    if (state.model.value!.spaceEnum == SpaceEnum.directory &&
        state.model.value!.source == null) {
      return super.popupMenuItems();
    }

    List<PopupMenuKey> items = [PopupMenuKey.shareQr];
    return items
        .map((e) => PopupMenuItem(
              value: e,
              child: Text(e.label),
            ))
        .toList();
  }
}
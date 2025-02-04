import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/getx/base_get_list_page_view.dart';
import 'package:orginone/dart/core/getx/submenu_list/item.dart';
import 'package:orginone/dart/core/getx/submenu_list/list_adapter.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/store/store_tree/store_nav_item.dart';

import 'logic.dart';
import 'state.dart';

class StoreSubPage extends BaseGetListPageView<StoreSubController,StoreSubState>{

  late String type;

  StoreSubPage(this.type);

  @override
  Widget buildView() {
    if(type == "all"){
      return allWidget();
    }
    if(type == "common"){
      return commonWidget();
    }
    return recentWidget(type: type);
  }


  Widget allWidget(){
    return ListView.builder(
      controller: state.scrollController,
      itemBuilder: (BuildContext context, int index) {
        var item = state.nav!.children[index];
        return StoreNavItem(
          item: item,
          onTap: () {
            controller.jumpDetails(item);
          },
          onNext: () {
            controller.onNext(item);
          },
          onSelected: (key, item) {
            controller.operation(key, item);
          },
        );
      },
      itemCount: state.nav!.children.length,
    );
  }

  Widget commonWidget(){
    return Obx((){
      return GridView.builder(
        controller: state.scrollController,
        itemBuilder: (context, index) {
          var store = settingCtrl.store.storeFrequentlyUsed[index];
          var adapter = ListAdapter(
            title: store.name ?? "",
            image: store.fileItemShare?.thumbnailUint8List ??
                Ionicons.clipboard_sharp,
            labels: [store.storeEnum.label],
          );
          adapter.popupMenuItems = [
            PopupMenuItem(
              value: PopupMenuKey.removeCommon,
              child: Text(PopupMenuKey.removeCommon.label),
            )
          ];
          adapter.onSelected = (key) {
            controller.onSelected(key, store);
          };
          return GridItem(
              adapter:adapter );
        },
        itemCount: settingCtrl.store.storeFrequentlyUsed.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      );
    });
  }


  Widget recentWidget({String type = "file"}){
    return Obx((){
      var data = settingCtrl.store.recent.where((p0) => p0.type == type).toList();

      return ListView.builder(
        controller: state.scrollController,
        itemBuilder: (context, index) {
          var store = data[index];
          return ListItem(adapter: ListAdapter.store(store));
        },
        itemCount: data.length,
      );
    });
  }

  @override
  StoreSubController getController() {
    return StoreSubController(type);
  }

  @override
  String tag() {
    // TODO: implement tag
    return "store_$type";
  }

  @override
  bool displayNoDataWidget() =>false;
}
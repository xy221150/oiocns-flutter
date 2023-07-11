import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_list_view.dart';
import 'package:orginone/widget/unified.dart';

import 'base_freqiently_usedList_controller.dart';
import 'base_frequently_used_item.dart';
import 'base_frequently_used_list_state.dart';

abstract class BaseFrequentlyUsedListPage<
T extends BaseFrequentlyUsedListController,
S extends BaseFrequentlyUsedListState> extends BaseGetListView<T, S> {
  @override
  Widget? headWidget() {
    if(state.mostUsedList.isEmpty){
      return null;
    }
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(color: Colors.grey.shade200, width: 0.5))),
      child: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: state.scrollController,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(
                  horizontal: 20.w, vertical: 10.h),
              child: Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: state.mostUsedList.map((element) {
                    Widget child = BaseFrequentlyUsedItem(
                        recent: element,
                        onTap: () {
                          controller.onTapFrequentlyUsed(element);
                        });
                    int index = state.mostUsedList.indexOf(element);

                    if (index != (state.mostUsedList.length - 1)) {
                      child = Container(
                        margin: EdgeInsets.only(right: 10.w),
                        child: child,
                      );
                    }
                    return Container(
                      margin:
                      EdgeInsets.only(left: index == 0 ? 0 : 10.w),
                      child: child,
                    );
                  }).toList(),
                );
              }),
            ),
            Positioned(
              bottom: 0,
              left: Get.width / 2 - 25.w,
              child: Obx(() {
                return Container(
                  width: 50.w,
                  height: 5.h,
                  alignment: Alignment(state.scrollX.value, 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.w),
                  ),
                  child: Container(
                    width: 20.w,
                    height: 5.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.w),
                      color: XColors.themeColor,
                    ),
                  ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement showAppBar
  bool get showAppBar => false;
}

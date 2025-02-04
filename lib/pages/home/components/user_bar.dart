import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:orginone/dart/controller/user_controller.dart';
import 'package:orginone/dart/core/chat/message/msgchat.dart';
import 'package:orginone/dart/core/work/task.dart';
import 'package:orginone/pages/store/state.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/icons.dart';
import 'package:orginone/widget/image_widget.dart';

import 'search_bar.dart';

class UserBar extends GetView<UserController> {
  UserBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(color: Colors.grey.shade400, width: 0.4),
        )),
        child: _userBar,
      );
    });
  }

  Widget get _userBar {
    return SizedBox(
      height: 74.h,
      child: Row(children: [
        Row(
          children: [
            customPopupMenu(
                child: Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: _imgAvatar(EdgeInsets.only(left: 10.w)),
                ),
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.functionMenuController.hideMenu();
                      Get.toNamed(Routers.userInfo);
                    },
                    child: Row(
                      children: [
                        _imgAvatar(
                            EdgeInsets.symmetric(
                                vertical: 5.h, horizontal: 10.w),
                            size: 60,
                            circular: false,
                            radius: 8.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 240.w,
                              child: Row(
                                children: [
                                  Text(controller.provider.user?.metadata.name ?? ""),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(right: 10.w),
                                      alignment: Alignment.centerRight,
                                      child: IconButton(
                                        onPressed: () {
                                          controller.functionMenuController.hideMenu();
                                          Get.toNamed(
                                            Routers.shareQrCode,
                                            arguments: {
                                              "entity": controller.user.metadata
                                            },
                                          );
                                        },
                                        icon: Icon(
                                          Ionicons.qr_code_outline,
                                          size: 24.w,
                                        ),
                                        padding: EdgeInsets.zero,
                                        constraints:
                                            BoxConstraints(maxHeight: 24.w),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            SizedBox(
                              width: 240.w,
                              child: Text(
                                controller.provider.user?.metadata.remark ?? "",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(fontSize: 16.sp),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  ...SettingEnum.values
                      .map(
                        (item) => GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            controller.functionMenuController.hideMenu();
                            controller.jumpSetting(item);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    color: Colors.grey.shade300, width: 0.5),
                              ),
                            ),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  item.icon,
                                  size: 24.w,
                                  color: Colors.black,
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(left: 10.w),
                                    padding:
                                        EdgeInsets.symmetric(vertical: 15.h),
                                    child: Text(
                                      item.label,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 24.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList()
                ],
                controller: controller.functionMenuController),
            SizedBox(
              width: 10.w,
            ),
            Text(
              controller.homeEnum.value.label,
              style: TextStyle(fontSize: 28.sp),
            ),
          ],
        ),
        const Expanded(child: SizedBox()),
        IconButton(
          icon: const Icon(Ionicons.search_outline),
          onPressed: () {
            SearchBar? search;
            switch (controller.homeEnum.value) {
              case HomeEnum.chat:
                search = SearchBar<IMsgChat>(
                    homeEnum: HomeEnum.chat, data: controller.chat.allChats);
                break;
              case HomeEnum.work:
                search = SearchBar<IWorkTask>(
                    homeEnum: HomeEnum.work, data: controller.work.todos);
                break;
              case HomeEnum.store:
                search = SearchBar<RecentlyUseModel>(homeEnum: HomeEnum.store, data: controller.store.recent);
                break;
              case HomeEnum.setting:
                search = SearchBar<int>(homeEnum: HomeEnum.setting, data: []);
                break;
            }
            if (search != null) {
              showSearch(context: Get.context!, delegate: search);
            }
          },
          constraints: BoxConstraints(maxWidth: 50.w),
        ),
        IconButton(
          icon: const Icon(Ionicons.scan_outline),
          onPressed: () {
            controller.qrScan();
          },
        ),
        customPopupMenu(
          children: controller.menuItems
              .map(
                (item) => GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    controller.settingMenuController.hideMenu();
                    controller.showAddFeatures(item);
                  },
                  child: Container(
                    padding:  EdgeInsets.symmetric(horizontal: 20.w),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.grey.shade300, width: 0.5))),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          item.shortcut.icon,
                          size: 24.w,
                          color: Colors.black,
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 10.w),
                            padding:
                            EdgeInsets.symmetric(vertical: 15.h),
                            child: Text(
                              item.shortcut.label,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
          controller: controller.settingMenuController,
          child: const Icon(
            Ionicons.add_sharp,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
      ]),
    );
  }

  Widget customPopupMenu(
      {CustomPopupMenuController? controller,
      required Widget child,
      required List<Widget> children}) {
    return CustomPopupMenu(
      menuBuilder: () => ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          color: Colors.white,
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ),
      ),
      controller: controller,
      pressType: PressType.singleClick,
      showArrow: false,
      child: child,
    );
  }

  Widget _imgAvatar(EdgeInsets insets,
      {BoxFit fit = BoxFit.cover,
      bool circular = true,
      double size = 45,
      double? radius}) {
    return Obx(() {
      dynamic avatar;
      var share = controller.provider.user?.share;
      avatar = share?.avatar?.thumbnailUint8List ??
          AIcons.icons['x']?['defalutAvatar'];

      return Container(
          margin: insets,
          child: ImageWidget(
            avatar,
            fit: fit,
            size: size.w,
            circular: circular,
            radius: radius,
          ));
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/template/originone_scaffold.dart';
import 'package:orginone/components/template/tabs.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/components/widgets/tab_item_widget.dart';
import 'package:orginone/pages/chat/message_page.dart';
import 'package:orginone/pages/other/home/components/user_bar.dart';
import 'package:orginone/pages/setting/set_home_page.dart';
import 'package:orginone/util/load_image.dart';
import 'package:orginone/util/sys_util.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SysUtil.setStatusBarBright();
    return OrginoneScaffold(
      resizeToAvoidBottomInset: false,
      appBarElevation: 0,
      appBarHeight: 0,
      body: Tabs(
        tabCtrl: controller.tabController,
        top: const UserBar(),
        views: controller.tabs.map((e) => e.tabView).toList(),
        bottom: TabBar(
          controller: controller.tabController,
          tabs: controller.tabs.map((item) => item.body!).toList(),
        ),
      ),
    );
  }

  initPermission(BuildContext context) async {
    await [Permission.storage, Permission.notification].request();
  }
}

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late List<XTab> tabs;
  late TabController tabController;
  late RxInt tabIndex;
  late XTab message, relation, center, work, my;

  @override
  void onInit() {
    super.onInit();
    _initTabs();
  }

  @override
  void onClose() {
    super.onClose();
    tabController.dispose();
  }

  void _initTabs() {
    var size = Size(32.w, 32.w);
    message = XTab(
      customTab: _buildTabTick(
        XImage.localImage("chat", size: Size(38.w, 32.w)),
        "沟通",
      ),
      tabView: const MessagePage(),
    );
    relation = XTab(
      body: Text('办事', style: XFonts.size14Black3),
      tabView: Container(),
      icon: XImage.localImage("work", size: size),
    );
    center = XTab(
      body: XImage.localImage("logo_not_bg", size: Size(36.w, 36.w)),
      tabView: Container(),
      iconMargin: EdgeInsets.zero,
    );
    work = XTab(
      body: Text('仓库', style: XFonts.size14Black3),
      tabView: Container(),
      icon: XImage.localImage("warehouse", size: size),
    );
    my = XTab(
      body: Text('设置', style: XFonts.size14Black3),
      tabView: SetHomePage(),
      icon: XImage.localImage("setting", size: size),
    );

    tabs = <XTab>[message, relation, center, work, my];
    tabIndex = tabs.indexOf(center).obs;
    tabController = TabController(
      length: tabs.length,
      vsync: this,
      initialIndex: tabIndex.value,
    );
    int preIndex = tabController.index;
    tabController.addListener(() {
      if (preIndex == tabController.index) {
        return;
      }
      tabIndex.value = tabController.index;
      preIndex = tabController.index;
    });
  }

  Widget _buildTabTick(Widget icon, String label) {
    return Obx(() => SizedBox(
          width: 200.w,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Tab(
                  iconMargin: const EdgeInsets.all(4),
                  icon: icon,
                  child: Text(label, style: XFonts.size14White),
                ),
              ),
            ],
          ),
        ));
  }
}

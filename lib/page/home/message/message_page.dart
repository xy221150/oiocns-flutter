import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/api_resp/target_resp.dart';
import 'package:orginone/api_resp/tree_node.dart';
import 'package:orginone/component/text_tag.dart';
import 'package:orginone/page/home/home_controller.dart';
import 'package:orginone/page/home/message/message_controller.dart';
import 'package:orginone/util/hive_util.dart';

import '../../../component/choose_item.dart';
import '../../../component/icon_avatar.dart';
import '../../../component/unified_edge_insets.dart';
import '../../../component/unified_text_style.dart';
import '../../../routers.dart';
import 'component/group_item_widget.dart';

class MessagePage extends GetView<MessageController> {
  const MessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        width: 120.w,
        child: TabBar(
          controller: controller.tabController,
          indicatorSize: TabBarIndicatorSize.label,
          labelPadding: EdgeInsets.only(top: 10.h, bottom: 6.h),
          labelStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          labelColor: Colors.black,
          tabs: const [
            Text("会话"),
            Text("通讯录"),
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: 2.h),
        child: Divider(height: 1.h),
      ),
      Expanded(
        child: TabBarView(
          controller: controller.tabController,
          children: [_chat(), _relation()],
        ),
      )
    ]);
  }

  Widget _chat() {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.refreshCharts();
      },
      child: GetBuilder<MessageController>(
        init: controller,
        builder: (controller) => ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: controller.orgChatCache.chats.length,
          itemBuilder: (BuildContext context, int index) {
            return GroupItemWidget(index);
          },
        ),
      ),
    );
  }

  Widget _relation() {
    List<Widget> children = [];
    children.addAll(_recent());
    children.add(
      Container(
        margin: EdgeInsets.only(top: 10.h),
        child: Divider(height: 1.h),
      ),
    );
    children.add(Container(margin: EdgeInsets.only(top: 10.h)));

    children.add(_tree());

    return Container(
      margin: EdgeInsets.only(left: 20.w, right: 20.w),
      child: Column(children: children),
    );
  }

  List<Widget> _recent() {
    double avatarWidth = 44.w;
    return [
      Container(margin: EdgeInsets.only(top: 4.h)),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "最近联系",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
          GestureDetector(onTap: () {}, child: const Text("更多"))
        ],
      ),
      Container(
        margin: EdgeInsets.only(top: 10.h),
        height: avatarWidth,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (context, index) {
            return Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6.w)),
              ),
              margin: EdgeInsets.only(right: 12.w),
              child: CachedNetworkImage(
                  width: avatarWidth,
                  height: avatarWidth,
                  imageUrl:
                      "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fblog%2F202105%2F04%2F20210504062111_d8dc3.thumb.1000_0.jpg&refer=http%3A%2F%2Fc-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1668839600&t=153f1b08bff7c682539eabde8c2f862f"),
            );
          },
        ),
      )
    ];
  }

  Widget _tree() {
    return GetBuilder<HomeController>(builder: (homeController) {
      var currentSpace = homeController.currentSpace;
      TargetResp userInfo = HiveUtil().getValue(Keys.userInfo);
      var isSelf = userInfo.id == currentSpace.id;

      double leftWidth = 36.w;

      // 选择项
      List<Widget> body = [];
      body.add(ChooseItem(
        padding: EdgeInsets.zero,
        header: Container(
          alignment: Alignment.center,
          width: leftWidth,
          child: TextTag(
            isSelf ? "个人" : "单位",
            padding: EdgeInsets.all(4.w),
            textStyle: TextStyle(
              color: Colors.blueAccent,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Container(
          margin: left10,
          child: Text(currentSpace.name, style: text20Bold),
        ),
        func: () {
          if (isSelf) {
            Get.toNamed(Routers.friends);
          } else {
            Get.toNamed(Routers.dept, arguments: currentSpace.id);
          }
        },
      ));

      NodeCombine? nodeCombine = homeController.nodeCombine;
      if (nodeCombine != null) {
        TreeNode topNode = nodeCombine.topNode;
        var children = topNode.children;
        double top = 16.h;
        if (children.isNotEmpty) {
          body.add(Container(margin: EdgeInsets.only(top: top)));
          body.add(_deptItem(children[0], leftWidth));
          if (children.length > 1) {
            body.add(Container(margin: EdgeInsets.only(top: top)));
            body.add(_deptItem(children[1], leftWidth));
            if (children.length > 2) {
              body.add(Container(margin: EdgeInsets.only(top: top)));
              body.add(_more(leftWidth));
            }
          }
        }
      }

      double top = 12.h;
      body.add(Container(margin: EdgeInsets.only(top: top)));
      body.add(_otherUnits);
      body.add(Container(margin: EdgeInsets.only(top: top)));
      body.add(_chats);
      body.add(Container(margin: EdgeInsets.only(top: top)));
      body.add(Divider(height: 1.h));
      body.add(Container(margin: EdgeInsets.only(top: top)));
      body.add(_specialFocus);
      body.add(Container(margin: EdgeInsets.only(top: top)));
      body.add(_myRelation);

      return Column(children: body);
    });
  }

  Widget _deptItem(TreeNode treeNode, double leftWidth) {
    return ChooseItem(
      padding: EdgeInsets.zero,
      header: Container(
        alignment: Alignment.centerRight,
        width: leftWidth,
        child: const Icon(Icons.arrow_right),
      ),
      body: Container(
        margin: left10,
        child: Text(treeNode.label, style: text18),
      ),
      func: () {
        Get.toNamed(Routers.dept, arguments: treeNode.id);
      },
    );
  }

  Widget _more(double leftWidth) {
    return ChooseItem(
      padding: EdgeInsets.zero,
      header: Container(width: leftWidth),
      body: Container(
        margin: left10,
        child: Text("更多", style: text16),
      ),
      func: () {
        Get.toNamed(Routers.dept);
      },
    );
  }

  get _otherUnits => ChooseItem(
        padding: EdgeInsets.zero,
        header: const IconAvatar(
          icon: Icon(
            Icons.group,
            color: Colors.white,
          ),
        ),
        body: Container(
          margin: left10,
          child: Text("其他单位", style: text16Bold),
        ),
        func: () {},
      );

  get _chats => ChooseItem(
        padding: EdgeInsets.zero,
        header: const IconAvatar(
          icon: Icon(
            Icons.group,
            color: Colors.white,
          ),
        ),
        body: Container(
          margin: left10,
          child: Text("奥集能通讯录", style: text16Bold),
        ),
        func: () {},
      );

  get _specialFocus => ChooseItem(
        padding: EdgeInsets.zero,
        header: const IconAvatar(
          icon: Icon(
            Icons.group,
            color: Colors.white,
          ),
        ),
        body: Container(
          margin: left10,
          child: Text("特别关注", style: text16Bold),
        ),
        func: () {},
      );

  get _myRelation => ChooseItem(
        padding: EdgeInsets.zero,
        header: const IconAvatar(
          icon: Icon(
            Icons.group,
            color: Colors.white,
          ),
        ),
        body: Container(
          margin: left10,
          child: Text("我的联系人", style: text16Bold),
        ),
        func: () {},
      );
}
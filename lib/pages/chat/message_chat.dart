import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/dart/core/target/chat/ichat.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/widget/template/originone_scaffold.dart';
import 'package:orginone/widget/unified.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/pages/chat/widgets/chat_box.dart';
import 'package:orginone/pages/chat/widgets/info_item.dart';
import 'package:orginone/util/date_util.dart';

class MessageChat extends StatelessWidget {
  const MessageChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var chat = Get.arguments;
    return OrginoneScaffold(
      appBarHeight: 74.h,
      appBarBgColor: XColors.navigatorBgColor,
      resizeToAvoidBottomInset: false,
      appBarLeading: XWidgets.defaultBackBtn,
      appBarTitle: _title(chat),
      appBarCenterTitle: true,
      appBarActions: _actions(chat),
      body: _body(context, chat),
    );
  }

  Widget _title(IChat chat) {
    return Obx(() {
      var messageItem = chat.target;
      var personCount = chat.personCount.value;
      String name = messageItem.name;
      if (messageItem.typeName != TargetType.person.label) {
        name += "($personCount)";
      }
      var spaceName = messageItem.labels.join(" | ");
      return Column(
        children: [
          Text(name, style: XFonts.size22Black3),
          Text(spaceName, style: XFonts.size14Black9),
        ],
      );
    });
  }

  List<Widget> _actions(IChat chat) {
    return <Widget>[
      GFIconButton(
        color: Colors.white.withOpacity(0),
        icon: Icon(
          Icons.more_horiz,
          color: XColors.black3,
          size: 32.w,
        ),
        onPressed: () async {
          Get.toNamed(Routers.messageSetting, arguments: chat);
        },
      ),
    ];
  }

  Widget _time(String? dateTime) {
    var content = dateTime != null
        ? CustomDateUtil.getDetailTime(DateTime.parse(dateTime))
        : "";
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
      child: Text(content, style: XFonts.size16Black9),
    );
  }

  Widget _item(int index, IChat chat) {
    XImMsg msg = chat.messages[index];
    Widget currentWidget = DetailItemWidget(msg: msg, chat: chat);

    var time = _time(msg.createTime);
    var item = Column(children: [currentWidget]);
    if (index == 0) {
      item.children.add(Container(margin: EdgeInsets.only(bottom: 5.h)));
    }
    if (index == chat.messages.length - 1) {
      item.children.insert(0, time);
      return item;
    } else {
      XImMsg pre = chat.messages[index + 1];
      if (msg.createTime != null && pre.createTime != null) {
        var curCreateTime = DateTime.parse(msg.createTime!);
        var preCreateTime = DateTime.parse(pre.createTime!);
        var difference = curCreateTime.difference(preCreateTime);
        if (difference.inSeconds > 60 * 3) {
          item.children.insert(0, time);
          return item;
        }
      }
      return item;
    }
  }

  Widget _body(BuildContext context, IChat chat) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        ChatBoxController chatBoxController = Get.find<ChatBoxController>();
        chatBoxController.eventFire(context, InputEvent.clickBlank, chat);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              color: XColors.bgColor,
              child: RefreshIndicator(
                onRefresh: () => chat.moreMessage(),
                child: Container(
                  padding: EdgeInsets.only(left: 10.w, right: 10.w),
                  child: Obx(
                    () => ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      controller: ScrollController(),
                      scrollDirection: Axis.vertical,
                      itemCount: chat.messages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _item(index, chat);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          ChatBox(chat: chat)
        ],
      ),
    );
  }
}

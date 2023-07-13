import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:orginone/dart/core/chat/message/msgchat.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/thing/application.dart';
import 'package:orginone/dart/core/work/task.dart';
import 'package:orginone/images.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/other/general_bread_crumbs/state.dart';
import 'package:orginone/pages/store/state.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/string_util.dart';

class ListAdapter {
  VoidCallback? callback;

  late bool enabledSlidable;

  List<SlidableAction> slideActions = [];

  late String title;

  late List<String> labels;

  dynamic image;

  late String content;

  late int noReadCount;

  String? dateTime;

  late bool circularAvatar;

  late bool isUserLabel;

  ListAdapter({
    this.title = '',
    this.labels = const [],
    this.image,
    this.content = '',
    this.dateTime,
    this.isUserLabel = false,
    this.noReadCount = 0,
    this.circularAvatar = false,
    this.callback,
    this.enabledSlidable = false,
    this.slideActions = const [],
  });

  ListAdapter.chat(IMsgChat chat) {
    labels = chat.labels;
    bool isTop = labels.contains("置顶");
    enabledSlidable = true;
    isUserLabel = false;
    slideActions = [
      SlidableAction(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        icon: Icons.vertical_align_top,
        label: isTop ? "取消置顶" : "置顶",
        onPressed: (BuildContext context) async {
          if (isTop) {
            chat.labels.remove('置顶');
          } else {
            chat.labels.add('置顶');
          }
          await chat.cache();
          settingCtrl.provider.refreshChat();
        },
      ),
      SlidableAction(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        icon: Icons.delete,
        label: "删除",
        onPressed: (BuildContext context) {
          settingCtrl.chat.allChats.remove(chat);
          settingCtrl.provider.refreshChat();
        },
      ),
    ];
    circularAvatar = chat.share.typeName == TargetType.person.label;
    noReadCount = chat.chatdata.value.noReadCount;
    title = chat.chatdata.value.chatName ?? "";
    dateTime = chat.chatdata.value.lastMessage?.createTime;
    var lastMessage = chat.chatdata.value.lastMessage;
    content = '';
    if (lastMessage!.fromId != settingCtrl.user.metadata.id) {
      if (chat.share.typeName != TargetType.person.label) {
        var target = chat.members
            .firstWhere((element) => element.id == lastMessage.fromId);
        content = "${target.name}:";
      } else {
        content = "对方:";
      }
    }
    content = content +
        StringUtil.msgConversion(lastMessage, settingCtrl.user.userId);

    image = chat.share.avatar?.thumbnailUint8List ??
        chat.share.avatar?.defaultAvatar;

    callback = () {
      chat.onMessage();
      Get.toNamed(
        Routers.messageChat,
        arguments: chat,
      );
    };
  }

  ListAdapter.work(IWorkTask work) {
    labels = [work.metadata.createUser!, work.metadata.shareId!];
    enabledSlidable = false;
    isUserLabel = true;
    slideActions = [];
    circularAvatar = false;
    noReadCount = 0;
    title = work.metadata.title ?? '';
    dateTime = work.metadata.createTime ?? "";
    content = work.metadata.content ?? "";

    if (work.targets.length == 2) {
      content =
          "${work.targets[0].name}[${work.targets[0].typeName}]申请加入${work.targets[1].name}[${work.targets[1].typeName}]";
    }

    content = "内容:$content";

    image = work.metadata.avatarThumbnail() ?? Images.iconWorkitem;

    callback = () async {
      await work.loadInstance();
      Get.toNamed(Routers.processDetails, arguments: {"todo": work});
    };
  }

  ListAdapter.application(IApplication application, ITarget target) {
    labels = [target.metadata.name ?? ""];
    enabledSlidable = false;
    isUserLabel = false;
    circularAvatar = false;
    noReadCount = 0;
    title = application.metadata.name ?? "";
    dateTime = application.metadata.createTime ?? "";
    content = "应用说明:";
    image = application.metadata.avatarThumbnail() ?? Ionicons.apps;

    callback = () async {
      var works = await application.loadWorks();
      var nav = GeneralBreadcrumbNav(
          id: application.metadata.id ?? "",
          name: application.metadata.name ?? "",
          source: application,
          spaceEnum: SpaceEnum.applications,
          space: target,
          children: [
            ...works.map((e) {
              return GeneralBreadcrumbNav(
                id: e.metadata.id ?? "",
                name: e.metadata.name ?? "",
                spaceEnum: SpaceEnum.work,
                space: target,
                source: e,
                children: [],
              );
            }).toList(),
            ..._loadNav(application.children, target),
          ]);
      Get.toNamed(Routers.generalBreadCrumbs, arguments: {"data": nav});
    };
  }

  ListAdapter.store(RecentlyUseModel recent) {
    image = recent.avatar ?? Icons.other_houses;
    labels = [recent.thing == null?"文件":"物"];
    title = recent.thing?.id??recent.file?.name??"";
    enabledSlidable = false;
    isUserLabel = false;
    circularAvatar = false;
    noReadCount = 0;
    content = '';
    dateTime = recent.createTime;

  }

  List<GeneralBreadcrumbNav> _loadNav(List<IApplication> app, ITarget target) {
    List<GeneralBreadcrumbNav> navs = [];
    for (var value in app) {
      navs.add(GeneralBreadcrumbNav(
          id: value.metadata.id ?? "",
          name: value.metadata.name ?? "",
          source: value,
          spaceEnum: SpaceEnum.module,
          space: target,
          onNext: (item) async {
            var works = await value.loadWorks();
            List<GeneralBreadcrumbNav> data = [
              ...works.map((e) {
                return GeneralBreadcrumbNav(
                  id: e.metadata.id ?? "",
                  name: e.metadata.name ?? "",
                  spaceEnum: SpaceEnum.work,
                  source: e,
                  space: target,
                  children: [],
                );
              }),
              ..._loadNav(value.children, target),
            ];
            item.children = data;
          },
          children: []));
    }
    return navs;
  }
}
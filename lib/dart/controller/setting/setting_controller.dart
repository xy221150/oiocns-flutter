import 'dart:async';

import 'package:get/get.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/target/person.dart';
import 'package:orginone/dart/core/target/team/company.dart';
import 'package:orginone/dart/core/user.dart';
import 'package:orginone/event/home_data.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/event_bus.dart';
import 'package:orginone/util/event_bus_helper.dart';

const sessionUserName = 'sessionUser';
const sessionSpaceName = 'sessionSpace';

/// 设置控制器
class SettingController extends GetxController {
  String currentKey = "";
  StreamSubscription<UserLoaded>? _userSub;
  late UserProvider _provider;

  var homeEnum = HomeEnum.door.obs;

  @override
  void onInit() {
    super.onInit();
    _provider = UserProvider();
    _userSub = XEventBus.instance.on<UserLoaded>().listen((event) async {
      EventBusHelper.fire(ShowLoading(true));
      await _provider.reload();
      EventBusHelper.fire(ShowLoading(false));
    });
  }

  @override
  void onClose() {
    _userSub?.cancel();
    super.onClose();
  }

  UserProvider get provider {
    return _provider;
  }

  IPerson get user {
    return _provider.user!;
  }

  /// 组织树
  Future<List<ITarget>> getTeamTree(
      IBelong space,
    [bool isShare = true]
  ) async {
    var result = <ITarget>[];
    result.add(space);
    if (space == user) {
      result.addAll([...(await user.loadCohorts(reload: false))??[]]);
    } else if (isShare) {
      result.addAll(
          [...(await (space as ICompany).loadGroups(reload: false))]);
    }
    return result;
  }

  /// 组织树
  Future<List<ITarget>> getCompanyTeamTree(
    ICompany company,
    bool isShare,
  ) async {
    var result = <ITarget>[];
    result.add(company);
    if (isShare) {
      var groups = await company.loadGroups(reload: false);
      result.addAll([...groups]);
    }
    return result;
  }

  void setHomeEnum(HomeEnum value) {
    homeEnum.value = value;
  }

  void jumpInitiate() {
    switch (homeEnum.value) {
      case HomeEnum.chat:
        Get.toNamed(Routers.initiateChat);
        break;
      case HomeEnum.work:
        Get.toNamed(Routers.initiateWork);
        break;
      case HomeEnum.store:
        Get.toNamed(Routers.storeTree);
        break;
      case HomeEnum.market:
        // TODO: Handle this case.
        break;
      case HomeEnum.door:
        // TODO: Handle this case.
        break;
    }
  }

  bool isUserSpace(space) {
    return space == user;
  }
}

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SettingController(), permanent: true);
  }
}

enum HomeEnum {
  chat("沟通"),
  work("办事"),
  door("门户"),
  store("存储"),
  market("流通");

  final String label;

  const HomeEnum(this.label);
}

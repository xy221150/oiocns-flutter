import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';
import 'package:orginone/dart/core/target/authority/iauthority.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/pages/setting/config.dart';

class SettingFunctionState extends BaseBreadcrumbNavState<SettingNavModel> {
  late ISpace space;



  SettingController get setting => Get.find<SettingController>();

  SettingFunctionState() {

    if(Get.arguments?['data'] != null){
      model.value = Get.arguments?['data'];
    } else if (Get.arguments?['space'] != null) {
      space = Get.arguments['space'];
      List<SettingNavModel> function = [];
      function = [
        SettingNavModel(
            name: SpaceEnum.standardSettings.label,
            spaceEnum: SpaceEnum.standardSettings,
            space: space)
      ];
      if (setting.isUserSpace(space: space)) {
        function.addAll([
          SettingNavModel(
              name: SpaceEnum.cardbag.label,
              spaceEnum: SpaceEnum.cardbag,
              space: space),
          SettingNavModel(
              name: SpaceEnum.security.label,
              spaceEnum: SpaceEnum.security,
              space: space),
          SettingNavModel(
              name: SpaceEnum.mark.label,
              spaceEnum: SpaceEnum.mark,
              space: space),
          SettingNavModel(
              name: SpaceEnum.personGroup.label,
              spaceEnum: SpaceEnum.personGroup,
              space: space),
        ]);
      } else {
        function.addAll([
          SettingNavModel(
              name: SpaceEnum.innerAgency.label,
              spaceEnum: SpaceEnum.innerAgency,
              space: space),
          SettingNavModel(
              name: SpaceEnum.outAgency.label,
              spaceEnum: SpaceEnum.outAgency,
              space: space),
          SettingNavModel(
              name: SpaceEnum.stationSetting.label,
              spaceEnum: SpaceEnum.stationSetting,
              space: space),
          SettingNavModel(
              name: SpaceEnum.companyCohort.label,
              spaceEnum: SpaceEnum.companyCohort,
              space: space),
        ]);
      }
      model.value = SettingNavModel(name: space.teamName, space: space,children: function);
    }
    title = model.value?.name??"";
  }
}

class SettingNavModel extends BaseBreadcrumbNavModel<SettingNavModel> {
  SpaceEnum? spaceEnum;
  StandardEnum? standardEnum;
  late ISpace space;

  SettingNavModel(
      {super.id = '',
      super.name = '',
      super.children = const [],
      super.source,
      super.image,
      this.spaceEnum,
      this.standardEnum,
      required this.space,
     });
}

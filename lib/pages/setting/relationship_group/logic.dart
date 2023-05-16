import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_controller.dart';
import 'package:orginone/dart/core/target/authority/authority.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/thing/base/species.dart';
import 'package:orginone/dart/core/thing/store/propclass.dart';
import 'package:orginone/pages/setting/classification_info/form.dart';
import 'package:orginone/pages/setting/config.dart';
import 'package:orginone/pages/setting/dialog.dart';
import 'package:orginone/pages/setting/home/setting/state.dart';
import 'package:orginone/pages/setting/network.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:orginone/widget/gy_scaffold.dart';

import 'state.dart';

class RelationGroupController extends BaseBreadcrumbNavController<RelationGroupState> {
  final RelationGroupState state = RelationGroupState();

  SettingController settingController = Get.find();

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    if (state.model.value!.children.isEmpty) {
      await initData();
    }
  }

  Future<void> initData() async {
    var spaceEnum = state.model.value!.spaceEnum;
    var standardEnum = state.model.value!.standardEnum;
    if (!state.isStandard) {
      switch (spaceEnum) {
        case SpaceEnum.innerAgency:
          await SettingNetWork.initDepartment(state.model.value!);
          break;
        case SpaceEnum.outAgency:
          await SettingNetWork.initGroup(state.model.value!);
          break;
        case SpaceEnum.stationSetting:
          await SettingNetWork.initStations(state.model.value!);
          break;
        case SpaceEnum.personGroup:
        case SpaceEnum.externalCohort:
          await SettingNetWork.initCohorts(state.model.value!);
          break;
      }
      state.model.refresh();
    } else {
      if (standardEnum == StandardEnum.dict) {
        await SettingNetWork.initDict(state.model.value!);
        state.model.refresh();
      }
    }
  }

  void loopSpecies(List<ISpeciesItem> species,SettingNavModel model){
    model.children = [];
    for (var value in species) {
      var child = SettingNavModel(
          space: model.space,
          spaceEnum: model.spaceEnum,
          source: value,
          standardEnum: model.standardEnum,
          name: value.metadata.name);
      if (value.children.isNotEmpty) {
        loopSpecies(value.children, child);
      }
      model.children.add(child);
    }
  }

  void nextLv(SettingNavModel model) async {
    if (model.children.isNotEmpty) {
      Get.toNamed(Routers.relationGroup,
          arguments: {
            "data": model,
          },
          preventDuplicates: false);
    } else {
      onTap(model);
    }
  }

  void onTap(SettingNavModel model) {
    var spaceEnum = state.model.value!.spaceEnum;
    var standardEnum = state.model.value!.standardEnum;
    if (!state.isStandard) {
      switch (spaceEnum) {
        case SpaceEnum.innerAgency:
          Get.toNamed(Routers.departmentInfo,arguments: {'depart':model.source});
          break;
        case SpaceEnum.outAgency:
          Get.toNamed(Routers.outAgencyInfo,arguments: {'group':model.source});
          break;
        case SpaceEnum.stationSetting:
          Get.toNamed(Routers.stationInfo,arguments: {'station':model.source});
          break;
        case SpaceEnum.personGroup:
        case SpaceEnum.externalCohort:
          Get.toNamed(Routers.cohortInfo,arguments: {'cohort':model.source});
          break;
      }
    }else{
      switch (standardEnum) {
        case StandardEnum.permission:
          Get.toNamed(Routers.permissionInfo,
              arguments: {"authority": model.source});
          break;
        case StandardEnum.classCriteria:
          Get.toNamed(Routers.classificationInfo, arguments: {"data": model});
          break;
        case StandardEnum.dict:
          Get.toNamed(Routers.dictInfo, arguments: {"data": model});
          break;
        case StandardEnum.propPackage:
          var property = (model.source.propertys as List<XProperty>).firstWhere((element) => element.id == model.id);
          Navigator.of(context).push(MaterialPageRoute(builder: (context){
            return Material(
              child: GyScaffold(
                titleName: "表单列表",
                body: FormPage([property],model.source),
              ),
            );
          }));
          break;
      }
    }
  }

  void createGroup(dynamic item, {bool isEdit = false}) {
    showCreateOrganizationDialog(context, item.subTeamTypes, callBack:
        (String name, String code, String nickName, String identify,
        String remark, TargetType type) async {
      var model = TargetModel(
        name: nickName,
        code: code,
        typeName: type.label,
        teamName: name,
        teamCode: code,
        remark: remark,
      );
      if (isEdit) {
        model.id = item.id;
        model.belongId = item.target.belongId;
        await item.update(model);
      } else {
        await item.create(model);
      }
    },
        code: isEdit ? item.target.code : "",
        name: isEdit ? item.teamName : "",
        nickName: isEdit ? item.name : "",
        identify: isEdit ? (item.target.code ?? "") : "",
        remark: isEdit ? (item.target.remark ?? "") : "",
        type: isEdit ? TargetType.getType(item.typeName) : null,
        isEdit: isEdit);
  }

  void removeGroup(dynamic item) async {
    bool success = await item.delete();
    if (success) {
      state.model.value!.children.remove(item);
      state.model.refresh();
    } else {
      ToastUtils.showMsg(msg: "删除失败");
    }
  }

  void editDict(SettingNavModel item) {
    showCreateDictDialog(context, onCreate: (name, code, remark) async {
      var success = await item.source.update(DictModel(
          name: name,
          public: true,
          code: code,
          remark: remark,
          id: item.source.metadata.id));
      if (success) {
        ToastUtils.showMsg(msg: "更新成功");
        item.source.metadata.name = name;
        item.source.metadata.code = code;
        item.source.metadata.remark = remark;
        item.name = name;
        state.model.refresh();
      }
    },
        name: item.source.metadata.name,
        code: item.source.metadata.code,
        remark: item.source.metadata.remark ?? "");
  }

  void removeDict(SettingNavModel item) async {
    bool success = await item.source.deleteDict(item.source.id);
    if (success) {
      ToastUtils.showMsg(msg: "删除成功");
      state.model.value!.children.remove(item);
      state.model.refresh();
    }
  }

  void createAuth(SettingNavModel item, {bool isEdit = false}) async {
    List<ITarget> targets = await settingController.getTeamTree(item.space);
    showCreateAuthDialog(context, getAllTarget(targets), target: item.space,
        callBack: (name, code, target, isPublic, remark) async {
          var model = AuthorityModel(
              name: name, code: code, public: isPublic, remark: remark);

          if (isEdit) {
            bool success = await item.source.update(model);
            if (success) {
              ToastUtils.showMsg(msg: "修改成功");
              item.source.metadata.name = name;
              item.source.metadata.public = isPublic;
              item.source.metadata.remark = remark;
              item.source.metadata.code = code;
              item.name = name;
              state.model.refresh();
            }
          } else {
            model.shareId = item.source.belongId;
            IAuthority? result = await item.source.create(model);
            if (result != null) {
              ToastUtils.showMsg(msg: "创建成功");
              item.children.add(SettingNavModel(
                space: state.model.value!.space,
                image: result.shareInfo.avatar?.shareLink,
                name: result.metadata.name ?? "",
                source: result,
                standardEnum: StandardEnum.permission,
              ));
              state.model.refresh();
            }
          }
        },
        isEdit: isEdit,
        name: isEdit ? item.source.metadata.name : "",
        public: isEdit ? (item.source.metadata.public ?? false) : false,
        remark: isEdit ? item.source.metadata.remark : "",
        code: isEdit ? item.source.metadata.code : "");
  }

  void createClassCriteria(SettingNavModel e, {bool isEdit = false}) async {
    List<ISpeciesItem> species = [];

    if (e.name == SpeciesType.store.label) {
      species.add(e.source);
    } else {
      for (var element in e.children) {
        if (element.source.speciesTypes.isNotEmpty) {
          species.add(element.source);
        }
      }
    }
    IAuthority? authority = await e.space.loadSuperAuth();
    List<IAuthority> auth = [];
    if (authority != null) {
      auth.add(authority);
    }

    List<ITarget> targets = await settingController.getTeamTree(e.space);

    showClassCriteriaDialog(
        context, getAllTarget(targets), species, getAllAuthority(auth),
        callBack: (name, code, target, specie, auth, public, remark) async {
          var model = SpeciesModel(
              name: name,
              code: code,
              public: public,
              typeName: specie.metadata.typeName,
              shareId: target.metadata.id,
              authId: auth.metadata.id ?? "",
              remark: remark);

          if (isEdit) {
            var success = await e.source.update(model);
            if (success) {
              ToastUtils.showMsg(msg: "修改成功");
              e.source.metadata.name = name;
              e.source.metadata.code = code;
              e.source.metadata.public = public;
              e.source.metadata.remark = remark;
              e.name = name;
              state.model.refresh();
            }
      } else {
        var item = await e.source.create(model);
      }
    },
        isEdit: isEdit,
        name: isEdit ? e.source.metadata.name : null,
        code: isEdit ? e.source.metadata.code : null,
        authId: isEdit ? e.source.metadata.authId : null,
        targetId: isEdit ? e.source.metadata.shareId : null,
        specie: isEdit ? e.source : null,
        public: isEdit ? e.source.metadata.public ?? false : false,
        remark: isEdit ? e.source.metadata.remark : null);
  }

  void removeAuth(SettingNavModel item) async {
    bool success = await item.source.delete();
    if (success) {
      ToastUtils.showMsg(msg: "删除成功");
      state.model.value!.children.remove(item);
      state.model.refresh();
    }
  }

  void removeClassCriteria(SettingNavModel item) async {
    bool success = await item.source.delete();
    if (success) {
      ToastUtils.showMsg(msg: "删除成功");
      state.model.value!.children.remove(item);
      state.model.refresh();
    }
  }

  void operationPermission(SettingNavModel item, value) {
    switch (value) {
      case "create":
        createAuth(item);
        break;
      case "edit":
        createAuth(item, isEdit: true);
        break;
      case "delete":
        removeAuth(item);
        break;
    }
  }

  void operationDict(SettingNavModel item, value) {
    switch (value) {
      case "edit":
        editDict(item);
        break;
      case "delete":
        removeDict(item);
        break;
    }
  }

  void operationClassCriteria(SettingNavModel item, value) {
    switch (value) {
      case "create":
        createClassCriteria(item);
        break;
      case "edit":
        createClassCriteria(item, isEdit: true);
        break;
      case "delete":
        removeClassCriteria(item);
        break;
    }
  }

  void operationGroup(SettingNavModel item, value) {
    switch (value) {
      case "create":
        createGroup(item.source);
        break;
      case "edit":
        createGroup(item, isEdit: true);
        break;
      case "delete":
        removeGroup(item.source);
        break;
    }
  }

  void operationPropPackage(SettingNavModel item, value) {
    switch (value) {
      case "create":
        createProperty(item);
        break;
      case "edit":
        createProperty(item, isEdit: true);
        break;
      case "delete":
        deleteProperty(item);
        break;
    }
  }


  void deleteProperty(SettingNavModel item) async{

    var property = (item.source.propertys as List<XProperty>).firstWhere((element) => element.id == item.id);

    bool success =
        await item.source.deleteProperty(property);
    if (success) {
      state.model.value!.children.remove(item);
      state.model.refresh();
      ToastUtils.showMsg(msg: "删除成功");
    }
  }


  void createProperty(SettingNavModel item, {bool isEdit = false}) async {

    var property;
    if(isEdit){
      property = (item.source.propertys as List<XProperty>).firstWhere((element) => element.id == item.id);
    }

    showCreateAttributeDialog(context,
        onCreate: (name, code, type, remark, unit, dict) async {
      var model = PropertyModel(
        name: name,
        code: code,
        valueType: type,
        remark: remark,
        unit: unit,
        dictId: dict?.metadata.id,
      );
      if (isEdit) {
        model.id = property.id;
        var success = await item.source.updateProperty(model);
        if (success) {
          ToastUtils.showMsg(msg: "修改成功");
          property.name = name;
          property.code = code;
          property.remark = remark;
          property.valueType = type;
          property.unit = unit;
          item.name = name;
          state.model.refresh();
        }
      } else {
        XProperty? property = await item.source.createProperty(model);
        if (property != null) {
          ToastUtils.showMsg(msg: "创建成功");
          item.children.add(SettingNavModel(
              space: item.space,
              spaceEnum: item.spaceEnum,
              source: item.source,
              name: property.name ?? "",
              standardEnum: item.standardEnum,id: property.id??""));
          state.model.refresh();
        }
      }
    },
        name: isEdit ? property.name ?? "" : null,
        code: isEdit ? property.code ?? "" : null,
        remark: isEdit ? property.remark ?? "" : null,
        valueType: isEdit ? property.valueType ?? "" : null,
        unit: isEdit ? property.unit ?? "" : null,
        dictId: isEdit ? property.dict?.id : null,
        isEdit: isEdit,
        dictList: item.space.dicts ?? []);
  }
}


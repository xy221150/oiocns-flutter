import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/images.dart';
import 'package:orginone/main.dart';

class InitiateWorkState extends BaseBreadcrumbNavState<WorkBreadcrumbNav> {

  InitiateWorkState() {

    showSearchButton = false;

    var joinedCompanies = settingCtrl.user.companys;

    model.value = Get.arguments?['data'];

    if (model.value == null) {
      List<WorkBreadcrumbNav> organization = [];
      for (var value in joinedCompanies) {
        organization.add(
          WorkBreadcrumbNav(
              name: value.metadata.name??"",
              id: value.metadata.id!,
              space: value,
              children: [
                WorkBreadcrumbNav(
                    name: WorkEnum.todo.label, workEnum: WorkEnum.todo, children: [],space: value,image:WorkEnum.todo.imagePath),
                WorkBreadcrumbNav(
                    name: WorkEnum.completed.label, workEnum: WorkEnum.completed, children: [],space: value,image:WorkEnum.completed.imagePath),
                WorkBreadcrumbNav(
                    name: WorkEnum.initiated.label, workEnum: WorkEnum.initiated, children: [],space: value,image:WorkEnum.initiated.imagePath),
              ],
              image: value.metadata.avatarThumbnail(),
          ),
        );
      }
      model.value = WorkBreadcrumbNav(
        name: "发起办事",
        children: [
          WorkBreadcrumbNav(
            name: "个人",
            children: [
              WorkBreadcrumbNav(
                  name: WorkEnum.todo.label, workEnum: WorkEnum.todo, children: [],space: settingCtrl.user,image:WorkEnum.todo.imagePath ),
              WorkBreadcrumbNav(
                  name: WorkEnum.completed.label, workEnum: WorkEnum.completed, children: [],space: settingCtrl.user,image:WorkEnum.completed.imagePath ),
              WorkBreadcrumbNav(
                  name: WorkEnum.initiated.label, workEnum: WorkEnum.initiated, children: [],space: settingCtrl.user,image:WorkEnum.initiated.imagePath ),
            ],
            space: settingCtrl.user
          ),
          WorkBreadcrumbNav(
            name: '组织',
            children: organization,
          ),
        ],
      );
    }

    title = model.value!.name;
  }
}

class WorkBreadcrumbNav extends BaseBreadcrumbNavModel<WorkBreadcrumbNav> {
  WorkEnum? workEnum;
  IBelong? space;
  WorkBreadcrumbNav(
      {super.id = '',
      super.name = '',
      required List<WorkBreadcrumbNav> children,
      super.image,
      super.source,
      this.workEnum,
      this.space,super.spaceEnum,super.onNext}){
   this.children = children;
  }
}

enum WorkEnum {
  todo("待办事项",Images.iconWorkTodo),
  completed("已办事项",Images.iconWorkCompleted),
  initiationWork("发起事项",Images.iconWorkInitiation),
  initiated("我发起的",Images.iconWorkInitiated);

  final String label;

  final String imagePath;

  const WorkEnum(this.label,this.imagePath);
}

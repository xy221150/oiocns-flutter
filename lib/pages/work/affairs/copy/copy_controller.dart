import 'package:orginone/dart/base/api/workflow_api.dart';
import 'package:orginone/dart/base/model/task_entity.dart';
import 'package:orginone/pages/work/affairs/base/affairs_base_list_controller.dart';

class CopyController extends AffairsBaseListController<TaskEntity> {
  String typeName = "notice";

  @override
  void onLoadMore() async {
    await WorkflowApi.task(limit, offset += 1, 'string', typeName)
        .then((pageResp) {
      addData(true, pageResp);
    }).onError((error, stackTrace) {
      refreshController.loadFailed();
    }).whenComplete(() {});
  }

  @override
  void onRefresh() async {
    await WorkflowApi.task(limit, offset, 'string', typeName)
        .then((pageResp) {
          addData(true, pageResp);
        })
        .onError((error, stackTrace) {})
        .whenComplete(() {});
  }
}
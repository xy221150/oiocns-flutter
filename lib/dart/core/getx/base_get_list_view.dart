import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/images.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'package:orginone/widget/load_state_widget.dart';

import 'base_get_list_state.dart';
import 'base_get_view.dart';
import 'base_list_controller.dart';

abstract class BaseGetListView<T extends BaseListController,
    S extends BaseGetListState> extends BaseGetView<T, S> {
  S get state => controller.state as S;
  BuildContext get context => controller.context;

  @override
  Widget build(BuildContext context) {
    this.controller.context = context;

    Widget body = EasyRefresh(
      controller: state.refreshController,
      onRefresh: controller.onRefresh,
      onLoad: controller.onLoadMore,
      header: const MaterialHeader(),
      footer: const MaterialFooter(),
      child: Column(
        children: [
          Expanded(
            child: Obx(() {
              return LoadStateWidget(
                isSuccess: state.isSuccess.value,
                isLoading: state.isLoading.value,
                onRetry: () {
                  controller.loadData();
                },
                child: Builder(builder: (context) {
                  if (state.dataList.isEmpty && displayNoDataWidget()) {
                    return noData();
                  }
                  return buildView();
                }),
              );
            }),
          ),
          bottomWidget(),
        ],
      ),
    );
    if (showAppBar) {
      body = GyScaffold(titleName: title, actions: actions(), body: body);
    }
    return body;
  }

  Widget noData() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      color: Colors.white,
      child: Image.asset(
        Images.empty,
        width: 300.w,
        height: 400.w,
      ),
    );
  }

  bool displayNoDataWidget() => true;

  @override
  Widget buildView();

  late String title;

  List<Widget> actions() {
    return [];
  }


  Widget bottomWidget() {
    return Container();
  }

  bool showAppBar = true;

}

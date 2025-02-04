


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/images.dart';
import 'package:orginone/pages/home/index/widget/widget.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/image_widget.dart';

class Warehouse extends StatefulWidget {
  const Warehouse({Key? key}) : super(key: key);

  @override
  State<Warehouse> createState() => _WarehouseState();
}

class _WarehouseState extends State<Warehouse> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        latest(),
        shared(),
        all()
      ],
    );
  }

  Widget latest(){
    return Column(
      children: [
        CommonWidget.commonHeadInfoWidget("最新",action: ImageWidget(Images.iconBlueArrow)),
        Container(
          height: 180.h,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 12,
            itemBuilder: (context, index) {
              return PopularItem();
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: 10.h,
              crossAxisSpacing: 10.w,
              childAspectRatio: 0.75,
            ),
          ),
        )
      ],
    );
  }

  Widget shared(){
    return Column(
      children: [
        CommonWidget.commonHeadInfoWidget("我分享的",action: ImageWidget(Images.iconBlueArrow)),
        ...List.generate(3, (index) =>  CardItem()).toList(),
      ],
    );
  }
  Widget all(){
    return Column(
      children: [
        CommonWidget.commonHeadInfoWidget("全部物品",action: ImageWidget(Images.iconBlueArrow)),
        ...List.generate(3, (index) =>  CardItem()).toList(),
      ],
    );
  }
}

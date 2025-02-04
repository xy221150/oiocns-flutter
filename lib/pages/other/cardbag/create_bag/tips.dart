import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/widget/buttons.dart';

import 'logic.dart';

class Tips extends StatelessWidget {

  CreateBagController get controller => Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 30.h),
          Text(
            "创建助记词",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              const Text("建议手写抄录"),
              SizedBox(width: 20.h),
              const Text("请勿复制保存"),
              SizedBox(width: 20.h),
              const Text("请勿截图保存")
            ],
          ),
          SizedBox(height: 10.h),
          _tips("助记词相当于你的钱包密码", Icons.home, "获取助记词等于获取资产所有权，一旦泄露资产将不再安全"),
          _tips("请手写抄录助记词", Icons.home, "若复制或截屏保存，助记词有可能泄露"),
          _tips("将助记词放在安全的地方", Icons.home, "一旦丢失资产将无法找回"),
          Expanded(child: Container()),
          elevatedButton("创建", onPressed: () {
            controller.nextPage();
          }),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _tips(
    String title,
    IconData iconData,
    String content,
  ) {
    return Row(
      children: [
        Icon(iconData),
        SizedBox(width: 20.h),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Text(
                  textAlign: TextAlign.start,
                  title,
                  style:
                      TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
              Text(
                  textAlign: TextAlign.start,
                  content,
                  style: TextStyle(fontSize: 16.sp)),
            ],
          ),
        ),
      ],
    );
  }
}

// class _ActionArea extends ConsumerStatefulWidget {
//   final void Function() onClickCreateButton;
//
//   _ActionArea(this.onClickCreateButton, {Key? key}) : super(key: key) {
//     Log.i("action-area 初始化");
//   }
//
//   @override
//   ConsumerState<_ActionArea> createState() => _ActionAreaState();
// }
//
// class _ActionAreaState extends ConsumerState<_ActionArea> {
//   void _onCheckedChanged(bool? checked) {
//     ref.read(_tipsAccepted.state).state = checked ?? false;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isChecked = ref.watch(_tipsAccepted);
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Checkbox(
//               value: isChecked,
//               onChanged: _onCheckedChanged,
//               activeColor: Theme.of(context).primaryColor,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(1000)),
//             ),
//             const Expanded(child: Text("我了解助记词由我个人保管，一旦丢失 xxx 无法为我找回")),
//           ],
//         ),
//         const SizedBox(height: 10),
//         const SizedBox(height: 20),
//       ],
//     );
//   }
// }
//

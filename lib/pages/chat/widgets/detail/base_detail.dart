import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/chat/message/msgchat.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/main.dart';
import 'package:orginone/widget/target_text.dart';
import 'package:orginone/widget/unified.dart';

double defaultWidth = 10.w;

abstract class BaseDetail extends StatelessWidget {
  final MsgSaveModel message;
  final IMsgChat? chat;
  final BoxConstraints? constraints;
  final Clip? clipBehavior;
  final EdgeInsets? padding;
  final Color? bgColor;
  final bool isSelf;
  final bool isReply;

  const BaseDetail(
      {Key? key,
      this.constraints,
      this.clipBehavior = Clip.hardEdge,
      this.padding = EdgeInsets.zero,
      this.bgColor,
      required this.isSelf,
      required this.message,
      this.isReply = false, this.chat})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextDirection textDirection =
        isSelf ? TextDirection.rtl : TextDirection.ltr;
    Color color = bgColor ?? (isSelf ? XColors.tinyLightBlue : Colors.white);


    Widget child = body(context);

    if(isReply){
      ShareIcon? shareIcon;
      if (isSelf) {
        shareIcon = settingCtrl.user.share;
      } else {
        if(chat!.share.typeName == TargetType.person.label){
          shareIcon = chat!.share;
        }else{
          var target = chat!.members.firstWhere((element) => element.id == message.fromId);
          shareIcon = target.shareIcon();
        }
      }
      if(shareIcon == null){
        print('');
      }
      child = Text.rich(
        TextSpan(
          children: [
            WidgetSpan(child: TargetText(userId: message.fromId,text: ": ",style: XFonts.size24Black0,shareIcon: shareIcon,),alignment: PlaceholderAlignment.bottom),
            WidgetSpan(child: child,alignment: PlaceholderAlignment.bottom),
          ]
        )
      );
    }

    return GestureDetector(
      onTap: (){
        onTap(context);
      },
      child: Container(
        constraints: constraints ?? BoxConstraints(maxWidth: 350.w),
        padding:
            padding ?? EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        margin: textDirection == TextDirection.ltr
            ? EdgeInsets.only(left: defaultWidth, top: defaultWidth / 2)
            : EdgeInsets.only(right: defaultWidth),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(defaultWidth)),
        ),
        clipBehavior: clipBehavior ?? Clip.none,
        child: child,
      ),
    );
  }

  Widget body(BuildContext context);

  void onTap(BuildContext context){

  }

}

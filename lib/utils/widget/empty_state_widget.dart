import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopping/utils/text_styles.dart';

class EmptyStateWidget extends StatelessWidget {
  EmptyState emptyStateFor;

  EmptyStateWidget({required this.emptyStateFor});

  @override
  Widget build(BuildContext context) {
    String imgName = "";
    String title = "";
    String subTitle = "";
    switch (emptyStateFor){
      case EmptyState.NoProductFound:
        imgName = "";
        title = "No product found";
        break;
      case EmptyState.NoCartItemFound:
        imgName = "";
        title = "No cart item found";
        break;
      default:
        imgName = "";
        title = "No data found";
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.w),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// title text
            Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyles.txtMedium16.copyWith(fontSize: 16)
            )
            // SizedBox(height:70.h),
            // /// image
            // ShowUpTransition(
            //   delay: 150,
            //   child: InkWell(
            //     onTap: (){
            //     },
            //     child: Image.asset(
            //         imgName
            //     ),
            //   ),
            // ),
            // /// sub title
            // ShowUpTransition(
            //   delay: 150,
            //   child: Text(
            //       title,
            //       textAlign: TextAlign.center,
            //       style: TextStyle(fontWeight: fwSemiBold, fontSize: 18.sp, color: clrTextByTheme())
            //   ),
            // ),
            // SizedBox(height: 15.h),
            // /// black line
            // SizedBox(height: 15.h,),
            // /// description
            // ShowUpTransition(
            //   delay: 150,
            //   child: Text(subTitle,
            //       textAlign: TextAlign.center,
            //       style: TextStyle(fontWeight: fwRegular, fontSize: 16.sp, color: clrTextGrey)
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

enum EmptyState{
  SomethingWentWrong,
  NoProductFound,
  NoCartItemFound,
  NoData,
}

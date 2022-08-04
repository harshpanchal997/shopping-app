import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:shopping/framework/controller/product/cart_controller.dart';
import 'package:shopping/framework/controller/product/product_provider.dart';
import 'package:shopping/framework/repository/product/model/cart_response_model.dart';
import 'package:shopping/utils/database/table_product.dart';
import 'package:shopping/utils/text_styles.dart';
import 'package:shopping/utils/theme_const.dart';
import 'package:shopping/utils/widget/cache_image.dart';
import 'package:shopping/utils/widget/custom_app_bar.dart';
import 'package:shopping/utils/widget/empty_state_widget.dart';

class MyCartScreen extends ConsumerStatefulWidget {
  const MyCartScreen({Key? key}) : super(key: key);

  @override
  _MyCartScreenState createState() => _MyCartScreenState();
}

class _MyCartScreenState extends ConsumerState<MyCartScreen> {

  final SwipeActionController ctrSwipeActionController = SwipeActionController();

  ///Init State
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) async {
      final cartWatch = ref.watch(cartProvider);
      await cartWatch.fillProductList();
    });
  }

  ///Dispose
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    // newsListWatch.clearProviderData();
  }

  ///Build
  @override
  Widget build(BuildContext context) {
    final cartWatch = ref.watch(cartProvider);

    return Stack(
      children: [
        Scaffold(
          appBar: CustomAppBar(
            title: "My Cart",
            appBar: AppBar(),
            isLeading: true,
          ),
          body: _mainBody(cartWatch),
          bottomNavigationBar: (cartWatch.arrProduct.isEmpty) ? const Offstage() : Container(
            height: 70.h,
            color: clrWhite,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: "Total Items : ",
                            style: TextStyles.txtMedium16.copyWith(fontSize: 16)
                        ),
                        TextSpan(
                            text: cartWatch.totalItems.toString(),
                            style: TextStyles.txtSemiBold18.copyWith(color: clrTheme, fontSize: 18)
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: RichText(
                    textAlign: TextAlign.right,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: "Total Price : ",
                            style: TextStyles.txtMedium16.copyWith(fontSize: 16)
                        ),
                        TextSpan(
                            text: cartWatch.totalPrice.toString(),
                            style: TextStyles.txtSemiBold18.copyWith(color: clrTheme, fontSize: 18)
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // DialogProgressBar(isLoading: newsListWatch.isLoading)
      ],
    );
  }

  ///Main Body
  Widget _mainBody(CartController cartWatch) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: (cartWatch.arrProduct.isEmpty) ? EmptyStateWidget(emptyStateFor: EmptyState.NoCartItemFound) : OrientationBuilder(
          builder: (context, orientation) {
            bool isPortrait = (orientation == Orientation.portrait);

            return ListView.builder(
              itemCount: cartWatch.arrProduct.length,
              itemBuilder: (context, index){
                CartResponseModel _dataObj = cartWatch.arrProduct[index];

                return Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: SwipeActionCell(
                      key: const ObjectKey(1), ///this key is necessary
                      controller: ctrSwipeActionController,
                      closeWhenScrolling: true,
                      trailingActions: <SwipeAction>[
                        SwipeAction(
                          icon: Icon(Icons.delete, color: clrWhite,),
                          backgroundRadius: 10.r,
                          widthSpace: 80.w,
                          title: "Remove",
                          style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: 10.sp,
                              color: clrWhite
                          ),
                          onTap: (CompletionHandler handler) {
                            showConfirmationDialog(context, "", "Remove", "Are you sure you want to remove this product from your cart?", (result) async {
                              ctrSwipeActionController.closeAllOpenCell();
                              if(result){
                                int value = await TblProduct.instance.deleteData(_dataObj.id ?? 0);
                                if(value > 0){
                                  showSnackBar(context, "Product remove successfully");
                                  cartWatch.deleteData(_dataObj.id ?? 0);
                                }
                              }
                            });
                          },
                        ),
                      ],
                      child: Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: clrBGLightGrey,
                                  borderRadius: BorderRadius.circular(10.r)
                              ),
                              padding: EdgeInsets.all(10.h),
                              child: CacheImage(
                                imageURL: _dataObj.featuredImage ?? "",
                                height: isPortrait ? 120.h : 200.h,
                                width: isPortrait ? 120.h : 200.h,
                                contentMode: BoxFit.contain,
                                topLeftRadius: 10.r,
                                bottomLeftRadius: 10.r,
                              ),
                            ),
                            SizedBox(width: 10.w,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _dataObj.title ?? "",
                                    maxLines: 2,
                                    style: TextStyles.txtSemiBold18.copyWith(fontSize: 18),
                                  ),
                                  SizedBox(height: 6.h,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Price",
                                        maxLines: 1,
                                        style: TextStyles.txtRegular16.copyWith(fontSize: 16, color: clrTextDarkGrey),
                                      ),
                                      Text(
                                        "\$ ${_dataObj.price ?? ""}",
                                        maxLines: 1,
                                        style: TextStyles.txtRegular16.copyWith(fontSize: 16, color: clrTextDarkGrey),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 6.h,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Quantity",
                                        maxLines: 1,
                                        style: TextStyles.txtRegular16.copyWith(fontSize: 16, color: clrTextDarkGrey),
                                      ),
                                      Text(
                                        "X ${_dataObj.quantity ?? ""}",
                                        maxLines: 1,
                                        style: TextStyles.txtRegular16.copyWith(fontSize: 16, color: clrTextDarkGrey),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

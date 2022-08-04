import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopping/framework/controller/product/product_controller.dart';
import 'package:shopping/framework/controller/product/product_provider.dart';
import 'package:shopping/framework/repository/product/model/cart_response_model.dart';
import 'package:shopping/framework/repository/product/model/product_list_response_model.dart';
import 'package:shopping/ui/product/my_cart_screen.dart';
import 'package:shopping/utils/database/table_product.dart';
import 'package:shopping/utils/text_styles.dart';
import 'package:shopping/utils/theme_const.dart';
import 'package:shopping/utils/widget/cache_image.dart';
import 'package:shopping/utils/widget/custom_app_bar.dart';
import 'package:shopping/utils/widget/dialog_progress_bar.dart';
import 'package:shopping/utils/widget/empty_state_widget.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);
  
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {

  ///Init State
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      final productWatch = ref.watch(productProvider);
      productWatch.clearProvider();
      _getProductListApi(true,productWatch);

      // _scrollController.addListener(() {
      //   if (_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
      //     if ((productWatch.productListResponseModel?.hasNextPage == true) && !productWatch.isLoadingPagination) {
      //       _getNotificationListApi(false,productWatch);
      //     }
      //   }
      // });
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
    final productWatch = ref.watch(productProvider);

    return Stack(
      children: [
        Scaffold(
          appBar: CustomAppBar(
            title: "Shopping Mall",
            appBar: AppBar(),
            isLeading: false,
            action: [
              InkWell(
                onTap: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MyCartScreen()));
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Icon(
                    Icons.shopping_cart_outlined, color: clrTheme,
                  ),
                ),
              )
            ],
          ),
          body: _mainBody(productWatch),
        ),
        DialogProgressBar(isLoading: productWatch.isLoading)
      ],
    );
  }

  ///Main Body
  Widget _mainBody(ProductController productWatch) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: OrientationBuilder(
          builder: (context, orientation) {
            bool isPortrait = (orientation == Orientation.portrait);

            return Column(
              children: [
                Expanded(
                  child: productWatch.productListResponseModel == null ? const Offstage() : (productWatch.arrProduct.isEmpty) ?
                  EmptyStateWidget(emptyStateFor: EmptyState.NoProductFound) : NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification){
                      bool hasNextPage = ((productWatch.productListResponseModel?.totalPage ?? 0) > productWatch.pageNo);
                      if (scrollNotification.metrics.pixels == scrollNotification.metrics.maxScrollExtent) {
                        if(hasNextPage && !productWatch.isLoadingPagination) {
                          _getProductListApi(false, productWatch);
                        }
                      }
                      return hasNextPage;
                    },
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: (isPortrait) ? 2 : 3,
                          mainAxisSpacing: 5.h,
                          crossAxisSpacing: 5.w,
                          childAspectRatio: (isPortrait) ? 0.69 : 1.4
                      ),
                      itemCount: productWatch.arrProduct.length,
                      itemBuilder: (context,index){
                        ProductData _dataObj = productWatch.arrProduct[index];

                        return Card(
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: clrBGLightGrey,
                                    borderRadius: BorderRadius.circular(10.r)
                                  ),
                                  padding: EdgeInsets.all(10.h),
                                  child: CacheImage(
                                    imageURL: _dataObj.featuredImage ?? "",
                                    height: double.infinity,
                                    width: double.infinity,
                                    contentMode: BoxFit.contain,
                                    topLeftRadius: 10.r,
                                    topRightRadius: 10.r,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.h,vertical: 18.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _dataObj.title ?? "",
                                      maxLines: 1,
                                      style: TextStyles.txtBold16.copyWith(fontSize: 16),
                                    ),
                                    SizedBox(height: 6.h,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            "$currencySymbol ${(_dataObj.price ?? 0).toString()}",
                                            maxLines: 1,
                                            style: TextStyles.txtRegular14.copyWith(fontSize: 16, color: clrTheme),
                                          ),
                                        ),
                                        SizedBox(width: 4.w,),
                                        InkWell(
                                          onTap: () async {
                                            List<CartResponseModel> cartProduct = await TblProduct.instance.getDataModel();
                                            List<int?> _ids = cartProduct.map((e) => (e.id)).toList();

                                            if(_ids.contains(_dataObj.id)){
                                              CartResponseModel _data = cartProduct.where((element) => (element.id == _dataObj.id)).first;
                                              _data.quantity = ((_data.quantity ?? 0) + 1);
                                              int value = await TblProduct.instance.updateData(_data);
                                              if(value > 0){
                                                showSnackBar(context, "Quantity update successfully");
                                              }
                                            }
                                            else{
                                              int value = await TblProduct.instance.insertTestData(
                                                  _dataObj.id ?? 0,
                                                  _dataObj.slug ?? "",
                                                  _dataObj.title ?? "",
                                                  _dataObj.description ?? "",
                                                  _dataObj.price ?? 0,
                                                  _dataObj.featuredImage ?? "",
                                                  _dataObj.status ?? "",
                                                  1,
                                                  _dataObj.createdAt ?? ""
                                              );
                                              if(value > 0){
                                                showSnackBar(context, "Product added successfully");
                                              }
                                            }
                                          },
                                          child: Icon(
                                            Icons.add_shopping_cart_sharp, color: clrTheme,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                DialogProgressBar(isLoading: productWatch.isLoadingPagination, forPagination: productWatch.isLoadingPagination)
              ],
            );
          },
        ),
      ),
    );
  }

  ///Get Product List APi
  _getProductListApi(bool fromFresh, ProductController productWatch) async{
    if(fromFresh){
      productWatch.productListResponseModel = null;
    }
    await productWatch.getProductListApi(context);
  }
}

import 'package:flutter/material.dart';
import 'package:mentorkhoj/common/providers/cart_provider.dart';
import 'package:mentorkhoj/common/widgets/custom_directionality_widget.dart';
import 'package:mentorkhoj/features/coupon/providers/coupon_provider.dart';
import 'package:mentorkhoj/features/order/providers/order_provider.dart';
import 'package:mentorkhoj/features/splash/providers/splash_provider.dart';
import 'package:mentorkhoj/helper/price_converter_helper.dart';
import 'package:mentorkhoj/helper/responsive_helper.dart';
import 'package:mentorkhoj/localization/language_constraints.dart';
import 'package:mentorkhoj/utill/dimensions.dart';
import 'package:mentorkhoj/utill/styles.dart';
import 'package:provider/provider.dart';

class CategoryCartTitleWidget extends StatelessWidget {
  const CategoryCartTitleWidget({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final OrderProvider orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final bool kmWiseCharge = splashProvider.configModel?.deliveryManagement?.status ?? false;

    return Consumer<CartProvider>(
        builder: (context,cartProvider,_) {
          double? deliveryCharge = 0;

          if(orderProvider.orderType == 'delivery' && !kmWiseCharge) {
            deliveryCharge = splashProvider.configModel?.deliveryCharge;
          }else {
            deliveryCharge = 0;
          }
          double itemPrice = 0;
          double discount = 0;
          double tax = 0;
          for (var cartModel in cartProvider.cartList) {
            itemPrice = itemPrice + (cartModel.price! * cartModel.quantity!);
            discount = discount + (cartModel.discount! * cartModel.quantity!);
            tax = tax + (cartModel.tax! * cartModel.quantity!);
          }
          double subTotal = itemPrice + tax;
          double total = subTotal - discount - Provider.of<CouponProvider>(context).discount! + deliveryCharge!;

          return (cartProvider.cartList.isNotEmpty && ResponsiveHelper.isMobile()) ? Container(
            width: Dimensions.webScreenWidth,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
                splashProvider.setPageIndex(2);
              },

              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(12)
                  ),
                  child: Column(
                    children: [

                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text(getTranslated('total_item', context),
                            style: poppinsMedium.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                              color: Theme.of(context).cardColor,
                            )),

                        Text('${cartProvider.cartList.length} ${getTranslated('items', context)}',
                            style: poppinsMedium.copyWith(color: Theme.of(context).cardColor)),

                      ]),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text(getTranslated('total_amount', context),
                            style: poppinsMedium.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                              color:Theme.of(context).cardColor,
                            )),

                        CustomDirectionalityWidget(child: Text(
                          PriceConverterHelper.convertPrice(context, total),
                          style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).cardColor),
                        )),
                      ]),

                    ],
                  ),
                ),
              ),
            ),
          ) : const SizedBox();
        }
    );
  }
}

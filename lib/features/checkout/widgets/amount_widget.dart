import 'package:flutter/material.dart';
import 'package:mentorkhoj/common/models/config_model.dart';
import 'package:mentorkhoj/common/widgets/custom_directionality_widget.dart';
import 'package:mentorkhoj/common/widgets/custom_divider_widget.dart';
import 'package:mentorkhoj/features/checkout/domain/models/check_out_model.dart';
import 'package:mentorkhoj/features/checkout/widgets/total_amount_widget.dart';
import 'package:mentorkhoj/features/order/providers/order_provider.dart';
import 'package:mentorkhoj/features/splash/providers/splash_provider.dart';
import 'package:mentorkhoj/helper/checkout_helper.dart';
import 'package:mentorkhoj/helper/price_converter_helper.dart';
import 'package:mentorkhoj/helper/responsive_helper.dart';
import 'package:mentorkhoj/localization/language_constraints.dart';
import 'package:mentorkhoj/utill/dimensions.dart';
import 'package:mentorkhoj/utill/styles.dart';
import 'package:provider/provider.dart';

class AmountWidget extends StatelessWidget {
  const AmountWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ConfigModel? configModel =  Provider.of<SplashProvider>(context, listen: false).configModel;

    return Consumer<OrderProvider>(
        builder: (context, orderProvider, _) {

          CheckOutModel? checkOutData = Provider.of<OrderProvider>(context, listen: false).getCheckOutData;
          bool isFreeDelivery = CheckOutHelper.isFreeDeliveryCharge(type: checkOutData?.orderType);
          bool selfPickup = CheckOutHelper.isSelfPickup(orderType: checkOutData?.orderType);
          bool showPayment = orderProvider.selectedPaymentMethod != null;


          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
            child: Column(children: [
              const SizedBox(height: Dimensions.paddingSizeLarge),

              if(CheckOutHelper.isKmWiseCharge(configModel: configModel)) Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(getTranslated('subtotal', context), style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),

                  CustomDirectionalityWidget(child: Text(
                    PriceConverterHelper.convertPrice(context, checkOutData?.amount),
                    style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                  )),
                ]),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(
                    getTranslated('delivery_fee', context),
                    style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                  ),
                  Consumer<OrderProvider>(builder: (context, orderProvider, _) {
                    return CustomDirectionalityWidget(
                      child: Text(isFreeDelivery ? getTranslated('free', context): (selfPickup ||  orderProvider.distance != -1)
                          ? '(+) ${PriceConverterHelper.convertPrice(context, selfPickup
                          ? 0 : checkOutData?.deliveryCharge)}'
                          : getTranslated('not_found', context),
                        style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                      ),
                    );
                  }),
                ]),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                  child: CustomDividerWidget(),
                ),
              ]),


              if(orderProvider.partialAmount != null) Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(
                    getTranslated('wallet_payment', context),
                    style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                  ),

                  CustomDirectionalityWidget(
                    child: Text(PriceConverterHelper.convertPrice(context, checkOutData!.amount! + (checkOutData.deliveryCharge ?? 0) - (orderProvider.partialAmount ?? 0) ),
                      style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                    ),
                  ),
                ]),
                const SizedBox(height: Dimensions.paddingSizeSmall),



                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text( showPayment && orderProvider.selectedPaymentMethod?.type != 'cash_on_delivery'? getTranslated(orderProvider.selectedPaymentMethod?.getWayTitle, context) :
                  '${getTranslated('due_amount', context)} ${orderProvider.selectedPaymentMethod?.type == 'cash_on_delivery'
                      ? '(${getTranslated(orderProvider.selectedPaymentMethod?.type, context)})' : ''}',
                    style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                  ),

                  CustomDirectionalityWidget(
                    child: Text(PriceConverterHelper.convertPrice(context, orderProvider.partialAmount ??  (orderProvider.getCheckOutData?.amount ?? 0)),
                      style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                    ),
                  ),

                ]),

                const SizedBox(height: Dimensions.paddingSizeLarge),

              ]),


              if(ResponsiveHelper.isDesktop(context)) TotalAmountWidget(
                amount: checkOutData?.amount ?? 0,
                freeDelivery: isFreeDelivery,
                deliveryCharge: checkOutData?.deliveryCharge ?? 0,
              ),

            ]),
          );
        }
    );
  }
}

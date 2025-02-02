import 'package:flutter/material.dart';
import 'package:mentorkhoj/common/enums/footer_type_enum.dart';
import 'package:mentorkhoj/features/order/domain/models/order_model.dart';
import 'package:mentorkhoj/helper/responsive_helper.dart';
import 'package:mentorkhoj/localization/language_constraints.dart';
import 'package:mentorkhoj/features/order/providers/order_provider.dart';
import 'package:mentorkhoj/utill/dimensions.dart';
import 'package:mentorkhoj/utill/images.dart';
import 'package:mentorkhoj/common/widgets/custom_loader_widget.dart';
import 'package:mentorkhoj/common/widgets/footer_web_widget.dart';
import 'package:mentorkhoj/common/widgets/no_data_widget.dart';
import 'package:mentorkhoj/features/order/widgets/order_item_widget.dart';
import 'package:provider/provider.dart';

class OrderWidget extends StatelessWidget {
  final bool isRunning;
  const OrderWidget({Key? key, required this.isRunning}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Consumer<OrderProvider>(
        builder: (context, order, index) {
          List<OrderModel>? orderList;
          if (order.runningOrderList != null) {
            orderList = isRunning ? order.runningOrderList!.reversed.toList() : order.historyOrderList!.reversed.toList();
          }

          return orderList != null ? orderList.isNotEmpty ? RefreshIndicator(
            onRefresh: () async {
              await Provider.of<OrderProvider>(context, listen: false).getOrderList(context);
              },

            backgroundColor: Theme.of(context).primaryColor,
            child: CustomScrollView(slivers: [
              SliverToBoxAdapter(child: Center(child: SizedBox(
                width: Dimensions.webScreenWidth,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  itemCount: orderList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                      child: OrderItemWidget(orderList: orderList,index: index),
                    );
                  },
                ),
              ))),

              const FooterWebWidget(footerType: FooterType.sliver),
            ]),
          ) : NoDataWidget(
            image: Images.emptyOrderImage, title: getTranslated('no_order_history', context),
            subTitle: getTranslated('buy_something_to_see', context),
            isShowButton: true,
          ) : Center(child: CustomLoaderWidget(color: Theme.of(context).primaryColor));
        },
      ),
    );
  }
}


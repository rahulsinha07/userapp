import 'package:flutter/material.dart';
import 'package:mentorkhoj/features/checkout/domain/models/check_out_model.dart';
import 'package:mentorkhoj/common/models/config_model.dart';
import 'package:mentorkhoj/features/checkout/widgets/amount_widget.dart';
import 'package:mentorkhoj/features/checkout/widgets/image_note_upload_widget.dart';
import 'package:mentorkhoj/helper/responsive_helper.dart';
import 'package:mentorkhoj/localization/language_constraints.dart';
import 'package:mentorkhoj/features/order/providers/order_provider.dart';
import 'package:mentorkhoj/utill/dimensions.dart';
import 'package:mentorkhoj/utill/styles.dart';
import 'package:mentorkhoj/common/widgets/custom_shadow_widget.dart';
import 'package:mentorkhoj/common/widgets/custom_text_field_widget.dart';
import 'package:mentorkhoj/features/checkout/widgets/payment_section_widget.dart';
import 'package:provider/provider.dart';

import 'partial_pay_widget.dart';

class DetailsWidget extends StatelessWidget {
  const DetailsWidget({
    Key? key,
    required this.paymentList,
    required this.noteController,
  }) : super(key: key);

  final List<PaymentMethod> paymentList;
  final TextEditingController noteController;

  @override
  Widget build(BuildContext context) {
    CheckOutModel? checkOutData = Provider.of<OrderProvider>(context, listen: false).getCheckOutData;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      const PaymentSectionWidget(),

      PartialPayWidget(totalPrice: checkOutData!.amount! + (checkOutData.deliveryCharge ?? 0)),

      const ImageNoteUploadWidget(),

      CustomShadowWidget(
        margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeDefault),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(getTranslated('add_delivery_note', context), style: poppinsRegular),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          CustomTextFieldWidget(
            fillColor: Theme.of(context).canvasColor,
            isShowBorder: true,
            controller: noteController,
            hintText: getTranslated('type', context),
            maxLines: 5,
            inputType: TextInputType.multiline,
            inputAction: TextInputAction.newline,
            capitalization: TextCapitalization.sentences,
          ),
        ]),
      ),

      if(!ResponsiveHelper.isDesktop(context)) const AmountWidget(),

    ]);
  }
}






import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mentorkhoj/common/widgets/custom_image_widget.dart';
import 'package:mentorkhoj/helper/route_helper.dart';
import 'package:mentorkhoj/localization/app_localization.dart';
import 'package:mentorkhoj/main.dart';
import 'package:mentorkhoj/utill/dimensions.dart';
import 'package:mentorkhoj/utill/images.dart';
import 'package:mentorkhoj/utill/styles.dart';
import 'package:mentorkhoj/common/widgets/custom_button_widget.dart';
import 'package:mentorkhoj/common/widgets/custom_directionality_widget.dart';
import 'package:mentorkhoj/features/order/screens/order_details_screen.dart';

class NotificationDialogWebWidget extends StatefulWidget {
  final String? title;
  final String? body;
  final int? orderId;
  final String? image;
  final String? type;
  const NotificationDialogWebWidget({Key? key, required this.title, required this.body, required this.orderId, this.image, this.type}) : super(key: key);

  @override
  State<NotificationDialogWebWidget> createState() => _NewRequestDialogState();
}

class _NewRequestDialogState extends State<NotificationDialogWebWidget> {

  @override
  void initState() {
    super.initState();

    _startAlarm();
  }

  void _startAlarm() async {
    AudioPlayer audio = AudioPlayer();
    audio.play(AssetSource('notification.wav'));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault)),
      //insetPadding: EdgeInsets.all(Dimensions.paddingSizeLarge),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          Icon(Icons.notifications_active, size: 60, color: Theme.of(context).primaryColor),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            child: CustomDirectionalityWidget(child: Text(
              '${widget.title} ${widget.orderId != null ? '(${widget.orderId})': ''}',
              textAlign: TextAlign.center,
              style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
            )),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            child: Column(
              children: [
                Text(
                  widget.body!, textAlign: TextAlign.center,
                  style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                ),
               if(widget.image != null)
                 const SizedBox(height: Dimensions.paddingSizeExtraSmall,),

                if(widget.image != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CustomImageWidget(
                      height: 100,
                      width: 500,
                      image: widget.image!,
                    ),
                  ),


              ],
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          Row(mainAxisAlignment: MainAxisAlignment.center, children: [

            Flexible(
              child: SizedBox(width: 120, height: 40,child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).disabledColor.withOpacity(0.3), padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault)),
                ),
                child: Text(
                  'cancel'.tr, textAlign: TextAlign.center,
                  style: poppinsRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color),
                ),
              )),
            ),


            const SizedBox(width: 20),

           if(widget.orderId != null || widget.type == 'message') Flexible(
             child: SizedBox(
                width: 120,
                height: 40,
                child: CustomButtonWidget(
                  textColor: Colors.white,
                  buttonText: 'go'.tr,
                  onPressed: () {
                    Navigator.pop(context);

                    try{
                      if(widget.orderId == null) {
                        Navigator.pushNamed(context, RouteHelper.getChatRoute(orderModel: null));
                      }else{
                        Get.navigator!.push(MaterialPageRoute(
                          builder: (context) => OrderDetailsScreen(orderModel: null, orderId: widget.orderId),
                        ));
                      }

                    }catch (e) {}

                  },
                ),
              ),
           ),

          ]),

        ]),
      ),
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:mentorkhoj/common/models/config_model.dart';
import 'package:mentorkhoj/features/auth/domain/models/social_login_model.dart';
import 'package:mentorkhoj/helper/route_helper.dart';
import 'package:mentorkhoj/localization/language_constraints.dart';
import 'package:mentorkhoj/main.dart';
import 'package:mentorkhoj/features/auth/providers/auth_provider.dart';
import 'package:mentorkhoj/features/splash/providers/splash_provider.dart';
import 'package:mentorkhoj/utill/app_constants.dart';
import 'package:mentorkhoj/utill/dimensions.dart';
import 'package:mentorkhoj/utill/images.dart';
import 'package:mentorkhoj/utill/styles.dart';
import 'package:mentorkhoj/features/auth/widgets/media_button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SocialLoginWidget extends StatefulWidget {
  final String? countryCode;
  const SocialLoginWidget({Key? key, required this.countryCode}) : super(key: key);

  @override
  State<SocialLoginWidget> createState() => _SocialLoginWidgetState();
}

class _SocialLoginWidgetState extends State<SocialLoginWidget> {
  SocialLoginModel socialLogin = SocialLoginModel();
  TextEditingController phoneController = TextEditingController();
  FocusNode focusNode = FocusNode();

  void route(
      bool isRoute,
      String? token,
      String? errorMessage,
      ) async {
    if (isRoute) {
      if(token != null){
        Navigator.pushNamedAndRemoveUntil(context, RouteHelper.menu, (route) => false);

      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage ?? ''),
            backgroundColor: Colors.red));
      }

    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage ?? ''),
          backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ConfigModel? configModel = Provider.of<SplashProvider>(context,listen: false).configModel;

    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return Column(children: [

          Center(child: Text(getTranslated('sign_in_with', context), style: poppinsRegular.copyWith(
              color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.6),
              fontSize: Dimensions.fontSizeSmall))),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          Row(mainAxisAlignment: MainAxisAlignment.center, children: [

            if(configModel?.socialLoginStatus?.isGoogle ?? false) Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
              child: MediaButtonView(
                image: Images.google,
                onTap: () async {
                  try{

                    GoogleSignInAuthentication  auth = await authProvider.googleLogin();
                    GoogleSignInAccount googleAccount = authProvider.googleAccount!;

                    Provider.of<AuthProvider>(Get.context!, listen: false).socialLogin(SocialLoginModel(
                      email: googleAccount.email, token: auth.accessToken, uniqueId: googleAccount.id, medium: 'google',
                    ), route);


                  }catch(er){
                    debugPrint('access token error is : $er');
                  }
                },
              ),
            ),


            if(configModel?.socialLoginStatus?.isFacebook ?? false) MediaButtonView(
              image: Images.facebookSocialLogo,
              onTap: () async {
                LoginResult result = await FacebookAuth.instance.login();

                if (result.status == LoginStatus.success) {
                  Map userData = await FacebookAuth.instance.getUserData();

                  authProvider.socialLogin(
                    SocialLoginModel(
                      email: userData['email'],
                      token: result.accessToken!.token,
                      uniqueId: result.accessToken!.userId,
                      medium: 'facebook',
                    ), route,
                  );
                }
              },
            ),


            if(!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS && (configModel?.appleLogin?.status ?? false)) Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
              child: MediaButtonView(
                image: Images.appleLogo,
                onTap: () async {

                  final credential = await SignInWithApple.getAppleIDCredential(scopes: [
                    AppleIDAuthorizationScopes.email,
                    AppleIDAuthorizationScopes.fullName,
                  ],
                    webAuthenticationOptions: WebAuthenticationOptions(
                      clientId: '${configModel?.appleLogin?.clientId}',
                      redirectUri: Uri.parse(AppConstants.baseUrl),
                    ),
                  );

                  

                  authProvider.socialLogin(SocialLoginModel(
                    email: credential.email, token: credential.authorizationCode, uniqueId: credential.authorizationCode, medium: 'apple',
                  ), route);
                },
              ),
            ),





          ]),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
        ]);
      }
    );
  }
}




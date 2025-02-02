import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:mentorkhoj/common/enums/footer_type_enum.dart';
import 'package:mentorkhoj/common/models/config_model.dart';
import 'package:mentorkhoj/common/widgets/custom_pop_scope_widget.dart';
import 'package:mentorkhoj/features/auth/domain/models/user_log_data.dart';
import 'package:mentorkhoj/helper/email_checker_helper.dart';
import 'package:mentorkhoj/helper/responsive_helper.dart';
import 'package:mentorkhoj/helper/route_helper.dart';
import 'package:mentorkhoj/localization/language_constraints.dart';
import 'package:mentorkhoj/features/auth/providers/auth_provider.dart';
import 'package:mentorkhoj/features/splash/providers/splash_provider.dart';
import 'package:mentorkhoj/utill/dimensions.dart';
import 'package:mentorkhoj/utill/images.dart';
import 'package:mentorkhoj/utill/styles.dart';
import 'package:mentorkhoj/common/widgets/custom_button_widget.dart';
import 'package:mentorkhoj/helper/custom_snackbar_helper.dart';
import 'package:mentorkhoj/common/widgets/custom_text_field_widget.dart';
import 'package:mentorkhoj/common/widgets/footer_web_widget.dart';
import 'package:mentorkhoj/features/auth/widgets/country_code_picker_widget.dart';
import 'package:mentorkhoj/features/auth/screens/forgot_password_screen.dart';
import 'package:mentorkhoj/common/widgets/web_app_bar_widget.dart';
import 'package:provider/provider.dart';

import '../widgets/social_login_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _numberFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  GlobalKey<FormState>? _formKeyLogin;
  bool email = true;
  bool phone = false;
  String? countryCode;

  @override
  void initState() {
    super.initState();
    _initLoading();
  }

  @override
  void dispose() {
    _emailController!.dispose();
    _passwordController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final configModel = Provider.of<SplashProvider>(context, listen: false).configModel!;
    final socialStatus = configModel.socialLoginStatus;

    return CustomPopScopeWidget(
      child: Scaffold(
        appBar: ResponsiveHelper.isDesktop(context)
            ? const PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: WebAppBarWidget(),
        )
            : null,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context)
                      ? Dimensions.paddingSizeDefault
                      : Dimensions.paddingSizeLarge),
                  child: Center(
                    child: Container(
                      width: ResponsiveHelper.isMobile() ? width : 600,
                      padding: !ResponsiveHelper.isMobile()
                          ? const EdgeInsets.symmetric(horizontal: 60, vertical: 40)
                          : null,
                      decoration: !ResponsiveHelper.isMobile()
                          ? BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            spreadRadius: 1,
                          )
                        ],
                      )
                          : null,
                      child: Form(
                        key: _formKeyLogin,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Image.asset(
                                Images.appLogo,
                                height: MediaQuery.of(context).size.height / 5,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: Text(
                                getTranslated('login', context),
                                style: poppinsMedium.copyWith(
                                  fontSize: 28,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildEmailOrPhoneField(context, configModel),
                            const SizedBox(height: 10),
                            _buildPasswordField(context),
                            const SizedBox(height: 10),
                            _buildRememberMeAndForgotPassword(context),
                            const SizedBox(height: 10),
                            _buildLoginButton(context),
                            const SizedBox(height: 10),
                            _buildSignupOption(context),
                            if (socialStatus!.isFacebook! || socialStatus.isGoogle!)
                              Center(child: SocialLoginWidget(countryCode: countryCode)),
                            Center(
                              child: Text(
                                getTranslated('OR', context),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                            _buildContinueAsGuest(context),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const FooterWebWidget(footerType: FooterType.sliver),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailOrPhoneField(BuildContext context, ConfigModel configModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          configModel.emailVerification ?? false
              ? getTranslated('email', context)
              : getTranslated('mobile_number', context),
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        configModel.emailVerification ?? false
            ? CustomTextFieldWidget(
          hintText: getTranslated('demo_gmail', context),
          isShowBorder: true,
          focusNode: _emailFocus,
          nextFocus: _passwordFocus,
          controller: _emailController,
          inputType: TextInputType.emailAddress,
        )
            : Row(
          children: [
            CountryCodePickerWidget(
              onChanged: (CountryCode value) {
                countryCode = value.dialCode;
              },
              initialSelection: countryCode,
              favorite: [countryCode!],
              showDropDownButton: true,
              padding: EdgeInsets.zero,
              showFlagMain: true,
              textStyle: TextStyle(color: Theme.of(context).textTheme.displayLarge?.color),
            ),
            Expanded(
              child: CustomTextFieldWidget(
                hintText: getTranslated('number_hint', context),
                isShowBorder: true,
                focusNode: _numberFocus,
                nextFocus: _passwordFocus,
                controller: _emailController,
                inputType: TextInputType.phone,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getTranslated('password', context),
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        CustomTextFieldWidget(
          hintText: getTranslated('password_hint', context),
          isShowBorder: true,
          isPassword: true,
          isShowSuffixIcon: true,
          focusNode: _passwordFocus,
          controller: _passwordController,
          inputAction: TextInputAction.done,
        ),
      ],
    );
  }

  Widget _buildRememberMeAndForgotPassword(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () => authProvider.onChangeRememberMeStatus(),
          child: Row(
            children: [
              Checkbox(
                value: authProvider.isActiveRememberMe,
                onChanged: (value) => authProvider.onChangeRememberMeStatus(),
              ),
              Text(
                getTranslated('remember_me', context),
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(RouteHelper.forgetPassword, arguments: const ForgotPasswordScreen());
          },
          child: Text(
            getTranslated('forgot_password', context),
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return CustomButtonWidget(
      isLoading: authProvider.isLoading,
      buttonText: getTranslated('login', context),
      onPressed: () async => _login(),
    );
  }

  Widget _buildSignupOption(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(RouteHelper.getCreateAccount());
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            getTranslated('create_an_account', context),
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(width: 5),
          Text(
            getTranslated('signup', context),
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueAsGuest(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushReplacementNamed(context, RouteHelper.menu);
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '${getTranslated('continue_as_a', context)} ',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            TextSpan(
              text: getTranslated('guest', context),
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ],
        ),
      ),
    );
  }

  void _initLoading() {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.onChangeLoadingStatus();
    authProvider.socialLogout();

    _formKeyLogin = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    final ConfigModel configModel = Provider.of<SplashProvider>(context, listen: false).configModel!;

    UserLogData? userData = authProvider.getUserData();
    if (userData != null) {
      _emailController!.text = configModel.emailVerification! ? userData.email! : userData.phoneNumber!;
      _passwordController!.text = userData.password!;
      countryCode = userData.countryCode;
    }
    countryCode ??= CountryCode.fromCountryCode(configModel.country!).dialCode;
  }

  void _login() {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);

    String email = _emailController?.text.trim() ?? '';
    String password = _passwordController?.text.trim() ?? '';

    if (!splashProvider.configModel!.emailVerification!) {
      email = countryCode! + _emailController!.text.trim();
    }

    if (email.isEmpty) {
      showCustomSnackBarHelper(
          splashProvider.configModel!.emailVerification!
              ? getTranslated('enter_email_address', context)
              : getTranslated('enter_phone_number', context));
    } else if (splashProvider.configModel!.emailVerification! &&
        EmailCheckerHelper.isNotValid(email)) {
      showCustomSnackBarHelper(getTranslated('enter_valid_email', context));
    } else if (password.isEmpty) {
      showCustomSnackBarHelper(getTranslated('enter_password', context));
    } else if (password.length < 6) {
      showCustomSnackBarHelper(getTranslated('password_should_be', context));
    } else {
      authProvider.login(email, password).then((status) async {
        if (status.isSuccess) {
          if (authProvider.isActiveRememberMe) {
            authProvider.saveUserNumberAndPassword(UserLogData(
              countryCode: countryCode,
              phoneNumber: !splashProvider.configModel!.emailVerification!
                  ? _emailController!.text
                  : null,
              email: splashProvider.configModel!.emailVerification!
                  ? _emailController!.text
                  : null,
              password: password,
            ));
          } else {
            authProvider.clearUserLogData();
          }
          Navigator.pushNamedAndRemoveUntil(context, RouteHelper.menu, (route) => false);
        } else if (status.message == 'verification') {
          Navigator.of(context).pushNamed(RouteHelper.getVerifyRoute('sign-up', email, session: null));
        }
      });
    }
  }
}

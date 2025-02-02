import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:mentorkhoj/common/enums/footer_type_enum.dart';
import 'package:mentorkhoj/common/models/config_model.dart';
import 'package:mentorkhoj/features/auth/domain/models/signup_model.dart';
import 'package:mentorkhoj/helper/email_checker_helper.dart';
import 'package:mentorkhoj/helper/responsive_helper.dart';
import 'package:mentorkhoj/helper/route_helper.dart';
import 'package:mentorkhoj/localization/language_constraints.dart';
import 'package:mentorkhoj/features/auth/providers/auth_provider.dart';
import 'package:mentorkhoj/features/splash/providers/splash_provider.dart';
import 'package:mentorkhoj/utill/dimensions.dart';
import 'package:mentorkhoj/utill/styles.dart';
import 'package:mentorkhoj/common/widgets/custom_button_widget.dart';
import 'package:mentorkhoj/common/widgets/custom_directionality_widget.dart';
import 'package:mentorkhoj/helper/custom_snackbar_helper.dart';
import 'package:mentorkhoj/common/widgets/custom_text_field_widget.dart';
import 'package:mentorkhoj/common/widgets/footer_web_widget.dart';
import 'package:mentorkhoj/features/auth/screens/login_screen.dart';
import 'package:mentorkhoj/features/auth/widgets/country_code_picker_widget.dart';
import 'package:mentorkhoj/common/widgets/web_app_bar_widget.dart';
import 'package:mentorkhoj/features/menu/screens/menu_screen.dart';
import 'package:provider/provider.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _numberFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _referTextFocus = FocusNode();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _referTextController = TextEditingController();

  String? countryCode;

  @override
  void initState() {
    countryCode = CountryCode.fromCountryCode(Provider.of<SplashProvider>(context, listen: false).configModel!.country!).dialCode;
    Provider.of<AuthProvider>(context, listen: false).updateRegistrationErrorMessage('', false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<SplashProvider>(context, listen: false).configModel!;
    countryCode = CountryCode.fromCountryCode(config.country!).dialCode;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(preferredSize: Size.fromHeight(120), child: WebAppBarWidget())
          : null,
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) => SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          width: width > 700 ? 700 : width,
                          padding: ResponsiveHelper.isDesktop(context)
                              ? const EdgeInsets.symmetric(horizontal: 50, vertical: 50)
                              : width > 700
                              ? const EdgeInsets.all(Dimensions.paddingSizeDefault)
                              : null,
                          decoration: width > 700
                              ? BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 5, spreadRadius: 1)],
                          )
                              : null,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 30),

                              Center(
                                child: Text(
                                  getTranslated('create_account', context),
                                  style: poppinsMedium.copyWith(fontSize: 24, color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6)),
                                ),
                              ),
                              const SizedBox(height: 30),

                              // Full Name Field
                              Text(
                                getTranslated('Full Name', context),
                                style: poppinsRegular.copyWith(color: Theme.of(context).hintColor.withOpacity(0.6)),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeSmall),

                              CustomTextFieldWidget(
                                hintText: 'John Doe',
                                isShowBorder: true,
                                controller: _nameController,
                                focusNode: _nameFocus,
                                nextFocus: _emailFocus,
                                inputType: TextInputType.name,
                                capitalization: TextCapitalization.words,
                              ),
                              const SizedBox(height: Dimensions.paddingSizeLarge),

                              // Mobile Number
                              Text(
                                getTranslated('mobile_number', context),
                                style: poppinsRegular.copyWith(color: Theme.of(context).hintColor.withOpacity(0.6)),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeSmall),

                              Row(children: [
                                CountryCodePickerWidget(
                                  onChanged: (CountryCode value) {
                                    countryCode = value.dialCode;
                                  },
                                  initialSelection: countryCode,
                                  favorite: [countryCode!],
                                  showDropDownButton: true,
                                  padding: EdgeInsets.zero,
                                  showFlagMain: true,
                                  textStyle: TextStyle(color: Theme.of(context).textTheme.displayLarge!.color),
                                ),
                                Expanded(
                                  child: CustomTextFieldWidget(
                                    hintText: getTranslated('number_hint', context),
                                    isShowBorder: true,
                                    controller: _numberController,
                                    focusNode: _numberFocus,
                                    nextFocus: config.referEarnStatus! ? _referTextFocus : _passwordFocus,
                                    inputType: TextInputType.phone,
                                  ),
                                ),
                              ]),
                              const SizedBox(height: Dimensions.paddingSizeLarge),

                              // Email Section
                              Text(
                                getTranslated('email', context),
                                style: poppinsRegular.copyWith(color: Theme.of(context).hintColor.withOpacity(0.6)),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeSmall),

                              CustomTextFieldWidget(
                                hintText: getTranslated('demo_gmail', context),
                                isShowBorder: true,
                                controller: _emailController,
                                focusNode: _emailFocus,
                                nextFocus: config.referEarnStatus! ? _referTextFocus : _passwordFocus,
                                inputType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: Dimensions.paddingSizeLarge),

                              // Refer Code
                              if (config.referEarnStatus!)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomDirectionalityWidget(
                                      child: Text(
                                        '${getTranslated('refer_code', context)} (${getTranslated('optional', context)})',
                                        style: poppinsRegular.copyWith(color: Theme.of(context).hintColor.withOpacity(0.6)),
                                      ),
                                    ),
                                    const SizedBox(height: Dimensions.paddingSizeSmall),

                                    CustomTextFieldWidget(
                                      hintText: '',
                                      isShowBorder: true,
                                      controller: _referTextController,
                                      focusNode: _referTextFocus,
                                      nextFocus: _passwordFocus,
                                      inputType: TextInputType.text,
                                    ),
                                    const SizedBox(height: Dimensions.paddingSizeLarge),
                                  ],
                                ),

                              // Password Section
                              Text(
                                getTranslated('password', context),
                                style: poppinsRegular.copyWith(color: Theme.of(context).hintColor.withOpacity(0.6)),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeSmall),

                              CustomTextFieldWidget(
                                hintText: getTranslated('password_hint', context),
                                isShowBorder: true,
                                isPassword: true,
                                controller: _passwordController,
                                focusNode: _passwordFocus,
                                nextFocus: _confirmPasswordFocus,
                                isShowSuffixIcon: true,
                              ),
                              const SizedBox(height: 22),

                              // Confirm Password Section
                              Text(
                                getTranslated('confirm_password', context),
                                style: poppinsRegular.copyWith(color: Theme.of(context).hintColor.withOpacity(0.6)),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeSmall),

                              CustomTextFieldWidget(
                                hintText: getTranslated('password_hint', context),
                                isShowBorder: true,
                                isPassword: true,
                                controller: _confirmPasswordController,
                                focusNode: _confirmPasswordFocus,
                                isShowSuffixIcon: true,
                                inputAction: TextInputAction.done,
                              ),
                              const SizedBox(height: 22),

                              // Error Message Display
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  authProvider.registrationErrorMessage!.isNotEmpty
                                      ? CircleAvatar(backgroundColor: Theme.of(context).primaryColor, radius: 5)
                                      : const SizedBox.shrink(),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      authProvider.registrationErrorMessage ?? "",
                                      style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Sign Up Button
                              CustomButtonWidget(
                                isLoading: authProvider.isLoading,
                                buttonText: getTranslated('signup', context),
                                onPressed: () => _onSignUpPress(config),
                              ),
                              const SizedBox(height: 11),

                              // Already Have Account Section
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pushReplacementNamed(RouteHelper.login, arguments: const LoginScreen());
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        getTranslated('already_have_account', context),
                                        style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor.withOpacity(0.6)),
                                      ),
                                      const SizedBox(width: Dimensions.paddingSizeSmall),
                                      Text(
                                        getTranslated('login', context),
                                        style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ResponsiveHelper.isDesktop(context) ? const SizedBox(height: 50) : const SizedBox(),
                      ],
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

  void _onSignUpPress(ConfigModel config) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);

    String fullName = _nameController.text.trim();
    String firstName = fullName.split(' ').first;
    String lastName = fullName.contains(' ') ? fullName.split(' ').last : '';

    String number = _numberController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (firstName.isEmpty) {
      showCustomSnackBarHelper(getTranslated('enter_first_name', context));
    } else if (number.isEmpty) {
      showCustomSnackBarHelper(getTranslated('enter_phone_number', context));
    } else if (password.isEmpty) {
      showCustomSnackBarHelper(getTranslated('enter_password', context));
    } else if (password.length < 6) {
      showCustomSnackBarHelper(getTranslated('password_should_be', context));
    } else if (confirmPassword.isEmpty) {
      showCustomSnackBarHelper(getTranslated('enter_confirm_password', context));
    } else if (password != confirmPassword) {
      showCustomSnackBarHelper(getTranslated('password_did_not_match', context));
    } else if (email.isEmpty) {
      showCustomSnackBarHelper(getTranslated('enter_email_address', context));
    } else if (EmailCheckerHelper.isNotValid(email)) {
      showCustomSnackBarHelper(getTranslated('enter_valid_email', context));
    } else {
      SignUpModel signUpModel = SignUpModel(
        fName: firstName,
        lName: lastName.isNotEmpty ? lastName : null,
        email: email,
        password: password,
        phone: '$countryCode$number',
        referralCode: _referTextController.text.trim(),
      );

      authProvider.registration(signUpModel, config).then((status) async {
        if (status.isSuccess) {
          Navigator.pushNamedAndRemoveUntil(context, RouteHelper.menu, (route) => false);
        } else if (authProvider.isCheckedPhone && (config.phoneVerification! || config.emailVerification!)) {
          Navigator.of(context).pushNamed(RouteHelper.getVerifyRoute('sign-up', '${config.phoneVerification! ? signUpModel.phone : signUpModel.email}'));
        }
      });
    }
  }
}

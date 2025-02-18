import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mentorkhoj/helper/responsive_helper.dart';
import 'package:mentorkhoj/common/providers/theme_provider.dart';
import 'package:mentorkhoj/utill/dimensions.dart';
import 'package:mentorkhoj/utill/styles.dart';
import 'package:provider/provider.dart';

class CustomTextFieldWidget extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final Color? fillColor;
  final int maxLines;
  final bool isPassword;
  final bool isCountryPicker;
  final bool isShowBorder;
  final bool isIcon;
  final bool isShowSuffixIcon;
  final bool isShowPrefixIcon;
  final Function? onTap;
  final Function? onSuffixTap;
  final IconData? suffixIconUrl;
  final String? suffixAssetUrl;
  final IconData? prefixIconUrl;
  final String? prefixAssetUrl;
  final bool isSearch;
  final Function? onSubmit;
  final bool isEnabled;
  final TextCapitalization capitalization;
  final bool isElevation;
  final bool isPadding;
  final Function? onChanged;
  final String? Function(String? )? onValidate;
  final Color? imageColor;

  //final LanguageProvider languageProvider;

  const CustomTextFieldWidget({Key? key, this.hintText = 'Write something...',
        this.controller,
        this.focusNode,
        this.nextFocus,
        this.isEnabled = true,
        this.inputType = TextInputType.text,
        this.inputAction = TextInputAction.next,
        this.maxLines = 1,
        this.onSuffixTap,
        this.fillColor,
        this.onSubmit,
        this.capitalization = TextCapitalization.none,
        this.isCountryPicker = false,
        this.isShowBorder = false,
        this.isShowSuffixIcon = false,
        this.isShowPrefixIcon = false,
        this.onTap,
        this.isIcon = false,
        this.isPassword = false,
        this.suffixIconUrl,
        this.prefixIconUrl,
        this.isSearch = false,
        this.isElevation = true,
        this.onChanged,
        this.isPadding=true, this.suffixAssetUrl, this.prefixAssetUrl,
        this.onValidate,
        this.imageColor,

      }) : super(key: key);

  @override
  State<CustomTextFieldWidget> createState() => _CustomTextFieldWidgetState();
}

class _CustomTextFieldWidgetState extends State<CustomTextFieldWidget> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ResponsiveHelper.isDesktop(context)? 20 : 12),
        boxShadow: [
          BoxShadow(
              color: widget.isElevation ? Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 200]! : Colors.transparent,
              spreadRadius: 0.5,
              blurRadius: 0.5,
            // changes position of shadow
              ),
        ],
      ),
      child: TextFormField(
        maxLines: widget.maxLines,
        controller: widget.controller,
        focusNode: widget.focusNode,
        style:
            Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeLarge),
        textInputAction: widget.inputAction,
        keyboardType: widget.inputType,
        cursorColor: Theme.of(context).primaryColor,
        textCapitalization: widget.capitalization,
        enabled: widget.isEnabled,
        autofocus: false,
        //onChanged: widget.isSearch ? widget.languageProvider.searchLanguage : null,
        obscureText: widget.isPassword ? _obscureText : false,
        inputFormatters: widget.inputType == TextInputType.phone ? <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp('[0-9+]'))] : null,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: widget.isPadding ? 22:0),
          enabledBorder: !widget.isShowBorder ? InputBorder.none : OutlineInputBorder(
            borderRadius: ResponsiveHelper.isDesktop(context) ? BorderRadius.circular(5.0) : BorderRadius.circular(7.0),
            borderSide: BorderSide(width: 1 , color: Theme.of(context).hintColor.withOpacity(0.3)),
          ),
          focusedBorder: !widget.isShowBorder ? InputBorder.none : OutlineInputBorder(
            borderRadius: ResponsiveHelper.isDesktop(context) ? BorderRadius.circular(5.0) : BorderRadius.circular(7.0),
            borderSide: BorderSide(width: 1 ,color: Theme.of(context).primaryColor.withOpacity(0.6)),
          ),
          border: !widget.isShowBorder ? InputBorder.none : OutlineInputBorder(
            borderRadius: ResponsiveHelper.isDesktop(context) ? BorderRadius.circular(5.0) : BorderRadius.circular(7.0),

            borderSide: BorderSide( width: 1 , color: Theme.of(context).hintColor.withOpacity(0.6)),
          ),
          isDense: true,
          hintText: widget.hintText,
          fillColor: widget.fillColor ?? Theme.of(context).cardColor,
          hintStyle: poppinsLight.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).hintColor.withOpacity(0.6)),
          filled: true,
          prefixIcon: widget.isShowPrefixIcon
              ? IconButton(
                  padding: const EdgeInsets.all(0),
                  icon: widget.prefixAssetUrl != null ? Image.asset(widget.prefixAssetUrl!, color: Theme.of(context).primaryColor) : Icon(
                    widget.prefixIconUrl,
                    color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6),
                  ),
                  onPressed: () {},
                )
              : const SizedBox.shrink(),
          prefixIconConstraints: const BoxConstraints(minWidth: 23, maxHeight: 20),
          suffixIcon: widget.isShowSuffixIcon
              ? widget.isPassword
                  ? IconButton(
                      icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: Theme.of(context).hintColor.withOpacity(0.3)),
                      onPressed: _toggle)
                  : widget.isIcon
                      ? IconButton(
                          onPressed: widget.onSuffixTap as void Function()?,
                          icon: ResponsiveHelper.isDesktop(context)? Image.asset(
                            widget.suffixAssetUrl!,
                            width: 20,
                            height: 20,
                            color: widget.imageColor ?? Theme.of(context).textTheme.bodyLarge!.color,
                          ) : Icon(widget.suffixIconUrl, color: Theme.of(context).hintColor.withOpacity(0.6)),
                        )
                      : null
              : null,
        ),
        onTap: widget.onTap as void Function()?,
        onChanged: widget.onChanged as void Function(String)?,
        onFieldSubmitted: (text) => widget.nextFocus != null ? FocusScope.of(context).requestFocus(widget.nextFocus)
            : widget.onSubmit != null ? widget.onSubmit!(text) : null,
        validator: widget.onValidate,

      ),
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}

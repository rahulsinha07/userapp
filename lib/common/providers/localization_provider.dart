import 'package:flutter/material.dart';
import 'package:mentorkhoj/data/datasource/remote/dio/dio_client.dart';
import 'package:mentorkhoj/common/reposotories/language_repo.dart';
import 'package:mentorkhoj/main.dart';
import 'package:mentorkhoj/utill/app_constants.dart';
import 'package:mentorkhoj/features/home/screens/home_screens.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationProvider extends ChangeNotifier {
 final DioClient? dioClient;
 final LanguageRepo? languageRepo;
  final SharedPreferences? sharedPreferences;

  LocalizationProvider({required this.dioClient, required this.sharedPreferences, required this.languageRepo}) {
    _loadCurrentLanguage();
  }

  int? _languageIndex;
  Locale _locale = Locale(AppConstants.languages[0].languageCode!, AppConstants.languages[0].countryCode);
  bool _isLtr = true;

  Locale get locale => _locale;
  bool get isLtr => _isLtr;
  int? get languageIndex => _languageIndex;

  void _loadCurrentLanguage() async {
    _locale = Locale(sharedPreferences!.getString(AppConstants.languageCode) ?? AppConstants.languages[0].languageCode!,
        sharedPreferences!.getString(AppConstants.countryCode) ?? AppConstants.languages[0].countryCode);
    _isLtr = _locale.languageCode != 'ar';
    notifyListeners();
  }

  void _saveLanguage(Locale locale) async {
    sharedPreferences!.setString(AppConstants.languageCode, locale.languageCode);
    sharedPreferences!.setString(AppConstants.countryCode, locale.countryCode!);
  }


  Future<void> setLanguage(Locale locale) async {
    _locale = locale;
    if(_locale.languageCode == 'ar') {
      _isLtr = false;
    }else {
      _isLtr = true;
    }
    for (var language in AppConstants.languages) {
      if(language.languageCode == _locale.languageCode) {
        _languageIndex = AppConstants.languages.indexOf(language);
      }
    }
    await dioClient!.updateHeader(getToken: sharedPreferences?.getString(AppConstants.token)).then((value){

      HomeScreen.loadData(true, Get.context!, fromLanguage: true);
    });
    notifyListeners();

    _saveLanguage(_locale);
    notifyListeners();
  }

  Future<void> changeLanguage()async {
    await languageRepo?.changeLanguageApi(languageCode: _locale.languageCode);
  }
}
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions{
  static String sharedPreferenceUserLoggedInKey='ISLOGGEDIN';
  static String sharedPreferenceUserNameKey="USERNAMEKEY";
  static String sharedPreferenceUserEmailKey = "USEREMAILKEY";


  // saving data to shared preference

  static Future<bool> saveUserLoggedInSharedPreference(bool isUserLoggedIn) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSharedPreference(String UserName) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserNameKey, UserName);
  }

  static Future<bool> saveUserEmailSharedPreference(String userEmail) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserEmailKey, userEmail);
  }

  // getting data from shared preference

  static Future<bool> getUserLoggedInSharedPreference() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sharedPreferenceUserLoggedInKey);
  }

  static Future<String> getUserNameSharedPreference() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserNameKey);
  }

  static Future<String> getUserEmailSharedPreference() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserEmailKey);
  }

}
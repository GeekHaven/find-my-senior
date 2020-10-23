import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  static String sharedPreferencesUIDKey = "USERuid";
  static String sharedPreferencesNameKey = "USERname";
  static String sharedPreferencesBranchKey = "USERbranch";
  static String sharedPreferencesBatchKey = "USERbatch";
  static String sharedPreferencesEmailKey = "USERemail";
  static String sharedPreferencesPhotoKey = "USERphoto";
  static Future<void> saveUserUid(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferencesUIDKey, uid);
  }

  static Future<String> getUserUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferencesUIDKey);
  }

  static Future<void> saveUserName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferencesNameKey, name);
  }

  static Future<String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferencesNameKey);
  }

  static Future<void> saveUserBranch(String branch) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferencesBranchKey, branch);
  }

  static Future<String> getUserBranch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferencesBranchKey);
  }

  static Future<void> saveUserBatch(int batch) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setInt(sharedPreferencesBatchKey, batch);
  }

  static Future<int> getUserBatch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(sharedPreferencesBatchKey);
  }

  static Future<void> saveUserEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferencesEmailKey, email);
  }

  static Future<String> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferencesEmailKey);
  }

  static Future<void> saveUserPhoto(String photoUrl) async{
        SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferencesPhotoKey, photoUrl);
  }

  static Future<String> getUserPhoto() async{
        SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferencesPhotoKey);
  }
}

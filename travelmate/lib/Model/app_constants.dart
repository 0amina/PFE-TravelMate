import 'package:travelmate/Model/user_model.dart';

const String apiKey = "AIzaSyD6hugMPtSL58RAyfrb36zdqFvCbQAbF2k";

class AppConstants {
  static UserModel currentUser = UserModel();
  UserModel createFromUserModel() {
    return UserModel(
      id: currentUser.id,
      name: currentUser.name,
      photo: currentUser.photo,
    );
  }
}

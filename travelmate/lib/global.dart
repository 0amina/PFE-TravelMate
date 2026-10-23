import 'package:travelmate/Model/app_constants.dart';
import 'package:travelmate/Model/property_model.dart';
import 'package:travelmate/Model/reservation_model.dart';
import 'package:travelmate/Model/review_model.dart';
import 'package:travelmate/ViewModel/Auth/login_view_model.dart';
import 'package:travelmate/ViewModel/Auth/signup_view_model.dart';
import 'package:travelmate/ViewModel/Auth/ForgotPwd_view_model.dart';
import 'package:travelmate/ViewModel/Auth/user_view_model.dart';
import 'package:travelmate/ViewModel/property_view_model.dart';
import 'package:travelmate/ViewModel/reservation_view_model.dart';
import 'package:travelmate/ViewModel/review_view_model.dart';

SignUpViewModel signUpViewModel = SignUpViewModel();
loginViewModel LoginViewModel = loginViewModel();
ForgotPwdViewModel forgotPwdViewModel = ForgotPwdViewModel();

UserViewModel userViewModel = UserViewModel(AppConstants.currentUser);
// Reservation-related models and view models
ReservationModel reservationModel = ReservationModel();
ReservationViewModel reservationViewModel =ReservationViewModel(reservationModel);

// Property-related models and view models
PropertyModel propertyModel = PropertyModel();
PropertyViewModel propertyViewModel = PropertyViewModel(propertyModel);

// Review-related models and view models
ReviewModel reviewModel = ReviewModel();
ReviewViewModel reviewViewModel = ReviewViewModel(reviewModel);

String paymentResult = "";
double? bookingPrice = 0.0;

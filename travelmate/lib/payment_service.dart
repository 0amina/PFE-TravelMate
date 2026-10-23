import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentService {
  static const String mockPaymentUrl = 'https://run.mocky.io/v3/486287e2-f816-4ebe-ab99-a3188326d168';
  static const String mockRefundUrl = 'https://run.mocky.io/v3/502dd4f1-a340-4d14-8058-6570e68db59b';

  static Future<bool> simulatePayment(String cardNumber, String expiryDate, String cvv, double amount) async {
    final response = await http.post(
      Uri.parse(mockPaymentUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'cardNumber': cardNumber,
        'expiryDate': expiryDate,
        'cvv': cvv,
        'amount': amount.toString(),
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> simulateRefund(String paymentIntentId, double amount) async {
    final response = await http.post(
      Uri.parse(mockRefundUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'paymentIntentId': paymentIntentId,
        'amount': amount.toString(),
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}

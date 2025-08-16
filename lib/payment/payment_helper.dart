import 'dart:convert';
// import 'package:bkash/bkash.dart';
import 'package:bmsk_userapp/Toast.dart';
import 'package:bmsk_userapp/util/baseURL.dart';
import 'package:bmsk_userapp/payment/PaymentProvider.dart';
import 'package:bmsk_userapp/providers/AuthProvider.dart';
import 'package:flutter_sslcommerz/model/SSLCCustomerInfoInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
// import 'package:get/get.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:shurjopay/models/config.dart';
// import 'package:shurjopay/models/payment_verification_model.dart';
// import 'package:shurjopay/models/shurjopay_request_model.dart';
// import 'package:shurjopay/models/shurjopay_response_model.dart';
// import 'package:shurjopay/shurjopay.dart';
// import 'package:uddoktapay/models/customer_model.dart';
// import 'package:uddoktapay/models/request_response.dart';
// import 'package:uddoktapay/uddoktapay.dart';

void onButtonTap(String selected,context) async {
  final customerPhone = Provider.of<AuthProvider>(context).phoneNumber;
  final customerName = Provider.of<AuthProvider>(context).phoneNumber;
int payAmount = Provider.of<PaymentProvider>(context).paymentAmount;
  String balanceType = Provider.of<PaymentProvider>(context).paymentType;

  final customerData = {
    'phoneNumber': customerPhone,
    'customerName': customerName,
    'amount': payAmount,
    'balanceType': balanceType,
  };
  switch (selected) {
    case 'bkash':
      //bkashPayment(context,customerData);
      break;

    case 'uddoktapay':
      //uddoktapay(context,customerData);
      break;

    case 'sslcommerz':
      sslcommerz(context,customerData);
      break;

    case 'shurjopay':
      //shurjoPay(context,customerData);
      break;

    case 'razorpay':
      //razorPay(context,customerData);
      break;

    default:
      print('No gateway selected');
  }
}


/// bKash
/*bkashPayment() async {
  final bkash = Bkash(
    logResponse: true,
  );

  try {
    final response = await bkash.pay(
      context: Get.context!,
      amount: totalPrice,
      merchantInvoiceNumber: 'Test0123456',
    );

    print(response.trxId);
    print(response.paymentId);
  } on BkashFailure catch (e) {
    print(e.message);
  }
}*/

/// UddoktaPay
/*void uddoktapay() async {
  final response = await UddoktaPay.createPayment(
    context: Get.context!,
    customer: CustomerDetails(
      fullName: 'Md Shirajul Islam',
      email: 'ytshirajul@icould.com',
    ),
    amount: totalPrice.toString(),
  );

  if (response.status == ResponseStatus.completed) {
    print('Payment completed, Trx ID: ${response.transactionId}');
    print(response.senderNumber);
  }

  if (response.status == ResponseStatus.canceled) {
    print('Payment canceled');
  }

  if (response.status == ResponseStatus.pending) {
    print('Payment pending');
  }
}*/

/// SslCommerz
void sslcommerz(context,customerData) async {
  Sslcommerz sslcommerz = Sslcommerz(
    initializer: SSLCommerzInitialization(
      multi_card_name: "visa,master,bkash",
      currency: SSLCurrencyType.BDT,
      product_category: "Digital Product",
      sdkType: SSLCSdkType.TESTBOX,
      store_id: dotenv.env['STORE_ID'],
      store_passwd: dotenv.env['STORE_PASSWORD'],
      total_amount: customerData.amount.toDouble(),
      tran_id: "TestTRX001",
    ),
  );
  sslcommerz.addCustomerInfoInitializer(
    customerInfoInitializer: SSLCCustomerInfoInitializer(
        customerState: "",
        customerName: customerData.customerName,
        customerEmail: "",
        customerAddress1: "",
        customerCity: "",
        customerPostCode: "",
        customerCountry: "Bangladesh",
        customerPhone: customerData.customerPhone
    )
  );
  final payResponse = await sslcommerz.payNow();

  if (payResponse.status == 'VALID') {
    print(jsonEncode(payResponse));
final res = await http.post(Uri.parse('${ApiConstants.baseUrl}/add-balance'),headers: {'Content-Type': 'application/json'},body:jsonEncode({'phone':customerData.customerPhone,'amount':payResponse.amount,'balanceType':customerData.balanceType,'trxId':payResponse.tranId}));
    if(res.statusCode==201 || res.statusCode==200){
      Toast({'message':'Payment completed, TRX ID: ${payResponse.tranId}','success':false},context);
    }
    print(payResponse.tranDate);
  }

  if (payResponse.status == 'Closed') {
    Toast({'success':false,'message':'Payment closed'},context);
  }

  if (payResponse.status == 'FAILED') {
    Toast({'success':false,'message':'Payment failed'},context);
  }
}

/*void shurjoPay() async {
  final shurjoPay = ShurjoPay();

  final paymentResponse = await shurjoPay.makePayment(
    context: Get.context!,
    shurjopayRequestModel: ShurjopayRequestModel(
      configs: ShurjopayConfigs(
        prefix: 'NOK',
        userName: 'sp_sandbox',
        password: 'pyyk97hu&6u6',
        clientIP: '127.0.0.1',
      ),
      currency: 'BDT',
      amount: totalPrice,
      orderID: 'test00255588',
      customerName: 'Md Shirajul Islam',
      customerPhoneNumber: '+8801700000000',
      customerAddress: 'Dhaka, Bangladesh',
      customerCity: 'Dhaka',
      customerPostcode: '1000',
      returnURL: 'url',
      cancelURL: 'url',
    ),
  );

  if (paymentResponse.status == true) {
    try {
      final verifyResponse = await shurjoPay.verifyPayment(
          orderID: paymentResponse.shurjopayOrderID!);

      if (verifyResponse.spCode == '1000') {
        print(verifyResponse.bankTrxId);
      } else {
        print(verifyResponse.spMessage);
      }

      // if (verifyResponse.bankTrxId == null || verifyResponse.bankTrxId!.isEmpty || verifyResponse.bankTrxId == '') {
      //
      //   print('Something is wrong with your payment');
      //
      // }
      // else {
      //
      //   print(verifyResponse.bankTrxId);
      //   print(verifyResponse.message);
      //
      // }
    } catch (e) {
      print(e);
    }
  }
}*/

/*void razorPay() async {
  final razorPay = Razorpay();

  var options = {
    'key': 'rzp_test_HJG5Rtuy8Xh2NB',
    'amount': totalPrice,
    'name': 'Acme Corp.',
    'description': 'Fine T-Shirt',
    'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'}
  };

  try {
    razorPay.open(options);

    razorPay.on(
      Razorpay.EVENT_PAYMENT_SUCCESS,
      (PaymentSuccessResponse response) {
        print('Payment success');
        print(response.paymentId);
      },
    );

    razorPay.on(
      Razorpay.EVENT_PAYMENT_ERROR,
          (PaymentFailureResponse response) {
        print('Payment failed');
        print(response.message);
      },
    );

  } catch (e) {
    print('Error ${e.toString()}');
  }
}*/

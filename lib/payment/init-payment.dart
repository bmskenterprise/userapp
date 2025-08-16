import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


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

    case 'sslcommerz':
      /*initiateSSLCPayment(customerData,context);*/final url = Uri.parse(ApiConstants.paymentInit);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(/*{
        'amount': customerData.amount,
        'customerName': customerData.customerName,
        // 'email': 'john@example.com',
        'phone': customerData.username,
      }*/customerData),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final gatewayUrl = responseData['url'];Navigator.push(context, MaterialPageRoute(builder: (context)=>WebView(url:gatewayUrl)));

      /*if (await canLaunchUrl(Uri.parse(gatewayUrl))) {
        await launchUrl(Uri.parse(gatewayUrl), mode: LaunchMode.externalApplication);
      } else {
        Toast({'message':'Could not launch $gatewayUrl','success':false},context);
      }*/
    } else {
      Toast({'message':'Payment initiation failed','success':false});
    }
      break;
}

}

  /*Future<void> initiateSSLCPayment(customerData,context) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/api/initiate-payment');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'amount': customerData.amount,
        'customerName': customerData.customerName,
        // 'email': 'john@example.com',
        'phone': customerData.username,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final gatewayUrl = responseData['url'];

      if (await canLaunchUrl(Uri.parse(gatewayUrl))) {
        await launchUrl(Uri.parse(gatewayUrl), mode: LaunchMode.externalApplication);
      } else {
        Toast({'message':'Could not launch $gatewayUrl','success':false},context);
      }
    } else {
      Toast({'message':'Payment initiation failed','success':false},context);
    }
  }*/

  
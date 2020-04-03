import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Razorpay Flutter',

      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int totalAmount = 0;

  Razorpay _razorpay;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,_handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,_handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,_handleExternalWallet);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async{
    var options = {
      'key' : 'rzp_test_UpVdqRyHZqXuA9',
      'amount' : totalAmount*100,
      'name' : 'CachyCourier',
      'description' : 'Test Payment',
      'prefill' : {'contact' : '','email':''},
      'external':{
        'wallets': ['paytm']
      }
    };

    try{

      _razorpay.open(options);
    }
    catch(e){
      debugPrint(e);
    }
  }


  void _handlePaymentSuccess(PaymentSuccessResponse response){
    Fluttertoast.showToast(msg: "SUCCESS" + response.paymentId);
  }

    void _handlePaymentError(PaymentFailureResponse response){
    Fluttertoast.showToast(msg: "ERROR" + response.code.toString()+'-'+response.message);
  }
    void _handleExternalWallet(ExternalWalletResponse response){
    Fluttertoast.showToast(msg: "EXTERNAL WALLET" + response.walletName);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('In app payments in flutter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
           LimitedBox(
             maxWidth:150.0,
             child : TextField(
               keyboardType : TextInputType.number,
               decoration: InputDecoration(
                 hintText: 'Please Enter Some Amount',
               ),

               onChanged: (value){
                 setState(() {
                   totalAmount = num.parse(value);
                 });
               },
             )
           ),

           SizedBox(
             height:15.0,
           ),
           RaisedButton(
             child:Text('Make Payment'),
             onPressed: (){

               openCheckout();
             },
           )
          ],
        ),
      ),
       
    );
  }
}

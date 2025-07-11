import 'package:flutter/material.dart';
import '../widgets/paymentwidget.dart';
import 'summary_screen .dart';
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _CartpaymentScreenState();
}

class _CartpaymentScreenState extends State<PaymentScreen> {
  String selectedPayment = "Credit/Debit";  // default selection

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,size: 20,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Payment Method",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Payment Method",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "choose your preferred payment option",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: 15),

            // Credit/Debit
            PaymentWidget(
              ic1: Icon(Icons.credit_card),
              t1: "Credit/Debit",
              t2: "visa, Mastercard etc.",
              selected: selectedPayment == "Credit/Debit",
              onTap: () {
                setState(() {
                  selectedPayment = "Credit/Debit";
                });
              },
            ),

            SizedBox(height: 14),

            // Paystack
            PaymentWidget(
              ic1: Icon(Icons.sort),
              t1: "Paystack",
              t2: "Fast and secure",
              selected: selectedPayment == "Paystack",
              onTap: () {
                setState(() {
                  selectedPayment = "Paystack";
                });
              },
            ),

            SizedBox(height: 14),

            // Cash on Delivery
            PaymentWidget(
              ic1: Icon(Icons.money_rounded),
              t1: "Cash on Delivery",
              t2: "Pay when you receive",
              selected: selectedPayment == "Cash on Delivery",
              onTap: () {
                setState(() {
                  selectedPayment = "Cash on Delivery";
                });
              },
            ),
            SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.only(left: 2.0,right: 3),
              child: Row(
                children: [
                  Icon(Icons.security),
                  SizedBox(width: 5,),
                  Text("All transactions are secure and encrypted",style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,

                  ),)
                ],
              ),
            ),
            SizedBox(height: 15,),
            Row(
              children: [
                SizedBox(
                    width: 35,
                    height: 35,
                    child: Image.asset("assets/images/41.png")),
                SizedBox(width: 10,),
                SizedBox(
                    width: 35,
                    height: 35,
                    child: Image.asset("assets/images/42.png")),
                SizedBox(width: 10,),
                SizedBox(
                    width: 35,
                    height: 35,
                    child: Image.asset("assets/images/43.png")),
                SizedBox(width: 10,),
                SizedBox(
                    width: 35,
                    height: 35,
                    child: Image.asset("assets/images/44.png")),


              ],
            ),
            SizedBox(height: 10,),
            Text("Total Amount "),
            Text("\$137",style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),),
            SizedBox(height: 20,),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> SummaryScreen()));
              },
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.orange,
                ),
                child: Center(
                  child: Text("Continue",style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),),
                ),
              ),
            )

            // ... rest of your UI unchanged ...
          ],
        ),
      ),
    );
  }
}

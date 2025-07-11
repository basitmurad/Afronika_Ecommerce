import 'package:afronika/features/dashborad/home/screen/sucess_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/cartamount_widget.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white70,
        title: Text("Order summary"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,size: 20,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only( left: 16,top: 12,right: 16),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(" Your Order",style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),),
            SizedBox(height:12,),
            SizedBox(
              height: 120,
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image
                  SizedBox(
                    height: 120,
                    width: 100,
                    child: Image.asset("assets/images/40.png"),
                  ),
        
                  // Space between image and text
                  SizedBox(width: 10),
        
                  // Text Column - wrapped in Expanded
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Sony WH-CH520 wireless Headphones with microphone - Black",
                              style: TextStyle(fontSize: 13,
                                  fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                SizedBox(width: 10,),
                                Text("Qty:1"),
                                SizedBox(width: 90,),
                                Text("\$132",style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                                ),),
                                SizedBox(width: 10,),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height:12,),
            SizedBox(
              height: 120,
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 120,
                    width: 100,
                    child: Image.asset("assets/images/21.png"),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Sony WH-CH520 wireless Headphones with microphone - Black",
                              style: TextStyle(fontSize: 13,
                                  fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                SizedBox(width: 10,),
                                Text("Qty:1"),
                                SizedBox(width: 90,),
                                Text("\$132",style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                ),),
                                SizedBox(width: 10,),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Delivery To",style: TextStyle(
                  fontSize: 16,
                ),),
                Text("Change",style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
        
                ),)
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 10,),
                Icon(Icons.location_on_outlined,size: 30,),
                SizedBox(width: 20,),
                Text("123 Main Street, Apt 4B \n New York, NY 10001",style: TextStyle(
                  color: Colors.black,
                ),),
              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Payment",style: TextStyle(
                  fontSize: 18,
                ),),
                Text("Change",style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
        
                ),)
              ],
            ),
            SizedBox(height: 30,),
            Row(
              children: [
                SizedBox(width: 20,),
               Image.asset("assets/images/41.png"),
                SizedBox(width: 20,),
                Text("  ...  ...   ...   2343",style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),),
              ],
            ),
            SizedBox(height: 30,),
            cart_amounts(txt: 'Subtotal:', amount: '\$132',),
            cart_amounts(txt: 'Shipping:', amount: '\$5',),
           SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 10,right: 10,top: 2 ,bottom: 0.0),
              child: Divider(
                color: Colors.grey,
                height: 4,
                thickness: 2,
              ),
            ),
            cart_amounts(txt: "Total:", amount: "\$137",),
            SizedBox(height: 20,),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SucessScreen()));
              },
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.orange,
                ),
                child: Center(
                  child: const Text("Place Order",style: TextStyle(
                      color: Colors.white
                  ),),
                ),
                ),
            ),
            SizedBox(height: 60,),
        
        
          ],
              ),
        ),
      ),
    );
  }
}

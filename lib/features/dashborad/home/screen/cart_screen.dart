import 'dart:ffi';
import 'package:flutter/material.dart';
import '../widgets/bottomnav_bar.dart';
import '../widgets/cartamount_widget.dart';
import '../widgets/cartbox_widget.dart';
import 'payment_screen.dart';

class CartScreen extends StatelessWidget {

  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> imagePaths = [
      'assets/images/24.png',
      'assets/images/20.png',
      'assets/images/35.png',
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
            child: Icon(Icons.arrow_back_ios_new)),
        actions: [
          Icon(Icons.search),
          SizedBox(width: 12),
        ],
        title: Text("Cart"),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30),
            cartbox_screen(img: 'assets/images/40.png',),
            SizedBox(height: 10,),
            cartbox_screen(img: 'assets/images/21.png',),
            SizedBox(height: 20,),
            Row(
              children: [
                SizedBox(width: 12,),
               SizedBox(
               height: 60,
                 width: 200,
                 child: TextField(
                      decoration: InputDecoration(
                        hint: Text("Enter Coupton Code "),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(

                          )
                        )
                      ),
                    ),
               ),
                SizedBox(width: 10,),
               Container(
                  height: 60,
                  width: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color:Colors.brown,
                  ),
                  child: TextButton(
                      onPressed: (){}, child:Center(
                    child: Text("Apply",style: TextStyle(
                      color: Colors.white
                    ),),
                  )),
                )
              ],
            ),
            cart_amounts(txt: 'Subtotal:', amount: '\$132',),
            cart_amounts(txt: 'Shipping:', amount: '\$5',),

            Padding(
              padding: const EdgeInsets.only(left: 10,right: 10,top: 2 ,bottom: 0.0),
              child: Divider(
                color: Colors.grey,
                height: 2,
                thickness: 2,
              ),
            ),
            cart_amounts(txt: "Total:", amount: "\$137",),
              SizedBox(height: 10,),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>PaymentScreen()));
                },
                child: Container(
                  height: 50,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.orange
                  ),child: Center(
                    child: Text("Proceed to Checkout",style: TextStyle(
                      color: Colors.white,
                    ),),
                  ),
                ),
              ),
            TextButton(onPressed: (){}, child:Text("Continue Shipping",style: TextStyle(
              color: Colors.black
            ),)),
            SizedBox(height: 10,),
            Align(
              alignment: Alignment.topLeft,
              child: Text("   You May Also Like",style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),),
            ),
            SizedBox(height: 10,),
            SizedBox(
              height: 300,
              child: ListView.builder(
                scrollDirection: Axis.horizontal, // vertical bhi kar sakte ho
                itemCount: imagePaths.length,
                itemBuilder: (context, index) {
                  final item = imagePaths[index]; // current item

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 140,
                      width: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 80,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10),
                              ),
                              child: Image.asset(
                                imagePaths[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Column(
                            children: [
                              Text("Hitaget Super Quality Wax",style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                              ),),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text("\$132.00",style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),),
                                    SizedBox(width: 5),
                                    Text(
                                      "\$156.00",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                        decorationColor: Colors.grey,
                                        decorationThickness: 2,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: 50,
                            width: 140,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.orange,
                            ),
                            child: TextButton(
                              onPressed: () {

                              },
                              child: const Text("Add Cart",style: TextStyle(
                                color: Colors.white
                              ),),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )


          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar (currentIndex: 2,),

    );
  }
}





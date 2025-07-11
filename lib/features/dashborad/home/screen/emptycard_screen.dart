import 'package:afronika/features/dashborad/home/screen/shop_screen.dart';
import 'package:flutter/material.dart';
class EmptycardScreen extends StatelessWidget {
  const EmptycardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            children: [

              Icon(
                Icons.card_travel_rounded,
                size: 80,
                color: Colors.orange,
              ),
              SizedBox(height: 20),

              Text(
                'Your cart is  empty',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              // 📄 2-line Text Below
              Text(
                "Looks like you haven't added anything yet Start   exploring our beautiful African collections",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20,),
              Container(
                width: 300,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(10),
                ),

                  child: TextButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ShopScreen()));
                      },
                      child: Center(
                        child: Text(
                            "Shop Now",style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                      )),
                ),
            ],
          ),
        ),
      ),
    );
  }
}


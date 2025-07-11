import 'package:flutter/material.dart';
class NohistoryScreen extends StatelessWidget {
  const NohistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Order History'),
        centerTitle: true,
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Icons.arrow_back_ios_new,size: 20,weight: 5,)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0,left: 10,right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("All Order"),
                  Text("Processing"),
                  Text("Shipped"),
                  Text("Cancelled"),

                ],
              ),
              SizedBox(height: 40,),
              Padding(
                padding: const EdgeInsets.only(top: 120,left: 10,right: 10),
                child: Column(
                  children: [
                    // Green Circle with Tick
                    Center(
                      child: Icon(
                        Icons.card_travel,
                        color: Colors.orange,
                        size: 90,
                      ),
                    ),

                    SizedBox(height: 40),

                    // Column with 4-5 texts
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text("You have not placed an order", style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          )),
                          SizedBox(height: 10,),
                          Text("Start shopping and your orders will appear here.", style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w200,

                          )),


                        ],
                      ),
                    ),
                    SizedBox(height: 60,),
                    Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.orange,
                      ),
                      child: TextButton(
                        onPressed: () {
                          // action for button (optional)
                        },
                        child: const Text("Start Shopping",style: TextStyle(
                            color: Colors.white
                        ),),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

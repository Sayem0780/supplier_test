import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplier_test/screen/qurte_clan_bill.dart';
import 'package:supplier_test/screen/shop_registration.dart';

import '../provider/cart.dart';

class SplashScreen extends StatefulWidget {
  static const routeName ='/splash';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override

  void didChangeDependencies() {
    final cart = Provider.of<Cart>(context,listen: false);
    cart.readData().whenComplete(() {
      if(cart.shop.isEmpty){
        print('empty');
        Timer(const Duration(seconds: 3), (){
          Navigator.pushReplacementNamed(context,ShopRegister.routeName);
        });
      }else{
        print('not empty');
        Timer(const Duration(seconds: 3), (){
          Navigator.pushReplacementNamed(context,QuteCalanBillPage.routeName);
        });
      }
    });
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height*.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                  image: AssetImage('assests/th.jpg'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(height: 50,),
            const Text("RackUp IT Solution",style: TextStyle(fontSize: 35,fontWeight: FontWeight.w900),),
            const Text("Where Creativty Meets Technology",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400),),
          ],
        ),
      ),
    );
  }
}

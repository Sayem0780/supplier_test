import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supplier_test/model/details.dart';
import 'package:supplier_test/model/report.dart';
import 'package:supplier_test/provider/cart.dart';
import 'package:supplier_test/screen/bill/bill_page.dart';
import 'package:supplier_test/screen/bill/bill_register.dart';
import 'package:supplier_test/screen/bill/bill_report.dart';
import 'package:supplier_test/screen/bill/bprint.dart';
import 'package:supplier_test/screen/calan/calan_page.dart';
import 'package:supplier_test/screen/calan/calan_register.dart';
import 'package:supplier_test/screen/calan/calan_report.dart';
import 'package:supplier_test/screen/calan/cprint.dart';
import 'package:supplier_test/screen/product_entry.dart';
import 'package:supplier_test/screen/quotation/qprint.dart';
import 'package:supplier_test/screen/quotation/quotation_register.dart';
import 'package:supplier_test/screen/quotation/quotation_report.dart';
import 'package:supplier_test/screen/quotation/qutation_page.dart';
import 'package:supplier_test/screen/qurte_clan_bill.dart';
import 'package:supplier_test/screen/shop_registration.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  final appDirectory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDirectory.path);
  Hive.registerAdapter(OrderAdapter());
  Hive.registerAdapter(DetailsAdapter());
  Hive.registerAdapter(CartItemAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> checkIfNameKeyExists() async {
    bool checker = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? nameKeyData = prefs.getString('namekey');
    nameKeyData==null?checker=false:checker=true;
    return checker;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>Cart()),
      ],
      child: FutureBuilder<bool>(
        future: checkIfNameKeyExists(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Or any loading indicator
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }else if(snapshot.data==true){
            print("S "+snapshot.data.toString());
            return MaterialApp(
              title: 'Supplier App',
              theme: ThemeData(
                  primarySwatch: Colors.purple,
                  primaryColor: Colors.purpleAccent,
                  useMaterial3: false
              ),
              debugShowCheckedModeBanner: false,
              home: QuteCalanBillPage(),

              routes: {
                QuotationlReport.routeName:(context)=>QuotationlReport(),
                CalanReport.routeName:(context)=>CalanReport(),
                BillReport.routeName:(context)=>BillReport(),
                ShopRegister.routeName:(context)=>ShopRegister(),
                QuteCalanBillPage.routeName:(context)=> QuteCalanBillPage(),
                QuotationRegister.routeName:(context)=> QuotationRegister(),
                QutationPage.routeName:(context)=>QutationPage(),
                QPrint.routeName:(context)=>QPrint(''),
                BillPage.routeName:(context)=> BillPage(),
                BillRegister.routeName:(context)=>BillRegister(),
                BPrint.routeName:(context)=>BPrint(''),
                CalanPage.routeName:(context)=>CalanPage(),
                CalanRegister.routeName:(context)=>CalanRegister(),
                CPrint.routeName:(context)=>CPrint(''),
                ProductEntry.routeName:(context)=>ProductEntry(),
              },
            );
          } else {
            print("Q "+snapshot.data.toString());
            return MaterialApp(
              title: 'Supplier App',
              theme: ThemeData(
                primarySwatch: Colors.purple,
                primaryColor: Colors.purpleAccent,
                useMaterial3: false
              ),
              debugShowCheckedModeBanner: false,
              home: ShopRegister(),

              routes: {
                QuotationlReport.routeName:(context)=>QuotationlReport(),
                CalanReport.routeName:(context)=>CalanReport(),
                BillReport.routeName:(context)=>BillReport(),
                ShopRegister.routeName:(context)=>ShopRegister(),
                QuteCalanBillPage.routeName:(context)=> QuteCalanBillPage(),
                QuotationRegister.routeName:(context)=> QuotationRegister(),
                QutationPage.routeName:(context)=>QutationPage(),
                QPrint.routeName:(context)=>QPrint(''),
                BillPage.routeName:(context)=> BillPage(),
                BillRegister.routeName:(context)=>BillRegister(),
                BPrint.routeName:(context)=>BPrint(''),
                CalanPage.routeName:(context)=>CalanPage(),
                CalanRegister.routeName:(context)=>CalanRegister(),
                CPrint.routeName:(context)=>CPrint(''),
                ProductEntry.routeName:(context)=>ProductEntry(),
              },
            );
          }
        },
      )
    );
  }
}

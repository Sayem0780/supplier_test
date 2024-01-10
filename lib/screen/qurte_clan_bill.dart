import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplier_test/screen/bill/bill_register.dart';
import 'package:supplier_test/screen/bill/bill_report.dart';
import 'package:supplier_test/screen/calan/calan_report.dart';
import 'package:supplier_test/screen/quotation/quotation_register.dart';
import 'package:supplier_test/screen/quotation/quotation_report.dart';
import '../provider/cart.dart';
import '../widget/round_button.dart';
import 'calan/calan_register.dart';

class QuteCalanBillPage extends StatefulWidget {
  static const routeName = '/qute calan bill page';
  const QuteCalanBillPage({Key? key}) : super(key: key);

  @override
  State<QuteCalanBillPage> createState() => _QuteCalanBillPageState();
}

class _QuteCalanBillPageState extends State<QuteCalanBillPage> {

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    cart.readData();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dash Board'),
        centerTitle: true,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 12.0,
        padding: const EdgeInsets.only(left: 16.0, right: 16, top: 50, bottom: 16),
        children: [
          RoundButton(
            title: 'Quotation',
            onpress: () {
              Navigator.pushNamed(context, QuotationRegister.routeName);
            },
          ),
          RoundButton(
            title: 'Calan',
            onpress: () {
              Navigator.pushNamed(context, CalanRegister.routeName);

            },
          ),
          RoundButton(
            title: 'Bill',
            onpress: () {
              Navigator.pushNamed(context, BillRegister.routeName,);
            },
          ),
          RoundButton(
            title: 'Quotation Report',
            onpress: () {
              Navigator.pushNamed(context, QuotationlReport.routeName);
            },
          ),
          RoundButton(
            title: 'Bill Report',
            onpress: () {
              Navigator.pushNamed(context, BillReport.routeName);
            },
          ),
          RoundButton(
            title: 'Calan Report',
            onpress: () {
              Navigator.pushNamed(context, CalanReport.routeName);
            },
          ),
        ],
      ),
    );
  }
}

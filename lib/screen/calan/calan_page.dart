
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../provider/cart.dart';
import '../../model/details.dart';
import '../../model/report.dart';
import '../product_entry.dart';
import 'cprint.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../widget/countdown.dart';

class CalanPage extends StatefulWidget {
  static const routeName = '/calan entry';
  const CalanPage({Key? key}) : super(key: key);

  @override
  State<CalanPage> createState() => _CalanPageState();
}

class _CalanPageState extends State<CalanPage> {

  bool showsipnner = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    final name = cart.register[0].name;
    final phone = cart.register[0].phone;
    final address = cart.register[0].address;
    final prpo = cart.register[0].prpo;
    final total = cart.totalAmount;
    final quantity = cart.totalItem;
    final qcode =cart.register[0].code;
    return Scaffold(
      appBar: AppBar(
        title: Text("Calan Entry"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              cart.creatProductList(name);
              var box = await Hive.openBox<Order?>('calanbox');
              Details details = Details(date: currentDate, name: name, phone: phone,
                  address: address, Conditions: '', prpo: prpo, code: qcode,quantity: quantity.toString(), total: total.toString());
              var calan = Order(
                details: details,
                itemList: cart.selectedItems.values.toList(),
              );
              await box.add(calan);
              calan.save();
              Future.delayed(Duration(microseconds: 1));
              calan.isInBox?Navigator.pushNamed(context, CPrint.routeName):
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Bill Not Stored'),
                    content: Text('The bill is not stored in the box.'),
                    actions: [
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
              setState(() {
                showsipnner = false;
              });
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: showsipnner
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Scrollable(
                axisDirection: AxisDirection.right,
                controller: ScrollController(),
                viewportBuilder: (BuildContext context, ViewportOffset offset) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        DataTable(
                          columns: [
                            DataColumn(label: Text('No')),
                            DataColumn(label: Text('Name')),
                            DataColumn(label: Text('Quantity')),
                            DataColumn(label: Text('UOM')),
                          ],
                          rows: cart.selectedItems.values.map((item) {
                            int index = cart.selectedItems.values
                                .toList()
                                .indexOf(item);
                            return DataRow(
                              cells: [
                                DataCell(Text((index + 1).toString())),
                                DataCell(Text(item.title)),
                                DataCell(
                                  TextField(
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      int quantity =
                                          int.parse(value.toString());
                                      cart.addItem(
                                        item.id.toString(),
                                        item.title.toString(),
                                        item.uom.toString(),
                                        item.price,
                                        item.stock,
                                        quantity,
                                        item.totalprice,
                                      );
                                    },
                                    decoration: InputDecoration(
                                      hintText: item.quantity.toString(),
                                      contentPadding: EdgeInsets.all(8),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  TextField(
                                    onChanged: (value) {
                                      String uom = value.toString();
                                      cart.addItem(
                                        item.id.toString(),
                                        item.title.toString(),
                                        uom,
                                        item.price,
                                        item.stock,
                                        item.quantity,
                                        item.totalprice,
                                      );
                                    },
                                    decoration: InputDecoration(
                                      hintText: item.uom.toString(),
                                      contentPadding: EdgeInsets.all(8),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  );
                },
              ),
            ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.restorablePushNamed(context, ProductEntry.routeName,arguments: 'calan');
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add,color: Colors.black,),
          backgroundColor: Colors.amber,
        )
    );
  }
}

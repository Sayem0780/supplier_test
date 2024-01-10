import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:supplier_test/screen/product_entry.dart';
import 'package:supplier_test/screen/quotation/qprint.dart';
import '../../../provider/cart.dart';
import '../../model/details.dart';
import '../../model/report.dart';

class QutationPage extends StatefulWidget {
  static const routeName ='/qutation entry';
  const QutationPage({Key? key}) : super(key: key);

  @override
  State<QutationPage> createState() => _QutationPageState();
}

class _QutationPageState extends State<QutationPage> {
  bool showsipnner = false;
  @override
  Widget build(BuildContext context) {

    final cart = Provider.of<Cart>(context);
    String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    final name = cart.register[0].name;
    final phone = cart.register[0].phone;
    final address = cart.register[0].address;
    final prpo = cart.register[0].prpo;
    final condition = cart.register[0].condition;
    final total = cart.totalAmount;
    final qcode =cart.register[0].code;
    final quantity = cart.totalItem;
    return Scaffold(
      appBar: AppBar(
        title: Text("Quotation Entry"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              setState(() {
                showsipnner = true;
              });
              cart.creatProductList(name);
              var box = await Hive.openBox<Order?>('quotationbox');
              Details details = Details(date: currentDate, name: name, phone: phone,
                  address: address, Conditions: condition, prpo: prpo, code: qcode, quantity: quantity.toString(), total: total.toString());
              var quotation = Order(
                details: details,
                itemList: cart.selectedItems.values.toList(),
              );
              await box.add(quotation);
              quotation.save();
              Future.delayed(Duration(microseconds: 1));
              quotation.isInBox?Navigator.pushNamed(context, QPrint.routeName):
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Quotation Not Stored'),
                    content: Text('The quotation is not stored in the box.'),
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
      body: showsipnner?Center(child: CircularProgressIndicator(),):SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Scrollable(
          axisDirection: AxisDirection.right,
          controller: ScrollController(),
          viewportBuilder: (BuildContext context, ViewportOffset offset) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  // argument==null?
                  DataTable(
                    columns: [
                      DataColumn(label: Text('No')),
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Quantity')),
                      DataColumn(label: Text('UOM')),
                      DataColumn(label: Text('Rate')),
                      DataColumn(label: Text('Total')),
                      DataColumn(label: Text('Stock')),
                    ],
                    rows: cart.selectedItems.values
                        .map((item) {
                      int index = cart.selectedItems.values.toList().indexOf(item);
                      return DataRow(
                        cells: [
                          DataCell(Text((index+1).toString())),
                          DataCell(Text(item.title)),
                          DataCell(
                            TextField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                int quantity = int.parse(value.toString());
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
                          DataCell(
                            TextField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                double rate = double.parse(value.toString());
                                cart.addItem(
                                  item.id.toString(),
                                  item.title.toString(),
                                  item.uom.toString(),
                                  rate,
                                  item.stock,
                                  item.quantity,
                                  rate * item.quantity,
                                );
                              },
                              decoration: InputDecoration(
                                hintText: item.price.toString(),
                                contentPadding: EdgeInsets.all(8),
                              ),
                            ),
                          ),
                          DataCell(Text(item.totalprice.toString())),
                          DataCell(
                            TextField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                int stock = int.parse(value.toString());
                                cart.addItem(
                                  item.id.toString(),
                                  item.title.toString(),
                                  item.uom.toString(),
                                  item.price,
                                  stock,
                                  item.quantity,
                                  item.price * item.quantity,
                                );
                              },
                              decoration: InputDecoration(
                                hintText: item.stock.toString(),
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
          Navigator.restorablePushNamed(context, ProductEntry.routeName);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add,color: Colors.black,),
        backgroundColor: Colors.amber,
      )
    );

  }

}

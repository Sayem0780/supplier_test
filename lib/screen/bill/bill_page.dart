import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:supplier_test/model/details.dart';
import 'package:supplier_test/model/report.dart';
import 'package:supplier_test/screen/bill/bprint.dart';
import '../../../provider/cart.dart';
import '../product_entry.dart';


class BillPage extends StatefulWidget {
  static const routeName = '/bill entry';
  const BillPage({Key? key}) : super(key: key);

  @override
  State<BillPage> createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
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
        title: Text("Bill Entry"),
        centerTitle: true,

        actions: [
          IconButton(
            onPressed: () async {
              cart.creatProductList(name);
              var box = await Hive.openBox<Order?>('billbox');
              Details details = Details(date: currentDate, name: name, phone: phone,
                    address: address, Conditions: '', prpo: prpo, code: qcode, quantity: quantity.toString(), total: total.toString());
              var bill = Order(
                  details: details,
                  itemList: cart.selectedItems.values.toList(),
              );
              await box.add(bill);
              bill.save();
              Future.delayed(Duration(microseconds: 1));
              bill.isInBox?Navigator.pushNamed(context, BPrint.routeName)
                  :showDialog(
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
      body: showsipnner?Center(child: CircularProgressIndicator(),):
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Scrollable(
          axisDirection: AxisDirection.right,
          controller: ScrollController(),
          viewportBuilder: (BuildContext context, ViewportOffset offset) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Container(
                          width: 150,
                          child: DataTable(
                            columns: [
                              DataColumn(label: Row(
                                children: [
                                  Text('SL '),
                                  Text(' Name')
                                ],
                              ),),
                            ],
                            rows: cart.selectedItems.values
                                .map((item) {
                              int index = cart.selectedItems.values.toList().indexOf(item) +1 ;
                              return DataRow(
                                cells: [
                                  // DataCell(Text((index+1).toString())),//Serial
                                  DataCell(
                                      Container(
                                    width: 140,
                                    child: Row(
                                      children: [
                                        Text('$index.  '),
                                        Container(
                                          width: 100,
                                            child: Text(item.title))
                                      ],
                                    ),
                                  )),//title
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                        Container(
                          width: 300,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: [
                                DataColumn(label: Text('Quantity')),
                                DataColumn(label: Text('UOM')),
                                DataColumn(label: Text('Rate')),
                                DataColumn(label: Text('Total ')),
                              ],
                              rows: cart.selectedItems.values
                                  .map((item) {
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Text(item.quantity.toString()),
                                    ),//Quantity
                                    DataCell(
                                        Text(item.uom)
                                    ),//UOM
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
                                    ),//Rate
                                    DataCell(Text(item.totalprice.toString())),//Total
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.restorablePushNamed(context, ProductEntry.routeName,arguments: 'bill');
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add,color: Colors.black,),
          backgroundColor: Colors.amber,
        )
    );

  }
}

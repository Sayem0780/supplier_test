import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplier_test/screen/bill/bill_page.dart';
import 'package:supplier_test/screen/calan/calan_page.dart';
import 'package:supplier_test/screen/quotation/qutation_page.dart';

import '../provider/cart.dart';
import '../widget/round_button.dart';

class ProductEntry extends StatefulWidget {
  const ProductEntry({Key? key}) : super(key: key);
  static const routeName ='/product entry';

  @override
  State<ProductEntry> createState() => _ProductEntryState();
}

class _ProductEntryState extends State<ProductEntry> {

  TextEditingController nameController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController uomController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String name="",uom="";
  double price=0,rate =0;
  int quantity =0,stcok=0;
  @override

  void initState() {
    super.initState();
    priceController.text = price.toString();
  }

  void updateTotalAmount() {
    setState(() {
      price = rate*quantity;
      priceController.text = price.toString();
    });
  }
  @override
  Widget build(BuildContext context) {

    final cart = Provider.of<Cart>(context);
    final dynamic argument = ModalRoute.of(context)!.settings.arguments as dynamic;

    return Scaffold(

      appBar: AppBar(
        title: const Text('Registration'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: nameController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: "Enter Product Name",
                            labelText: "Name",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (String value){
                            name = value;
                          },
                          validator: ((value) {
                            return value!.isEmpty?'Enter Product Name':null;
                          }),
                        ),
                        Visibility(
                          visible: argument!='calan',
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: TextFormField(
                              controller: rateController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: "Enter Product Rate",
                                labelText: "Rate",
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (String value){
                                rate = double.parse(value);
                                updateTotalAmount();
                              },
                              validator: ((value) {
                                return value!.isEmpty?'Set Rate':null;
                              }),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: TextFormField(
                            controller: quantityController,
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            decoration: const InputDecoration(
                              hintText: "Product Quantity",
                              labelText: "Quantity",
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (String value){
                              quantity = int.parse(value);
                              argument!='calan'?updateTotalAmount():null;
                            },
                            validator: ((value) {
                              return value!.isEmpty?'Quantity is required':null;
                            }),
                          ),
                        ),
                        Visibility(
                          visible: argument!='calan',
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: TextFormField(
                              enabled: false,
                              controller: priceController,
                              decoration: const InputDecoration(
                                alignLabelWithHint: true,
                                labelText: 'Total Price',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: TextFormField(
                            maxLines: 1,
                            controller: uomController,
                            keyboardType: TextInputType.multiline,
                            decoration: const InputDecoration(
                              hintText: "Set Uom Type",
                              alignLabelWithHint: true,
                              labelText: "Uom",
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (String value){
                              uom = value;
                            },
                            validator: ((value) {
                              return value!.isEmpty?'Set Uom':null;
                            }),
                          ),
                        ),
                        Visibility(
                          visible: argument!='calan'&&argument!='bill',
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: TextFormField(
                              maxLines: 1,
                              controller: stockController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: "Set Stock ",
                                alignLabelWithHint: true,
                                labelText: "Stock",
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (String value){
                                stcok = int.parse(value);
                              },
                              validator: ((value) {
                                return value!.isEmpty?'Set Stock':null;
                              }),
                            ),
                          ),
                        ),
                        RoundButton(title: "Next", onpress: ()async{
                          if(_formKey.currentState!.validate())
                          {
                            cart.addItem(
                              name,
                              name,
                              uom,
                              double.parse(rate.toString()),
                              stcok,
                              int.parse(quantity.toString()),
                             quantity*rate,
                            );
                            argument!='calan'?( argument!='bill'?Navigator.pushNamed(context,QutationPage.routeName):Navigator.pushNamed(context,BillPage.routeName)):Navigator.pushNamed(context,CalanPage.routeName);
                          }
                        })
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

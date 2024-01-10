import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supplier_test/screen/qurte_clan_bill.dart';
import '../../../widget/round_button.dart';
import '../utils.dart';

class ShopRegister extends StatefulWidget {
  static const routeName ='shop register';
  const ShopRegister({Key? key}) : super(key: key);

  @override
  State<ShopRegister> createState() => _ShopRegisterState();
}

class _ShopRegisterState extends State<ShopRegister> {
  bool spin = false;
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController addressController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    String ShopName="",Address="",Phone="";
    final formKey = GlobalKey<FormState>();
    final store = Utils();
    Future<void> saveData() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // Save a string
      prefs.setString('namekey', ShopName);
      prefs.setString('addresskey', Address);
      prefs.setString('phonekey', Phone);
    }

    return  Scaffold(
      appBar: AppBar(
        title: const Text('Shop Details'),
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
                    key: formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: TextFormField(
                            controller: nameController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              hintText: "Enter Your Shop Name",
                              labelText: "Shop Name",
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (String value){
                              ShopName = value;
                            },
                            validator: ((value) {
                              return value!.isEmpty?'Enter Shop Name':null;
                            }),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: TextFormField(
                            controller: addressController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              hintText: "Enter Your Shop Address",
                              labelText: "Shop Address",
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (String value){
                              Address = value;
                            },
                            validator: ((value) {
                              return value!.isEmpty?'Enter Shop Address':null;
                            }),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: TextFormField(
                            controller: phoneController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              hintText: "Enter Contact Number ",
                              labelText: "Contact Number",
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (String value){
                              Phone = value;
                            },
                            validator: ((value) {
                              return value!.isEmpty?'Enter Contact Number':null;
                            }),
                          ),
                        ),
                        const SizedBox(height: 20,),
                        RoundButton(title: "Next", onpress: ()async{

                          setState(() {
                            spin = true;
                          });
                          if(formKey.currentState!.validate()){
                            await saveData().whenComplete(() {
                              store.readData();
                              setState(() {
                                spin = false;
                              });
                              Navigator.of(context).pushReplacementNamed(QuteCalanBillPage.routeName,);
                            });
                          }else{
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text(' Shop Registeration'),
                                  content: const Text('Shop is not registered.'),
                                  actions: [
                                    TextButton(
                                      child: const Text('Try Again'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );

                              },
                            );
                            setState(() {
                              spin = false;
                            });
                          }

                        })
                      ],
                    )),
              ),
              spin?const CircularProgressIndicator():Container()
            ],
          ),
        ),
      ),
    );
  }
}

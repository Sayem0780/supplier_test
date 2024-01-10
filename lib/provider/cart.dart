import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../model/register.dart';
part 'cart.g.dart';

@HiveType(typeId: 2)
class CartItem extends HiveObject{
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String uom;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final double price;
  @HiveField(4)
  final int stock;
  @HiveField(5)
  final int quantity;
  @HiveField(6)
  double totalprice;

  CartItem({
    required this.id,
    required this.uom,
    required this.title,
    required this.price,
    required this.stock,
    required this.quantity,
    required this.totalprice,
  }
  );
}
class ShopDetails{
  final String shopName;
 final String shopAddress;
 final String shopPhone;

 ShopDetails({required this.shopName,required this.shopAddress,required this.shopPhone});

}

class Cart with ChangeNotifier {
  Map<String, CartItem> _selectedItems = {};
  Map<String, CartItem> get selectedItems {
    return _selectedItems;
  }
  List<ShopDetails> shop =[];
  List<Register> register =[];

  Future<void> readData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // var box = await Hive.openBox<Shop?>('shopbox');
      // String? stringValue = box.values.first!.shopName;
      // String? addressValue =box.values.first!.shopAddress;
      // String? phoneValue = box.values.first!.shopContact;
      String? stringValue = prefs.getString('namekey');
      String? addressValue = prefs.getString('addresskey');
      String? phoneValue = prefs.getString('phonekey');

      if (stringValue != null && addressValue != null && phoneValue != null) {
        shop.add(ShopDetails(shopName: stringValue, shopAddress: addressValue, shopPhone: phoneValue));
      }
    } catch (e) {
    }
  }

  int get totalAmount{
    int total = 0;
    _selectedItems.forEach((key, CartItem) {
      total = (total+ CartItem.totalprice!).ceil();
    });
   return total;
  }


  int get totalItem{
    int total = 0;
    _selectedItems.forEach((key, CartItem) {
      total = (total+ CartItem.quantity);
    });
    return total;
  }

  addItem(
      String pid,
      String ptitle,
      String puom,
      double pprice,
      int pstock,
      int pquantity,
      double totalprice,
  ) {
    if (_selectedItems.containsKey(pid)) {
      _selectedItems.update(pid, (value) {
        return CartItem(
            id: value.id,
            uom: puom,
            title: value.title,
            price: pprice,
            stock: pstock,
            quantity: pquantity,
          totalprice: pprice*pquantity,
        );
      });
    }else{
      _selectedItems.putIfAbsent(pid, () => CartItem(id: pid,uom: puom, title: ptitle, price: pprice,stock: pstock, quantity: pquantity,totalprice: pprice*pquantity));
    }
    notifyListeners();
  }
  removeSingleItem(String id){
    _selectedItems.remove(id);
    notifyListeners();
  }
  void clear(){
    _selectedItems = {};
    notifyListeners();
  }

  Future<void> creatProductList(String shopname) async {
    List<String> product =[];
    selectedItems.values.forEach((element) {
      product.add(element.title.toString());
    }
    );
    final String apiUrl = 'https://shop-624d0-default-rtdb.firebaseio.com/supplynow/$shopname.json'; // Replace with your API endpoint
    final response = await http.post(Uri.parse(apiUrl),
      body: jsonEncode(product),
    );
    if (response.statusCode == 200) {
    } else {
    }
  }
}

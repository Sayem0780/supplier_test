import 'package:hive/hive.dart';
part 'shop.g.dart';
@HiveType(typeId: 4)
class Shop extends HiveObject{
  @HiveField(0)
  final String shopName;
  @HiveField(1)
  final String shopAddress;
  @HiveField(2)
  final String shopContact;

  Shop({required this.shopName,required this.shopAddress,required this.shopContact});
}
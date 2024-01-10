import 'package:hive/hive.dart';
part 'details.g.dart';
@HiveType(typeId: 1)
class Details extends HiveObject{
  @HiveField(0)
  final String date;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String phone;
  @HiveField(3)
  final String address;
  @HiveField(4)
  final String Conditions;
  @HiveField(5)
  final String prpo;
  @HiveField(6)
  final String code;
  @HiveField(7)
  final String quantity;
  @HiveField(8)
  final String total;
  Details({required this.date,required this.name,required this.phone,required this.address,required this.Conditions,required this.prpo,required this.code,required this.quantity,required this.total});
}


import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:supplier_test/screen/qurte_clan_bill.dart';

import '../../../provider/cart.dart';
import '../../model/report.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';


class QPrint extends StatefulWidget {
  static const routeName = '/print pdf page';
  const QPrint(this.title, {Key? key}) : super(key: key);

  final String title;

  @override
  State<QPrint> createState() => _QPrintState();

  Future<Uint8List> createPDF(
      List<CartItem>
      items, int itemsPerPage,name,phone,address,condition,
      quotationNumber,total,ShopName,Address,Phone) async {


    String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    final pdf = pw.Document();
    final itemData = items;
    // final itemData = items.values
    //     .map((item) => [
    //           item.id,
    //           item.title,
    //           item.quantity.toString(),
    //           item.uom,
    //           item.price.toString(),
    //           item.stock.toString(),
    //           item.totalprice.toString()
    //         ])
    //     .toList();
    final pageCount = (itemData.length / itemsPerPage).ceil();

    var i = 0;
    for (var pageNum = 0; pageNum < pageCount; pageNum++) {
      pdf.addPage(
        pw.Page(
          build: (context) {
            final rows = <pw.TableRow>[];
            for (var j = 0; j < itemsPerPage; j++) {
              final index = i * itemsPerPage + j;
              if (index >= itemData.length) {
                break;
              }
              final item = itemData[index];
              rows.add(pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text((index+1).toString()),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(item.title),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(item.quantity.toString()),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(item.uom),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(item.price.toString()),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(item.totalprice.toString()),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(item.stock.toString()),
                  ),
                ],
              ));
            }
            i++;

            if (pageNum == 0 && pageCount-1>pageNum) {
              return pw.Stack(
                  children: [
                    pw.Container(
                      margin: const pw.EdgeInsets.only(top: 80),
                      child:  pw.Center(
                        child:   pw.Transform.rotate(
                          angle: 3.14159 / .5633,
                          child:  pw.Text('$ShopName',style:
                          pw.TextStyle(color: PdfColors.grey100,fontSize: 110, fontWeight: pw.FontWeight.bold,
                            fontStyle: pw.FontStyle.italic,
                          ),
                          ),
                        ),
                      ),
                    ),
                    pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Container(
                                alignment: pw.Alignment.center,
                                child: pw.Text(
                                  '$ShopName',
                                  style: pw.TextStyle(
                                    fontSize: 20,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              ),
                              pw.SizedBox(height: 10),
                              pw.Container(
                                alignment: pw.Alignment.center,
                                child: pw.Column(
                                  children: [
                                    pw.Text('$Address'),
                                    pw.Text('Contact''$Phone'),
                                  ],
                                ),
                              ),
                              pw.SizedBox(height: 20),
                              pw.Center(child: pw.Text('Quotation',style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                              pw.SizedBox(height: 20),
                              pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text('Name: $name'),
                                      pw.Text('Phone: $phone'),
                                      pw.Text('Address: $address'),
                                    ],
                                  ),
                                  pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                                    children: [
                                      pw.Text('Quotation No: $quotationNumber'),
                                      pw.Text('Date:$currentDate'),
                                    ],
                                  ),
                                ],
                              ),
                              pw.SizedBox(height: 30),
                              pw.Center(
                                  child: pw.Table(
                                    border: pw.TableBorder.all(),
                                    children: [
                                      pw.TableRow(
                                        decoration: const pw.BoxDecoration(
                                          color: PdfColors.blue50,
                                        ),
                                        children: [
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.all(4),
                                            child: pw.Text('SL'),
                                          ),
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.all(4),
                                            child: pw.Text('Name'),
                                          ),
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.all(4),
                                            child: pw.Text('Unit'),
                                          ),
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.all(4),
                                            child: pw.Text('UOM'),
                                          ),
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.all(4),
                                            child: pw.Text('Rate'),
                                          ),
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.all(4),
                                            child: pw.Text('Total Price'),
                                          ),
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.all(4),
                                            child: pw.Text('Stock'),
                                          ),
                                        ],
                                      ),
                                      ...rows,

                                    ],
                                  )),
                            ],
                          ),
                          pw.Positioned(
                            bottom: 20,
                            left: 0,
                            right: 0,
                            child: pw.Center(
                              child: pw.Column(
                                  children: [
                                    pw.Text('Page: ${pageNum+1}'),
                                    pw.Text('Generated By RackUp IT Solution'),
                                  ]
                              ),
                            ),
                          ),
                        ]
                    ),
                  ]
              );
            }//For first page of multiple page

            if(pageNum==0 && pageCount-1==0 ){
              return pw.Stack(
                  children: [
                    pw.Container(
                      margin: const pw.EdgeInsets.only(top: 80),
                      child:  pw.Center(
                        child:   pw.Transform.rotate(
                          angle: 3.14159 / .5633,
                          child:  pw.Text('$ShopName',style:
                          pw.TextStyle(color: PdfColors.grey100,fontSize: 110, fontWeight: pw.FontWeight.bold,
                            fontStyle: pw.FontStyle.italic,
                          ),
                          ),
                        ),
                      ),
                    ),
                    pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Container(
                                alignment: pw.Alignment.center,
                                child: pw.Text(
                                  '$ShopName',
                                  style: pw.TextStyle(
                                    fontSize: 20,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              ),
                              pw.SizedBox(height: 10),
                              pw.Container(
                                alignment: pw.Alignment.center,
                                child: pw.Column(
                                  children: [
                                    pw.Text('$Address'),
                                    pw.Text('Contact: ''$Phone'),
                                  ],
                                ),
                              ),
                              pw.SizedBox(height: 20),
                              pw.Center(child: pw.Text('Quotation',style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                              pw.SizedBox(height: 20),
                              pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text('Name: $name'),
                                      pw.Text('Phone: $phone'),
                                      pw.Text('Address: $address'),
                                    ],
                                  ),
                                  pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                                    children: [
                                      pw.Text('Quotation No: $quotationNumber'),
                                      pw.Text('Date:$currentDate'),
                                    ],
                                  ),
                                ],
                              ),
                              pw.SizedBox(height: 30),
                              pw.Center(
                                  child: pw.Table(
                                    border: pw.TableBorder.all(),
                                    children: [
                                      pw.TableRow(
                                        decoration: const pw.BoxDecoration(
                                          color: PdfColors.blue50,
                                        ),
                                        children: [
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.all(4),
                                            child: pw.Text('SL'),
                                          ),
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.all(4),
                                            child: pw.Text('Name'),
                                          ),
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.all(4),
                                            child: pw.Text('Unit'),
                                          ),
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.all(4),
                                            child: pw.Text('UOM'),
                                          ),
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.all(4),
                                            child: pw.Text('Rate'),
                                          ),
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.all(4),
                                            child: pw.Text('Total Price'),
                                          ),
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.all(4),
                                            child: pw.Text('Stock'),
                                          ),
                                        ],
                                      ),
                                      ...rows,
                                      pw.TableRow(
                                          decoration: const pw.BoxDecoration(color: PdfColors.blue100,),
                                          children: [
                                            pw.Padding(
                                              padding: const pw.EdgeInsets.all(4),
                                              child: pw.Text(''),
                                            ),
                                            pw.Padding(
                                              padding: const pw.EdgeInsets.all(4),
                                              child: pw.Text('Total'),
                                            ),
                                            pw.Padding(
                                              padding: const pw.EdgeInsets.all(4),
                                              child: pw.Text(''),
                                            ),
                                            pw.Padding(
                                              padding: const pw.EdgeInsets.all(4),
                                              child: pw.Text(''),
                                            ),
                                            pw.Padding(
                                              padding: const pw.EdgeInsets.all(4),
                                              child: pw.Text(''),
                                            ),
                                            pw.Padding(
                                              padding: const pw.EdgeInsets.all(4),
                                              child: pw.Text(total.toString()),
                                            ),
                                          ]
                                      ),
                                    ],
                                  )),
                              pw.SizedBox(height: 30),
                              pw.Text('Conditions',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(height: 10),
                              pw.Text(''),
                              pw.Text(condition.toString()),
                            ],
                          ),
                          pw.Center(
                            child: pw.Column(
                                children: [
                                  pw.Row(
                                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.Text('Receiver\'s Signature',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                                        pw.Text('$ShopName',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                                      ]
                                  ),
                                  pw.SizedBox(height: 15),
                                  pw.Text('Page: ${pageNum+1}'),
                                  pw.Text('Generated By RackUp IT Solution'),
                                ]
                            ),
                          ),
                        ]
                    ),
                  ]
              );
            }//For one & only page

            if(pageNum==pageCount-1){
              return pw.Stack(
                  children: [
                    pw.Container(
                      margin: const pw.EdgeInsets.only(top: 80),
                      child:  pw.Center(
                        child:   pw.Transform.rotate(
                          angle: 3.14159 / .5633,
                          child:  pw.Text('$ShopName',style:
                          pw.TextStyle(color: PdfColors.grey100,fontSize: 110, fontWeight: pw.FontWeight.bold,
                            fontStyle: pw.FontStyle.italic,
                          ),
                          ),
                        ),
                      ),
                    ),
                    pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Center(
                                    child: pw.Table(
                                      border: pw.TableBorder.all(),
                                      children: [
                                        pw.TableRow(
                                          decoration: const pw.BoxDecoration(
                                            color: PdfColors.blue50,
                                          ),
                                          children: [
                                            pw.Padding(
                                              padding: const pw.EdgeInsets.all(4),
                                              child: pw.Text('SL'),
                                            ),
                                            pw.Padding(
                                              padding: const pw.EdgeInsets.all(4),
                                              child: pw.Text('Name'),
                                            ),
                                            pw.Padding(
                                              padding: const pw.EdgeInsets.all(4),
                                              child: pw.Text('Unit'),
                                            ),
                                            pw.Padding(
                                              padding: const pw.EdgeInsets.all(4),
                                              child: pw.Text('UOM'),
                                            ),
                                            pw.Padding(
                                              padding: const pw.EdgeInsets.all(4),
                                              child: pw.Text('Rate'),
                                            ),
                                            pw.Padding(
                                              padding: const pw.EdgeInsets.all(4),
                                              child: pw.Text('Total Price'),
                                            ),
                                            pw.Padding(
                                              padding: const pw.EdgeInsets.all(4),
                                              child: pw.Text('Stock'),
                                            ),
                                          ],
                                        ),
                                        ...rows,
                                        pw.TableRow(
                                            decoration: const pw.BoxDecoration(color: PdfColors.blue100,),
                                            children: [
                                              pw.Padding(
                                                padding: const pw.EdgeInsets.all(4),
                                                child: pw.Text(''),
                                              ),
                                              pw.Padding(
                                                padding: const pw.EdgeInsets.all(4),
                                                child: pw.Text('Total'),
                                              ),
                                              pw.Padding(
                                                padding: const pw.EdgeInsets.all(4),
                                                child: pw.Text(''),
                                              ),
                                              pw.Padding(
                                                padding: const pw.EdgeInsets.all(4),
                                                child: pw.Text(''),
                                              ),
                                              pw.Padding(
                                                padding: const pw.EdgeInsets.all(4),
                                                child: pw.Text(''),
                                              ),
                                              pw.Padding(
                                                padding: const pw.EdgeInsets.all(4),
                                                child: pw.Text(total.toString()),
                                              ),
                                            ]
                                        ),
                                      ],
                                    )),
                                pw.SizedBox(height: 30),
                                pw.Text('Conditions',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                                pw.SizedBox(height: 10),
                                pw.Text(''),
                                pw.Text(condition.toString()),
                                pw.SizedBox(height: 30),
                                pw.Row(
                                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                    children: [
                                      pw.Text('Reciver\'s Signature',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                                      pw.Text('$ShopName',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                                    ]
                                ),
                              ]
                          ),
                          pw.Positioned(
                            bottom: 20,
                            left: 0,
                            right: 0,
                            child: pw.Center(
                              child: pw.Column(
                                  children: [
                                    pw.Text('Page: ${pageNum+1}'),
                                    pw.Text('Generated By RackUp IT Solution'),
                                  ]
                              ),
                            ),
                          ),
                        ]
                    )
                  ]
              ) ;
            }//For Last Page

            return pw.Stack(
                children: [
                  pw.Container(
                    margin: const pw.EdgeInsets.only(top: 80),
                    child:  pw.Center(
                      child:   pw.Transform.rotate(
                        angle: 3.14159 / .5633,
                        child:  pw.Text('$ShopName',style:
                        pw.TextStyle(color: PdfColors.grey100,fontSize: 110, fontWeight: pw.FontWeight.bold,
                          fontStyle: pw.FontStyle.italic,
                        ),
                        ),
                      ),
                    ),
                  ),
                  pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Table(
                          border: pw.TableBorder.all(),
                          children: [
                            pw.TableRow(
                              decoration: const pw.BoxDecoration(
                                color: PdfColors.blue50,
                              ),
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(4),
                                  child: pw.Text('SL'),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(4),
                                  child: pw.Text('Name'),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(4),
                                  child: pw.Text('Unit'),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(4),
                                  child: pw.Text('UOM'),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(4),
                                  child: pw.Text('Rate'),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(4),
                                  child: pw.Text('Total Price'),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(4),
                                  child: pw.Text('Stock'),
                                ),
                              ],
                            ),
                            ...rows,
                          ],
                        ),
                        pw.Positioned(
                          bottom: 20,
                          left: 0,
                          right: 0,
                          child: pw.Center(
                            child: pw.Column(
                                children: [
                                  pw.Text('Page: ${pageNum+1}'),
                                  pw.Text('Generated By RackUp IT Solution'),
                                ]
                            ),
                          ),
                        ),
                      ]
                  )
                ]
            );//For all page between first and last page
          },
        ),
      );
    }
    return pdf.save();
  }
}

class _QPrintState extends State<QPrint> {
  List<Order?> customDataList =[];
  Future<void> openBox() async {
    var box = await Hive.openBox<Order?>('quotationbox'); // Call searchUnsold after _box is initialized
    setState(() {
      customDataList = box.values.toList();
    });
  }

  @override
  Widget build(BuildContext context) {

    RewardedAd? _rewardedAd;

    final String _adUnitId = Platform.isAndroid
        ? 'ca-app-pub-1200290256287461/7881533445'
        : 'ca-app-pub-1200290256287461/7881533445';
    //test ca-app-pub-3940256099942544/5224354917
    //actual ca-app-pub-1200290256287461/7881533445


    void _loadAd() {
      RewardedAd.load(
        adUnitId: _adUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              // Called when the ad showed the full screen content.
              onAdShowedFullScreenContent: (ad) {
                // _loadAd(); // Load a new ad after this one is shown
              },
              // Called when an impression occurs on the ad.
              onAdImpression: (ad) {},
              // Called when the ad failed to show full screen content.
              onAdFailedToShowFullScreenContent: (ad, err) {
                ad.dispose();
                _loadAd(); // Load a new ad after failure to show content
              },
              // Called when the ad dismissed full screen content.
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
                // Load a new ad after content is dismissed
              },
              // Called when a click is recorded for an ad.
              onAdClicked: (ad) {},
            );

            // Keep a reference to the ad so you can show it later.
            _rewardedAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            // ignore: avoid_print
            // print('RewardedAd failed to load: $error');
          },
        ),
      );
    }
    void _showAd() {
      _rewardedAd?.show(onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
      });
    }

    final cart = Provider.of<Cart>(context);
    final name = cart.register[0].name;
    final phone = cart.register[0].phone;
    final address = cart.register[0].address;
    final condition = cart.register[0].condition;
    final int condittionLength = int.parse(condition.length.toString());
    final total = cart.totalAmount;
    final ShopName= cart.shop[0].shopName;
    final Address = cart.shop[0].shopAddress;
    final Phone = cart.shop[0].shopPhone;
    int itemsPerPage = 10;
    final qcode = cart.register[0].code;
    if(condittionLength>50){
      setState(() {
        itemsPerPage = 9;
      });
    }
    _loadAd();

    return WillPopScope(
      onWillPop: () async {
        cart.register.clear();
        cart.selectedItems.clear();
        Future.delayed(const Duration(seconds: 1));
        _showAd();
        Navigator.pushNamedAndRemoveUntil(context, QuteCalanBillPage.routeName, (Route<dynamic> route) => false);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          leading: IconButton(icon: const Icon(Icons.arrow_back_ios),onPressed: (){
            cart.register.clear();
            cart.selectedItems.clear();
            Future.delayed(const Duration(seconds: 1));
            _showAd();
            Navigator.pushNamedAndRemoveUntil(context, QuteCalanBillPage.routeName, (Route<dynamic> route) => false);
          },),
        ),
        body:  PdfPreview(
          build: (formate) => createPDF(cart.selectedItems.values.toList(), itemsPerPage,name,phone,address,condition,qcode,total,ShopName,Address,Phone),
        ),

      ),
    );
  }

  Future<Uint8List> createPDF(
      List<CartItem>
      items, int itemsPerPage,name,phone,address,condition,
      quotationNumber,total,ShopName,Address,Phone) async {

    String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    final pdf = pw.Document();
    final itemData = items;
    final pageCount = (itemData.length / itemsPerPage).ceil();

    var i = 0;
    for (var pageNum = 0; pageNum < pageCount; pageNum++) {
      pdf.addPage(
        pw.Page(
          build: (context) {
            final rows = <pw.TableRow>[];
            for (var j = 0; j < itemsPerPage; j++) {
              final index = i * itemsPerPage + j;
              if (index >= itemData.length) {
                break;
              }
              final item = itemData[index];
              rows.add(pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text((index+1).toString()),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(item.title),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(item.quantity.toString()),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(item.uom),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(item.price.toString()),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(item.totalprice.toString()),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(item.stock.toString()),
                  ),
                ],
              ));
            }
            i++;

            if (pageNum == 0 && pageCount-1>pageNum) {
              return pw.Stack(
                children: [
                  pw.Container(
                    margin: const pw.EdgeInsets.only(top: 80),
                    child:  pw.Center(
                      child:   pw.Transform.rotate(
                        angle: 3.14159 / .5633,
                        child:  pw.Text('$ShopName',style:
                        pw.TextStyle(color: PdfColors.grey100,fontSize: 110, fontWeight: pw.FontWeight.bold,
                          fontStyle: pw.FontStyle.italic,
                        ),
                        ),
                      ),
                    ),
                  ),
                  pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Container(
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                                '$ShopName',
                                style: pw.TextStyle(
                                  fontSize: 20,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                            pw.SizedBox(height: 10),
                            pw.Container(
                              alignment: pw.Alignment.center,
                              child: pw.Column(
                                children: [
                                  pw.Text('$Address'),
                                  pw.Text('Contact''$Phone'),
                                ],
                              ),
                            ),
                            pw.SizedBox(height: 20),
                            pw.Center(child: pw.Text('Quotation',style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                            pw.SizedBox(height: 20),
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text('Name: $name'),
                                    pw.Text('Phone: $phone'),
                                    pw.Text('Address: $address'),
                                  ],
                                ),
                                pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                                  children: [
                                    pw.Text('Quotation No: $quotationNumber'),
                                    pw.Text('Date:$currentDate'),
                                  ],
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 30),
                            pw.Center(
                                child: pw.Table(
                                  border: pw.TableBorder.all(),
                                  children: [
                                    pw.TableRow(
                                      decoration: const pw.BoxDecoration(
                                        color: PdfColors.blue50,
                                      ),
                                      children: [
                                        pw.Padding(
                                          padding: const pw.EdgeInsets.all(4),
                                          child: pw.Text('SL'),
                                        ),
                                        pw.Padding(
                                          padding: const pw.EdgeInsets.all(4),
                                          child: pw.Text('Name'),
                                        ),
                                        pw.Padding(
                                          padding: const pw.EdgeInsets.all(4),
                                          child: pw.Text('Unit'),
                                        ),
                                        pw.Padding(
                                          padding: const pw.EdgeInsets.all(4),
                                          child: pw.Text('UOM'),
                                        ),
                                        pw.Padding(
                                          padding: const pw.EdgeInsets.all(4),
                                          child: pw.Text('Rate'),
                                        ),
                                        pw.Padding(
                                          padding: const pw.EdgeInsets.all(4),
                                          child: pw.Text('Total Price'),
                                        ),
                                        pw.Padding(
                                          padding: const pw.EdgeInsets.all(4),
                                          child: pw.Text('Stock'),
                                        ),
                                      ],
                                    ),
                                    ...rows,

                                  ],
                                )),
                          ],
                        ),
                        pw.Positioned(
                          bottom: 20,
                          left: 0,
                          right: 0,
                          child: pw.Center(
                            child: pw.Column(
                                children: [
                                  pw.Text('Page: ${pageNum+1}'),
                                  pw.Text('Generated By RackUp IT Solution'),
                                ]
                            ),
                          ),
                        ),
                      ]
                  ),
                ]
              );
            }//For first page of multiple page

            if(pageNum==0 && pageCount-1==0 ){
              return pw.Stack(
                children: [
                  pw.Container(
                    margin: const pw.EdgeInsets.only(top: 80),
                    child:  pw.Center(
                      child:   pw.Transform.rotate(
                        angle: 3.14159 / .5633,
                        child:  pw.Text('$ShopName',style:
                        pw.TextStyle(color: PdfColors.grey100,fontSize: 110, fontWeight: pw.FontWeight.bold,
                          fontStyle: pw.FontStyle.italic,
                        ),
                        ),
                      ),
                    ),
                  ),
              pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Container(
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            '$ShopName',
                            style: pw.TextStyle(
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                        pw.SizedBox(height: 10),
                        pw.Container(
                          alignment: pw.Alignment.center,
                          child: pw.Column(
                            children: [
                              pw.Text('$Address'),
                              pw.Text('Contact: ''$Phone'),
                            ],
                          ),
                        ),
                        pw.SizedBox(height: 20),
                        pw.Center(child: pw.Text('Quotation',style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                        pw.SizedBox(height: 20),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text('Name: $name'),
                                pw.Text('Phone: $phone'),
                                pw.Text('Address: $address'),
                              ],
                            ),
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.end,
                              children: [
                                pw.Text('Quotation No: $quotationNumber'),
                                pw.Text('Date:$currentDate'),
                              ],
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 30),
                        pw.Center(
                            child: pw.Table(
                              border: pw.TableBorder.all(),
                              children: [
                                pw.TableRow(
                                  decoration: const pw.BoxDecoration(
                                    color: PdfColors.blue50,
                                  ),
                                  children: [
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.all(4),
                                      child: pw.Text('SL'),
                                    ),
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.all(4),
                                      child: pw.Text('Name'),
                                    ),
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.all(4),
                                      child: pw.Text('Unit'),
                                    ),
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.all(4),
                                      child: pw.Text('UOM'),
                                    ),
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.all(4),
                                      child: pw.Text('Rate'),
                                    ),
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.all(4),
                                      child: pw.Text('Total Price'),
                                    ),
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.all(4),
                                      child: pw.Text('Stock'),
                                    ),
                                  ],
                                ),
                                ...rows,
                                pw.TableRow(
                                    decoration: const pw.BoxDecoration(color: PdfColors.blue100,),
                                    children: [
                                      pw.Padding(
                                        padding: const pw.EdgeInsets.all(4),
                                        child: pw.Text(''),
                                      ),
                                      pw.Padding(
                                        padding: const pw.EdgeInsets.all(4),
                                        child: pw.Text('Total'),
                                      ),
                                      pw.Padding(
                                        padding: const pw.EdgeInsets.all(4),
                                        child: pw.Text(''),
                                      ),
                                      pw.Padding(
                                        padding: const pw.EdgeInsets.all(4),
                                        child: pw.Text(''),
                                      ),
                                      pw.Padding(
                                        padding: const pw.EdgeInsets.all(4),
                                        child: pw.Text(''),
                                      ),
                                      pw.Padding(
                                        padding: const pw.EdgeInsets.all(4),
                                        child: pw.Text(total.toString()),
                                      ),
                                    ]
                                ),
                              ],
                            )),
                        pw.SizedBox(height: 30),
                        pw.Text('Conditions',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 10),
                        pw.Text(''),
                         pw.Text(condition.toString()),
                      ],
                    ),
                    pw.Center(
                      child: pw.Column(
                          children: [
                            pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  pw.Text('Receiver\'s Signature',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                                  pw.Text('$ShopName',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                                ]
                            ),
                            pw.SizedBox(height: 15),
                            pw.Text('Page: ${pageNum+1}'),
                            pw.Text('Generated By RackUp IT Solution'),
                          ]
                      ),
                    ),
                  ]
              ),
                ]
              );
            }//For one & only page

            if(pageNum==pageCount-1){
              return pw.Stack(
                children: [
                  pw.Container(
                    margin: const pw.EdgeInsets.only(top: 80),
                    child:  pw.Center(
                      child:   pw.Transform.rotate(
                        angle: 3.14159 / .5633,
                        child:  pw.Text('$ShopName',style:
                        pw.TextStyle(color: PdfColors.grey100,fontSize: 110, fontWeight: pw.FontWeight.bold,
                          fontStyle: pw.FontStyle.italic,
                        ),
                        ),
                      ),
                    ),
                  ),
                  pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Center(
                                  child: pw.Table(
                                    border: pw.TableBorder.all(),
                                    children: [
                                      pw.TableRow(
                                        decoration: const pw.BoxDecoration(
                                          color: PdfColors.blue50,
                                        ),
                                        children: [
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.all(4),
                                            child: pw.Text('SL'),
                                          ),
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.all(4),
                                            child: pw.Text('Name'),
                                          ),
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.all(4),
                                            child: pw.Text('Unit'),
                                          ),
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.all(4),
                                            child: pw.Text('UOM'),
                                          ),
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.all(4),
                                            child: pw.Text('Rate'),
                                          ),
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.all(4),
                                            child: pw.Text('Total Price'),
                                          ),
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.all(4),
                                            child: pw.Text('Stock'),
                                          ),
                                        ],
                                      ),
                                      ...rows,
                                      pw.TableRow(
                                          decoration: const pw.BoxDecoration(color: PdfColors.blue100,),
                                          children: [
                                            pw.Padding(
                                              padding: const pw.EdgeInsets.all(4),
                                              child: pw.Text(''),
                                            ),
                                            pw.Padding(
                                              padding: const pw.EdgeInsets.all(4),
                                              child: pw.Text('Total'),
                                            ),
                                            pw.Padding(
                                              padding: const pw.EdgeInsets.all(4),
                                              child: pw.Text(''),
                                            ),
                                            pw.Padding(
                                              padding: const pw.EdgeInsets.all(4),
                                              child: pw.Text(''),
                                            ),
                                            pw.Padding(
                                              padding: const pw.EdgeInsets.all(4),
                                              child: pw.Text(''),
                                            ),
                                            pw.Padding(
                                              padding: const pw.EdgeInsets.all(4),
                                              child: pw.Text(total.toString()),
                                            ),
                                          ]
                                      ),
                                    ],
                                  )),
                              pw.SizedBox(height: 30),
                              pw.Text('Conditions',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(height: 10),
                              pw.Text(''),
                              pw.Text(condition.toString()),
                              pw.SizedBox(height: 30),
                              pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                  children: [
                                    pw.Text('Receiver\'s Signature',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                                    pw.Text('$ShopName',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                                  ]
                              ),
                            ]
                        ),
                        pw.Positioned(
                          bottom: 20,
                          left: 0,
                          right: 0,
                          child: pw.Center(
                            child: pw.Column(
                                children: [
                                  pw.Text('Page: ${pageNum+1}'),
                                  pw.Text('Generated By RackUp IT Solution'),
                                ]
                            ),
                          ),
                        ),
                      ]
                  )
                ]
              ) ;
            }//For Last Page

            return pw.Stack(
              children: [
                pw.Container(
                  margin: const pw.EdgeInsets.only(top: 80),
                  child:  pw.Center(
                    child:   pw.Transform.rotate(
                      angle: 3.14159 / .5633,
                      child:  pw.Text('$ShopName',style:
                      pw.TextStyle(color: PdfColors.grey100,fontSize: 110, fontWeight: pw.FontWeight.bold,
                        fontStyle: pw.FontStyle.italic,
                      ),
                      ),
                    ),
                  ),
                ),
                pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Table(
                        border: pw.TableBorder.all(),
                        children: [
                          pw.TableRow(
                            decoration: const pw.BoxDecoration(
                              color: PdfColors.blue50,
                            ),
                            children: [
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(4),
                                child: pw.Text('SL'),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(4),
                                child: pw.Text('Name'),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(4),
                                child: pw.Text('Unit'),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(4),
                                child: pw.Text('UOM'),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(4),
                                child: pw.Text('Rate'),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(4),
                                child: pw.Text('Total Price'),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(4),
                                child: pw.Text('Stock'),
                              ),
                            ],
                          ),
                          ...rows,
                        ],
                      ),
                      pw.Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: pw.Center(
                          child: pw.Column(
                              children: [
                                pw.Text('Page: ${pageNum+1}'),
                                pw.Text('Generated By RackUp IT Solution'),
                              ]
                          ),
                        ),
                      ),
                    ]
                )
              ]
            );//For all page between first and last page
          },
        ),
      );
    }
    return pdf.save();
  }
}

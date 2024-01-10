import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:supplier_test/model/report.dart';
import 'package:supplier_test/provider/cart.dart';
import 'package:supplier_test/screen/calan/cprint.dart';

import '../../widget/search.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../widget/countdown.dart';


class CalanReport extends StatefulWidget {
  static const routeName="/calan";
  const CalanReport({Key? key}) : super(key: key);

  @override
  State<CalanReport> createState() => _CalanReportState();
}

class _CalanReportState extends State<CalanReport>  with WidgetsBindingObserver{
  late Box<Order?> _box;
  bool isSecondSegmentVisible = false;
  Order? selectedReport;
  int? selectedListTileIndex;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    openBox();
    _loadAd();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _box.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Close the box when the app is paused or the user leaves the page
      _box.close();
    } else if (state == AppLifecycleState.resumed) {
      // Open the box when the app is resumed or the user enters the page
      openBox();
    }
  }

  List<Order?> customDataList =[];

  Future<void> openBox() async {
    _box = await Hive.openBox<Order?>('calanbox'); // Call searchUnsold after _box is initialized
    setState(() {
      customDataList = _box.values.toList();
    });

  }

  TextEditingController cNoController = TextEditingController();
  void searchChassis(String cNo) {
    String chassisNO = cNo.toLowerCase(); // Convert the search text to lowercase for case-insensitive comparison

    List<Order?> matchingLCs = customDataList.where((element) => element!.details.name.toLowerCase().contains(chassisNO)).toList();
    setState(() {
      if (matchingLCs.isNotEmpty) {
        customDataList = matchingLCs;
      }
    });
  }
  CPrint cPrint = const CPrint('');

  RewardedAd? _rewardedAd;

  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-1200290256287461/7881533445'
      : 'ca-app-pub-1200290256287461/7881533445';
  //test ca-app-pub-3940256099942544/5224354917
  //actual ca-app-pub-1200290256287461/7881533445


  Future<void> _loadAd() async{
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

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context,listen: false);
    final ShopName= cart.shop[0].shopName;
    final Address = cart.shop[0].shopAddress;
    final Phone = cart.shop[0].shopPhone;
    double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: ()async{
        _rewardedAd?.show(onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {});
        Future.delayed(const Duration(seconds: 1));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Calan Report"),centerTitle: true,automaticallyImplyLeading: false,),
        body: Container(
          child: customDataList.isNotEmpty? Column(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    SearchWidget(cNoController: cNoController, searchChassis: searchChassis),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: width<600?(width<350?1:2):3, // Adjust the number of columns as needed
                          mainAxisSpacing: 16.0,
                          crossAxisSpacing: 5.0,
                          childAspectRatio: 2,
                        ),
                        itemCount: customDataList.length,
                        itemBuilder: (context, index) {
                          Order? customData = customDataList[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedReport = customDataList[index];
                                isSecondSegmentVisible = true;
                                selectedListTileIndex = index;
                              });
                            },
                            child: Card(
                              color: selectedListTileIndex == index ? Colors.amber.shade500 : null,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                  width: 2,
                                  color: Colors.black,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Vendor: ${customData!.details.name}'),
                                    Text('Issue Date: ${customData.details.date}'),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: isSecondSegmentVisible,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: (){
                      setState(() {
                        isSecondSegmentVisible=!isSecondSegmentVisible;
                      });
                    },
                  ),
              ),
              Visibility(
                visible: isSecondSegmentVisible,
                child: Expanded(
                    flex: 5,
                    child: PdfPreview(
                      build: (format) => cPrint.createPDF(
                          selectedReport!.itemList.toList(), 15, selectedReport!.details.name,
                          selectedReport!.details.phone, selectedReport!.details.address, selectedReport!.details.prpo, selectedReport!.details.quantity, selectedReport!.details.code, ShopName, Address, Phone
                      ),
                    )),
              )
            ],
          ):const Text("No Data Found"),
        )
        ,
      ),
    );
  }
}

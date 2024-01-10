import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:supplier_test/model/report.dart';
import 'package:supplier_test/provider/cart.dart';
import 'package:supplier_test/screen/quotation/qprint.dart';
import '../../widget/search.dart';


class QuotationlReport extends StatefulWidget {
  static const routeName="/quotation";
  const QuotationlReport({Key? key}) : super(key: key);

  @override
  State<QuotationlReport> createState() => _QuotationlReportState();
}

class _QuotationlReportState extends State<QuotationlReport>  with WidgetsBindingObserver{
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

  RewardedAd? _rewardedAd;

  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-1200290256287461/7881533445'
      : 'ca-app-pub-1200290256287461/7881533445';



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

  List<Order?> customDataList =[];

  Future<void> openBox() async {
    _box = await Hive.openBox<Order?>('quotationbox'); // Call searchUnsold after _box is initialized
    setState(() {
      customDataList = _box.values.toList();
    });

  }

  TextEditingController cNoController = TextEditingController();
  void search(String cNo) {
    String chassisNO = cNo.toLowerCase(); // Convert the search text to lowercase for case-insensitive comparison

    List<Order?> matchingLCs = customDataList.where((element) => element!.details.name.toLowerCase().contains(chassisNO)).toList();
    setState(() {
      if (matchingLCs.isNotEmpty) {
        customDataList = matchingLCs;
      }
    });
  }
  QPrint qPrint = const QPrint('');

  @override
  Widget build(BuildContext context) {

    final cart = Provider.of<Cart>(context,listen: false);
    final ShopName= cart.shop[0].shopName;
    final Address = cart.shop[0].shopAddress;
    final Phone = cart.shop[0].shopPhone;
    double width = MediaQuery.of(context).size.width;
    return  WillPopScope(
      onWillPop: ()async{
        _rewardedAd?.show(onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {});
        Future.delayed(const Duration(seconds: 1));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Quotation Report"),centerTitle: true,automaticallyImplyLeading: false,),
        body: Container(
          child: customDataList.isNotEmpty? Column(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    SearchWidget(cNoController: cNoController, searchChassis: search),
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
                      build: (format) => qPrint.createPDF(
                          selectedReport!.itemList.toList(), 15, selectedReport!.details.name,
                          selectedReport!.details.phone, selectedReport!.details.address, selectedReport!.details.Conditions, selectedReport!.details.code, selectedReport!.details.total, ShopName, Address, Phone
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

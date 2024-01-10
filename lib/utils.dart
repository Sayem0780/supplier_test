// Utils class for reading data

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:supplier_test/screen/qurte_clan_bill.dart';
import '../../widget/countdown.dart';

class Utils {
  String ShopName = "", Address = "", Phone = "";
  Future<void> readData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? stringValue = prefs.getString('namekey');
      String? addressValue = prefs.getString('addresskey');
      String? phoneValue = prefs.getString('phonekey');

      if (stringValue != null && addressValue != null && phoneValue != null) {
        ShopName = stringValue;
        Address = addressValue;
        Phone = phoneValue;

      }

    } catch (e) {
    }
  }

  final CountdownTimer _countdownTimer = CountdownTimer();
  RewardedAd? _rewardedAd;

  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-3940256099942544/5224354917';
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
              _loadAd(); // Load a new ad after this one is shown
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
              _loadAd(); // Load a new ad after content is dismissed
            },
            // Called when a click is recorded for an ad.
            onAdClicked: (ad) {},
          );

          // Keep a reference to the ad so you can show it later.
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          // ignore: avoid_print
          print('RewardedAd failed to load: $error');
        },
      ),
    );
  }

  void startNewGame() {
    _loadAd();
    _countdownTimer.start();
  }

  void showAd(BuildContext context) {
    _rewardedAd?.show(onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
      Future.delayed(const Duration(milliseconds: 1));
      Navigator.pushNamedAndRemoveUntil(
        context,
        QuteCalanBillPage.routeName,
            (Route<dynamic> route) => false,
      );
    });
  }
}


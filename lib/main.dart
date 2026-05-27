import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int points = 0;
  RewardedAd? _rewardedAd;

  @override
  void initState() {
    super.initState();
    _loadRewardedAd();
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917', // ده كود تجريبي، غيره بعدين
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => _rewardedAd = ad,
        onAdFailedToLoad: (error) => print('Ad failed: $error'),
      ),
    );
  }

  void _showAd() {
    if (_rewardedAd != null) {
      _rewardedAd!.show(onUserEarnedReward: (ad, reward) {
        setState(() => points += 10);
      });
      _loadRewardedAd();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('اربح نقاط')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('نقاطك: $points', style: TextStyle(fontSize: 30)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showAd,
              child: Text('شاهد إعلان واكسب 10 نقاط'),
            ),
          ],
        ),
      ),
    );
  }
}

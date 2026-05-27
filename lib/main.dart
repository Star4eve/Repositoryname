import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const VideoCashApp());
}

class VideoCashApp extends StatelessWidget {
  const VideoCashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int points = 1208;
  RewardedAd? _rewardedAd;
  bool _isAdReady = false;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadRewardedAd();
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917', // ID تجريبي - غيره بعدين من AdMob
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isAdReady = true;
        },
        onAdFailedToLoad: (error) {
          _isAdReady = false;
          _loadRewardedAd();
        },
      ),
    );
  }

  void _showRewardedAd() {
    if (_isAdReady && _rewardedAd != null) {
      _rewardedAd!.show(onUserEarnedReward: (ad, reward) {
        setState(() {
          points += 10;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('مبروك! تم إضافة 10 نقاط')),
        );
        _loadRewardedAd();
      });
      _rewardedAd = null;
      _isAdReady = false;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الإعلان لسه بيحمل، جرب بعد ثانية')),
      );
      _loadRewardedAd();
    }
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00D4AA), Color(0xFF8B5CF6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.person, color: Colors.purple)),
                    const SizedBox(width: 12),
                    const Text('Video Cash', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    IconButton(icon: const Icon(Icons.menu, color: Colors.white), onPressed: () {}),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(16)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      const CircleAvatar(backgroundColor: Colors.white, radius: 20, child: Icon(Icons.person, color: Colors.purple, size: 20)),
                      const SizedBox(width: 12),
                      Text('$points', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ]),
                    const Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Text('250 Points', style: TextStyle(color: Colors.white70)),
                      Text('\$1.25', style: TextStyle(color: Colors.greenAccent, fontSize: 18, fontWeight: FontWeight.bold)),
                    ]),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _showRewardedAd,
                child: Container(
                  width: 200, height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(colors: [Colors.cyanAccent.withOpacity(0.8), Colors.blueAccent.withOpacity(0.6)]),
                  ),
                  child: const Icon(Icons.play_arrow, size: 100, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              const Text('شاهد فيديو', style: TextStyle(color: Colors.white, fontSize: 20)),
              const Text('& اربح 10 نقاط', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Align(alignment: Alignment.centerLeft, child: Text('السحب', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold))),
              ),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: Container(margin: const EdgeInsets.only(left: 16, right: 8), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)), child: const Column(children: [Text('Vodafone Cash', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)), SizedBox(height: 8), Text('€.57', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))]))),
                Expanded(child: Container(margin: const EdgeInsets.only(left: 8, right: 16), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)), child: const Column(children: [Text('PayPal', style: TextStyle(color: Colors.blue, fontSize: 24, fontWeight: FontWeight.bold)), SizedBox(height: 8), Text('€.25', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))]))),
              ]),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(16)),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                  _navItem(Icons.home, 'الرئيسية', 0),
                  _navItem(Icons.task, 'المهام', 1),
                  _navItem(Icons.swap_horiz, 'السحب', 2, badge: true),
                  _navItem(Icons.person, 'الحساب', 3, badge: true),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index, {bool badge = false}) {
    return GestureDetector(
      onTap: () => setState(() => currentIndex = index),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Stack(children: [
          Icon(icon, color: currentIndex == index ? Colors.white : Colors.white54),
          if (badge) Positioned(right: 0, top: 0, child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle))),
        ]),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: currentIndex == index ? Colors.white : Colors.white54, fontSize: 12)),
      ]),
    );
  }
}

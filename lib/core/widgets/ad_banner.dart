import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdBanner extends StatefulWidget {
  const AdBanner({super.key, this.adUnitId});

  final String? adUnitId;

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  BannerAd? _ad;

  @override
  void initState() {
    super.initState();
    const enabled = bool.fromEnvironment('ADS_ENABLED');
    if (!enabled) return;
    BannerAd(
      adUnitId:
          widget.adUnitId ??
          const String.fromEnvironment(
            'ADMOB_BANNER_ID',
            defaultValue: 'ca-app-pub-3940256099942544/6300978111',
          ),
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) setState(() => _ad = ad as BannerAd);
        },
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
    ).load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _ad;
    if (ad == null) return const SizedBox.shrink();
    return SafeArea(
      top: false,
      child: SizedBox(
        width: ad.size.width.toDouble(),
        height: ad.size.height.toDouble(),
        child: AdWidget(ad: ad),
      ),
    );
  }
}

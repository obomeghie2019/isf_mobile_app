import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  final String adUnitId;

  const BannerAdWidget({super.key, required this.adUnitId});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  AdSize? _adSize;
  AdLoadState _loadState = AdLoadState.loading;
  String? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }

  Future<void> _loadAd() async {
    if (!mounted) return;

    setState(() {
      _loadState = AdLoadState.loading;
      _error = null;
    });

    try {
      // Get adaptive size
      final width = MediaQuery.of(context).size.width.toInt();
      _adSize =
          await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width);

      _bannerAd = BannerAd(
        adUnitId: widget.adUnitId,
        request: const AdRequest(),
        size: _adSize ?? AdSize.banner,
        listener: BannerAdListener(
          onAdLoaded: (_) {
            if (!mounted) return;
            setState(() => _loadState = AdLoadState.loaded);
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            if (!mounted) return;
            setState(() {
              _loadState = AdLoadState.error;
              _error = 'Failed to load ad: ${error.message}';
            });
            debugPrint('Ad error: $error');
          },
        ),
      )..load();
    } catch (e) {
      setState(() {
        _loadState = AdLoadState.error;
        _error = 'Exception: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_loadState) {
      case AdLoadState.loading:
        return _buildLoading();
      case AdLoadState.loaded:
        return _buildAd();
      case AdLoadState.error:
        return _buildError();
    }
  }

  Widget _buildLoading() => Container(
        height: _adSize?.height.toDouble() ?? 50,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      );

  Widget _buildAd() => SizedBox(
        width: _adSize!.width.toDouble(),
        height: _adSize!.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      );

  Widget _buildError() => Container(
        height: 50,
        color: Colors.red[100],
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Text(
            _error ?? 'Ad failed to load',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
}

enum AdLoadState { loading, loaded, error }

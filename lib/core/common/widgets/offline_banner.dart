import 'dart:async';
import 'package:flutter/material.dart';
import '../../services/connectivity_service.dart';
import '../../../injection_container.dart';

//offline banner if user turn off data showing this bannar at the top
class OfflineBanner extends StatefulWidget {
  const OfflineBanner({super.key});

  @override
  State<OfflineBanner> createState() => _OfflineBannerState();
}

class _OfflineBannerState extends State<OfflineBanner> {
  late StreamSubscription<bool> _subscription;
  bool _isConnected = true;
  bool _showBanner = false;
  Color _bannerColor = Colors.red;
  String _message = 'You are offline';

  @override
  void initState() {
    super.initState();
    _checkInitialConnection();
    _subscription = sl<ConnectivityService>().connectionStream.listen((
      isConnected,
    ) {
      _updateConnectionStatus(isConnected);
    });
  }

  Future<void> _checkInitialConnection() async {
    final isConnected = await sl<ConnectivityService>().isConnected;
    if (!mounted) return;
    setState(() {
      _isConnected = isConnected;
      _showBanner = !isConnected;
    });
  }

  void _updateConnectionStatus(bool isConnected) {
    if (!mounted) return;
    if (isConnected == _isConnected) return;

    setState(() {
      _isConnected = isConnected;
      if (!isConnected) {
        _showBanner = true;
        _bannerColor = Colors.red.shade700;
        _message = 'You are offline';
      } else {
        _bannerColor = Colors.green.shade700;
        _message = 'Back online';
        // Auto-hide the "Back online" green banner after 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted && _isConnected) {
            setState(() {
              _showBanner = false;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_showBanner) return const SizedBox.shrink();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      color: _bannerColor,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isConnected ? Icons.wifi_rounded : Icons.wifi_off_rounded,
              color: Colors.white,
              size: 14,
            ),
            const SizedBox(width: 8),
            Text(
              _message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

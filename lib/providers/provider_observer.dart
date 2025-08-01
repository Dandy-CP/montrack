import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProviderObservers extends ProviderObserver {
  static final List<ProviderBase> _allProviders = [];

  @override
  void didAddProvider(
    ProviderBase provider,
    Object? value,
    ProviderContainer container,
  ) {
    _allProviders.add(provider);
  }

  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    _allProviders.add(provider);
  }

  @override
  void didDisposeProvider(ProviderBase provider, ProviderContainer container) {
    _allProviders.remove(provider);
  }

  static Future<void> invalidateAllProviders(WidgetRef ref) async {
    for (final provider in List.from(_allProviders)) {
      ref.invalidate(provider);
    }

    _allProviders.clear();
  }
}

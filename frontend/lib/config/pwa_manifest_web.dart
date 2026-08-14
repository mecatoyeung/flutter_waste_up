import 'dart:convert';
import 'dart:html';

import 'env_config.dart';

void configurePwaManifest() {
  final manifest = <String, Object>{
    'name': EnvConfig.pwaInstallationTitle,
    'short_name': EnvConfig.pwaInstallationTitle,
    'start_url': '.',
    'display': 'standalone',
    'background_color': '#0175C2',
    'theme_color': '#0175C2',
    'description': EnvConfig.pwaInstallationDescription,
    'orientation': 'portrait-primary',
    'prefer_related_applications': false,
    'icons': [
      {'src': 'icons/Icon-192.png', 'sizes': '192x192', 'type': 'image/png'},
      {'src': 'icons/Icon-512.png', 'sizes': '512x512', 'type': 'image/png'},
      {
        'src': 'icons/Icon-maskable-192.png',
        'sizes': '192x192',
        'type': 'image/png',
        'purpose': 'maskable',
      },
      {
        'src': 'icons/Icon-maskable-512.png',
        'sizes': '512x512',
        'type': 'image/png',
        'purpose': 'maskable',
      },
    ],
  };

  final manifestLink = document.querySelector('link[rel="manifest"]');
  if (manifestLink is LinkElement) {
    manifestLink.href = 'data:application/manifest+json,${Uri.encodeComponent(jsonEncode(manifest))}';
  }

  document.title = EnvConfig.pwaInstallationTitle;
  document.querySelector('meta[name="description"]')?.setAttribute(
        'content',
        EnvConfig.pwaInstallationDescription,
      );
  document.querySelector('meta[name="apple-mobile-web-app-title"]')?.setAttribute(
        'content',
        EnvConfig.pwaInstallationTitle,
      );
}
import 'dart:convert';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

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

  final manifestLink = web.document.querySelector('link[rel="manifest"]');
  if (manifestLink != null && manifestLink.isA<web.HTMLLinkElement>()) {
    (manifestLink as web.HTMLLinkElement).href =
        'data:application/manifest+json,${Uri.encodeComponent(jsonEncode(manifest))}';
  }

  web.document.title = EnvConfig.pwaInstallationTitle;
  web.document.querySelector('meta[name="description"]')?.setAttribute(
        'content',
        EnvConfig.pwaInstallationDescription,
      );
  web.document.querySelector('meta[name="apple-mobile-web-app-title"]')?.setAttribute(
        'content',
        EnvConfig.pwaInstallationTitle,
      );
}
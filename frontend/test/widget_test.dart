import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waste_up/main.dart';

void main() {
	testWidgets('uses Traditional Chinese by default', (tester) async {
		await tester.pumpWidget(const WasteUpApp());

		expect(find.text('找一份\n適合您的工作。'), findsOneWidget);
	});

	testWidgets('supports Simplified Chinese and English', (tester) async {
		await tester.pumpWidget(const WasteUpApp(locale: Locale('zh', 'CN')));
		expect(find.text('寻找一份\n适合您的工作。'), findsOneWidget);

		await tester.pumpWidget(const WasteUpApp(locale: Locale('en')));

		expect(find.text('Find work that\nworks for you.'), findsOneWidget);
	});
}

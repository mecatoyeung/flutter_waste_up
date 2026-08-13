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

	testWidgets('changes language from the App Bar menu', (tester) async {
		await tester.pumpWidget(const WasteUpApp());

		await tester.tap(find.byIcon(Icons.language));
		await tester.pumpAndSettle();
		await tester.tap(find.text('English'));
		await tester.pumpAndSettle();

		expect(find.text('Find work that\nworks for you.'), findsOneWidget);
	});

	testWidgets('shows account actions for the current authentication state', (tester) async {
		await tester.pumpWidget(const WasteUpApp());

		await tester.tap(find.byTooltip('帳戶'));
		await tester.pumpAndSettle();
		expect(find.text('登入'), findsOneWidget);
		expect(find.text('註冊'), findsOneWidget);

		await tester.tap(find.text('登入'));
		await tester.pumpAndSettle();
		await tester.tap(find.byTooltip('帳戶'));
		await tester.pumpAndSettle();
		expect(find.text('個人檔案'), findsWidgets);
		expect(find.text('登出'), findsOneWidget);
	});
}

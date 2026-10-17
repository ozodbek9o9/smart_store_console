import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:smart_store_console/main.dart';

void main() {
  testWidgets('shows splash while Firebase data loads', (tester) async {
    final loading = Completer<void>();

    await tester.pumpWidget(
      MaterialApp(home: StartupPage(loadData: () => loading.future)),
    );

    expect(find.text('SmartStore Console'), findsOneWidget);
    expect(find.text('Firebase ma’lumotlari yuklanmoqda...'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}

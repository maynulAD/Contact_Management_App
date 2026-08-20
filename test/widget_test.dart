import 'package:flutter_test/flutter_test.dart';

import 'package:contact_management_app/main.dart';

void main() {
  testWidgets('Contact Management App loads', (WidgetTester tester) async {
    await tester.pumpWidget(const ContactManagementApp());
    await tester.pump(const Duration(seconds: 2));

    expect(find.text('My Contacts'), findsOneWidget);
  });
}

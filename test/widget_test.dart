import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:electromart/main.dart';
import 'package:electromart/store.dart';

void main() {
  testWidgets('akun demo User membuka beranda ElectroMart', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => StoreState(),
        child: const ElectroMartApp(),
      ),
    );
    final demoButton = find.text('Masuk sebagai User');
    await tester.ensureVisible(demoButton);
    await tester.tap(demoButton);
    await tester.pump();

    expect(find.text('PROMO SPESIAL'), findsOneWidget);
    expect(find.text('Belanja sekarang'), findsOneWidget);
    expect(find.text('Jelajah'), findsOneWidget);
  });
}

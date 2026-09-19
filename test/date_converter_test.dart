import 'package:flutter_test/flutter_test.dart';
import 'package:tugas2mobile/helpers/date_converter_helper.dart';

void main() {
  group('DateConverterHelper Edge Tests', () {
    test('Calculates weton, hijriah, saka for year 1700', () {
      final d = DateTime(1700, 5, 15);
      final weton = DateConverterHelper.konversiWeton(d);
      expect(weton['weton'], isNotEmpty);
      expect(weton['neptu'], isPositive);

      final hijriah = DateConverterHelper.konversiHijriah(d);
      expect(hijriah, contains('H'));

      final saka = DateConverterHelper.konversiSakaBali(d);
      expect(saka, contains('Saka'));

      final umur = DateConverterHelper.hitungUmur(d, DateTime(2026, 9, 19));
      expect(umur['tahun'], greaterThanOrEqualTo(326));
    });

    test('Calculates for year 1000 and year 2500 without error', () {
      for (final year in [1000, 1500, 1700, 1945, 2026, 2500]) {
        final d = DateTime(year, 8, 17);
        expect(DateConverterHelper.konversiWeton(d)['weton'], isNotEmpty);
        expect(DateConverterHelper.konversiHijriah(d), contains('H'));
        expect(DateConverterHelper.konversiSakaBali(d), contains('Saka'));
      }
    });

    test('17 Agustus 1945 is Jumat Legi', () {
      final d = DateTime(1945, 8, 17);
      final weton = DateConverterHelper.konversiWeton(d);
      expect(weton['weton'], 'Jumat Legi');
      expect(weton['neptu'], 11); // Jumat(6) + Legi(5) = 11
    });
  });
}

import 'package:dash_flags/dash_flags.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LanguageSelection {
  final LanguageFlag flag;
  final String name;
  final String code;

  LanguageSelection({
    required this.flag,
    required this.name,
    required this.code,
  });
}

class LanguageNotifier extends StateNotifier<List<LanguageSelection>> {
  LanguageNotifier()
      : super([
          LanguageSelection(
            flag: LanguageFlag(
              language: Language.af,
              height: 40.h,
            ),
            name: 'Afrikaans',
            code: 'af',
          ),
          LanguageSelection(
            flag: LanguageFlag(
              language: Language.ar,
              height: 40.h,
            ),
            name: 'Arabic',
            code: 'ar',
          ),
          LanguageSelection(
            flag: LanguageFlag(
              language: Language.zh,
              height: 40.h,
            ),
            name: 'Chinese',
            code: 'zh',
          ),
          LanguageSelection(
            flag: LanguageFlag(
              language: Language.hr,
              height: 40.h,
            ),
            name: 'Croatian',
            code: 'hr',
          ),
          LanguageSelection(
            flag: LanguageFlag(
              language: Language.cs,
              height: 40.h,
            ),
            name: 'Czech',
            code: 'cs',
          ),
          LanguageSelection(
            flag: LanguageFlag(
              language: Language.da,
              height: 40.h,
            ),
            name: 'Danish',
            code: 'da',
          ),
          LanguageSelection(
            flag: LanguageFlag(
              language: Language.nl,
              height: 40.h,
            ),
            name: 'Dutch',
            code: 'nl',
          ),
          LanguageSelection(
            flag: LanguageFlag(
              language: Language.en,
              height: 40.h,
            ),
            name: 'English',
            code: 'en',
          ),
          LanguageSelection(
            flag: LanguageFlag(
              language: Language.fi,
              height: 40.h,
            ),
            name: 'Finnish',
            code: 'fi',
          ),
          LanguageSelection(
            flag: LanguageFlag(
              language: Language.fr,
              height: 40.h,
            ),
            name: 'French',
            code: 'fr',
          ),
          LanguageSelection(
            flag: LanguageFlag(
              language: Language.de,
              height: 40.h,
            ),
            name: 'German',
            code: 'de',
          ),
          LanguageSelection(
            flag: LanguageFlag(
              language: Language.el,
              height: 40.h,
            ),
            name: 'Greek',
            code: 'el',
          ),
          LanguageSelection(
            flag: LanguageFlag(
              language: Language.it,
              height: 40.h,
            ),
            name: 'Italian',
            code: 'it',
          ),
          LanguageSelection(
            flag: LanguageFlag(
              language: Language.ja,
              height: 40.h,
            ),
            name: 'Japanese',
            code: 'jp',
          ),
          LanguageSelection(
            flag: LanguageFlag(
              language: Language.ko,
              height: 40.h,
            ),
            name: 'Korean',
            code: 'ko',
          ),
          LanguageSelection(
            flag: LanguageFlag(
              language: Language.no,
              height: 40.h,
            ),
            name: 'Norwegian',
            code: 'no',
          ),
          LanguageSelection(
            flag: LanguageFlag(
              language: Language.pl,
              height: 40.h,
            ),
            name: 'Polish',
            code: 'pl',
          ),
          LanguageSelection(
            flag: LanguageFlag(
              language: Language.pt,
              height: 40.h,
            ),
            name: 'Portuguese',
            code: 'pt',
          ),
          LanguageSelection(
            flag: LanguageFlag(
              language: Language.ru,
              height: 40.h,
            ),
            name: 'Russian',
            code: 'ru',
          ),
          LanguageSelection(
            flag: LanguageFlag(
              language: Language.sr,
              height: 40.h,
            ),
            name: 'Serbian',
            code: 'sr',
          ),
          LanguageSelection(
            flag: LanguageFlag(
              language: Language.es,
              height: 40.h,
            ),
            name: 'Spanish',
            code: 'es',
          ),
          LanguageSelection(
            flag: LanguageFlag(
              language: Language.sv,
              height: 40.h,
            ),
            name: 'Swedish',
            code: 'sv',
          ),
          LanguageSelection(
            flag: LanguageFlag(
              language: Language.tr,
              height: 40.h,
            ),
            name: 'Turkish',
            code: 'tr',
          ),
          LanguageSelection(
            flag: LanguageFlag(
              language: Language.uk,
              height: 40.h,
            ),
            name: 'Ukrainian',
            code: 'uk',
          ),
          LanguageSelection(
            flag: LanguageFlag(
              language: Language.cy,
              height: 40.h,
            ),
            name: 'Welsh',
            code: 'cy',
          ),
          // Add more languages as needed
        ]);
}

final languageProvider =
    StateNotifierProvider<LanguageNotifier, List<LanguageSelection>>(
  (ref) => LanguageNotifier(),
);

import 'package:clinic_ai/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LanguageSelector extends StatelessWidget {
  final HomeController controller;
  final Map<String, RxString> translationData;

  const LanguageSelector({
    Key? key,
    required this.controller,
    required this.translationData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.value
          ? const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              ),
            )
          : PopupMenuButton(
              offset: const Offset(0, 40),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF727970)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Icon(
                          Icons.language,
                          size: 16,
                          color: Color(0xFF727970),
                        )),
                    Obx(() => Text(
                          controller.currentLanguage.value.toUpperCase(),
                          style: GoogleFonts.inter(
                            color: const Color(0xFF727970),
                            fontSize: 14,
                          ),
                        )),
                    Icon(Icons.arrow_drop_down,
                        size: 16, color: Colors.grey[600]),
                  ],
                ),
              ),
              onSelected: (String language) {
                controller.updateAllTranslations(translationData, language);
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                    value: 'en',
                    child: Text('English'),
                  ),
                  // const PopupMenuItem(
                  //   value: 'es',
                  //   child: Text('Español'),
                  // ),
                  const PopupMenuItem(
                    value: 'id',
                    child: Text('Indonesia'),
                  ),
                ];
              },
            ),
    );
  }
}

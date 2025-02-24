import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/help_center_controller.dart';

// FAQ Item Model
class FaqItem {
  final String title;
  final String content;
  bool isExpanded;

  FaqItem({
    required this.title,
    required this.content,
    this.isExpanded = false,
  });
}

class HelpCenterView extends StatefulWidget {
  const HelpCenterView({super.key});

  @override
  State<HelpCenterView> createState() => _HelpCenterViewState();
}

class _HelpCenterViewState extends State<HelpCenterView> {
  final List<FaqItem> list = [
    FaqItem(
      title: 'What is ClinicAI?',
      content:
          'ClinicAI is an advanced healthcare platform that combines artificial intelligence with medical expertise to provide better healthcare services.',
    ),
    FaqItem(
      title: 'Why choose ClinicAI?',
      content:
          'ClinicAI offers personalized healthcare solutions, quick access to medical professionals, and AI-powered health monitoring to ensure comprehensive care.',
    ),
    FaqItem(
      title: 'What if i can do?',
      content:
          'With ClinicAI, you can schedule appointments, consult with doctors, access your medical records, and receive personalized health recommendations.',
    ),
    FaqItem(
      title: 'Is there are have Medical Record?',
      content:
          'Yes, ClinicAI maintains secure digital medical records that you can access anytime. All your health information is stored safely and confidentially.',
    ),
    FaqItem(
      title: 'How ClinicAI Works?',
      content:
          'ClinicAI uses advanced AI algorithms to analyze your health data, connect you with appropriate healthcare providers, and provide personalized health insights.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7FBF2),
      appBar: AppBar(
        backgroundColor: const Color(0xffF7FBF2),
        title: Text(
          'Help Center',
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          onPressed: () => Get.offAllNamed(Routes.PROFILE),
          icon: Image.asset('assets/icons/back.png'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Help message container
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'we are here to help whatever\nproblems there are in the AI Clinic',
                      style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff181D18)),
                    ),
                    Gap(8),
                    Text(
                      'Lorem ipsum dolor sit amet consectetur. Sed justo bibendum magna accumsan scelerisque. Eleifmod at donec neque velit id lobortis. Pulvinar pretium vitae nisi ultricies non nulla dignissim. Purus in vestibulum dictum magna leo convallis sed.',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: Color(0xff727970),
                      ),
                    ),
                  ],
                ),
              ),
              Gap(16),
              // Search bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Can Chat, Kategori',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: InputBorder.none,
                    suffixIcon: Icon(Icons.search, color: Colors.grey[400]),
                  ),
                ),
              ),
              Gap(16),
              // FAQ Section
              Text(
                'FAQ',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),

              // FAQ Accordion List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list.length,
                separatorBuilder: (context, index) => const Gap(8),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        title: Text(
                          list[index].title,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff181D18),
                          ),
                        ),
                        trailing: Icon(
                          list[index].isExpanded ? Icons.remove : Icons.add,
                          color: const Color(0xff2D5A27),
                        ),
                        onExpansionChanged: (expanded) {
                          setState(() {
                            list[index].isExpanded = expanded;
                          });
                        },
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                              bottom: 16,
                            ),
                            child: Text(
                              list[index].content,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: const Color(0xff727970),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),

              // Bottom text and button
              Center(
                child: Column(
                  children: [
                    Text(
                      'Still stuck? Help is a mail away',
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Gap(16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff2D5A27),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Send a message',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

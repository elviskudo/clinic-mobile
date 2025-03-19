import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/help_center_controller.dart';

class HelpCenterView extends StatefulWidget {
  const HelpCenterView({super.key});

  @override
  State<HelpCenterView> createState() => _HelpCenterViewState();
}

class _HelpCenterViewState extends State<HelpCenterView> {
  final HelpCenterController controller = Get.put(HelpCenterController());
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      controller.setSearchQuery(searchController.text);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Build highlighted text from the controller's segments
  Widget buildHighlightedText(String text, double fontSize,
      {FontWeight? fontWeight, Color? color}) {
    List<Map<String, dynamic>> segments = controller.highlightText(text);

    return RichText(
      text: TextSpan(
        children: segments.map((segment) {
          return TextSpan(
            text: segment["text"],
            style: GoogleFonts.inter(
              fontSize: fontSize,
              fontWeight: segment["highlighted"] ? FontWeight.bold : fontWeight,
              color: segment["highlighted"]
                  ? Theme.of(context).colorScheme.primary
                  : (color ?? Theme.of(context).colorScheme.onSurfaceVariant),
              backgroundColor: segment["highlighted"]
                  ? Theme.of(context).colorScheme.primaryContainer
                  : null,
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          'Help Center',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onBackground,
          ),
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
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                    Gap(8),
                    Obx(() => Text(
                          controller.isLoading.value
                              ? 'Loading...'
                              : controller.helpCenterSummary.value,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        )),
                  ],
                ),
              ),
              Gap(16),
              // Search bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search FAQ',
                    hintStyle: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color),
                    border: InputBorder.none,
                    suffixIcon: Obx(() => controller.searchQuery.isEmpty
                        ? Icon(Icons.search, color: Colors.grey[400])
                        : IconButton(
                            icon: Icon(Icons.close, color: Colors.grey[400]),
                            onPressed: () {
                              searchController.clear();
                              controller.clearSearch();
                            },
                          )),
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
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 8),

              // FAQ Accordion List
              Obx(() => ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.filteredFaqItems.length,
                    separatorBuilder: (context, index) => const Gap(8),
                    itemBuilder: (context, index) {
                      final item = controller.filteredFaqItems[index];

                      // Check if this FAQ item contains the search query
                      bool containsQuery = controller.searchQuery.isEmpty
                          ? false
                          : item.title.toLowerCase().contains(
                                  controller.searchQuery.value.toLowerCase()) ||
                              item.content.toLowerCase().contains(
                                  controller.searchQuery.value.toLowerCase());

                      return Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: containsQuery
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.outline,
                            width: containsQuery ? 2.0 : 1.0,
                          ),
                        ),
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: Obx(() => ExpansionTile(
                                initiallyExpanded: item.isExpanded,
                                tilePadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                title: buildHighlightedText(item.title, 16,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color),
                                trailing: Icon(
                                  item.isExpanded ? Icons.remove : Icons.add,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                onExpansionChanged: (expanded) {
                                  // Toggle expansion through controller
                                  controller.toggleExpansion(index);
                                },
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 16,
                                      right: 16,
                                      bottom: 16,
                                    ),
                                    child:
                                        buildHighlightedText(item.content, 14),
                                  ),
                                ],
                              )),
                        ),
                      );
                    },
                  )),

              const SizedBox(height: 32),

              // Bottom text and button
              Center(
                child: Column(
                  children: [
                    Text(
                      'Still stuck? Help is a mail away',
                      style: GoogleFonts.inter(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
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
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Send a message',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
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

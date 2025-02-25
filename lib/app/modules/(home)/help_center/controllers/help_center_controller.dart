import 'package:clinic_ai/models/faq_model.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HelpCenterController extends GetxController {
  final _supabase = Supabase.instance.client;

  var helpCenterSummary = ''.obs;
  var isLoading = true.obs;
  var searchQuery = ''.obs;

  var faqItems = <FaqItem>[].obs;
  var filteredFaqItems = <FaqItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchHelpCenterData();
    fetchFaqData();

    // Set up reactive search
    ever(searchQuery, (String query) {
      updateSearch(query);
    });
  }

  // Called when search query changes
  void updateSearch(String query) {
    query = query.toLowerCase();

    if (query.isEmpty) {
      // Reset expanded state when search is cleared
      for (var item in faqItems) {
        item.isExpanded = false;
      }
      filteredFaqItems.assignAll(faqItems);
      return;
    }

    // Update expansion state based on search
    for (var item in faqItems) {
      if (item.title.toLowerCase().contains(query) ||
          item.content.toLowerCase().contains(query)) {
        item.isExpanded = true;
      } else {
        item.isExpanded = false;
      }
    }

    // Filter items to only show matching ones (optional)
    // Comment this out if you want to show all items even when searching
    filteredFaqItems.assignAll(faqItems.where((item) =>
        item.title.toLowerCase().contains(query) ||
        item.content.toLowerCase().contains(query)));
  }

  // Update search query (call this from your TextField)
  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  // Highlight text with search query
  List<Map<String, dynamic>> highlightText(String text) {
    String query = searchQuery.value;
    if (query.isEmpty) {
      return [
        {"text": text, "highlighted": false}
      ];
    }

    List<Map<String, dynamic>> segments = [];
    String textLower = text.toLowerCase();
    String queryLower = query.toLowerCase();

    int start = 0;
    int indexOfMatch;

    while (true) {
      indexOfMatch = textLower.indexOf(queryLower, start);
      if (indexOfMatch == -1) {
        // No more matches
        if (start < text.length) {
          segments.add({"text": text.substring(start), "highlighted": false});
        }
        break;
      }

      // Add text before match
      if (indexOfMatch > start) {
        segments.add({
          "text": text.substring(start, indexOfMatch),
          "highlighted": false
        });
      }

      // Add highlighted match
      segments.add({
        "text": text.substring(indexOfMatch, indexOfMatch + query.length),
        "highlighted": true
      });

      // Move start to after the match
      start = indexOfMatch + query.length;
    }

    return segments;
  }

  Future<void> fetchHelpCenterData() async {
    try {
      isLoading(true);

      // Fetch data from help_centers table
      final response = await _supabase
          .from('help_centers')
          .select('en_summary')
          .order('id', ascending: true)
          .limit(1);
      if (response != null && response.isNotEmpty) {
        helpCenterSummary.value = response[0]['en_summary'] ?? '';
      }
    } catch (e) {
      print('Error retrieving help center data: $e');
      helpCenterSummary.value = 'Unable to load help center information.';
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchFaqData() async {
    try {
      // Fetch data from faqs table
      final response = await _supabase
          .from('faqs')
          .select('en_title, en_description')
          .order('id', ascending: true);

      if (response != null) {
        // Use factory constructor for conversion
        final List<FaqItem> items =
            (response as List).map((item) => FaqItem.fromJson(item)).toList();

        faqItems.assignAll(items);
        filteredFaqItems
            .assignAll(items); // Initialize filtered list with all items
      }
      print('FAQ Count: ${faqItems.length}');
    } catch (e) {
      print('Error retrieving FAQ data: $e');
    }
  }

  // Toggle expansion state
  void toggleExpansion(int index) {
    filteredFaqItems[index].isExpanded = !filteredFaqItems[index].isExpanded;
  }

  // Clear search and reset
  void clearSearch() {
    searchQuery.value = '';
  }
}

// lib/app/data/models/faq_item.dart

class FaqItem {
  final String title;
  final String content;
  bool isExpanded;

  FaqItem({
    required this.title,
    required this.content,
    this.isExpanded = false,
  });


  factory FaqItem.fromJson(Map<String, dynamic> json) {
    return FaqItem(
      title: json['en_title'] ?? '',
      content: json['en_description'] ?? '',
      isExpanded: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'isExpanded': isExpanded,
    };
  }


  FaqItem copyWith({
    String? title,
    String? content,
    bool? isExpanded,
  }) {
    return FaqItem(
      title: title ?? this.title,
      content: content ?? this.content,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}
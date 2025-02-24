import 'package:flutter/material.dart';

class FaqItem {
  FaqItem({
    required this.title,
    required this.content,
    this.isExpanded = false,
  });

  String title;
  String content;
  bool isExpanded;
}

class FaqAccordion extends StatefulWidget {
  const FaqAccordion({
    super.key,
    required this.faqList,
  });

  final List<FaqItem> faqList;

  @override
  State<FaqAccordion> createState() => _FaqAccordionState();
}

class _FaqAccordionState extends State<FaqAccordion> {
  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      elevation: 0,
      expandedHeaderPadding: EdgeInsets.zero,
      dividerColor: Colors.grey[300],
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          widget.faqList[index].isExpanded = !isExpanded;
        });
      },
      children: widget.faqList.map<ExpansionPanel>((FaqItem item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(
                item.title,
                style: const TextStyle(fontSize: 14),
              ),
              // trailing: Icon(
              //   item.isExpanded ? Icons.remove : Icons.add,
              //   color: Colors.grey[600],
              // ),
            );
          },
          body: Container(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 16,
            ),
            child: Text(
              item.content,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          isExpanded: item.isExpanded,
          backgroundColor: Colors.white,
          canTapOnHeader: true,
        );
      }).toList(),
    );
  }
}

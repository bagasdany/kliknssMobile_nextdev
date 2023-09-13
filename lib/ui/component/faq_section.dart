import 'package:flutter/material.dart';
import 'package:kliknss77/application/style/constants.dart';

class FAQSection extends StatefulWidget {
  final List<dynamic> faq;

  const FAQSection({Key? key, required this.faq}) : super(key: key);

  @override
  _FAQSectionState createState() => _FAQSectionState();
}

class _FAQSectionState extends State<FAQSection> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(Constants.spacing4, Constants.spacing4, Constants.spacing4, Constants.spacing2),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pertanyaan Umum',
                  style: Constants.heading4,
                ),
              ],
            ),
          ),
          ListView.separated(
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.faq.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.fromLTRB(Constants.spacing4,
                          Constants.spacing2, Constants.spacing4, 0),
                      title: Text(widget.faq[index]['question'] ?? ""),
                      children: [
                        Container(
                          child: Text(widget.faq[index]['answer'] ?? ""),
                          padding: const EdgeInsets.fromLTRB(
                              Constants.spacing4,
                              Constants.spacing2,
                              Constants.spacing4,
                              Constants.spacing4),
                        ),
                      ],
                    ),
                  ));
            },
            separatorBuilder: (BuildContext context, int index) {
              return Container();
            },
          )
        ],
      ),
    );
  }
}

import 'package:doit/theme/text.dart';
import 'package:flutter/material.dart';

class ReminderSelector extends StatelessWidget {
  Function(int index) onItemClicked;
  int selectedIndex;
  List<String> data;

  ReminderSelector({
    Key? key,
    required this.data,
    required this.selectedIndex,
    required this.onItemClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: data.asMap().entries.map((e) {
        int index = e.key;
        String value = e.value;

        return InkWell(
          onTap: () {
            print(index);
            onItemClicked(index);
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: selectedIndex == index ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Opacity(
              opacity: index == selectedIndex ? 1 : 0.6,
              child: Text(
                value,
                style: AppTextStyles.formReminderText.copyWith(
                  color: index == selectedIndex ? Colors.black : Colors.white,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

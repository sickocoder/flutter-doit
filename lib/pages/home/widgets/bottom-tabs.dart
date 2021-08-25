import 'package:doit/shared/widgets/base-button.dart';
import 'package:doit/shared/widgets/text.dart';
import 'package:doit/theme/text.dart';
import 'package:flutter/material.dart';

class BottomTabs extends StatefulWidget {
  final List<String> tabsData;
  final Function(int itemIndex)? onSelected;

  BottomTabs({
    Key? key,
    required this.tabsData,
    this.onSelected,
  }) : super(key: key);

  @override
  _BottomTabsState createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {
  int _selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.only(bottom: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: this.widget.tabsData.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              right: 16.0,
              left: index == 0 ? 16 : 0,
            ),
            child: BaseButton(
              onPressed: () {
                setState(() {
                  this._selectedTab = index;
                });
                this.widget.onSelected!(this._selectedTab);
              },
              child: AnimatedOpacity(
                duration: Duration(microseconds: 300),
                opacity: this._selectedTab == index ? 1 : 0.6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: ScalableText(
                      this.widget.tabsData[index],
                      style: AppTextStyles.button,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

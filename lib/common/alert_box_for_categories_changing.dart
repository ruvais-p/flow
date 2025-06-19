import 'package:flow/data/lists/categories_list.dart';
import 'package:flow/screens/homepage_screen/services/homepage_db_services.dart';
import 'package:flow/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 

void showCategoryDialog(BuildContext context, int id) async {
  List<String> categories = categoriesList;
  int selectedIndex = 0;

  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) {
      return ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
        child: Container(
          height: 300,
          color: Colors.white,
          child: Column(
            children: [
              // Top action buttons
              Container(
                color: Colors.grey[200],
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      child: Text(
                        "Cancel",
                        style: Theme.of(context).textTheme.displayMedium!.copyWith(color: AppColors.lightred),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    CupertinoButton(
                      child: Text(
                        "OK",
                        style: Theme.of(context).textTheme.displayMedium!.copyWith(color: AppColors.darkgray),
                      ),
                      onPressed: () async {
                        String selectedCategory = categories[selectedIndex];
                        await HomepageDbServices.instance.updateCategoryInDb(id, selectedCategory);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
              // The picker
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 40.0,
                  scrollController: FixedExtentScrollController(initialItem: selectedIndex),
                  onSelectedItemChanged: (int index) {
                    selectedIndex = index;
                    HapticFeedback.lightImpact();
                  },
                  children: categories.map((category) => Center(child: Text(category))).toList(),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

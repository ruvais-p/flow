import 'package:flow/data/lists/categories_list.dart';
import 'package:flow/screens/homepage_screen/provider/provider.dart';
import 'package:flow/screens/homepage_screen/services/homepage_db_services.dart';
import 'package:flow/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart'; 
void showCategoryDialog(
  BuildContext context,
  int id,
  String currentCategory,
  VoidCallback onCategoryUpdated,
) async {
  List<String> categories = categoriesList;
  int selectedIndex = categories.indexOf(currentCategory);
  if (selectedIndex == -1) selectedIndex = 0;

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
              // Header
              Container(
                color: Colors.grey[200],
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      child: Text("Cancel", style: Theme.of(context).textTheme.displayMedium!.copyWith(color: AppColors.lightred)),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    CupertinoButton(
                      child: Text("OK", style: Theme.of(context).textTheme.displayMedium!.copyWith(color: AppColors.darkgray)),
                      onPressed: () async {
                        final selectedCategory = categories[selectedIndex];
                        await HomepageDbServices.instance.updateCategoryInDb(id, selectedCategory);

                        // 🔥 Update the provider
                        final provider = Provider.of<TransactionListProvider>(context, listen: false);
                        provider.updateTransactionCategory(id, selectedCategory);

                        // Optional callback
                        onCategoryUpdated();

                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
              // Picker
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 40,
                  scrollController: FixedExtentScrollController(initialItem: selectedIndex),
                  onSelectedItemChanged: (index) {
                    selectedIndex = index;
                    HapticFeedback.selectionClick();
                  },
                  children: categories.map((e) => Center(child: Text(e))).toList(),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}

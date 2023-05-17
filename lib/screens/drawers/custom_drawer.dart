import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logging/logging.dart';

import 'package:flutter_tasks_app/models/category.dart';

final Logger _logger = Logger('CustomDrawer');

class CustomDrawer extends StatelessWidget {
  const CustomDrawer(
      {Key? key, required this.categories, required this.onCategorySelected})
      : super(key: key);

  final List<Category> categories;
  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    _logger.info('Building CustomDrawer widget');
    double screenWidth = MediaQuery.of(context).size.width;
    double drawerWidth = screenWidth * ((screenWidth <= 540) ? 0.6 : 0.4);

    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.white.withOpacity(0.98),
      ),
      child: ClipPath(
        child: SizedBox(
          width: drawerWidth,
          child: Drawer(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 45.0, 16.0, 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset(
                          'assets/buttons/close_X.svg',
                          height: 30,
                          width: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 5, bottom: 50),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            'assets/categories/${categories[index].id}.svg',
                          ),
                        ),
                        title: Text(
                          categories[index].name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        onTap: () {
                          _logger.info(
                              'Category selected: ${categories[index].id}');
                          onCategorySelected(categories[index].id);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logging/logging.dart';

import '../../models/categories.dart';

final Logger _logger = Logger('CustomDrawer');

class CustomDrawer extends StatefulWidget {
  final String lng;
  final ValueChanged<String> onCategorySelected;

  const CustomDrawer({
    Key? key,
    required this.onCategorySelected,
    required this.lng,
  }) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late Future<List<Category>> categoriesFuture;

  @override
  void initState() {
    super.initState();
    categoriesFuture = _loadCategories(widget.lng);
  }

  Future<List<Category>> _loadCategories(String lng) async {
    String jsonString = await rootBundle.loadString('assets/categories/categories_$lng.json');
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    List<Category> categories = [];
    for (int i = 0; i < jsonMap['category_ids'].length; i++) {
      categories.add(Category.fromJson(jsonMap, i));
    }
    _logger.info('Categories was loaded');
    return categories;
  }

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
                  child: FutureBuilder<List<Category>>(
                    future: categoriesFuture,
                    builder: (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
                      if (snapshot.hasData) {
                        List<Category> categories = snapshot.data!;
                        return ListView.builder(
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
                                child: Image.asset(
                                  categories[index].image,
                                ),
                              ),
                              title:  Text(
                                categories[index].name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              onTap: () {
                                _logger.info(
                                    'Category selected: ${categories[index].id}');
                                widget.onCategorySelected(categories[index].id);
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
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

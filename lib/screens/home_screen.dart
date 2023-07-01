import 'package:flutter/material.dart';
import 'package:flutter_tasks_app/screens/drawers/custom_drawer.dart';
import 'package:flutter_tasks_app/models/app_data_singleton.dart';
import 'package:flutter_tasks_app/screens/wallpapers/photos_stack.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../gen_l10n/app_localizations.dart';
import 'package:flutter_tasks_app/models/app_data.dart';
import 'package:logging/logging.dart';

import 'drawers/end_drawer.dart';

final _logger = Logger('MyHomePage');

class MyHomePage extends StatefulWidget {
  final String language;
  const MyHomePage({Key? key, required this.language}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

enum SelectedButton { newPhotos, top, favorite }

class MyHomePageState extends State<MyHomePage> {
  late Future<AppData> _appDataFuture;
  late AppData _appData;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedCategoryId = '0';
  late String _currentLanguage;
  SelectedButton _selectedButton = SelectedButton.newPhotos;

  List<int> _favoritePhotos = [];

  Future<void> _fetchFavoritePhotos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _favoritePhotos = prefs.getStringList('likedPhotos')?.map((photoId) => int.parse(photoId)).toList() ?? [];
  }

  @override
  void initState() {
    super.initState();
    _logger.finest('Initializing MyHomePage');
    _currentLanguage = widget.language;
    _appDataFuture = AppDataRepository().fetchAppData();
    _fetchFavoritePhotos();
  }

  void _onButtonSelected(SelectedButton button) {
    if (button == SelectedButton.favorite) {
      refreshFavoritePhotos();
    }
    setState(() {
      _selectedButton = button;
    });
  }

  void refreshFavoritePhotos() {
    _fetchFavoritePhotos().then((_) {
      setState(() {});
    });
  }

  void _onCategorySelected(String categoryId) {
    _logger.finest('Category selected: $categoryId');
    setState(() {
      _selectedCategoryId = categoryId;
      _appDataFuture = AppDataRepository().fetchCategoryData(categoryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    _logger.finest('Building MyHomePage');

    return FutureBuilder<AppData>(
      future: _appDataFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _appData = snapshot.data!;

          List<int> photos;
          switch (_selectedButton) {
            case SelectedButton.newPhotos:
              photos = _appData.newItems;
              break;
            case SelectedButton.top:
              photos = _appData.top;
              break;
            case SelectedButton.favorite:
              photos = _favoritePhotos;
              break;
            default:
              photos = [..._appData.newItems, ..._appData.top];
          }

          return Scaffold(
            key: _scaffoldKey,
            body: PhotosStack(
              photos: photos,
              currentLanguage: _currentLanguage,
              appData: _appData,
              refreshFavoritePhotos: refreshFavoritePhotos,
              selectedButton: _selectedButton,
              scaffoldKey: _scaffoldKey,
              onButtonSelected: (button) => _onButtonSelected(button),
            ),
            drawer: CustomDrawer(
              selectedCategory: _selectedCategoryId,
              onCategorySelected: _onCategorySelected,
              lng: widget.language,
            ),
            endDrawer: _selectedButton == SelectedButton.favorite
                ? SettingsDrawer(favoritePhotos: _favoritePhotos, linkSet: _appData.imagesSetWallpapers,)
                : null,
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(AppLocalizations.of(context).error),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

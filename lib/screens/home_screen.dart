import 'package:flutter/material.dart';
import 'package:flutter_tasks_app/screens/drawers/custom_drawer.dart';
import 'package:flutter_tasks_app/models/app_data_singleton.dart';
import 'package:flutter_tasks_app/screens/wallpapers/list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../gen_l10n/app_localizations.dart';
import 'package:flutter_tasks_app/models/app_data.dart';
import 'package:logging/logging.dart';
import 'package:flutter_svg/svg.dart';

final _logger = Logger('MyHomePage');

// MyHomePage is a StatefulWidget that displays the main screen.
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
  String _selectedCategoryId = '';
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
    });
  }

  // build returns the widget tree for MyHomePage.
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
            body: Stack(
              children: [
                PhotosList(
                  photos: photos,
                  lng: _currentLanguage,
                  appData: _appData,
                  onLikeToggle: refreshFavoritePhotos,
                ),
                Positioned(
                  top: 50,
                  left: 10,
                  child: FloatingActionButton(
                    heroTag: 'menu_fab', // Add a unique hero tag
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    backgroundColor: Colors.transparent,
                    elevation: 20,
                    child: Transform.scale(
                      scale: 1.5, // adjust the scale factor to the desired size
                      child: SvgPicture.asset(
                        'assets/menu/menu_hamburger-01.svg',
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildButton(SelectedButton.newPhotos, AppLocalizations.of(context).menu_najnowsze),
                          const SizedBox(width: 20),
                          _buildButton(SelectedButton.top, AppLocalizations.of(context).menu_najlepsze),
                          const SizedBox(width: 20),
                          _buildButton(SelectedButton.favorite, AppLocalizations.of(context).menu_ulubione),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            drawer: CustomDrawer(
              onCategorySelected: _onCategorySelected,
              lng: widget.language,
            ),
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

  Widget _buildButton(SelectedButton button, String title) {
    return ElevatedButton(
      onPressed: () => _onButtonSelected(button),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          _selectedButton == button ? Colors.blue : Colors.grey,
        ),
      ),
      child: Text(title),
    );
  }
}

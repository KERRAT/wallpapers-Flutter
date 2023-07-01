import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../gen_l10n/app_localizations.dart';
import '../../models/app_data.dart';
import '../../widgets/custom_button.dart';
import '../home_screen.dart';
import 'list.dart';

class PhotosStack extends StatelessWidget {
  final List<int> photos;
  final String currentLanguage;
  final AppData appData;
  final VoidCallback refreshFavoritePhotos;
  final SelectedButton selectedButton;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function(SelectedButton) onButtonSelected; // додаємо цей параметр


  PhotosStack({
    required this.photos,
    required this.currentLanguage,
    required this.appData,
    required this.refreshFavoritePhotos,
    required this.selectedButton,
    required this.scaffoldKey,
    required this.onButtonSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PhotosList(
          photos: photos,
          lng: currentLanguage,
          appData: appData,
          onLikeToggle: refreshFavoritePhotos,
        ),
        Positioned(
          top: 50,
          left: 10,
          child: FloatingActionButton(
            heroTag: 'menu_fab', // Add a unique hero tag
            onPressed: () {
              scaffoldKey.currentState?.openDrawer();
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
        if (selectedButton == SelectedButton.favorite)
          Positioned(
            top: 50,
            right: 10,
            child: FloatingActionButton(
              heroTag: 'end_drawer_fab', // Add a unique hero tag
              onPressed: () {
                scaffoldKey.currentState?.openEndDrawer();
              },
              backgroundColor: Colors.transparent,
              elevation: 20,
              child: const Icon(Icons.menu, size: 36.0), // Your drawer icon
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
                  CustomButton(
                    button: SelectedButton.newPhotos,
                    title: AppLocalizations.of(context).menu_najnowsze,
                    selectedButton: selectedButton,
                    onButtonSelected: (button) => onButtonSelected(button),
                  ),
                  const SizedBox(width: 20),
                  CustomButton(
                    button: SelectedButton.top,
                    title: AppLocalizations.of(context).menu_najlepsze,
                    selectedButton: selectedButton,
                    onButtonSelected: (button) => onButtonSelected(button),
                  ),
                  const SizedBox(width: 20),
                  CustomButton(
                    button: SelectedButton.favorite,
                    title: AppLocalizations.of(context).menu_ulubione,
                    selectedButton: selectedButton,
                    onButtonSelected: (button) => onButtonSelected(button),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

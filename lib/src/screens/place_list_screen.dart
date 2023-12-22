import 'package:favorite_place_apps/src/models/favorite_place.dart';
import 'package:favorite_place_apps/src/providers/place_provider.dart';
import 'package:favorite_place_apps/src/screens/add_new_place.dart';
import 'package:favorite_place_apps/src/screens/place_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favorite_place_apps/src/util/barrel.dart';

class PlaceListScreen extends ConsumerStatefulWidget {
  const PlaceListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _PlaceListScreen();
  }
}

class _PlaceListScreen extends ConsumerState<PlaceListScreen> {
  @override
  Widget build(BuildContext context) {
    final places = ref.watch(favoritePlaceProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Place"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => AddPlaceScreen(),
                ),
              );
            },
            icon: Icon(
              Icons.add,
            ),
          )
        ],
      ),
      body: places.isEmpty ? _noItem() : _itemList(places),
    );
  }

  Widget _noItem() {
    return const Center(
      child: Text(
        "No Favortite Items",
      ),
    );
  }

  Widget _itemList(List<FavoritePlace> places) {
    return ListView.builder(
        itemCount: places.length,
        itemBuilder: (ctx, idx) {
          return Dismissible(
            onDismissed: (_) {
              var item = places[idx];
              ref.read(favoritePlaceProvider.notifier).removeFavortiePlace(item);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${item.name} has been removed"),
                  action: SnackBarAction(
                    label: "Undo",
                    onPressed: () {
                      setState(() {
                        ref.read(favoritePlaceProvider.notifier).addFavoritePlaceToIndex(item, idx);
                      });
                    },
                  ),
                ),
              );
            },
            key: UniqueKey(),
            background: Container(
              color: Theme.of(context).colorScheme.onError,
              child: const Icon(Icons.delete),
            ),
            child: ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => PlaceDetails(
                      place: places[idx],
                    ),
                  ),
                );
              },
              leading: CircleAvatar(
                radius: 26,
                backgroundImage: FileImage(places[idx].image),
              ),
              title: Text(places[idx].name),
              subtitle: Text(places[idx].category.name.capitalizeFirstLetter()),
            ),
          );
        });
  }
}

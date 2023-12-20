import 'package:favorite_place_apps/src/models/favorite_place.dart';
import 'package:riverpod/riverpod.dart';

class PlaceNotifier extends StateNotifier<List<FavoritePlace>> {
  PlaceNotifier() : super([]);

  void addFavoritePlace(FavoritePlace place) {
    state = [place, ...state];
  }

  void addFavoritePlaceToIndex(FavoritePlace place, int idx) {
    var tmp = state;
    tmp.insert(idx, place);
    state = tmp;
  }

  void removeFavortiePlace(FavoritePlace place) {
    var tmp = state;
    state = [];
    tmp.remove(place);
    state = tmp;
  }
}

final favoritePlaceProvider =
    StateNotifierProvider<PlaceNotifier, List<FavoritePlace>>((ref) => PlaceNotifier());

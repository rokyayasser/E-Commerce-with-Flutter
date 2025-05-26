import 'package:bloc/bloc.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(FavoritesInitial());

  final Set<int> _favoriteProductIds = {};

  void toggleFavoriteStatus(int productId) {
    if (_favoriteProductIds.contains(productId)) {
      _favoriteProductIds.remove(productId);
    } else {
      _favoriteProductIds.add(productId);
    }
    emit(FavoritesUpdated(List.from(_favoriteProductIds)));
  }

  bool isFavorite(int productId) {
    return _favoriteProductIds.contains(productId);
  }

  List<int> get favoriteProductIds => List.from(_favoriteProductIds);
}

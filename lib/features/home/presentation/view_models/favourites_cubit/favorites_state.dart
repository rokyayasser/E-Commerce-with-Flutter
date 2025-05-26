part of 'favorites_cubit.dart';


abstract class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class FavoritesUpdated extends FavoritesState {
  final List<int> favoriteProductIds;

  FavoritesUpdated(this.favoriteProductIds);
}
part of 'search_location_bloc.dart';

@immutable
sealed class SearchLocationEvent {}

class LoadRecentSearch extends SearchLocationEvent {
}

class SaveRecentSearch extends SearchLocationEvent {
  final List<String> recentSearches;
  SaveRecentSearch(this.recentSearches);
}

class CurrentLocationLoaded extends SearchLocationEvent {
}

class SearchByName extends SearchLocationEvent {
  final String query;

  SearchByName(this.query);
}

class OnMapMoved extends SearchLocationEvent {
  final MapPosition position;
  OnMapMoved(this.position);
}

class OnTapMap extends SearchLocationEvent {
  final LatLng point;
  OnTapMap(this.point);
}

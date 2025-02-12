part of 'search_location_bloc.dart';

class SearchLocationState {
  final LatLng? location;
  List<String>? searches = [];
  String? errorMessage = '';
  final bool isLoading;

  SearchLocationState({this.location, this.isLoading = false, this.searches, this.errorMessage});
}

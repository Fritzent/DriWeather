import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'search_location_event.dart';
part 'search_location_state.dart';

class SearchLocationBloc
    extends Bloc<SearchLocationEvent, SearchLocationState> {
  final MapController mapController;
  final AnimationController animationController;
  SearchLocationBloc(
      {required this.mapController, required this.animationController})
      : super(SearchLocationState()) {
    on<LoadRecentSearch>(onLoadRecentSearch);
    on<SaveRecentSearch>(onSaveRecentSearch);
    on<CurrentLocationLoaded>(onCurrentLocationLoaded);
    on<SearchByName>(onSearchByName);
    on<OnMapMoved>(onMapMoved);
    on<OnTapMap>(onTapMap);
  }

  FutureOr<void> onLoadRecentSearch(
      LoadRecentSearch event, Emitter<SearchLocationState> emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> searches = prefs.getStringList('recentSearches') ?? [];
    emit(SearchLocationState(searches: searches));
    animationController.forward();
  }

  FutureOr<void> onSaveRecentSearch(
      SaveRecentSearch event, Emitter<SearchLocationState> emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('recentSearches', event.recentSearches);
    emit(SearchLocationState(searches: event.recentSearches));
  }

  FutureOr<void> onCurrentLocationLoaded(
      CurrentLocationLoaded event, Emitter<SearchLocationState> emit) async {
    Position position = await Geolocator.getCurrentPosition();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String checkLatLng = prefs.getString('latLng') ?? '';

    if (checkLatLng.isNotEmpty) {
      List<String> latLngParts = checkLatLng.split(',');
        double latitude = double.parse(latLngParts[0]);
        double longitude = double.parse(latLngParts[1]);
      
      emit(SearchLocationState(
        location: LatLng(latitude, longitude)));
    } else {
      String latLngString = '${position.latitude},${position.longitude}';
      await prefs.setString('latLng', latLngString);

      emit(SearchLocationState(
        location: LatLng(position.latitude, position.longitude)));
    }
  }

  FutureOr<void> onSearchByName(
      SearchByName event, Emitter<SearchLocationState> emit) async {
    try {
      Dio dio = Dio();
      final response = await dio.get(
          'https://nominatim.openstreetmap.org/search',
          queryParameters: {'q': event.query, 'format': 'json'});

      if (response.data.isNotEmpty) {
        var result = response.data[0];
        LatLng location =
            LatLng(double.parse(result['lat']), double.parse(result['lon']));
        SharedPreferences prefs = await SharedPreferences.getInstance();
        List<String> recentSearches =
            prefs.getStringList('recentSearches') ?? [];
        if (!recentSearches.contains(event.query)) {
          recentSearches.insert(0, event.query);
          prefs.setStringList('recentSearches', recentSearches);

          String latLngString = '${location.latitude},${location.longitude}';
          await prefs.setString('latLng', latLngString);
        }

        emit(SearchLocationState(location: location, searches: recentSearches));
      } else {
        emit(SearchLocationState(errorMessage: "No results found"));
      }
    } catch (e) {
      emit(SearchLocationState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> onMapMoved(
      OnMapMoved event, Emitter<SearchLocationState> emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String latLngString =
        '${event.position.center?.latitude},${event.position.center?.longitude}';
    await prefs.setString('latLng', latLngString);
    emit(SearchLocationState(location: event.position.center));
  }

  FutureOr<void> onTapMap(
      OnTapMap event, Emitter<SearchLocationState> emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String latLngString = '${event.point.latitude},${event.point.longitude}';
    await prefs.setString('latLng', latLngString);
    emit(SearchLocationState(location: event.point));
  }
}

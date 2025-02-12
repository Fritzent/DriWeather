import 'package:andri_driweather/bloc/search_location_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import '../resources/style_config.dart';

class SearchLocationPage extends StatefulWidget {
  const SearchLocationPage({super.key});

  @override
  SearchLocationPageState createState() => SearchLocationPageState();
}

class SearchLocationPageState extends State<SearchLocationPage>
    with SingleTickerProviderStateMixin {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _showRecentSearches = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late SearchLocationBloc blocSearchLocation;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _searchFocusNode.addListener(() {
      setState(() {
        _showRecentSearches = _searchFocusNode.hasFocus;
      });
    });
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    blocSearchLocation = SearchLocationBloc(
        mapController: _mapController,
        animationController: _animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location services are disabled")));
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return;
      }
    }
    blocSearchLocation.add(CurrentLocationLoaded());
  }

  _onMapMoved(MapPosition position, bool hasGesture) {
    if (hasGesture) {
      blocSearchLocation.add(OnMapMoved(position));
    }
    if (blocSearchLocation.state.location != null) {
      _mapController.move(blocSearchLocation.state.location!, 14.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => blocSearchLocation..add(LoadRecentSearch()),
      child: BlocListener<SearchLocationBloc, SearchLocationState>(
        listener: (context, state) {
          if (state.location != null) {
            _mapController.move(state.location!, 14.0);
          }
        },
        child: BlocBuilder<SearchLocationBloc, SearchLocationState>(
          builder: (context, state) {
            return Scaffold(
              body: Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter:
                          blocSearchLocation.state.location ?? LatLng(0.0, 0.0),
                      initialZoom: 12,
                      onPositionChanged: _onMapMoved,
                      onTap: (_, point) =>
                          blocSearchLocation.add(OnTapMap(point)),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c'],
                      ),
                      if (blocSearchLocation.state.location != null)
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: blocSearchLocation.state.location!,
                              child: const Icon(
                                Icons.location_pin,
                                color: Colors.red,
                                size: 40,
                              ),
                            )
                          ],
                        ),
                    ],
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 30,
                          right: 30,
                          top: FontList.font36 +
                              MediaQuery.of(context).padding.top,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              textAlign: TextAlign.start,
                              focusNode: _searchFocusNode,
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search here',
                                hintStyle: GoogleFonts.overpass(
                                    fontSize: FontList.font18,
                                    fontWeight: FontWeight.w400,
                                    color: ColorList.grayColor),
                                filled: true,
                                fillColor: ColorList.whiteColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: ColorList.whiteColor,
                                    width: 2.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: ColorList.grayColor,
                                    width: 1.0,
                                  ),
                                ),
                                prefixIcon: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context,
                                        blocSearchLocation.state.location);
                                  },
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: ColorList.blueColor,
                                    size: 24.0,
                                  ),
                                ),
                              ),
                              onSubmitted: (value) {
                                blocSearchLocation.add(SearchByName(value));
                                _searchFocusNode.unfocus();
                              },
                            ),
                            const SizedBox(height: 41),
                            Visibility(
                              visible: _showRecentSearches,
                              child: FadeTransition(
                                opacity: _fadeAnimation,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (blocSearchLocation.state.searches !=
                                          null)
                                        Text(
                                          'Recent Search',
                                          style: GoogleFonts.overpass(
                                            fontSize: FontList.font14,
                                            fontWeight: FontWeight.w700,
                                            color: ColorList.blueColor,
                                          ),
                                        ),
                                      if (blocSearchLocation.state.searches !=
                                          null)
                                        ...blocSearchLocation.state.searches
                                                ?.map((search) => ListTile(
                                                      titleAlignment:
                                                          ListTileTitleAlignment
                                                              .center,
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              right: 8,
                                                              bottom: 0,
                                                              top: 0),
                                                      leading: SvgPicture.asset(
                                                        'assets/icons/clock line.svg',
                                                        width: 24,
                                                      ),
                                                      title: Text(
                                                        search,
                                                        style: GoogleFonts
                                                            .overpass(
                                                                fontSize:
                                                                    FontList
                                                                        .font18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: ColorList
                                                                    .blueColor),
                                                      ),
                                                      onTap: () {
                                                        blocSearchLocation.add(
                                                            SearchByName(
                                                                search));
                                                        _searchFocusNode
                                                            .unfocus();
                                                      },
                                                    ))
                                                .toList() ??
                                            [],
                                    ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 36,
                    right: 36,
                    child: ElevatedButton(
                      onPressed: _getCurrentLocation,
                      child: SvgPicture.asset(
                        'assets/icons/focus.svg',
                        height: FontList.font24,
                        width: FontList.font24,
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

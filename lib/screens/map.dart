import 'package:favorite_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.location = const PlaceLocation(
      latitude: 37.422,
      longitude: -122.0484,
      address: "",
    ),
    this.isSelecting = true,
  });

  final PlaceLocation location;
  final bool isSelecting;

  @override
  State<MapScreen> createState() {
    return _MapScreenState();
  }
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isSelecting == true ? "Pick a location" : "Pictures location",
        ),
        actions: [
          if (widget.isSelecting)
            IconButton(
              onPressed: () {
                Navigator.of(context).pop(_pickedLocation);
              },
              icon: const Icon(Icons.save_rounded),
            ),
        ],
      ),
      body: Center(
          child: Stack(
        children: <Widget>[
          FlutterMap(
            options: MapOptions(
                onTap: (tapPosition, latLng) {
                  if (widget.isSelecting) {
                    setState(() {
                      _pickedLocation = latLng;
                    });
                  }
                },
                initialCenter:
                    LatLng(widget.location.latitude!, widget.location.longitude!),
                initialZoom: 13.0),
            children: [
              TileLayer(
                urlTemplate: "https://api.tomtom.com/map/1/tile/basic/main/"
                    "{z}/{x}/{y}.png?key={apiKey}",
                additionalOptions: const {
                  "apiKey": "GoSxhkyxXUqY6LXznLBJcmwqkyLA0AnE"
                },
              ),
              MarkerLayer(
                markers: (_pickedLocation == null && widget.isSelecting)
                    ? []
                    : [
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point: _pickedLocation ??
                              LatLng(widget.location.latitude!,
                                  widget.location.longitude!),
                          child: const Icon(Icons.location_on,
                              size: 60.0, color: Colors.red),
                        ),
                      ],
              ),
            ],
          )
        ],
      )),
    );
  }
}

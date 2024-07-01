import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/map.dart';
import 'package:flutter/material.dart';

class LocationImage extends StatefulWidget {
  const LocationImage({super.key, required this.place});

  final Place place;

  @override
  State<LocationImage> createState() => _LocationImageState();
}

class _LocationImageState extends State<LocationImage> {
  String get locationImage {
    if (widget.place.location != null) {
      final lat = widget.place.location!.latitude;
      final lng = widget.place.location!.longitude;
      return "https://api.tomtom.com/map/1/staticimage?key=GoSxhkyxXUqY6LXznLBJcmwqkyLA0AnE&center=$lng,$lat&zoom=14&height=160";
    }
    throw "Error: No location provided!";
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = widget.place.location != null
        ? GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => MapScreen(
                  location: widget.place.location!,
                  isSelecting: false,
                ),
              ),
            ),
            child: Image(
              image: NetworkImage(locationImage),
              fit: BoxFit.cover,
            ),
          )
        : Text(
            "No location chosen",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Theme.of(context).colorScheme.primary),
          );

    return Column(
      children: [
        Container(
          height: 160.0,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              width: 1.5,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: previewContent,
          ),
        ),
      ],
    );
  }
}

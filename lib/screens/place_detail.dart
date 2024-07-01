import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/widgets/edit_place.dart';
import 'package:favorite_places/widgets/location_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlaceDetails extends StatefulWidget {
  const PlaceDetails({super.key, required this.place});
  final Place place;

  @override
  State<PlaceDetails> createState() => _PlaceDetailsState();
}

class _PlaceDetailsState extends State<PlaceDetails> {
  List<Widget> imageCheck() {
    if (widget.place.image != null) {
      return [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: kIsWeb
              ? Image.memory(
                  widget.place.imageWeb!,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                )
              : Image.file(
                  widget.place.image!,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  widget.place.imageWeb = null;
                  widget.place.image = null;
                });
              },
              child: const Icon(Icons.delete_rounded),
            ),
          ),
        )
      ];
    } else {
      return [
        Text(
          "No image attached to this place",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.place.name),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                TextButton(
                  onPressed: () async {
                    await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditItem(place: widget.place),
                    ));
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          widget.place.name,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      const Icon(Icons.edit_rounded),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                Container(
                  width: double.infinity,
                  height: 250,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      width: 1.5,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  child: Stack(children: imageCheck()),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                LocationImage(place: widget.place),
                const SizedBox(
                  height: 24.0,
                ),
                widget.place.location == null
                    ? Text(
                        "Address: -",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      )
                    : Text(
                        "Address: ${widget.place.location!.address}",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

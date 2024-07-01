import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/providers/user_places.dart';
import 'package:favorite_places/screens/place_detail.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesList extends ConsumerStatefulWidget {
  const PlacesList({super.key, required this.placeList});

  final List<Place> placeList;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlacesListState();
}

class _PlacesListState extends ConsumerState<PlacesList> {
  Uint8List? image;

  ImageProvider<Object>? getImage(int index) {
    print(ref.read(userPlacesProvider)[index].image);
    if (ref.read(userPlacesProvider)[index].image == null) {
      return Image.asset("assets/Icon-location.png")
          .image; // const AssetImage("assets/Icon-location.png")
    } else {
      if (!kIsWeb) {
        return FileImage(ref.read(userPlacesProvider)[index].image!);
      } else {
        image = ref.read(userPlacesProvider)[index].imageWeb!;
        return Image.memory(image!).image;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.placeList.isEmpty) {
      return Center(
        child: Text(
          "No places available!",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      );
    } else {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
        itemCount: widget.placeList.length,
        itemBuilder: (context, index) {
          final location = widget.placeList[index].location;
          return Column(
            children: [
              ListTile(
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return PlaceDetails(
                          place: ref.watch(userPlacesProvider)[index],
                        );
                      },
                    ),
                  );
                  setState(() {});
                },
                leading: CircleAvatar(
                  radius: 26,
                  backgroundImage: getImage(index),
                ),
                title: Text(widget.placeList[index].name),
                subtitle: location != null
                    ? Text(
                        location.address!,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: Theme.of(context).colorScheme.primary),
                      )
                    : Text(
                        "No location available!",
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: Theme.of(context).colorScheme.primary),
                      ),
              ),
              const Divider(
                indent: 24,
                endIndent: 24,
              ),
            ],
          );
        },
      );
    }
  }
}

import 'package:favorite_places/data/places_list.dart';
import 'package:favorite_places/providers/user_places.dart';
import 'package:favorite_places/screens/add_new_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FrontPage extends ConsumerStatefulWidget {
  const FrontPage({super.key});

  @override
  ConsumerState<FrontPage> createState() {
    return _FrontPageState();
  }
}

class _FrontPageState extends ConsumerState<FrontPage> {
  late Future<void> _placesFuture;

  @override
  void initState() {
    super.initState();
    _placesFuture = ref.read(userPlacesProvider.notifier).loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("favorite places"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddNewItem(),
                ),
              );
            },
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: FutureBuilder(
          future: _placesFuture,
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : PlacesList(placeList: ref.watch(userPlacesProvider)),
        ),
      ),
    );
  }
}

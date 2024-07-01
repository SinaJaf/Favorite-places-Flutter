import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/providers/user_places.dart';
import 'package:favorite_places/widgets/image_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditItem extends ConsumerWidget {
  EditItem({super.key, required this.place});
  final _fromKey = GlobalKey<FormState>();
  final Place place;

  void _savePlace() {
    if (_fromKey.currentState!.validate()) {
      return;
    } else {
      _fromKey.currentState!.save();
    }
  }

  String? _isFormValid(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => Center(
          child: Padding(
            padding: const EdgeInsets.all(38.0),
            child: Container(
              padding: const EdgeInsets.all(18.0),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12.0)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.red,
                    size: 32,
                  ),
                  const SizedBox(
                    width: 16.0,
                  ),
                  Text(
                    "Error: Invalid input!",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      throw "Error: Invalid input";
    } else {
      return value;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add item"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 16.0,
        ),
        child: Column(
          children: [
            Form(
              key: _fromKey,
              child: TextFormField(
                initialValue: place.name,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                decoration: const InputDecoration(
                  label: Text("Place name"),
                ),
                onSaved: (newPlace) => {
                  ref
                      .watch(
                        userPlacesProvider.notifier,
                      )
                      .updatePlace(
                        place,
                        Place(
                          name: newPlace!,
                          image: place.image,
                          imageWeb: place.imageWeb,
                          location: place.location,
                        ),
                      ),
                },
                validator: (value) => _isFormValid(context, value),
              ),
            ),
            const SizedBox(
              height: 24.0,
            ),
            ImageInput(
              onSelectedImage: (image, imageWeb) {
                place.imageWeb = imageWeb;
                place.image = image;
              },
            ),
            const SizedBox(
              height: 24.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _savePlace();
                    Navigator.of(context).pop();
                  },
                  child: const Text("Add item"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

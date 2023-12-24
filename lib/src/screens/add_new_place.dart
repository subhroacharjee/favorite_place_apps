import 'dart:io';

import 'package:favorite_place_apps/src/components/image_input.dart';
import 'package:favorite_place_apps/src/components/location_input.dart';
import 'package:favorite_place_apps/src/models/favorite_place.dart';
import 'package:favorite_place_apps/src/providers/place_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favorite_place_apps/src/util/string_extensions.dart';
import 'package:uuid/v4.dart';

class AddPlaceScreen extends ConsumerWidget {
  final gKey = GlobalKey<FormState>();
  late String _name;
  PlaceCategory _category = PlaceCategory.home;
  File? _selectedImage;
  PlaceLocation? _selctedLocation;

  void _save(BuildContext context, WidgetRef ref) {
    if (!gKey.currentState!.validate()) return;
    gKey.currentState!.save();
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("image is required"),
        ),
      );
      return;
    }
    if (_selctedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("location is required"),
        ),
      );
      return;
    }
    final newPlace = FavoritePlace(
      id: const UuidV4().toString(),
      name: _name,
      category: _category,
      image: _selectedImage!,
      location: _selctedLocation!,
    );
    ref.read(favoritePlaceProvider.notifier).addFavoritePlace(newPlace);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Favorite Place"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: gKey,
          child: Column(
            children: [
              _TextFormField(
                value: "Name",
                validate: (val) => val == null || val.isEmpty || val.trim().isEmpty,
                onSave: (value) => _name = value!.capitalizeFirstLetter(),
              ),
              const SizedBox(
                height: 15,
              ),
              _TDropDownButtonForm(
                selectedCategory: _category,
                onChanged: (cat) {
                  _category = cat;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              ImageInput(
                setImage: (file) {
                  _selectedImage = file;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              LocationInput(setLocation: (place) {
                _selctedLocation = place;
              }),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      gKey.currentState!.reset();
                    },
                    child: const Text("Reset"),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _save(context, ref);
                    },
                    child: const Text("Add"),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _TextFormField extends StatelessWidget {
  const _TextFormField({
    super.key,
    required this.value,
    required this.validate,
    this.isSring = true,
    required this.onSave,
  });
  final String value;
  final bool Function(String?) validate;
  final bool isSring;
  final void Function(String?) onSave;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: 50,
      keyboardType: isSring ? TextInputType.text : TextInputType.number,
      onSaved: onSave,
      decoration: InputDecoration(
        label: Text(
          this.value,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 3, color: Theme.of(context).colorScheme.secondary),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 3, color: Theme.of(context).colorScheme.secondary),
        ),
      ),
      validator: (value) {
        if (validate(value)) return 'Invalid input';
        return null;
      },
    );
  }
}

class _TDropDownButtonForm extends StatefulWidget {
  _TDropDownButtonForm({required this.selectedCategory, required this.onChanged});
  PlaceCategory selectedCategory;
  void Function(PlaceCategory) onChanged;
  @override
  State<_TDropDownButtonForm> createState() => _TDropDownButtonFormState();
}

class _TDropDownButtonFormState extends State<_TDropDownButtonForm> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: widget.selectedCategory,
      items: [
        for (final category in PlaceCategory.values)
          DropdownMenuItem(
            value: category,
            child: Row(children: [
              Text(
                category.name.capitalizeFirstLetter(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
            ]),
          )
      ],
      onChanged: (obj) {
        setState(() {
          widget.onChanged(obj!);
          widget.selectedCategory = obj;
        });
      },
      decoration: InputDecoration(
        label: Text(
          "Category",
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 3, color: Theme.of(context).colorScheme.secondary),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 3, color: Theme.of(context).colorScheme.secondary),
        ),
      ),
    );
  }
}

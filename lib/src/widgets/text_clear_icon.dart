import 'package:flutter/material.dart';
import 'package:easy_place_picker/src/providers/search_provider.dart';
import 'package:provider/provider.dart';

class TextClearIcon extends StatelessWidget {
  final void Function() onTap;
  const TextClearIcon({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Selector<SearchProvider, String>(
        selector: (final _, final provider) => provider.searchTerm,
        builder: (final _, final data, final __) {
          if (data.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: onTap,
                child: Icon(
                  Icons.clear,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            );
          } else {
            return const SizedBox(width: 10);
          }
        });
  }
}

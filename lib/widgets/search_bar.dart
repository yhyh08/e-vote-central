import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final void Function(String)? onChanged;

  const SearchBar({
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: TextField(
            style: TextStyle(color: Theme.of(context).primaryColorDark),
            cursorColor: Theme.of(context).primaryColor,
            decoration: InputDecoration(
              suffixIcon: Icon(
                Icons.search_rounded,
                color: Theme.of(context).dialogBackgroundColor,
              ),
              hintText: 'Search...',
              hintStyle: Theme.of(context).textTheme.bodyMedium,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7.0),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7.0),
                borderSide: BorderSide(
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

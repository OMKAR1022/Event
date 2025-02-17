import 'package:flutter/material.dart';
import 'package:mit_event/utils/screen_size.dart';

class SearchBar_student extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const SearchBar_student({
    Key? key,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenSize.height(context,17),
      width: ScreenSize.width(context,1.1),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 1, offset: Offset(-2, 2)),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.blue[700],
          ),
        ),
        child: TextField(
          controller: controller,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: "Search events by title or club...",
            hintStyle: TextStyle(
              color: Colors.black45,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Icon(Icons.search, color: Colors.blue),
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.black45,
                size: 20,
              ),
              onPressed: () {
                controller.clear();
                onChanged('');
              },
            )
                : null,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            fillColor: Colors.transparent, // Set fillColor to transparent
            filled: true, // Ensure filled is true
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}


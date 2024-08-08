import 'package:flutter/material.dart';

Widget searchFieldNew({TextEditingController? controller,Function(String? val)? onChange}) {
  // final controller = TextEditingController();
  return Container(
    // height: 21,
     padding: const EdgeInsets.only(
                              left: 16, right: 16, bottom: 30),
    child: TextField(
      onChanged: onChange,
      controller: controller,
      maxLines: 1,
      decoration: InputDecoration(
        fillColor: Colors.white,
        isDense: true,
        contentPadding: const EdgeInsets.all(15),
        filled: true,
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
            borderSide: BorderSide(color: Colors.white)),
        hintText: "Search..",
        suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              child: const Icon(
                Icons.search,
              ),
            )),
        hintStyle:  TextStyle(color: Colors.grey.shade400),
      ),
    ),
  );
}

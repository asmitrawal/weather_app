// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomSearchTile extends StatelessWidget {
  final String cityName;
  final String countryName;
  final void Function()? onTap;
  const CustomSearchTile({
    Key? key,
    required this.cityName,
    required this.countryName,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          title: Text(
            "${cityName}",
            style: TextStyle(fontSize: 14),
          ),
          subtitle: Text(
            "$countryName",
            style: TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
  }
}

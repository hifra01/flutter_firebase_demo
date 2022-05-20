import 'package:flutter/material.dart';

class ProfileSection extends StatefulWidget {
  const ProfileSection({Key? key}) : super(key: key);

  @override
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(48),
      children: [
        Row(
          children: const [Text("Nama:"), Text("Lorem Ipsum")],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
        Row(
          children: const [Text("Email:"), Text("lorem.ipsum@example.com")],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
        Row(
          children: const [Text("User ID:"), Text("qwertyuiop1234")],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
      ],
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/src/pages/login_page.dart';

class ProfileSection extends StatefulWidget {
  const ProfileSection({Key? key}) : super(key: key);

  @override
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  bool _isBusy = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(48),
      children: [
        Row(
          children: [const Text("Nama:"), Text(_user.displayName ?? "null")],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
        Row(
          children: [const Text("Email:"), Text(_user.email ?? "null")],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
        Row(
          children: [const Text("User ID:"), Text(_user.uid)],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
        const SizedBox(
          height: 64,
        ),
        ElevatedButton(
          child: !_isBusy
              ? const Text("Log out")
              : const CircularProgressIndicator(),
          onPressed: () async {
            setState(() {
              _isBusy = true;
            });

            try {
              await _auth.signOut();
              Navigator.pushNamedAndRemoveUntil(
                context,
                LoginPage.routeName,
                (route) => false,
              );
            } on FirebaseException catch (e) {
              setState(() {
                _isBusy = false;
              });
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Terjadi kesalahan'),
                    content: Text(e.message ?? "Terjadi kesalahan"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Tutup"),
                      )
                    ],
                  );
                },
              );
            }
          },
        ),
      ],
    );
  }
}

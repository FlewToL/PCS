import 'package:flutter/material.dart';

class Profile {
  final int id;
  final IconData icon;
  final String title;

  Profile({required this.id, required this.icon, required this.title});
}

class ProfileSettings {
  String name;
  String lastName;
  String phoneNumber;
  String email;
  String img;

  ProfileSettings(
      {required this.name,
      required this.lastName,
      required this.phoneNumber,
      required this.email,
      required this.img
      });
}

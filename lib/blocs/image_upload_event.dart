import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ImageUploadEvent {}

class UploadImageEvent extends ImageUploadEvent {
  File image;
  Map<String, dynamic> value;

  UploadImageEvent(this.image, this.value);
}

class ProfileEditEvent extends ImageUploadEvent {
  File image;
  Map<String, dynamic> value;

  ProfileEditEvent(this.image, this.value);
}

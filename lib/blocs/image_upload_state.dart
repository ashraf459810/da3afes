import 'package:meta/meta.dart';

@immutable
abstract class ImageUploadState {}

class InitialImageUploadState extends ImageUploadState {}

class UploadingState extends ImageUploadState {}

class UploadedState extends ImageUploadState {
  String key;

  UploadedState(this.key);
}

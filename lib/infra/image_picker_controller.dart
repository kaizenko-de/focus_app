import 'dart:typed_data';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerController extends StateNotifier<AsyncValue<Uint8List?>> {
  ImagePickerController(this.ref) : super(const AsyncData(null));
  final Ref ref;

  Future<void> pickImage({
    ImageSource source = ImageSource.gallery,
  }) async {
    state = const AsyncLoading();
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        state = AsyncData(await image.readAsBytes());
      }
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> pickImageCamera({
    ImageSource source = ImageSource.camera,
  }) async {
    state = const AsyncLoading();
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        state = AsyncData(await image.readAsBytes());
      }
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  void removeImage() {
    state = const AsyncData(null);
  }
}

final chooseProfileImagePickerControllerProvider = StateNotifierProvider
    <ImagePickerController, AsyncValue<Uint8List?>>((ref) {
  return ImagePickerController(ref);
});

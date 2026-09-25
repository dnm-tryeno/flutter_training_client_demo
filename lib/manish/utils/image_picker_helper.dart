import 'image_picker_stub.dart'
    if (dart.library.html) 'image_picker_web.dart' as picker;

class ImagePickerHelper {
  /// Pick an image file from local device and return its base64 data URL string
  static Future<String?> pickImage() => picker.pickImageAsBase64();
}

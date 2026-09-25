// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:async';
import 'dart:html' as html;

Future<String?> pickImageAsBase64() async {
  final completer = Completer<String?>();
  final uploadInput = html.FileUploadInputElement()..accept = 'image/*';
  uploadInput.click();

  uploadInput.onChange.listen((e) {
    final files = uploadInput.files;
    if (files != null && files.isNotEmpty) {
      final file = files[0];
      final reader = html.FileReader();
      reader.onLoadEnd.listen((e) {
        completer.complete(reader.result as String?);
      });
      reader.onError.listen((e) {
        completer.complete(null);
      });
      reader.readAsDataUrl(file);
    } else {
      completer.complete(null);
    }
  });

  return completer.future;
}

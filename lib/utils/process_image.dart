import 'package:image/image.dart' as img;

List<List<List<num>>> processImage(dynamic imageData) {
  try {
    final image = img.decodeImage(imageData);

    final imageInput = img.copyResize(
      image!,
      width: 224,
      height: 224,
    );

    final imageMatrix = List.generate(
      imageInput.height,
      (y) => List.generate(
        imageInput.width,
        (x) {
          final pixel = imageInput.getPixel(x, y);
          return [pixel.r, pixel.g, pixel.b];
        },
      ),
    );

    return imageMatrix;
  } catch (error) {
    rethrow;
  }
}

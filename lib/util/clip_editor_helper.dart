import 'package:extended_image/extended_image.dart';
import 'package:image_editor/image_editor.dart';

Future<List<int>> cropImageDataWithNativeLibrary(
    {ExtendedImageEditorState state}) async {
  print("native library start cropping");

  final cropRect = state.getCropRect();
  final action = state.editAction;

  final rotateAngle = action.rotateAngle.toInt();
  final flipHorizontal = action.flipY;
  final flipVertical = action.flipX;
  final img = state.rawImageData;

  ImageEditorOption option = ImageEditorOption();

  if (action.needCrop) option.addOption(ClipOption.fromRect(cropRect));

  if (action.needFlip)
    option.addOption(
        FlipOption(horizontal: flipHorizontal, vertical: flipVertical));

  if (action.hasRotateAngle) option.addOption(RotateOption(rotateAngle));

  final start = DateTime.now();
  final result = await ImageEditor.editImage(
    image: img,
    imageEditorOption: option,
  );

  print("${DateTime.now().difference(start)} ：total time");
  return result;
}

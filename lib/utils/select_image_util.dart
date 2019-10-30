import 'dart:io';

import 'package:image_picker/image_picker.dart';

class SelectImage{

  static Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    return image;
}
}
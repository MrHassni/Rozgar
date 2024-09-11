import 'package:image_picker/image_picker.dart';

pickImage(ImageSource src) async {
  final ImagePicker _pick=  ImagePicker();
  XFile ? _file = await _pick.pickImage(source:src);
  if(_file!=null){
    return await _file.readAsBytes();
  }
  print('No Image Selected!');
}





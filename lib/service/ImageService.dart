import 'dart:io';

import 'package:http/http.dart' as http;

class ImageService{
  
Future<int> submitSubscription({required File file,String? filename})async{
    ///MultiPart request
    var request = http.MultipartRequest(
        'POST', Uri.parse("https://rrnew.easwdb.com/api/UploadImage"),

    );
    Map<String,String> headers={
      "Content-type": "multipart/form-data"
    };
    request.files.add(
        http.MultipartFile(
           'file',
            file.readAsBytes().asStream(),
            file.lengthSync(),
            filename: filename,
            //MediaType('image','jpeg'),
        ),
    );
    request.headers.addAll(headers);
    request.fields.addAll({
      "name":"test",
      "email":"test@gmail.com",
      "id":"12345"
    });
    print("request: "+request.toString());
    var res = await request.send();
    print("This is response:"+res.toString());
    return res.statusCode;
  }
}


import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerController extends GetxController{
  RxString imagePath =''.obs;
  Future getImage()async{
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if(image!=null){
      imagePath.value= image.path.toString();
    }
  }

}
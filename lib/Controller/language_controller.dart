import 'package:get/get.dart';

class LanguageController extends GetxController{
  // ignore: prefer_typing_uninitialized_variables
  var selectedIndex;

  onIndexChange(index){
    selectedIndex=index;
    update();
  }
  // ignore: prefer_typing_uninitialized_variables
  var selectedIndex1;

  onIndexChange1(index){
    selectedIndex1=index;
    update();
  }
}
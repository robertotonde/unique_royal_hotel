// ignore_for_file: prefer_typing_uninitialized_variables, duplicate_ignore, deprecated_member_use

import 'package:evente/evente.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../data/data_file.dart';

class IntroController extends GetxController {
  // ignore: prefer_typing_uninitialized_variables
  var pageController;
  ValueNotifier selectedPage = ValueNotifier(0);
  RxInt select = 0.obs;

  change(RxInt index) {
    select.value = index.value;
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    pageController = PageController();
  }


  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    pageController.disclose;
  }
}

class LoginController extends GetxController {
  // ignore: prefer_typing_uninitialized_variables
  var emailController;
  var passwordController;
  final loginFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }


  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    emailController.disclose;
    passwordController.disclose;
  }

  String? emailvalidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter email address.';
    }
    return null;
  }

  String? passwordvalidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter password.';
    }
    return null;
  }
}

class ForgotController extends GetxController {
  var emailController;
  final forgotFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    emailController = TextEditingController();
  }


  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    emailController.disclose;
  }
}

class ResetController extends GetxController {
  var oldPassController;
  var newPassController;
  var confPassController;
  final resetFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    oldPassController = TextEditingController();
    newPassController = TextEditingController();
    confPassController = TextEditingController();
  }


  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    oldPassController.disclose;
    newPassController.disclose;
    confPassController.disclose;
  }
}

// class SignUpController extends GetxController {
//   var nameController;
//   var emailController;
//   var phoneController;
//   var passwordController;
//   var searchController;

//   RxString image = "flag.png".obs;
//   RxString code = "+1".obs;
//   RxBool check = false.obs;
//   List<ModelCountry> newCountryLists = DataFile.countryList;

//   onItemChanged(String value) {
//     newCountryLists = DataFile.countryList
//         .where((string) =>
//             string.name!.toLowerCase().contains(value.toLowerCase()))
//         .toList();
//     update();
//   }

//   pickImage(String value, String value1) {
//     image.value = value;
//     code.value = value1;
//     update();
//   }

//   onCheck() {
//     check.value = check.value == true ? false : true;
//     update();
//   }

//   String? fullNamevalidator(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter full name.';
//     }
//     return null;
//   }

//   String? emailvalidator(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter email address.';
//     }
//     return null;
//   }

//   String? phonevalidator(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter phone number.';
//     }
//     return null;
//   }

//   String? passwordvalidator(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter password.';
//     }
//     return null;
//   }

//   @override
//   void onInit() {
//     // TODO: implement onInit
//     super.onInit();
//     nameController = TextEditingController();
//     emailController = TextEditingController();
//     phoneController = TextEditingController();
//     passwordController = TextEditingController();
//     searchController = TextEditingController();
//   }


//   @override
//   void onClose() {
//     // TODO: implement onClose
//     super.onClose();
//     nameController.disclose;
//     emailController.disclose;
//     phoneController.disclose;
//     passwordController.disclose;
//     searchController.disclose;
//   }
// }

class HomeController extends GetxController {
  RxInt index = 0.obs;

  onChange(RxInt value) {
    index.value = value.value;
    update();
  }
}


class HomeController2 extends GetxController {
  RxInt index = 0.obs;

  onChange(RxInt value) {
    index.value = value.value;
    update();
  }
}

// class ActivityController extends GetxController {
//   Rx<DateTime> selectDate = DateTime.now().obs;
//   RxInt select = 0.obs;
//   RxInt item = 5.obs;

//   itemChange(RxInt value, RxInt value1) {
//     select.value = value.value;
//     item.value = value1.value;
//     update();
//   }

//   onChange(Rx<DateTime> date) {
//     selectDate.value = date.value;
//     update();
//   }
// }

class HomeScreenController extends GetxController {
  var searchController;
  RxInt select = 0.obs;

  onChange(RxInt value) {
    select.value = value.value;
    update();
  }



  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    searchController = TextEditingController();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    searchController.disclose;
  }
}

class BuyTicketController extends GetxController {
  RxInt select = 0.obs;
  RxInt count = 1.obs;

  countChange(RxInt value) {
    count.value = value.value;
    update();
  }

  onChange(RxInt value) {
    select.value = value.value;
    update();
  }
}

class PaymentController extends GetxController {
  RxInt select = 0.obs;

  onChange(RxInt value) {
    select.value = value.value;
    update();
  }
}

class CreateEventController extends GetxController {
  var eventNameController;
  var addressController;
  var priceController;
  var dateController;
  var startTimeController;
  var endTimeController;
  RxInt select = 0.obs;
  File? image1;
  String? imagePath;
  final _picker = ImagePicker();
  File? image2;
  File? image3;
  File? image4;
  File? image5;

  RxInt index = 0.obs;
  
  onIndexChange(RxInt value) {
    index.value = value.value;
    update();
  }

  onDateChange(RxString value){
    dateController.text = value.value;
    update();
  }

  onStartTimeChange(RxString value){
    startTimeController.text = value.value;
    update();
  }

  onEndTimeChange(RxString value){
    endTimeController.text = value.value;
    update();
  }

  Future<void> pickImage1() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image1 = File(pickedFile.path);
      imagePath = pickedFile.path;

      update();
    } else {}
  }

  Future<void> pickImage2() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image2 = File(pickedFile.path);
      imagePath = pickedFile.path;

      update();
    } else {}
  }

  Future<void> pickImage3() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image3 = File(pickedFile.path);
      imagePath = pickedFile.path;

      update();
    } else {}
  }

  Future<void> pickImage4() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image4 = File(pickedFile.path);
      imagePath = pickedFile.path;

      update();
    } else {}
  }

  Future<void> pickImage5() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image5 = File(pickedFile.path);
      imagePath = pickedFile.path;

      update();
    } else {}
  }

  onChange(RxInt value) {
    select.value = value.value;
    update();
  }

  onImage2Null() {
    image2 = null;
    update();
  }

  onImage3Null() {
    image3 = null;
    update();
  }

  onImage4Null() {
    image4 = null;
    update();
  }

  onImage5Null() {
    image5 = null;
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    eventNameController = TextEditingController();
    addressController = TextEditingController();
    priceController = TextEditingController();
    dateController = TextEditingController();
    startTimeController = TextEditingController();
    endTimeController = TextEditingController();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    eventNameController.disclose;
    addressController.disclose;
    priceController.disclose;
    dateController.disclose;
    startTimeController.disclose;
    endTimeController.disclose;
  }
}

class EditProfileController extends GetxController {
  var fullnameController;
  var emailController;
  var dateController;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fullnameController = TextEditingController();
    emailController = TextEditingController();
    dateController = TextEditingController();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    fullnameController.disclose;
    emailController.disclose;
    dateController.disclose;
  }
}

class EditCardController extends GetxController {
  var cardNameController;
  var cardNumberController;
  var dateController;
  var cvvController;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    cardNameController = TextEditingController();
    cardNumberController = TextEditingController();
    dateController = TextEditingController();
    cvvController = TextEditingController();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    cardNameController.disclose;
    cardNumberController.disclose;
    dateController.disclose;
    cvvController.disclose;
  }
}

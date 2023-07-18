import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePageScreen extends StatefulWidget {
  const ProfilePageScreen({super.key});

  @override
  State<ProfilePageScreen> createState() => _ProfilePageScreenState();
}

class _ProfilePageScreenState extends State<ProfilePageScreen> {

  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final nameController = TextEditingController();

  final phoneNumberController = TextEditingController();

  String imageUrl =
      "https://www.simplilearn.com/ice9/free_resources_article_thumb/what_is_image_Processing.jpg";

  File? imageFile;

  @override
  void initState() {
    super.initState();
    getUserDataFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              const SizedBox(height: 20),
              InkWell(
                onTap: () => selectImage(),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    imageFile == null
                        ? CircleAvatar(
                      backgroundImage: NetworkImage(imageUrl),
                      radius: 45,
                    )
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.file(
                        imageFile!,
                        height: 100,
                        width: 100,
                        fit: BoxFit.fill,
                      ),
                    ),
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.black,
                          size: 15,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: nameController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.person,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: emailController,
                enabled: false,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.email,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: phoneNumberController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.phone,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: MaterialButton(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  onPressed: () => updateProfile(),
                  child: const Text(
                    "Update",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  updateProfile() {
    Navigator.pop(context);
  }

  void getUserDataFromFirestore() {
    String userId = auth.currentUser!.uid;

    firestore
        .collection("quizUsers")
        .doc(userId)
        .get()
        .then((value) => updateUi(value.data()!))
        .catchError((error) => Fluttertoast.showToast(msg: error.toString()));
  }

  void updateUi(Map<String, dynamic> data) {
    nameController.text = data['name'];
    emailController.text = data['email'];
    phoneNumberController.text = data['phone'];

    if (data.containsKey("imageUrl")) {
      imageUrl = data['imageUrl'];
      setState(() {});
    }
  }


  selectImage() async {
    final ImagePicker picker = ImagePicker();

    await picker.pickImage(source: ImageSource.gallery).then((image) {
      imageFile = File(image!.path);

      uploadImage();

      setState(() {});
    }).catchError((error) {
      Fluttertoast.showToast(msg: error.toString());
    });
  }

  void uploadImage() {
    String userId = auth.currentUser!.uid;

    storage.ref("profileImages/$userId.png").putFile(imageFile!).then((p0) {
      print('IMAGE UPLOADED!');
      getImageUrl();
    }).catchError((error) {
      Fluttertoast.showToast(msg: error.toString());
    });
  }

  void getImageUrl() {
    String userId = auth.currentUser!.uid;

    storage.ref("profileImages/$userId.png").getDownloadURL().then((imageUrl) {
      print(imageUrl);
      saveImageUrl(imageUrl);
    }).catchError((error) {
      Fluttertoast.showToast(msg: error.toString());
    });
  }

  void saveImageUrl(String imageUrl) {
    String userId = auth.currentUser!.uid;

    Map<String, dynamic> data = {
      "imageUrl": imageUrl,
    };

    firestore
        .collection("quizUsers")
        .doc(userId)
        .update(data)
        .then((imageUrl) {})
        .catchError((error) {
      Fluttertoast.showToast(msg: error.toString());
    });
  }
}


import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class RegisterData {
  String email;
  String password;
  String confirmPassword;
  String userName;
  String motive;

  RegisterData(this.email, this.password, this.confirmPassword, this.userName,
      this.motive);

  static createEmptyRegisterData() {
    return RegisterData('', '', '', '', '');
  }

  static RegisterUser(
      BuildContext context, RegisterData data, dynamic imageFile) async {
    if (data.password != data.confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password and Confirm Password are not the same'),
        ),
      );
      return false;
    }
    // Firebase Authentication
    try {
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: data.email, password: data.password);
      await FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(user.user!.uid)
          .set({
        'email': data.email,
        'userName': data.userName,
        'motive': data.motive,
      });
      if (kIsWeb) {
        if (imageFile != null) {
          // TODO: Upload image to Firebase Storage
          SettableMetadata metadata = SettableMetadata(
            contentType: 'image/jpeg',
          );
          // TaskSnapshot image= await FirebaseStorage.instance
          //     .ref('userProfile/${user.user!.uid}')
          //     .putData(imageBytes,
          //     metadata);
          Uint8List imageByte = imageFile as Uint8List;
          final storage = FirebaseStorage.instance;
          final storageRef = storage.ref();
          final image = storageRef.child('userProfile/${user.user!.uid}.jpg');
          final uploadTask = await image.putData(imageByte, metadata);
          final downloadURL = await uploadTask.ref.getDownloadURL();
          await user.user!.updatePhotoURL(downloadURL);
        }
      } else {
        if (imageFile != null) {
          await user.user!.updatePhotoURL(imageFile);
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'User successfully registered',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      return true;
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('The password provided is too weak.'),
            ),
          );
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('The account already exists for that email.'),
            ),
          );
        } else {
          String error = e.message.toString();
          error = error.substring(
              error.indexOf('Firebase:') + 10, error.indexOf('('));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text('Error: $error'),
            ),
          );
        }
      }
      return false;
    }
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  File? _image;
  Uint8List? _webImage = Uint8List(8);

  Future<void> _pickImage(ImageSource source) async {
    // check the platform of the device
    if (kIsWeb) {
      // ignore: invalid_use_of_visible_for_testing_member
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        var f = await pickedImage.readAsBytes();
        setState(() {
          _webImage = f;
          _image = File('a');
        });
      }
    } else {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        setState(() {
          _image = File(pickedImage.path);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    RegisterData registerData = RegisterData.createEmptyRegisterData();

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Sign Up',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Upload Image'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.photo_library),
                              title: Text('Photo Library'),
                              onTap: () {
                                _pickImage(ImageSource.gallery);
                                Navigator.of(context).pop();
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.camera_alt),
                              title: Text('Camera'),
                              onTap: () {
                                _pickImage(ImageSource.camera);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: Container(
                  width: 200,
                  height: 200,
                  constraints: const BoxConstraints(
                    maxWidth: 250,
                    maxHeight: 400,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(150),
                    color: Colors.grey[300],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _image != null
                          ? kIsWeb
                              ? CircleAvatar(
                                  radius: 100,
                                  backgroundImage: MemoryImage(_webImage!),
                                )
                              : CircleAvatar(
                                  radius: 100,
                                  backgroundImage: FileImage(_image!),
                                )
                          : const Column(
                          children: [
                            Icon(
                              Icons.camera,
                              size: 50,
                              color: Colors.grey,
                            ),
                            Text(
                              'Upload Photo',
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 20),
                            ),
                          ],
                      ),
                    ],
                  ))),
          Padding(
            padding: const EdgeInsets.all(80),
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter your Name',
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    registerData.userName = value;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter your email',
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    registerData.email = value;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                      hintText: 'Enter your password',
                      labelText: 'Password',
                      border: OutlineInputBorder()),
                  onChanged: (value) {
                    registerData.password = value;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  // Hide the password character
                  obscureText: true,
                  decoration: const InputDecoration(
                      hintText: 'Enter your password again',
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder()),
                  onChanged: (value) {
                    registerData.confirmPassword = value;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  minLines: 3,
                  maxLines: 4,
                  decoration: const InputDecoration(
                      hintText: 'Enter your Motive',
                      labelText: 'Your Motive',
                      border: OutlineInputBorder()),
                  onChanged: (value) {
                    registerData.motive = value;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          if (kIsWeb) {
                            if (await RegisterData.RegisterUser(
                                context, registerData, _webImage)) {
                              Navigator.pushReplacementNamed(context, '/home');
                            }
                          } else {
                            if (await RegisterData.RegisterUser(
                                context, registerData, _image)) {
                              Navigator.pushReplacementNamed(context, '/home');
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 100, vertical: 20),
                        ),
                        child: const Text('Register')),
                    SizedBox(
                      height: 20,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 20),
                        ),
                        child: const Text('Already have an account? Login')),
                  ],
                )
              ],
            ),
          ),
        ],
      )),
    );
  }
}

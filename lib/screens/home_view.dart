import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  State<Home> createState() => _HomeState();
  File? _selectedImage;

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Select Profile Photo',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: _selectedImage != null
                        ? Image.file(
                            _selectedImage!,
                            fit: BoxFit.fill,
                          )
                        : Image.network(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQrxMNkq9COMgaR8ikKTfjVHoAHcOdydsBHoQ&s'),
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 150,
                                child: Column(
                                  children: [
                                    ListTile(
                                        leading:
                                            Icon(Icons.camera_alt_outlined),
                                        title: Text(
                                          "Capture from camera",
                                        ),
                                        onTap: () {
                                          _pickImageFromCamera();

                                          Navigator.pop(context);
                                        }),
                                    Divider(
                                      height: 5,
                                      thickness: 2,
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.photo_album_outlined),
                                      title: Text("Take photo from Gallery"),
                                      onTap: () {
                                        _pickImageFromGallery();
                                      },
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    child: Text("Choose image")),
                SizedBox(height: 30),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedImage = null;
                      });
                    },
                    child: Text(
                      "Remove image",
                      style: TextStyle(color: Colors.red),
                    )),
                SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Colors.black,
                  )),
                  width: 300,
                  height: 300,
                  child: _selectedImage != null
                      ? Image.file(
                          _selectedImage!,
                          fit: BoxFit.fill,
                        )
                      : const Text(""),
                ),
              ],
            ),
          ),
        ));
  }

  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    var results = await ImageCropper().cropImage(
      sourcePath: returnedImage!.path,
    );

    setState(() {
      _selectedImage = File(returnedImage!.path);
    });
  }

  Future _pickImageFromCamera() async {
    //from imagepicker
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    ///from cropper
    var results = await ImageCropper().cropImage(
      sourcePath: returnedImage!.path,
    );

    AndroidUiSettings(toolbarTitle: 'Edit Image');

    setState(() {
      _selectedImage = File(results!.path);
    });
  }
}

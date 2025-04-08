import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_rest_lesson/models/upload_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../notifiers/blog_notifier.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  File? photo;
  UploadModel? _uploadModel;
  bool _isLoading = false;
  bool _isError = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add Posts'),
      ),
      body: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading == true && _isError == false)
              const Center(
                child: CircularProgressIndicator(),
              ),
            if (_isError == true && _isLoading == false)
              const Center(
                child: Text('Something went wrong!'),
              ),
            if (_uploadModel != null)
              Center(
                child: Column(
                  children: [
                    Text(_uploadModel!.result!),
                    OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Ok')),
                  ],
                ),
              ),
            if (_uploadModel == null &&
                _isLoading == false &&
                _isError == false)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            label: Text('Add Title'),
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        TextField(
                          controller: _contentController,
                          minLines: 5,
                          maxLines: null,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            label: Text('Add Content'),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            ImagePicker picker = ImagePicker();
                            XFile? xFile = await picker.pickImage(
                                source: ImageSource.gallery);
                            if (xFile != null) {
                              setState(() {
                                photo = File(xFile.path);
                              });
                            }
                          },
                          child: const Text('Select Photo(Optional)'),
                        ),
                        if (photo != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.file(photo!),
                          ),
                        FilledButton(
                            onPressed: () async {
                              String title = _titleController.text;
                              String content = _contentController.text;
                              if (title.trim().isNotEmpty ||
                                  content.trim().isNotEmpty) {
                                try {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  final uploadModel =
                                      await Provider.of<BlogNotifier>(context,
                                              listen: false)
                                          .uploadPost(
                                              title: title,
                                              body: content,
                                              photo: photo);
                                  setState(() {
                                    _isLoading = false;
                                    _isError = false;
                                    _uploadModel = uploadModel;
                                  });
                                } catch (e) {
                                  setState(() {
                                    _isError = true;
                                  });
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Please enter something')));
                              }
                            },
                            child: const Text('Add'))
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

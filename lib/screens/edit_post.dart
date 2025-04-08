import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../config/constant.dart';
import '../models/detail_model.dart';
import '../models/updated_model.dart';
import '../notifiers/blog_notifier.dart';

class EditPost extends StatefulWidget {
  EditPost({super.key, required this.id});
  int? id;

  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  File? photo;
  UpdatedModel? _updatedModel;
  bool _isLoading = false;
  bool _isError = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getPostDetail();
    });
    super.initState();
  }

  void _getPostDetail() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<BlogNotifier>(context, listen: false)
          .getPostDetail(widget.id!);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Edit Post'),
      ),
      body: Consumer<BlogNotifier>(
        builder: (BuildContext context, BlogNotifier notifier, Widget? _) {
          final DetailModel detailModel = notifier.detailModel;
          return Column(
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
              if (_updatedModel != null)
                Center(
                  child: Column(
                    children: [
                      Text(_updatedModel!.result!),
                      OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Ok')),
                    ],
                  ),
                ),
              if (_updatedModel == null &&
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
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                ),
                                label: const Text('Edit Post Title'),
                                hintText: detailModel.title ?? ''),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          TextField(
                            controller: _contentController,
                            minLines: 5,
                            maxLines: null,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                              ),
                              label: const Text('Edit Content Body'),
                              hintText: detailModel.body ?? '',
                            ),
                          ),
                          const TextButton(
                            /*onPressed: () async {
                              ImagePicker picker = ImagePicker();
                              XFile? xFile = await picker.pickImage(
                                  source: ImageSource.gallery);
                              if (xFile != null) {
                                setState(() {
                                  photo = File(xFile.path);
                                });
                              }
                            },*/
                            onPressed: null,
                            child: Text('Select Photo(Optional)'),
                          ),
                          if (detailModel.photo != null)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                  '${Constant.baseUrl}${detailModel.photo}'),
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
                                    final updateModel =
                                        await Provider.of<BlogNotifier>(context,
                                                listen: false)
                                            .updatePost(
                                                id: detailModel.id!,
                                                title: title,
                                                body: content);
                                    setState(() {
                                      _isLoading = false;
                                      _isError = false;
                                      _updatedModel = updateModel;
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
                              child: const Text('Edit'))
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

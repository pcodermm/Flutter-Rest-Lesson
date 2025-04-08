import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/delete_model.dart';
import '../models/home_model.dart';
import '../notifiers/blog_notifier.dart';
import 'add_post.dart';
import 'edit_post.dart';
import 'post_detail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  bool _isError = false;
  DeleteModel? deleteModel;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getAllPost();
    });
  }

  void _getAllPost() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<BlogNotifier>(context, listen: false).getAllPosts();
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
        title: const Text('Flutter Rest Lesson'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isLoading && !_isError)
            const Center(child: CircularProgressIndicator()),
          if (_isError)
            Center(
              child: Column(
                children: [
                  const Text('Something went wrong!'),
                  FilledButton(
                    onPressed: () {
                      setState(() {
                        _isError = false;
                        _getAllPost();
                      });
                    },
                    child: const Text('Retry'),
                  )
                ],
              ),
            ),
          if (!_isError && !_isLoading)
            Expanded(
              child:
                  Consumer<BlogNotifier>(builder: (context, notifier, child) {
                List<HomeModel> posts = notifier.postLists;
                if (posts.isEmpty) return const Text('No data found!');
                return RefreshIndicator(
                  onRefresh: () async {
                    _getAllPost();
                  },
                  child: ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        HomeModel model = posts[index];
                        return Card(
                          child: ListTile(
                            leading: Text(model.id.toString()),
                            title: Text(model.title ?? ''),
                            onTap: () {
                              int? id = model.id;
                              if (id != null) {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (builder) {
                                  return PostDetail(
                                    id: id,
                                  );
                                }));
                              }
                            },
                            onLongPress: () async {
                              bool? isConfirmed = await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      icon: const Icon(Icons.delete),
                                      title: const Text('Delete!'),
                                      content: RichText(
                                        text: TextSpan(
                                          children: [
                                            const TextSpan(
                                              style: TextStyle(
                                                  color: Colors.black),
                                              text: 'Do you wanna delete this ',
                                            ),
                                            TextSpan(
                                              style: const TextStyle(
                                                  color: Colors.red),
                                              text: '${model.title} ?',
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Cancel')),
                                        FilledButton(
                                            onPressed: () async {
                                              Navigator.pop(context, true);
                                            },
                                            child: const Text('Delete!')),
                                      ],
                                    );
                                  });
                              if (isConfirmed == true) {
                                final DeleteModel delete =
                                    await notifier.deletePost(id: model.id!);
                                deleteModel = delete;
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(delete.result!)));
                                  _getAllPost();
                                }
                              }
                            },
                            trailing: IconButton(
                                onPressed: () async {
                                  await Navigator.push(context,
                                      MaterialPageRoute(builder: (_) {
                                    return EditPost(
                                      id: model.id,
                                    );
                                  }));
                                  _getAllPost();
                                },
                                icon: const Icon(Icons.edit_note)),
                          ),
                        );
                      }),
                );
              }),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const AddPost();
          }));
          _getAllPost();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

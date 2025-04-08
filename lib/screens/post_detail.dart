import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/constant.dart';
import '../models/detail_model.dart';
import '../notifiers/blog_notifier.dart';

class PostDetail extends StatefulWidget {
  PostDetail({super.key, required this.id});
  final int id;

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  bool _isLoading = true;
  bool _isError = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getPostDetail();
    });
  }

  void _getPostDetail() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<BlogNotifier>(context, listen: false)
          .getPostDetail(widget.id);
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
        title: const Text('Post Detail'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isLoading && !_isError)
            const Center(child: CircularProgressIndicator()),
          if (_isError)
            const Center(
              child: Text('Something went wrong!'),
            ),
          if (!_isError && !_isLoading)
            Consumer<BlogNotifier>(builder: (context, notifier, child) {
              final DetailModel detailModel = notifier.detailModel;
              return Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 8.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (detailModel.photo != null)
                            SizedBox(
                              width: double.infinity,
                              child: Image.network(
                                  '${Constant.baseUrl}${detailModel.photo}'),
                            ),
                          Text(detailModel.title ?? ''),
                          Text(detailModel.body ?? ''),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}

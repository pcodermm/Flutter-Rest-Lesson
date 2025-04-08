import 'dart:io';

import 'package:flutter/material.dart';
import '../models/delete_model.dart';
import '../models/detail_model.dart';
import '../models/home_model.dart';
import '../models/updated_model.dart';
import '../models/upload_model.dart';
import '../rest/api_service.dart';

class BlogNotifier extends ChangeNotifier {
  ApiService apiService = ApiService();
  List<HomeModel> postLists = [];
  late DetailModel detailModel;

  Future<void> getAllPosts() async {
    try {
      postLists = (await apiService.getAllPost())!;
      notifyListeners();
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> getPostDetail(int id) async {
    try {
      detailModel = await apiService.getPostDetail(id);
      notifyListeners();
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<UploadModel> uploadPost({
    required String title,
    required String body,
    File? photo,
  }) async {
    try {
      UploadModel uploadModel = await apiService.uploadPost(
        title: title,
        body: body,
        photo: photo,
      );
      notifyListeners();
      return uploadModel;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<UpdatedModel> updatePost({
    required int id,
    required String title,
    required String body,
  }) async {
    try {
      UpdatedModel updatedModel =
          await apiService.updatePost(id: id, title: title, body: body);
      notifyListeners();
      return updatedModel;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<DeleteModel> deletePost({required int id}) async {
    try {
      DeleteModel deleteModel = await apiService.deletePost(id);
      notifyListeners();
      return deleteModel;
    } catch (e) {
      return Future.error(e);
    }
  }
}

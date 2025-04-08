import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import '../config/constant.dart';
import '../models/delete_model.dart';
import '../models/detail_model.dart';
import '../models/home_model.dart';
import '../models/updated_model.dart';
import '../models/upload_model.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: Constant.baseUrl));

  Future<List<HomeModel>?> getAllPost() async {
    final response = await _dio.get(Constant.allPosts);
    List<dynamic> list = response.data;
    return list.map((e) {
      return HomeModel.fromJson(e);
    }).toList();
  }

  Future<DetailModel> getPostDetail(int id) async {
    /*final response = await _dio
        .get('${Constant.postDetail}', queryParameters: {'id': id});*/
    final response = await _dio.get('${Constant.postDetail}$id');
    List<dynamic> list = response.data;
    return DetailModel.fromJson(list.first);
  }

  Future<UploadModel> uploadPost({
    required String title,
    required String body,
    File? photo,
  }) async {
    FormData? formData;
    if (photo != null) {
      formData = FormData.fromMap({
        'photo': MultipartFile.fromFileSync(photo.path),
      });
    }
    final response = await _dio.post(
      Constant.uploadPost,
      queryParameters: {"title": title, "body": body},
      data: formData,
    );
    return UploadModel.fromJson(response.data);
  }

  Future<UpdatedModel> updatePost(
      {required int id, required String title, required String body}) async {
    final response = await _dio.put(Constant.updatePost, queryParameters: {
      'id': id,
      'title': title,
      'body': body,
    });
    return UpdatedModel.fromJson(response.data);
  }

  Future<DeleteModel> deletePost(int id) async {
    final response =
        await _dio.delete(Constant.deletePost, queryParameters: {'id': id});
    return DeleteModel.fromJson(response.data);
  }
}

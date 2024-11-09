import 'package:dio/dio.dart';
import 'package:music_player/core/models/search_model.dart';

const baseUrl = "https://music-tech-rho.vercel.app";

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  late Dio _dio;

  ApiService._internal() {
    _dio = Dio(BaseOptions(baseUrl: baseUrl));
    // _dio.interceptors.add(_AuthInterceptor());
    // _dio.interceptors.add(_ResponseInterceptor());
  }
  Future<List<SearchModel>> searchSongs(String query) async {
    try {
      var url = '/songs?query=$query';
      final Response response = await _dio.get(url);
      final List<dynamic> data = response.data['data'];
      final dataList = data.map((ele) => SearchModel.fromMap(ele)).toList();
      return dataList;
    } catch (e) {
      print(e);
      return [];
    }
  }
}

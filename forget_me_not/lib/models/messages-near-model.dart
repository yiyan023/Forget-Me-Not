import 'dart:developer';
import 'dart:convert';
import '../services/messages-near-api-service.dart';
import '../services/ar_manager.dart';

class MessagesNearModel {
  String title;
  String time;
  String body;
  List<double> location;

  MessagesNearModel({required this.title, required this.time, required this.body, required this.location});

  factory MessagesNearModel.fromJson(Map<String, dynamic> json) {
    return MessagesNearModel(
      title: json['title'] as String,
      time: json['time'] as String,
      body: json['body'] as String,
      location: (json['location'] as List).map((e) => e as double).toList(),
    );
  }

  void fetchData(List<double> position) async {
  try {
      var apiService = MessagesNearApiService("http://localhost:5000"); ////// do something about baseURL
      var response = await apiService.getRequest('/note/nearby', position); // Adjust the endpoint
      var jsonData = json.decode(response.body) as List;
      var datalist = jsonData.map((item) => MessagesNearModel.fromJson(item)).toList();

      for (var i in datalist) {
        ArManager.updateList(i.title, i.time, i.body, i.location);
      }
    } catch (e) {
      log('Error: $e');
    }
  }
}
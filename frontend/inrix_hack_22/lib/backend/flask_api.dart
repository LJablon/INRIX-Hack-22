import 'dart:convert';
import 'package:http/http.dart' as http;

String apiUrl = 'http://172.31.138.220:5000';

void findDistanceFromAPI(double myLon, double myLat, double timeThresh,
    double lon, double lat) async {
  String endpoint = '/checkdistance';

  var response = await http.Client().get(Uri.parse(
      '$apiUrl$endpoint?my_lon=$myLon&my_lat=$myLat&time_thresh=$timeThresh&lon=$lon&lat=&lat'));

  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);
  } else {
    throw Exception('Response code was not 200, was ${response.statusCode}');
  }
}

Future<Map<String, dynamic>> getLonLatFromAddress(String address) async {
  /*var request = http.Request(
      'GET',
      Uri.parse(
          'http://127.0.0.1:5000/getcoordinates?address=Santa%20Clara%20University'));

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    Map<String, double> json =
        jsonDecode(await response.stream.bytesToString());

    return json;
  } else {
    throw Exception('Response code was not 200, was ${response.reasonPhrase}');
  }*/
  String endpoint = '/getcoordinates';

  var response =
      await http.Client().get(Uri.parse('$apiUrl$endpoint?address=$address'));

  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);
    return json;
  } else {
    throw Exception('Response code was not 200, was ${response.statusCode}');
  }
}

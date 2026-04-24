import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart'as http;
import '../services/shared_preferences_singelton.dart';

class Api{
  Future<dynamic> get({required String url, @required String? token}) async{
    Map<String,String> headers={};

    // Use provided token or get stored API token
    final authToken = token ?? Prefs.getString('api_token');
    
    if (authToken!=null && authToken.isNotEmpty) {
      headers.addAll({'Authorization': 'Bearer $authToken'});
    } else {
      print('Warning: No authentication token available for request to $url');
    }
    http.Response response=await http.get(Uri.parse(url),headers: headers);
    if(response.statusCode==200){
      return jsonDecode(response.body);
    }

    else{
    throw Exception('There is a problem with status code ${response.statusCode} with body${jsonDecode(response.body)}');
    }
  }

  Future<dynamic> post({required String url, @required dynamic body, String? token})
 async {
    Map<String,String> headers={};
    
    // Determine which token to use
    String? authToken;
    
    // For authentication endpoints (register/login), don't use stored token
    // Use stored token only if no token is explicitly provided AND it's not an auth endpoint
    final isAuthEndpoint = url.contains('auth/register') || url.contains('auth/login');
    
    if (token != null) {
      // Use explicitly provided token
      authToken = token;
    } else if (!isAuthEndpoint) {
      // For non-auth endpoints, use stored token if available
      authToken = Prefs.getString('api_token');
    }
    // For auth endpoints without explicit token, authToken remains null
    
    if (authToken!=null && authToken.isNotEmpty) {
      headers.addAll({'Authorization': 'Bearer $authToken'});
    } else if (!isAuthEndpoint) {
      print('Warning: No authentication token available for request to $url');
    }

    print('url= $url\nbody= $body\ntoken=${authToken != null ? "${authToken.substring(0, authToken.length > 20 ? 20 : authToken.length)}..." : "null"}');

    http.Response response=await http.post(Uri.parse(url),body:body,headers:headers);
    if (response.statusCode==200||response.statusCode==201) {
      Map<String,dynamic> data=jsonDecode(response.body);
      print(data);
      return data;
    }
    else{
      throw Exception('there is a problem with status code ${response.statusCode} with body${jsonDecode(response.body)}');
    }

  }
}

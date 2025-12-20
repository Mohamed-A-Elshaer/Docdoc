import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class TestPost extends StatelessWidget{
  const TestPost({super.key});
  static const routeName='testPost';
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: Center(
       child: FloatingActionButton(
           child: const Icon(CupertinoIcons.plus),
           onPressed: () async{
             Response response= await post(
                 Uri.parse('https://vcare.integration25.com/api/appointment/store'),
                 body: {
                   'doctor_id':'5',
                   'start_time':'2025-12-19 14:00',
                   'notes':'',
                 },
               headers: {
                 'Accept': 'application/json',
                 'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3ZjYXJlLmludGVncmF0aW9uMjUuY29tL2FwaS9hdXRoL2xvZ2luIiwiaWF0IjoxNzY1NzExMjQwLCJleHAiOjE3NjU3OTc2NDAsIm5iZiI6MTc2NTcxMTI0MCwianRpIjoiSzNaNE5GTlg2WGo4V2N5QyIsInN1YiI6IjI4MCIsInBydiI6IjIzYmQ1Yzg5NDlmNjAwYWRiMzllNzAxYzQwMDg3MmRiN2E1OTc2ZjcifQ.7rayG_dcJYYBdl6QUl7N0IbCUXpoZQbPaDn_dwH3NLI',
               }
             );

               print(response.body);

           }),
     ),
   );
  }


}
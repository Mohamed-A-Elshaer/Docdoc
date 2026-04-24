import 'package:docdoc/core/utils/app_text_styles.dart';
import 'package:docdoc/core/utils/assets.dart';
import 'package:docdoc/core/utils/backend_endpoint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CustomHomeAppBar extends StatelessWidget{
  const CustomHomeAppBar({super.key});

  Future<String?> _getUserName() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      return null;
    }

    final data = await Supabase.instance.client
        .from(BackendEndpoint.addUserData)
        .select('name')
        .eq('uid', user.id)
        .maybeSingle();

    if (data == null) {
      return null;
    }

    final map = Map<String, dynamic>.from(data);
    final name = map['name'];
    if (name is String && name.trim().isNotEmpty) {
      return name.trim();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<String?>(
                future: _getUserName(),
                builder: (context, snapshot) {
                  final name = snapshot.data;
                  final greeting = (name == null) ? 'Hi!' : 'Hi, $name!';
                  return Text(greeting, style: TextStyles.bold18);
                },
              ),
              const SizedBox(height: 5,),
              Text('How Are you Today?',style: TextStyles.regular11.copyWith(color: Color(0xff616161)),),
            ],
          ),
          const Spacer(),
          CircleAvatar(
            backgroundColor: const Color(0xffF5F5F5),
            radius: 28,
            child: SvgPicture.asset(Assets.imagesNotificationIcon),
          )
        ],
      ),
    );
  }

}
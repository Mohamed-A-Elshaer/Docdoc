import 'package:docdoc/features/home/presentation/views/widgets/home_view_body.dart';
import 'package:flutter/cupertino.dart';

class HomeView extends StatelessWidget{
  const HomeView({super.key});

  static const routeName='home';
  @override
  Widget build(BuildContext context) {
  return HomeViewBody();
  }


}
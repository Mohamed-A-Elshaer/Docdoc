import 'package:flutter/cupertino.dart';
import '../../../domain/entities/bottom_navigation_bar_entity.dart';
import 'active_item.dart';
import 'inactive_item.dart';

class NavigationBarItem extends StatelessWidget{
  const NavigationBarItem({super.key,required this.isSelected,required this.bottomNavigationBarEntity,this.isPng=false});
  final bool isSelected;
  final bool isPng;
  final BottomNavigationBarEntity bottomNavigationBarEntity;
  @override
  Widget build(BuildContext context) {
    return isSelected?  ActiveItem(logoName: bottomNavigationBarEntity.activeImg, isPng: isPng,)
        :InActiveItem(logoName:bottomNavigationBarEntity.inActiveImg, isPng: isPng, );
  }

}
import '../../../../core/generated/assets.dart';

class BottomNavigationBarEntity{
  final String activeImg,inActiveImg;
  BottomNavigationBarEntity({required this.activeImg,required this.inActiveImg});

 static List<BottomNavigationBarEntity> get bottomNavigationBarItems => [
  BottomNavigationBarEntity(activeImg: Assets.imagesHomeIconActive, inActiveImg: Assets.imagesHomeIcon),
  BottomNavigationBarEntity(activeImg: Assets.imagesMessageIconActive, inActiveImg: Assets.imagesMessageIcon),
  BottomNavigationBarEntity(activeImg: Assets.imagesCalendarIconActive, inActiveImg: Assets.imagesCalendarIcon),
  BottomNavigationBarEntity(activeImg: Assets.imagesNurse, inActiveImg: Assets.imagesNurse),
];
}
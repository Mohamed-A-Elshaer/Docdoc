import 'package:docdoc/core/generated/app_text_styles.dart';
import 'package:docdoc/core/generated/assets.dart';
import 'package:flutter/material.dart';

class ReviewItem extends StatelessWidget{
   ReviewItem({super.key});

  final List<Map<String,dynamic>> reviews=[
    {
       'name':'Jane Cooper',
       'comment': 'As someone who lives in a remote area with limited access to healthcare, this telemedicine app has been a game changer for me. I can easily schedule virtual appointments with doctors and get the care I need without having to travel long distances.'
    },
    {
      'name':'Robert Fox',
      'comment':'I was initially skeptical about using a telemedicine app but this app has exceeded my expectations. The doctors are highly qualified and provide excellent care.'
    },
    {
      'name':'Jacob Jones',
      'comment': 'As someone who lives in a remote area with limited access to healthcare, this telemedicine app has been a game changer for me. I can easily schedule virtual appointments with doctors and get the care I need without having to travel long distances.'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: reviews.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(Assets.imagesDefaultAvatar),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(reviews[index]['name'],style: TextStyles.semiBold16.copyWith(color: const Color(0xff242424)),),
                          Text('Today',style: TextStyles.regular12.copyWith(color: const Color(0xff9E9E9E)),),
                        ],
                      ),
                      const SizedBox(height: 8,),
                      const Icon(Icons.star,color: Color(0xffFFD600),size: 23.07,),
                      const SizedBox(height: 10,),
                      Text(reviews[index]['comment'],
                        style: TextStyles.regular12.copyWith(color: const Color(0xff757575)),)

                    ],
                  ),
                )
              ],
            ),
            if (index < reviews.length - 1) const SizedBox(height: 16),
          ],
        );

      },

    );
  }


}
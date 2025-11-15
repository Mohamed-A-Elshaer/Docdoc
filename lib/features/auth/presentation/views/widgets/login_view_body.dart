import 'package:docdoc/core/generated/app_colors.dart';
import 'package:docdoc/core/generated/app_text_styles.dart';
import 'package:docdoc/features/auth/presentation/views/widgets/auth_footer.dart';
import 'package:docdoc/features/auth/presentation/views/widgets/auth_header.dart';
import 'package:docdoc/core/widgets/custom_button.dart';
import 'package:docdoc/core/widgets/custom_check_box.dart';
import 'package:docdoc/core/widgets/custom_text_form_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../sign_up_view.dart';

class LoginViewBody extends StatelessWidget{
  const LoginViewBody({super.key});

  @override
  Widget build(BuildContext context) {
   return  Scaffold(
body: SafeArea(
  child: SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: [
          const AuthHeader(title: "Welcome Back",
              desc: "We're excited to have you back, can't wait to see what you've been up to since you last logged in.", height: 30,),
          const SizedBox(height: 40,),
          const CustomTextFormField(hintText: 'Email', textInputType: TextInputType.emailAddress,),
          const SizedBox(height: 15,),
          const CustomTextFormField(hintText: 'Password', textInputType: TextInputType.visiblePassword,suffixIcon: Icon(Icons.visibility,color: Color(0xffC2C2C2),),),
          const SizedBox(height: 10,),
          Transform.translate(
            offset: Offset(MediaQuery.of(context).size.width * -0.01, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomCheckBox(text: 'Remember Me',),
                const SizedBox(width: 80,),
                InkWell(
                  child: Text("Forgot Password?",style: TextStyles.regular12.copyWith(color: AppColors.primaryColor)),
                  onTap: (){},
                ),
              ],
            ),
          ),
          const SizedBox(height: 25,),
          CustomButton(text: "Login", onPressed: (){}),
          AuthFooter(text1: 'By logging, you agree to our ',
            text2: "Don't have an account? ",
            text3: 'Sign Up',
            gestureRecognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pushNamed(context, SignUpView.routeName);
              } ,),
        ],

      ),
    ),
  ),
),

   );
  }


}
import 'package:docdoc/features/auth/presentation/cubits/signups_cubit.dart';
import 'package:docdoc/features/auth/presentation/views/login_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../../../core/generated/app_colors.dart';
import '../../../../../core/generated/app_text_styles.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text_form_field.dart';
import 'auth_footer.dart';
import 'auth_header.dart';

class SignUpViewBody extends StatefulWidget{
  const SignUpViewBody({super.key});

  @override
  State<SignUpViewBody> createState() => _SignUpViewBodyState();
}

class _SignUpViewBodyState extends State<SignUpViewBody> {
  final GlobalKey<FormState> formKey=GlobalKey<FormState>();
  AutovalidateMode autovalidateMode=AutovalidateMode.disabled;
late String email,password,phone;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: formKey,
              autovalidateMode: autovalidateMode,
              child: Column(
                children: [
                  const AuthHeader(title: "Create Account",
                      desc: "Sign up now and start exploring all that our app has to offer. We're excited to welcome you to our community!", height: 20,),
                  const SizedBox(height: 40,),
                  CustomTextFormField(
                    onSaved: (value){
                      email=value!;
                    },
                    hintText: 'Email',
                    textInputType: TextInputType.emailAddress,),
                  const SizedBox(height: 30,),
                  CustomTextFormField(
                    onSaved: (value){
                      password=value!;
                    },
                    hintText: 'Password',
                    textInputType: TextInputType.visiblePassword,suffixIcon: const Icon(Icons.visibility,color: Color(0xffC2C2C2),),),
                  const SizedBox(height: 25,),
                  CustomButton(text: "Create Account", onPressed: (){
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      context.read<SignupsCubit>().signUpUser(email, password);

                    } else{
                      setState(() {
                        autovalidateMode=AutovalidateMode.always;
                      });
                    }
                  }),
                  AuthFooter(text1: 'By creating an account, you agree to our ',
                    text2: 'Already have an account? ',
                    text3: 'Sign In',
                    gestureRecognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pop(context);
                      },),
                ],

              ),
            ),
          ),
        ),
      ),

    );
  }
}
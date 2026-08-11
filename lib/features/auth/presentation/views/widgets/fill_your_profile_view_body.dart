import 'package:docdoc/core/utils/assets.dart';
import 'package:docdoc/core/widgets/custom_button.dart';
import 'package:docdoc/core/widgets/custom_drop_down_button_form_field.dart';
import 'package:docdoc/core/widgets/custom_text_form_field.dart';
import 'package:docdoc/features/auth/data/models/user_model.dart';
import 'package:docdoc/features/auth/domain/entities/user_entity.dart';
import 'package:docdoc/features/auth/presentation/views/widgets/auth_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../../core/helper_functions/build_error_bar.dart';
import '../../../../../core/widgets/custom_Intl_phone_field.dart';
import '../../../../../core/widgets/custom_date_picker_text_form_field.dart';
import '../../cubits/fillYourProfile_cubits/fill_your_profile_cubit.dart';

class FillYourProfileViewBody extends StatefulWidget {
  const FillYourProfileViewBody({super.key, required this.user});

  final UserEntity user;

  @override
  State<FillYourProfileViewBody> createState() =>
      _FillYourProfileViewBodyState();
}

class _FillYourProfileViewBodyState extends State<FillYourProfileViewBody> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String? name;
  String? phone;
  String? birthdate;
  String? gender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: formKey,
              autovalidateMode: autovalidateMode,
              child: Column(
                children: [
                  const AuthHeader(
                    title: 'Fill Your Profile',
                    desc:
                        'Please take a few minutes to fill out your profile with as much detail as possible.',
                    height: 30,
                  ),
                  const SizedBox(height: 30),
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: const Color(0xffffffff),
                    child: Image.asset(
                      Assets.imagesProfAvatar,
                      color: const Color(0xffdddddd),
                    ),
                  ),
                  const SizedBox(height: 27),
                  CustomTextFormField(
                    hintText: 'Full Name',
                    textInputType: TextInputType.name,
                    onSaved: (value) {
                      name = value;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomDatePickerTextFormField(
                    onSaved: (value) {
                      if ((value ?? '').isEmpty || birthdate != null) return;
                      birthdate = DateFormat('dd/MM/yyyy')
                          .parse(value!)
                          .toIso8601String();
                    },
                    onDateChanged: (date) {
                      setState(() {
                        birthdate = date?.toIso8601String();
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomIntlPhoneField(
                    validator: (value) {
                      if (value == null || value.number.isEmpty) {
                        return "Please enter your phone number";
                      }
                      return null;
                    },
                    onPhoneChanged: (value) {
                      phone = value.completeNumber;
                    },
                    onSaved: (value) {
                      phone = value?.completeNumber;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomDropDownButtonFormField(
                    value: gender,
                    onChanged: (String? newValue) {
                      setState(() {
                        gender = newValue;
                      });
                    },
                    onSaved: (value) {
                      gender = value;
                    },
                  ),
                  const SizedBox(height: 63),
                  CustomButton(
                      text: 'Submit',
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          // Ensure phone is not null or empty
                          if (phone == null || phone!.isEmpty) {
                            setState(() {
                              autovalidateMode = AutovalidateMode.always;
                            });
                            buildErrorBar(
                                context, 'Please enter your phone number');

                            return;
                          }
                          final updatedUser = UserModel(
                            email: widget.user.email,
                            uid: widget.user.uid,
                            name: name ?? widget.user.name,
                            phone: phone!,
                            birthdate: birthdate ?? widget.user.birthdate,
                            gender: gender ?? widget.user.gender,
                          );
                          context.read<FillYourProfileCubit>().submitProfile(
                                user: updatedUser,
                              );
                        } else {
                          setState(() {
                            autovalidateMode = AutovalidateMode.always;
                          });
                        }
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

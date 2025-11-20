import 'package:docdoc/features/auth/presentation/views/widgets/sign_in_view_body.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../../core/helper_functions/build_error_bar.dart';
import '../../cubits/signin_cubits/signin_cubit.dart';

class SignInViewBodyBlocConsumer extends StatelessWidget {
  const SignInViewBodyBlocConsumer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return BlocConsumer<SigninCubit,SigninState>(
          builder: (BuildContext context, state) {
            return ModalProgressHUD(
                inAsyncCall: state is SigninLoading? true:false,
                child: const SignInViewBody());
          },
          listener: (BuildContext context, Object? state) {
            if (state is SigninSuccess) {}
            if (state is SigninFailure) {
              buildErrorBar(context, state.message);
            }
          },
        );
      }
    );
  }
}
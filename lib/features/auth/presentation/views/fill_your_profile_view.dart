import 'package:docdoc/core/services/get_it_service.dart';
import 'package:docdoc/features/auth/domain/entities/user_entity.dart';
import 'package:docdoc/features/auth/domain/repos/auth_repo.dart';
import 'package:docdoc/features/auth/presentation/views/widgets/fill_your_profile_view_body_bloc_consumer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/fillYourProfile_cubits/fill_your_profile_cubit.dart';

class FillYourProfileView extends StatelessWidget {
  static const routeName = 'fillYourProfile';

  const FillYourProfileView({super.key, required this.userEntity});

  final UserEntity userEntity;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FillYourProfileCubit(getIt<AuthRepo>()),
      child: FillYourProfileViewBodyBlocConsumer(
        userEntity: userEntity,
      ),
    );
  }
}

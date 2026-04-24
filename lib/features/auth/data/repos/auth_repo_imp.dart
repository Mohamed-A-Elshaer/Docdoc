import 'dart:developer';
import 'dart:math' as math;
import 'package:dartz/dartz.dart';
import 'package:docdoc/core/api_services/auth_module.dart';
import 'package:docdoc/core/errors/exceptions.dart';
import 'package:docdoc/core/errors/failures.dart';
import 'package:docdoc/core/utils/backend_endpoint.dart';
import 'package:docdoc/core/helper_classes/api.dart';
import 'package:docdoc/core/helper_models/environment.dart';
import 'package:docdoc/core/services/database_service.dart';
import 'package:docdoc/core/services/shared_preferences_singelton.dart';
import 'package:docdoc/core/services/supabase_auth_service.dart';
import 'package:docdoc/features/auth/data/models/user_model.dart';
import 'package:docdoc/features/auth/domain/entities/user_entity.dart';
import 'package:docdoc/features/auth/domain/repos/auth_repo.dart';
import 'package:docdoc/features/auth/presentation/views/fill_your_profile_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepoImp extends AuthRepo{
  final SupabaseAuthService supabaseAuthService;
  final DatabaseService databaseService;
  AuthRepoImp({required this.supabaseAuthService,required this.databaseService});
  @override
  Future<Either<Failures, UserEntity>> signUpUser(String email, String password) async{
    User? user;
    try {
      user = await supabaseAuthService.signUpUser(email: email, password: password);
      var userEntity = UserModel.fromSupabaseUser(user);

      // Create / upsert base user data
      await addUserDataToDatabase(user: userEntity);

      // Explicitly set is_profile_completed = false in Supabase users table
      try {
        await Supabase.instance.client
            .from(BackendEndpoint.addUserData)
            .update({'is_profile_completed': false})
            .eq('uid', user.id);
      } catch (e) {
        log('Warning: Failed to set is_profile_completed=false on sign up: $e');
      }

      // Store password permanently for future API sign-ins
      // This allows users to re-authenticate with API when tokens expire
      await Prefs.setString('password_${user.id}', password);

      return right(userEntity);
    } on CustomException catch (e) {
      if (user != null) {
        await supabaseAuthService.deleteUser(userId: user.id);
      }
      return left(ServerFailures(e.message));
    } catch (e) {
      if (user != null) {
        await supabaseAuthService.deleteUser(userId: user.id);
      }
      log('Exception in AuthRepoImp.signUpUser: ${e.toString()}');
      return left(ServerFailures('An error occured. Please try again later.'));
    }
  }




  @override
  Future<Either<Failures, UserEntity>> signInUser(String email, String password,BuildContext context) async{
    try {
      final user = await supabaseAuthService.signInUser(email: email, password: password);

      final userData = await databaseService.getUserData(
        path: BackendEndpoint.addUserData,
        uid: user.id,
      );

      if (userData != null) {
        // Check if profile is completed or not.
        // Treat only explicit true as completed; null/false => not completed.
        final bool isProfileCompleted = userData['is_profile_completed'] == true;
        if (!isProfileCompleted) {
          if (!context.mounted) {
            return right(UserModel.fromMap(userData));
          }

          Navigator.pushReplacementNamed(
            context,
            FillYourProfileView.routeName,
            arguments: UserModel.fromMap(userData),
          );

          // Stop executing the rest of the method
          return right(UserModel.fromMap(userData));
        }

        // Profile is completed => we must login to API to get a valid token for app API services.
        // If API login fails, treat it as a sign-in failure (otherwise the app will break later).
        
        // Store password permanently for future API sign-ins (in case token expires)
        await Prefs.setString('password_${user.id}', password);
        
        await AuthModule().signInUserApi(email: email, password: password);

        // Check if api_user_id is null and update it if needed
        final apiUserId = userData['api_user_id'];
        if (apiUserId == null) {
          // Get user profile from API to extract the API user ID
          try {
            final profileResponse = await Api().get(
              url: '${Environment.apiBaseUrl}user/profile',
              token: null, // Api class will use stored token
            );

            // Extract id from data array (response structure: { "data": [{ "id": 123, ... }] })
            if (profileResponse is Map &&
                profileResponse.containsKey('data') &&
                profileResponse['data'] is List) {
              final dataList = profileResponse['data'] as List;
              if (dataList.isNotEmpty && dataList[0] is Map) {
                final data = dataList[0] as Map;
                if (data.containsKey('id') && data['id'] is int) {
                  final apiUserIdValue = data['id'] as int;

                  // Update the api_user_id in Supabase users table
                  await Supabase.instance.client
                      .from(BackendEndpoint.addUserData)
                      .update({'api_user_id': apiUserIdValue})
                      .eq('uid', user.id);

                  log('API user ID ($apiUserIdValue) stored successfully for user ${user.id}');

                  // Update userData map to include the new api_user_id
                  userData['api_user_id'] = apiUserIdValue;
                } else {
                  log('Warning: Could not extract API user ID from profile response - id field missing or invalid');
                }
              } else {
                log('Warning: Profile response data array is empty or invalid');
              }
            } else {
              log('Warning: Invalid profile response structure - expected data to be a List');
            }
          } catch (profileError) {
            // Log error but don't fail sign-in
            log('Warning: Failed to get user profile to update api_user_id: ${profileError.toString()}');
          }
        }

        return right(UserModel.fromMap(userData));
      }

      return right(UserModel.fromSupabaseUser(user));
    } on CustomException catch (e) {
      return left(ServerFailures(e.message));
    } catch (e) {
      log('Exception in AuthRepoImp.signInUser: ${e.toString()}');
      return left(ServerFailures('An error occured. Please try again later.'));
    }
  }

  @override
  Future<Either<Failures, UserEntity>> signInWithGoogle() async{
     try {
       var user = await supabaseAuthService.signInWithGoogle();
       final userData = await databaseService.getUserData(
         path: BackendEndpoint.addUserData,
         uid: user.id,
       );

       if (userData != null) {
         // Existing user - check if profile is completed
         final bool isProfileCompleted = userData['is_profile_completed'] == true;
         
         if (!isProfileCompleted) {
           // Profile not completed - return user data (UI will handle navigation)
           return right(UserModel.fromMap(userData));
         }

         // Profile is completed => login to API to get token
         final email = user.email ?? '';
         final storedPassword = Prefs.getString('password_${user.id}') ?? '';
         
         if (storedPassword.isEmpty) {
           log('Warning: No stored password found for OAuth user ${user.id}');
           // Still return user data, but API services might not work
           return right(UserModel.fromMap(userData));
         }

         try {
           await AuthModule().signInUserApi(email: email, password: storedPassword);
         } catch (apiError) {
           log('Warning: API sign-in failed for OAuth user: ${apiError.toString()}');
           // Continue anyway - user is signed in to Supabase
         }

         // Check if api_user_id is null and update it if needed
         final apiUserId = userData['api_user_id'];
         if (apiUserId == null) {
           try {
             final profileResponse = await Api().get(
               url: '${Environment.apiBaseUrl}user/profile',
               token: null, // Api class will use stored token
             );

             if (profileResponse is Map &&
                 profileResponse.containsKey('data') &&
                 profileResponse['data'] is List) {
               final dataList = profileResponse['data'] as List;
               if (dataList.isNotEmpty && dataList[0] is Map) {
                 final data = dataList[0] as Map;
                 if (data.containsKey('id') && data['id'] is int) {
                   final apiUserIdValue = data['id'] as int;

                   await Supabase.instance.client
                       .from(BackendEndpoint.addUserData)
                       .update({'api_user_id': apiUserIdValue})
                       .eq('uid', user.id);

                   log('API user ID ($apiUserIdValue) stored successfully for OAuth user ${user.id}');
                   userData['api_user_id'] = apiUserIdValue;
                 }
               }
             }
           } catch (profileError) {
             log('Warning: Failed to get user profile to update api_user_id: ${profileError.toString()}');
           }
         }

         return right(UserModel.fromMap(userData));
       }

       // First time OAuth user - create user data similar to signUpUser
       var userEntity = UserModel.fromSupabaseUser(user);
       await addUserDataToDatabase(user: userEntity);

       // Explicitly set is_profile_completed = false
       try {
         await Supabase.instance.client
             .from(BackendEndpoint.addUserData)
             .update({'is_profile_completed': false})
             .eq('uid', user.id);
       } catch (e) {
         log('Warning: Failed to set is_profile_completed=false for OAuth user: $e');
       }

       // Generate and store temporary password for API registration later (in submitProfile)
       final password = _generateOAuthPassword();
       await Prefs.setString('password_${user.id}', password);

       return right(userEntity);
     } on CustomException catch (e) {
       return left(ServerFailures(e.message));
     } catch(e){
       log('Exception in AuthRepoImp.signInWithGoogle: ${e.toString()}');
       return left(ServerFailures('An error occured. Please try again later.'));
     }
  }

  @override
  Future<Either<Failures, UserEntity>> signInWithFacebook() async {
    try {
      var user = await supabaseAuthService.signInWithFacebook();
      final userData = await databaseService.getUserData(
        path: BackendEndpoint.addUserData,
        uid: user.id,
      );

      if (userData != null) {
        // Existing user - check if profile is completed
        final bool isProfileCompleted = userData['is_profile_completed'] == true;
        
        if (!isProfileCompleted) {
          // Profile not completed - return user data (UI will handle navigation)
          return right(UserModel.fromMap(userData));
        }

        // Profile is completed => login to API to get token
        final email = user.email ?? '';
        final storedPassword = Prefs.getString('password_${user.id}') ?? '';
        
        if (storedPassword.isEmpty) {
          log('Warning: No stored password found for OAuth user ${user.id}');
          // Still return user data, but API services might not work
          return right(UserModel.fromMap(userData));
        }

        try {
          await AuthModule().signInUserApi(email: email, password: storedPassword);
        } catch (apiError) {
          log('Warning: API sign-in failed for OAuth user: ${apiError.toString()}');
          // Continue anyway - user is signed in to Supabase
        }

        // Check if api_user_id is null and update it if needed
        final apiUserId = userData['api_user_id'];
        if (apiUserId == null) {
          try {
            final profileResponse = await Api().get(
              url: '${Environment.apiBaseUrl}user/profile',
              token: null, // Api class will use stored token
            );

            if (profileResponse is Map &&
                profileResponse.containsKey('data') &&
                profileResponse['data'] is List) {
              final dataList = profileResponse['data'] as List;
              if (dataList.isNotEmpty && dataList[0] is Map) {
                final data = dataList[0] as Map;
                if (data.containsKey('id') && data['id'] is int) {
                  final apiUserIdValue = data['id'] as int;

                  await Supabase.instance.client
                      .from(BackendEndpoint.addUserData)
                      .update({'api_user_id': apiUserIdValue})
                      .eq('uid', user.id);

                  log('API user ID ($apiUserIdValue) stored successfully for OAuth user ${user.id}');
                  userData['api_user_id'] = apiUserIdValue;
                }
              }
            }
          } catch (profileError) {
            log('Warning: Failed to get user profile to update api_user_id: ${profileError.toString()}');
          }
        }

        return right(UserModel.fromMap(userData));
      }

      // First time OAuth user - create user data similar to signUpUser
      var userEntity = UserModel.fromSupabaseUser(user);
      await addUserDataToDatabase(user: userEntity);

      // Explicitly set is_profile_completed = false
      try {
        await Supabase.instance.client
            .from(BackendEndpoint.addUserData)
            .update({'is_profile_completed': false})
            .eq('uid', user.id);
      } catch (e) {
        log('Warning: Failed to set is_profile_completed=false for OAuth user: $e');
      }

      // Generate and store password permanently for API registration and future sign-ins
      // This password is kept permanently so OAuth users can always re-authenticate with API
      final password = _generateOAuthPassword();
      await Prefs.setString('password_${user.id}', password);

      return right(userEntity);
    } on CustomException catch (e) {
      return left(ServerFailures(e.message));
    } catch (e) {
      log('Exception in AuthRepoImp.signInWithFacebook: ${e.toString()}');
      return left(ServerFailures('An error occured. Please try again later.'));
    }
  }

  @override
  Future addUserDataToDatabase({required UserEntity user}) async{
    await databaseService.addUserDataToDatabase(path: BackendEndpoint.addUserData, data: user.toMap());
  }

  /// Generates a temporary password for OAuth users (for API registration)
  String _generateOAuthPassword() {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*';
    final random = math.Random.secure();
    return List.generate(16, (index) => chars[random.nextInt(chars.length)]).join();
  }

  @override
  Future<Either<Failures, UserEntity>> submitProfile({required UserEntity user}) async {
    try {
      // Update user data in Supabase
      await databaseService.addUserDataToDatabase(
        path: BackendEndpoint.addUserData,
        data: user.toMap(),
      );

      // Get current Supabase user
      final supabaseUser = Supabase.instance.client.auth.currentUser;
      if (supabaseUser == null) {
        return left(ServerFailures('User not authenticated'));
      }

      // Explicitly set is_profile_completed = true in Supabase users table
      try {
        await Supabase.instance.client
            .from(BackendEndpoint.addUserData)
            .update({'is_profile_completed': true})
            .eq('uid', supabaseUser.id);
      } catch (e) {
        log('Warning: Failed to set is_profile_completed=true on submitProfile: $e');
      }

      // Get stored password for API registration
      final password = Prefs.getString('password_${supabaseUser.id}') ?? '';

      // Register user in API
      await AuthModule().signUpUserApi(
        user: user,
        password: password,
        supaUser: supabaseUser,
      );

      // Delete the stored password after successful API registration
      await Prefs.remove('password_${supabaseUser.id}');

      return right(user);
    } on CustomException catch (e) {
      return left(ServerFailures(e.message));
    } catch (e) {
      log('Exception in AuthRepoImp.submitProfile: ${e.toString()}');
      return left(ServerFailures('An error occured. Please try again later.'));
    }
  }
}
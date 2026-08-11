import 'package:docdoc/core/api_services/user_module.dart';
import 'package:docdoc/core/services/auth_email_change_session_service.dart';
import 'package:docdoc/core/services/shared_preferences_singelton.dart';
import 'package:docdoc/core/services/user_profile_display_notifier.dart';
import 'package:docdoc/core/utils/app_text_styles.dart';
import 'package:docdoc/core/utils/assets.dart';
import 'package:docdoc/core/utils/backend_endpoint.dart';
import 'package:docdoc/core/widgets/custom_Intl_phone_field.dart';
import 'package:docdoc/core/widgets/custom_app_bar.dart';
import 'package:docdoc/core/widgets/custom_button.dart';
import 'package:docdoc/core/widgets/custom_text_form_field.dart';
import 'package:docdoc/core/widgets/password_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../constants.dart';

class PersonalInformationView extends StatefulWidget {
  const PersonalInformationView({super.key});

  static const String routeName = 'personal_information';

  @override
  State<PersonalInformationView> createState() =>
      _PersonalInformationViewState();
}

class _PersonalInformationViewState extends State<PersonalInformationView> {
  static final TextStyle _inputStyle =
      TextStyles.medium14.copyWith(color: const Color(0xff242424));

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _loading = true;
  bool _saving = false;
  bool _phoneTouched = false;
  String? _nameInitial;
  String? _phoneInitial;
  String? _emailInitial;
  String? _genderFromDb;
  String? _phoneComplete;

  @override
  void initState() {
    super.initState();
    _loadUserRow();
  }

  Future<void> _loadUserRow() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }

    final data = await Supabase.instance.client
        .from(BackendEndpoint.addUserData)
        .select('name, email, phone, gender')
        .eq('uid', user.id)
        .maybeSingle();

    if (!mounted) return;

    if (data == null) {
      final email = user.email?.trim();
      setState(() {
        _nameController.text = '';
        _emailController.text = email ?? '';
        _nameInitial = '';
        _phoneInitial = null;
        _emailInitial = email;
        _genderFromDb = null;
        _phoneComplete = null;
        _loading = false;
      });
      return;
    }

    final map = Map<String, dynamic>.from(data);
    String? s(dynamic v) =>
        v is String && v.trim().isNotEmpty ? v.trim() : null;

    setState(() {
      _nameController.text = s(map['name']) ?? '';
      _emailController.text = s(map['email']) ?? user.email?.trim() ?? '';
      _nameInitial = s(map['name']) ?? '';
      _phoneInitial = s(map['phone']);
      _emailInitial = s(map['email']) ?? user.email?.trim();
      _genderFromDb = s(map['gender']);
      _phoneComplete = _phoneInitial;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _resolvePhoneForSave() {
    if (!_phoneTouched && _phoneInitial != null) {
      return _phoneInitial!.trim();
    }
    final phone = _phoneComplete?.trim();
    return (phone == null || phone.isEmpty) ? null : phone;
  }

  bool _hasProfileChanges() {
    final nameText = _nameController.text.trim();
    final emailText = _emailController.text.trim();
    final phoneVal = _resolvePhoneForSave() ?? '';
    final pass = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    final nameChanged = nameText != (_nameInitial?.trim() ?? '');
    final emailChanged = emailText != (_emailInitial?.trim() ?? '');
    final phoneChanged = phoneVal != (_phoneInitial?.trim() ?? '');
    final passwordChanged = pass.isNotEmpty || confirm.isNotEmpty;

    return nameChanged || emailChanged || phoneChanged || passwordChanged;
  }

  Future<void> _syncProfileToApi({
    required String uid,
    required String name,
    required String email,
    required String? phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    final apiToken = Prefs.getString('api_token');
    if (apiToken == null || apiToken.isEmpty) {
      return;
    }

    final apiPassword = password.isNotEmpty
        ? password
        : (Prefs.getString('password_$uid') ?? '');
    if (apiPassword.isEmpty) {
      throw Exception(
        'API profile update error.',
      );
    }

    final apiPasswordConfirmation =
        passwordConfirmation.isNotEmpty ? passwordConfirmation : apiPassword;

    await UserModule().updateProfileWithWorkaround(
      name: name,
      email: email.trim(),
      phone: UserModule.nationalPhoneFromE164(phone),
      gender: UserModule.genderToApiValue(_genderFromDb),
      password: apiPassword,
      passwordConfirmation: apiPasswordConfirmation,
    );

    if (password.isNotEmpty) {
      await Prefs.setString('password_$uid', password);
    }
  }

  Future<void> _onSave() async {
    if (_saving) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _formKey.currentState!.save();

    if (!_hasProfileChanges()) {
      return;
    }

    setState(() => _saving = true);

    final uid = Supabase.instance.client.auth.currentUser?.id;
    if (uid == null) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Not signed in')),
        );
      }
      return;
    }

    final pass = _passwordController.text;
    final confirm = _confirmPasswordController.text;
    if (pass.isNotEmpty || confirm.isNotEmpty) {
      if (pass != confirm) {
        if (mounted) {
          setState(() => _saving = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Passwords do not match')),
          );
        }
        return;
      }
      if (pass.length < 6) {
        if (mounted) {
          setState(() => _saving = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Password must be at least 6 characters')),
          );
        }
        return;
      }
      try {
        await Supabase.instance.client.auth.updateUser(
          UserAttributes(password: pass),
        );
      } catch (e) {
        if (mounted) {
          setState(() => _saving = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not update password: $e')),
          );
        }
        return;
      }
    }

    final emailText = _emailController.text.trim();
    final emailChanged = emailText != (_emailInitial?.trim() ?? '');
    if (emailChanged && emailText.isNotEmpty) {
      try {
        await Supabase.instance.client.auth.updateUser(
          UserAttributes(email: emailText),
          emailRedirectTo: kIsWeb ? null : redirectUrl,
        );
        await AuthEmailChangeSessionServiceSessionService.instance
            .markPendingEmailChange(emailText);
      } catch (e) {
        if (mounted) {
          setState(() => _saving = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not update login email: $e')),
          );
        }
        return;
      }
    }

    try {
      final existing = await Supabase.instance.client
          .from(BackendEndpoint.addUserData)
          .select()
          .eq('uid', uid)
          .maybeSingle();

      final row = existing != null
          ? Map<String, dynamic>.from(existing)
          : <String, dynamic>{'uid': uid};

      final nameText = _nameController.text.trim();
      row['name'] = nameText.isEmpty ? null : nameText;
      row['email'] = emailText.isEmpty ? null : emailText;
      final phoneVal = _resolvePhoneForSave();
      row['phone'] = (phoneVal == null || phoneVal.isEmpty) ? null : phoneVal;

      await Supabase.instance.client
          .from(BackendEndpoint.addUserData)
          .upsert(row, onConflict: 'uid');

      try {
        await _syncProfileToApi(
          uid: uid,
          name: nameText.isEmpty ? '' : nameText,
          email: emailText,
          phone: phoneVal,
          password: pass,
          passwordConfirmation: confirm,
        );
      } catch (apiError) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'API profile update failed: $apiError',
              ),
            ),
          );
        }
      }

      _passwordController.clear();
      _confirmPasswordController.clear();
      if (mounted) {
        UserProfileDisplayNotifier.instance.notifyProfileUpdated();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              emailChanged
                  ? 'Please check your current email for a confirmation link to update your email address.'
                  : 'Profile Saved Successfully',
            ),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not save: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Personal information',
        leftPadding: 17,
        onTap: () => Navigator.of(context).pop(),
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 18),
                            Center(
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    width: 120,
                                    height: 120,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: AssetImage(
                                          Assets.imagesUserAvatarPlaceholder,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 96,
                                    right: 6,
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        width: 30.55,
                                        height: 30.55,
                                        decoration: BoxDecoration(
                                          color: const Color(0xffF8F8F8),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: SvgPicture.asset(
                                          Assets.imagesModifyAvatarIcon,
                                          width: 16,
                                          height: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 51),
                            CustomTextFormField(
                              hintText: 'Full Name',
                              textInputType: TextInputType.name,
                              controller: _nameController,
                              style: _inputStyle,
                              validator: (_) => null,
                            ),
                            const SizedBox(height: 16),
                            CustomTextFormField(
                              hintText: 'Email',
                              textInputType: TextInputType.emailAddress,
                              controller: _emailController,
                              style: _inputStyle,
                              validator: (_) => null,
                            ),
                            const SizedBox(height: 16),
                            PasswordField(
                              controller: _passwordController,
                              style: _inputStyle,
                              validator: (_) => null,
                            ),
                            const SizedBox(height: 16),
                            PasswordField(
                              controller: _confirmPasswordController,
                              hintText: 'Confirm Password',
                              style: _inputStyle,
                              validator: (_) => null,
                            ),
                            const SizedBox(height: 16),
                            CustomIntlPhoneField(
                              key: ValueKey(_phoneInitial ?? ''),
                              hintText: 'Phone Number',
                              phoneInitialValue: _phoneInitial,
                              style: _inputStyle,
                              invalidNumberMessage:
                                  'Enter a valid phone number for the selected country',
                              validator: (value) {
                                if (value == null ||
                                    value.number.trim().isEmpty) {
                                  return null;
                                }
                                try {
                                  value.isValidNumber();
                                  return null;
                                } on NumberTooShortException {
                                  return 'Phone number is too short';
                                } on NumberTooLongException {
                                  return 'Phone number is too long';
                                } catch (_) {
                                  return 'Invalid phone number';
                                }
                              },
                              onPhoneChanged: (phone) {
                                _phoneTouched = true;
                                final full = formatPhoneE164(phone);
                                _phoneComplete = full.isEmpty ? null : full;
                              },
                              onSaved: (value) {
                                if (!_phoneTouched && _phoneInitial != null) {
                                  _phoneComplete = _phoneInitial;
                                  return;
                                }
                                if (value == null ||
                                    value.number.trim().isEmpty) {
                                  _phoneComplete = null;
                                  return;
                                }
                                final full = formatPhoneE164(value);
                                _phoneComplete = full.isEmpty ? null : full;
                              },
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'When you set up your personal information settings, you should take care to provide accurate information.',
                              style: TextStyles.regular12.copyWith(
                                color: const Color(0xff757575),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: CustomButton(
                        text: 'Save',
                        isLoading: _saving,
                        onPressed: _onSave,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
      ),
    );
  }
}

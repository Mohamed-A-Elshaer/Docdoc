import 'package:envied/envied.dart';

part 'environment.g.dart';
@Envied(path: '.env.development')
final class Environment {
 /* @EnviedField(varName: 'API_token',obfuscate: true)
  static final String apiKey = _Environment.apiKey;*/
  @EnviedField(varName: 'API_base_url',obfuscate: true)
  static final String apiBaseUrl = _Environment.apiBaseUrl;
  @EnviedField(varName: 'supabase_url',obfuscate: true)
  static final String supabaseUrl = _Environment.supabaseUrl;
  @EnviedField(varName: 'supabase_anonKey',obfuscate: true)
  static final String supabaseAnonKey = _Environment.supabaseAnonKey;
}
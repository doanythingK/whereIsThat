import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/app_repository.dart';
import '../../../core/data/repository_providers.dart';

final authActionsProvider = Provider<AuthActions>((ref) => AuthActions(ref));

class AuthActions {
  AuthActions(this.ref);

  final Ref ref;

  Future<void> signIn(SocialProvider provider) async {
    await ref.read(appRepositoryProvider).signIn(provider);
    ref.invalidate(currentUserProvider);
  }

  Future<void> signOut() async {
    await ref.read(appRepositoryProvider).signOut();
    ref.invalidate(currentUserProvider);
  }

  Future<void> deleteAccount() async {
    await ref.read(appRepositoryProvider).deleteAccount();
    ref.invalidate(currentUserProvider);
  }
}

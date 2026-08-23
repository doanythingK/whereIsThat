import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/app_repository.dart';
import '../../../core/data/repository_providers.dart';
import '../../../core/services/app_services.dart';

final authActionsProvider = Provider<AuthActions>((ref) => AuthActions(ref));

class AuthActions {
  AuthActions(this.ref);

  final Ref ref;

  Future<void> signIn(SocialProvider provider) async {
    await ref.read(appRepositoryProvider).signIn(provider);
    ref.invalidate(currentUserProvider);
    await AppServices.current.syncDevice(ref.read(appRepositoryProvider));
  }

  Future<void> linkIdentity(SocialProvider provider) async {
    await ref.read(appRepositoryProvider).linkIdentity(provider);
  }

  Future<void> signOut() async {
    await ref.read(appRepositoryProvider).signOut();
    ref.invalidate(currentUserProvider);
  }

  Future<void> deleteAccount() async {
    await ref.read(appRepositoryProvider).deleteAccount();
    await ref.read(appRepositoryProvider).signOut();
    ref.invalidate(currentUserProvider);
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/repository_providers.dart';
import '../../features/auth/presentation/auth_page.dart';
import '../../features/checklist/presentation/checklist_page.dart';
import '../../features/floor_plan/presentation/floor_plan_page.dart';
import '../../features/item/presentation/item_list_page.dart';
import '../../features/space/presentation/home_page.dart';
import '../../features/space/presentation/invite_page.dart';
import '../../features/space/presentation/space_picker_page.dart';
import '../../features/space/presentation/space_shell_page.dart';
import '../../features/space/presentation/more_page.dart';
import '../../features/shopping/presentation/shopping_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final repository = ref.watch(appRepositoryProvider);
  final authState = ref.watch(authStateProvider);
  return GoRouter(
    initialLocation: repository.isDemoMode ? '/spaces' : '/auth',
    redirect: (context, state) {
      if (repository.isDemoMode || authState.isLoading) return null;
      final signedIn = authState.value != null;
      final onAuth = state.uri.path == '/auth';
      final onInvite = state.uri.path.startsWith('/invite/');
      if (!signedIn && !onAuth && !onInvite) return '/auth';
      if (signedIn && onAuth) return '/spaces';
      return null;
    },
    routes: [
      GoRoute(path: '/auth', builder: (context, state) => const AuthPage()),
      GoRoute(
        path: '/spaces',
        builder: (context, state) => const SpacePickerPage(),
      ),
      GoRoute(
        path: '/invite/:code',
        builder: (context, state) =>
            InvitePage(code: state.pathParameters['code']!),
      ),
      ShellRoute(
        builder: (context, state, child) => SpaceShellPage(
          spaceId: state.pathParameters['spaceId']!,
          child: child,
        ),
        routes: [
          GoRoute(
            path: '/space/:spaceId/home',
            builder: (context, state) =>
                HomePage(spaceId: state.pathParameters['spaceId']!),
          ),
          GoRoute(
            path: '/space/:spaceId/floor-plan',
            builder: (context, state) =>
                FloorPlanPage(spaceId: state.pathParameters['spaceId']!),
          ),
          GoRoute(
            path: '/space/:spaceId/shopping',
            builder: (context, state) =>
                ShoppingPage(spaceId: state.pathParameters['spaceId']!),
          ),
          GoRoute(
            path: '/space/:spaceId/checklist',
            builder: (context, state) =>
                ChecklistPage(spaceId: state.pathParameters['spaceId']!),
          ),
          GoRoute(
            path: '/space/:spaceId/items',
            builder: (context, state) => ItemListPage(
              spaceId: state.pathParameters['spaceId']!,
              initialQuery: state.uri.queryParameters['q'],
            ),
          ),
          GoRoute(
            path: '/space/:spaceId/more',
            builder: (context, state) =>
                MorePage(spaceId: state.pathParameters['spaceId']!),
          ),
        ],
      ),
    ],
  );
});

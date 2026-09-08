import 'package:go_router/go_router.dart';
import 'screens/author_list_screen.dart';
import 'screens/book_list_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/books',
  routes: [
    GoRoute(
      path: '/books',
      builder: (context, state) => BookListScreen(
        queryParams: state.uri.queryParameters,
      ),
    ),
    GoRoute(
      path: '/authors',
      builder: (context, state) => AuthorListScreen(
        queryParams: state.uri.queryParameters,
      ),
    ),
  ],
);
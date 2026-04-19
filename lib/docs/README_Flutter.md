# Nexus — Flutter App Documentation

## Architecture

```
UI (Screen)
  └── BlocConsumer (listener + builder)
        └── Cubit (emits states)
              └── Repository (normalizes errors)
                    └── Service (raw API calls)
```

---

## Folder Structure

```
lib/
  features/
    auth/           → login, register, reset (shared)
    onboarding/     → create shop or join shop
    admin/          → everything admin sees
      home/
      cashiers/
      reports/
      settings/
    cashier/        → everything cashier sees
      shift/
      transactions/
    cubit/
      auth/         → auth_cubit.dart, auth_state.dart
      feedback/     → flash_cubit.dart
    components/     → shared UI components
  core/
    helpers/        → dio_client, token_storage, extensions
    routing/        → app_router, routes
    localization/   → locale_cubit, locale_service
    theme/          → colors
  models/           → user_model, shop_model
  repositories/     → auth_repo
  services/         → auth_services
  di.dart           → dependency injection (GetIt)
  main.dart
  NexusApp.dart
```

---

## Dependency Injection

Everything registered in `di.dart` via GetIt:

```dart
getIt.registerLazySingleton<AuthServices>(() => AuthServices());
getIt.registerLazySingleton<AuthRepo>(() => AuthRepo(authServices: getIt()));
getIt.registerLazySingleton(() => AuthCubit(getIt<AuthRepo>()));
getIt.registerLazySingleton(() => FlashCubit());
```

> Never create services or repos manually in screens. Always use `getIt<T>()`.

---

## State Management — Bloc/Cubit

### AuthState (sealed)
```dart
AuthInitial    // screen just opened
AuthLoading    // API call in flight — show spinner
AuthSuccess    // login/register succeeded — carries User
AuthLoggedOut  // logout completed — navigate to login
AuthError      // something went wrong — carries message
```

Sealed = compiler knows all possible states. Impossible states are impossible.

### AuthCubit methods
```dart
login(email, password)
register(name, email, phone, password, passwordConfirmation)
logout()
```

### FlashState
```dart
FlashState {
  message: String
  type: FlashType (success | error | info)
  visible: bool
  count: int   // increments if same message fires multiple times
}
```

### FlashCubit methods
```dart
flash.success('message')
flash.error('message')
flash.info('message')
flash.hide()   // NOT close() — close() is reserved by Cubit and kills it
```

---

## Error Handling Pipeline

```
Service     → throws raw exceptions (Dio, socket, etc.)
Repository  → catches ALL exceptions → normalizes to AuthException
Cubit       → catches AuthException → emits AuthError(message)
UI listener → reads AuthError → calls FlashCubit.error(message)
FlashBar    → displays friendly message to user
```

### DioException types handled in Repository
```dart
DioExceptionType.connectionError  → 'No internet connection'
DioExceptionType.unknown          → 'No internet connection'
DioExceptionType.connectionTimeout
DioExceptionType.receiveTimeout
DioExceptionType.sendTimeout      → 'Request timed out'
DioExceptionType.badResponse      → extracts message from response body
```

### Safe extraction from response
```dart
// never response.data['message'] directly — can throw if data is not a Map
final data = e.response?.data;
final message = (data is Map ? data['message'] : null) ?? e.message ?? 'Network error';
```

---

## Logout — Security Design

```dart
Future<void> logout() async {
  try {
    await authServices.logout(); // tell server to invalidate token
  } catch (e) {
    // swallowed — server error doesn't matter
    // token is wiped locally regardless
  } finally {
    await TokenStorage.clear(); // ALWAYS runs
  }
}
```

> `finally` guarantees token is wiped even if server call fails. User is always logged out locally.

---

## FlashBar — Global Feedback Component

Placed inside `MaterialApp.builder` — overlays entire app without pushing UI:

```dart
// NexusApp.dart
MaterialApp(
  builder: (context, child) => FlashBar(child: child!),
)
```

> Must be INSIDE MaterialApp — not wrapping it — because it needs Directionality.

### Usage from any screen listener
```dart
context.read<FlashCubit>().error(state.message);
context.read<FlashCubit>().success('Welcome!');
context.read<FlashCubit>().info('You have been logged out.');
```

---

## Navigation — BlocConsumer Pattern

```dart
// listener → one-time side effects (navigation, flash)
listener: (context, state) {
  if (state is AuthError) {
    context.read<FlashCubit>().error(state.message);
  }
  if (state is AuthSuccess) {
    context.read<FlashCubit>().success('Welcome, ${state.user.name}!');
    context.pushNamedAndRemoveUntil(Routes.home, predicate: (_) => false);
  }
  if (state is AuthLoggedOut) {
    context.read<FlashCubit>().info('You have been logged out.');
    context.pushNamedAndRemoveUntil(Routes.loginScreen, predicate: (_) => false);
  }
},

// builder → visual state only (spinner, error UI)
builder: (context, state) {
  final isLoading = state is AuthLoading;
  ...
}
```

---

## App Split by Role

```
Login succeeds
    ↓
AuthGate checks user.shop
    ├── null → OnboardingScreen
    │     ├── Create Shop → role = admin  → AdminApp
    │     └── Join Shop   → role = cashier → CashierApp
    └── exists → check user.role
          ├── admin   → AdminApp
          └── cashier → CashierApp
```

### User model carries role + shop
```dart
class User {
  final String? role;
  final Shop? shop;

  bool get isAdmin   => role == 'admin';
  bool get isCashier => role == 'cashier';
  bool get hasShop   => shop != null;
}
```

---

## API Response Shape

All endpoints return unified shape:
```dart
// repo reads data from nested 'data' key
final data = response['data'];
final userJson = data['user'];
final token    = data['token'];
final shop     = data['shop'];   // null = go to onboarding
final role     = data['role'];   // null = not assigned yet
```

---

## LogoutButton Component

Drop anywhere in the app — handles navigation and flash automatically:

```dart
// default look
LogoutButton()

// custom child
LogoutButton(child: Icon(Icons.logout_rounded))

// in AppBar
AppBar(actions: [LogoutButton(child: Icon(Icons.logout_rounded))])
```

---

## DioClient Setup

```dart
// constants.dart — always trailing slash on base URL
final baseUrl = "https://your-tunnel.trycloudflare.com/api/";

// DioClient adds auth token to every request automatically
dio.interceptors.add(InterceptorsWrapper(
  onRequest: (options, handler) async {
    final token = await TokenStorage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
));
```

---

## Key Rules

| Rule | Why |
|---|---|
| Never throw past Repository | Repo is the error firewall |
| Always use `AuthException` not `Exception` | `e.toString()` prefixes "Exception:" — ugly in UI |
| Never navigate in `builder` | builder runs on every rebuild |
| Always navigate in `listener` | listener fires once per state change |
| `hide()` not `close()` on FlashCubit | `close()` is reserved — kills the cubit |
| Token always cleared in `finally` | Never leave stale token if server call fails |
| `AuthCubit` provided at root (`main.dart`) | Available to all screens including LogoutButton |

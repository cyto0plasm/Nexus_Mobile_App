# Nexus

> A Flutter POS & shop management app — multi-role, multi-shop, built clean.

---

## Stack

| Layer | Tool |
|---|---|
| State Management | Flutter Bloc / Cubit |
| HTTP Client | Dio |
| Dependency Injection | GetIt |
| Token Storage | flutter_secure_storage |
| Local Storage | shared_preferences |
| Backend | Laravel API (Cloudflare Tunnel) |

---

## Architecture

```
UI (Screen)
  └── BlocConsumer
        └── Cubit          → emits states
              └── Repository → normalizes errors
                    └── Service  → raw Dio API calls
```

Strict layering — no Dio in cubits, no navigation in repos, no business logic in widgets.

---

## Folder Structure

```
lib/
  features/
    auth/                  → login, register, reset
    onboarding/            → create shop / join shop
    admin/                 → admin role screens
      home/
      cashiers/
      reports/
      settings/
    cashier/               → cashier role screens
      shift/
      transactions/
    cubit/
      auth/                → auth_cubit.dart, auth_state.dart
      feedback/            → flash_cubit.dart
    components/            → shared UI components
  core/
    helpers/               → dio_client, token_storage, extensions
    routing/               → app_router, routes
    localization/          → locale_cubit, locale_service
    theme/                 → colors
  models/                  → user_model, shop_model
  repositories/            → auth_repo
  services/                → auth_services
  di.dart                  → GetIt registrations
  main.dart
  NexusApp.dart
```

---

## Auth Flow

```
App opens
  └── AuthGate checks local token + user
        ├── No token        → LoginScreen
        ├── No shop         → OnboardingScreen
        └── Has shop
              ├── admin     → AdminApp
              └── cashier   → CashierApp
```

Onboarding routes:
```
OnboardingScreen
  ├── Create Shop  → role = admin   → AdminApp
  └── Join Shop    → role = cashier → CashierApp
```

---

## State — AuthCubit

```dart
sealed class AuthState
  AuthInitial    // screen just opened
  AuthLoading    // API in flight → show spinner
  AuthSuccess    // success → carries User
  AuthLoggedOut  // logged out → go to login
  AuthError      // failed → carries message string
```

Methods:
```dart
login(email, password)
register(name, email, phone, password, passwordConfirmation)
logout()
rehydrate(user)   // restores state from local storage on cold start
```

---

## Error Handling Pipeline

```
Service      → throws raw DioException
Repository   → catches all → maps to AuthException(message)
Cubit        → catches AuthException → emits AuthError(message)
UI listener  → reads AuthError → calls FlashCubit.error(message)
FlashBar     → shows friendly message to user
```

DioException types handled:
```dart
connectionError / unknown    → 'No internet connection'
connectionTimeout / receiveTimeout / sendTimeout  → 'Request timed out'
badResponse                  → extracts message from response body
```

---

## Global Feedback — FlashCubit

Placed inside `MaterialApp.builder` so it overlays the entire app:

```dart
// Usage from any screen
context.read<FlashCubit>().success('Logged in!');
context.read<FlashCubit>().error('Wrong password.');
context.read<FlashCubit>().info('You have been logged out.');
```

> Use `hide()` not `close()` — `close()` is reserved by Cubit and kills the instance.

---

## Logout — Security Design

```dart
Future<void> logout() async {
  try {
    await authServices.logout(); // tell server to invalidate token
  } catch (_) {
    // swallowed — server failure doesn't block local logout
  } finally {
    await TokenStorage.clear(); // ALWAYS runs no matter what
    await UserStorage.clear();
  }
}
```

Token is **always** wiped locally, even if the server call fails.

---

## API — Response Shape

All endpoints return a unified envelope:

```json
{
  "data": {
    "user":  { "id", "name", "email", "phone" },
    "token": "...",
    "role":  "admin | cashier | null",
    "shop":  { "id", "name" } // null = onboarding not done
  }
}
```

---

## DioClient Setup

```dart
// constants.dart — always trailing slash
final baseUrl = "https://your-tunnel.trycloudflare.com/api/";
```

Auth token is injected automatically on every request via an interceptor. No manual header management needed in services or cubits.

---

## Dependency Injection

Everything wired in `di.dart` via GetIt:

```dart
getIt.registerLazySingleton<AuthServices>(() => AuthServices());
getIt.registerLazySingleton<AuthRepo>(() => AuthRepo(authServices: getIt()));
getIt.registerLazySingleton(() => AuthCubit(getIt<AuthRepo>()));
getIt.registerLazySingleton(() => FlashCubit());
```

> Never instantiate services or repos directly in screens. Always `getIt<T>()`.

---

## Key Rules

| Rule | Why |
|---|---|
| Never throw past Repository | Repo is the error firewall — cubits only see `AuthException` |
| Always `AuthException`, not `Exception` | `e.toString()` adds ugly "Exception:" prefix |
| Navigate in `listener`, never `builder` | `builder` reruns on every rebuild |
| `hide()` not `close()` on FlashCubit | `close()` kills the cubit permanently |
| Token wiped in `finally` | Never leave a stale token if server call fails |
| `AuthCubit` provided at root | Available to all screens including `LogoutButton` |
| Trailing slash on `baseUrl` | Dio path joining breaks without it |

---

## Screens (In Progress)

- [x] Login
- [x] Register
- [ ] Onboarding — Create Shop
- [ ] Onboarding — Join Shop
- [ ] Admin Home
- [ ] Admin — Cashier Management
- [ ] Admin — Reports
- [ ] Cashier — Shift
- [ ] Cashier — Transactions

---

*More screens documented as the app grows.*

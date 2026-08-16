# Admin & SuperAdmin Implementation Guide

This document maps the **MarketExpress API** (`https://www.marketexpress.somee.com`, Swagger at `/swagger/index.html`) to the Bloc layer built in `lib/blocs/`, and lays out the screens/flows needed to build the **Store-Admin dashboard** and the **SuperAdmin dashboard** on top of it. Use it as the spec when building the admin UI.

## 1. Roles & accounts

The API has three roles, returned as `getRoles` on login and stored via `MySharedPref.saveRoles()`:

| Role | Meaning | Example test account |
|---|---|---|
| `User` | Every authenticated account has this (customers, store owners, super admin alike) | `test@gmail.com` |
| `Admin` | Store owner — manages exactly one store | `StepElegance@gmail.com`, `Rose@gmail.com`, `Luxe@gmail.com`, `ELM@gmail.com` |
| `SuperAdmin` | Platform administrator — manages all stores/users/categories | `ayasally123456@gmail.com` |

All test accounts share the password `Sa123456?`. Check role with `AuthState.isStoreAdmin` / `AuthState.isSuperAdmin` (backed by `MySharedPref.isStoreAdmin()` / `isSuperAdmin()`), and gate navigation to the two dashboards accordingly.

A store owner's own store id/details come from `StoreBloc` → `GetStoreByAdminEvent` (`GET Store/GetStoresByAdmin`), **not** from the login response — the login response only contains role names and tokens.

## 2. Core plumbing (already wired)

- **`lib/core/utils/api_service.dart`** — `baseUrl` points at MarketExpress. `ApiService.init()` must run once at app start (already how it's structured) and loads any persisted token. A `QueuedInterceptorsWrapper` auto-refreshes on `401` using `Auth/RefreshToken` and retries the original request once; if refresh fails it calls `ApiService.clearAuth()` so subsequent calls go out unauthenticated (the UI should react to a failed call after that by routing to the login screen — there's no global "force logout" broadcast, check per-screen).
- **`lib/core/utils/my_shared_pref.dart`** — added `token` clear, `refresh_token`, `roles`, `user_id` storage, plus setters for the profile fields that already had getters.
- **`lib/core/utils/jwt_helper.dart`** — decodes the JWT payload client-side (no verification, just reads claims) to pull `userId`/`roles` right after login without an extra API call.
- **`lib/core/utils/api_error_helper.dart`** — `apiErrorMessage(error)` pulls the server's `message`/`errors` out of a `DioException` for display; every bloc's `catchError` branch uses it.
- **`lib/models/common/api_response_model.dart`** — `ApiResponseModel<T>` mirrors the API's constant envelope: `{ statusCode, success, message, data, errors }`. Every bloc unwraps `response.data` through this before touching the typed model.

## 3. Response envelope (every endpoint)

```json
{ "statusCode": 200, "success": true, "message": "Operation successful.", "data": { }, "errors": [] }
```

Failures come back as non-2xx HTTP (400/401/403/404), so Dio's `catchError`/`onError` chain (the same three-step pattern as `products_bloc`) is what fires — `success:false` on a 2xx response was not observed in practice, but `ApiResponseModel` still exposes `.success` if you want to double-check defensively.

## 4. Bloc directory

All follow the exact `products_bloc` shape: `part` files for event/state, `enum XStatus { init, loading, failure, success }` per action, `copyWith`-based state, `.then().catchError().onError()` per handler, Arabic fallback message `"حدث خطأ ما!"`.

| Bloc | Folder | Swagger tag(s) | Key state fields |
|---|---|---|---|
| `AuthBloc` | `lib/blocs/auth_bloc/` | Auth | `isLoggedIn`, `roles`, `loginResponse` |
| `UserBloc` | `lib/blocs/user_bloc/` | User | `userProfile` |
| `WalletBloc` | `lib/blocs/wallet_bloc/` | Wallet, Transaction | `wallet`, `transactions` |
| `CategoryBloc` | `lib/blocs/category_bloc/` | Category, StoreCategory | `categories`, `storeCategories` |
| `StoreBloc` | `lib/blocs/store_bloc/` | Store | `stores`, `myStore`, `storeProducts` |
| `StoreRequestBloc` | `lib/blocs/store_request_bloc/` | StoreRequest | `storeRequests`, `storeRequestFiles` |
| `StoreFollowerBloc` | `lib/blocs/store_follower_bloc/` | StoreFollower | `storeFollow`, `followedStoresProducts`, `followersCount` |
| `ProductBloc` | `lib/blocs/product_bloc/` | Product | `discountedProducts`, `searchResults`, `filterResults` |
| `ClothingItemBloc` | `lib/blocs/clothing_item_bloc/` | ClothingItem | `clothingItems`, `clothingItem`, `sizesByColor`, `suggestedProducts` |
| `CartBloc` | `lib/blocs/cart_bloc/` | Cart | `cart`, `lastAddedItem` |
| `OrderBloc` | `lib/blocs/order_bloc/` | Order, Payment | `orders`, `orderItems`, `checkoutResult`, `cancelResult`, `payment` |
| `CommentBloc` | `lib/blocs/comment_bloc/` | Comment | `comments` |
| `RatingBloc` | `lib/blocs/rating_bloc/` | Rating | `userRating`, `rating` |
| `PostBloc` | `lib/blocs/post_bloc/` | Post, PostReaction | `posts` |
| `ComplaintBloc` | `lib/blocs/complaint_bloc/` | Complaint, Message | `storeComplaints`, `userComplaints`, `messages` |
| `AdminBloc` | `lib/blocs/admin_bloc/` | Admin | `dashboardSummary`, `dashboardAnalytics`, `productDashboard`, `ordersDetail`, `inventoryAlerts`, `discountedStoreProducts` |
| `SuperAdminBloc` | `lib/blocs/super_admin_bloc/` | SuperAdmin | `activeUsers`, `bannedUsers`, `storeRequests`, `storeCategories`, `orders` |

Register every bloc your screen tree needs with `MultiBlocProvider` at the appropriate scope (app root for `AuthBloc`/`UserBloc`; per-dashboard for the rest to avoid keeping unused blocs alive).

## 5. Store-Admin Dashboard (`Admin` role) — screens

The store owner's whole app surface is scoped to **their own store**, resolved once via `StoreBloc.GetStoreByAdminEvent` and cached (`myStore.id`) for every subsequent call that needs a `storeId`.

### 5.1 Dashboard home
- `AdminBloc.GetDashboardSummaryEvent` → `dashboardSummary` (productsCount, followersCount, postsCount, totalReactions) as headline tiles.
- `AdminBloc.GetDashboardAnalyticsEvent(fromDate, endDate)` → `dashboardAnalytics` (ordersCount, totalSales, customersCount) for a date-range chart/panel. Default to e.g. last 30 days, let the owner change the range.
- `AdminBloc.GetProductInventoryAlertEvent` → `inventoryAlerts`, a low-stock list (product/color/size/quantity) — surface as a warning banner/list ("N variants low on stock").

### 5.2 Products management
- List: `AdminBloc.GetProductDashboardEvent(pageNumber, pageSize)` → `productDashboard.products` (rich shape: colors→sizes, totalStock, soldCount, soldTotalPrice, discount fields) + `productDashboard.totalProductsCount` for pagination. This is the admin-specific product list — richer than the public `ProductCatalogModel`/`StoreProductModel` used on customer-facing screens.
- Create: `ProductBloc.AddProductEvent` (multipart: name, description, price, season, gender, type, image, categoryId, optional discount%/dates). `season`/`gender`/`type` are free strings from the UI but must match the API enums: `enSeason` (Summer/Spring/Autumn/Winter), `enGender` (Male/Female), `enType` (Pants/Skirt/Dress/ShortPants/Shirt/T_shirt/Shoes/SportSet) — build these as dropdowns, not free text.
- Edit: `ProductBloc.UpdateProductEvent` — **only** price, categoryId, discount%/dates, and image are editable via the API; name/description/season/gender/type are not (matches what `Product/UpdateProduct` accepts). Don't build editable fields for the others.
- Delete: `ProductBloc.DeleteProductEvent`.
- Discounted products view: `AdminBloc.GetAllDiscountProductByStoreEvent` → `discountedStoreProducts`.

### 5.3 Product detail (colors & sizes)
Per product, colors and sizes are managed through `ClothingItemBloc`:
- `GetAllClothingItemsEvent(productId)` → color/size tree for the product detail screen.
- `AddColorForProductEvent(productId, color, colorHexCode, image)` → add a new color variant (multipart).
- `UpdateProductColorDetailsEvent(clothingItemId, color, image)` → replace a color's photo.
- `AddSizesForProductEvent(productColorId, sizes)` → bulk add sizes+quantities for a color. `size` values must be one of `enSize` (XS/S/M/L/XL/XXL/Shoe36…Shoe45 — shoe sizes vs clothing sizes, pick the right subset based on the product's category).
- `UpdateProductSizeEvent(productSizeId, quantity)` → restock a single size.
- `DeleteProductColorEvent` / `DeleteProductSizeEvent` → remove a variant/size.

### 5.4 Discounts, Categories
- Store categories (which global categories this store is tagged under): `CategoryBloc.GetAllStoreCategoryByAdminEvent` / `AddStoreCategoryEvent` / `DeleteStoreCategoryEvent`. `CategoryBloc.GetAllCategoriesEvent` supplies the global category picker.
- Product-level discounts are set directly on `AddProductEvent`/`UpdateProductEvent` (`discountPercentage`, `discountStartDate`, `discountEndDate`) — there's no separate discount CRUD endpoint in this API version (unlike the older `clothes_store` backend's `AddDiscount`/`GetAllDiscount`).

### 5.5 Orders
- `OrderBloc.GetAllOrdersEvent` for the store's order list (note: `GET Order/GetAllOrder` is scoped by the caller's token — for a store owner this should return the store's incoming orders; verify this against a real order once the store has one, since all orders observed during testing belonged to the buyer, not the seller).
- `OrderBloc.GetOrderItemsEvent(orderId)` for line items.
- `OrderBloc.UpdateOrderStatusEvent(orderId, status)` to move an order through `Processing → Delivered` (or `Cancelled`). `status` must be one of `enOrderStatus`.
- `OrderBloc.GetPaymentEvent(orderId)` to show payment/settlement info.
- Store-owner sales breakdown: `AdminBloc.GetOrdersDetailEvent(startDate, endDate)` → per (product,size,color) sales count/remaining stock — good for a "best sellers" table.

### 5.6 Store profile
- `StoreBloc.GetStoreByAdminEvent` to load; `UpdateStoreEvent` (PATCH, only send changed fields) for name/description/address/hours/phone; `UpdateStoreImagesEvent` (multipart) for logo/featured image.
- `StoreBloc.GetAllProductsByStoreEvent` for the public-facing product list preview.

### 5.7 Posts (store social feed)
- `PostBloc.GetAllPostsEvent(storeId)`, `AddPostEvent` (multipart, supports multiple `Image`/`Video` media items with per-item `mediaType`), `UpdatePostEvent`, `DeletePostEvent`. `visibility` is `Public` or `Followers` (`enPostVisibility`).
- Reactions are read-only from the store's perspective (`postReactions` counts inside each `PostModel`); `TogglePostReactionEvent` is for the *customer* side, not admin authoring.

### 5.8 Complaints (customer support)
- `ComplaintBloc.GetAllComplaintsEvent` → complaints filed against this store (`storeComplaints`, includes `status`).
- `ComplaintBloc.GetComplaintMessagesEvent(complaintId)` / `ReadComplaintMessagesEvent` for a chat-style thread. **The message shape is unverified** (see §7) and there's no "send message" endpoint in the current API — treat this as a stub until the backend exposes one, or confirm out-of-band whether replies happen through the `status` field only.

### 5.9 Wallet & transactions
- `WalletBloc.GetWalletEvent` → current balance. `GetAllTransactionsEvent` → ledger (`transactionType`: Deposit/Withdraw). Store owners get paid into this wallet on each order (`Payment.status: Paid` creates a `Deposit` transaction, observed live).

## 6. SuperAdmin Dashboard — screens

### 6.1 Store approvals
- `SuperAdminBloc.GetAllStoreRequestsByFilterEvent(storeStatus)` — filter tabs for `Pending`/`Approved`/`Rejected`/`Deleted`/`Cancelled` (`enStoreStatus`).
- Approve: `ApproveStoreRequestEvent(requestId)`. Reject: `RejectStoreRequestEvent(requestId, rejectionReason)`.
- `GetAllStoreCategoryEvent(storeId)` to show what categories an applicant selected.
- Cross-reference `StoreRequestBloc.GetStoreRequestFilesEvent(storeId)` (national ID front/back, store license images) for KYC review — this bloc lives in the *user-facing* folder since applicants also use it, but the SuperAdmin screen can reuse it read-only.

### 6.2 Users
- `GetActiveUsersEvent` / `GetBannedUsersEvent` → two tabs, both typed as `UserProfileModel` (same shape as `User/GetUserProfile`).
- `RevokeUserTokenEvent(userId)` — force logout (revokes refresh token).
- `UnbanUserEvent(userId)` — there is no explicit "ban" endpoint in this API version; banning likely happens as a side effect of another action (or isn't exposed yet) — only unban is available.
- `DeleteUserEvent(userId)` — irreversible; confirm with a dialog.
- `AddRoleEvent(userId, role)` — grants a role (e.g. promote a user to `Admin`/store owner outside the normal store-request flow, or grant `SuperAdmin`). Treat as a dangerous action requiring confirmation.

### 6.3 Categories (global catalog)
- `CategoryBloc.GetAllCategoriesEvent` / `AddCategoryEvent` / `DeleteCategoryEvent` — SuperAdmin owns the global category list that store owners then tag their store/products with.

### 6.4 Orders (platform-wide)
- `SuperAdminBloc.GetAllFilterOrdersEvent(orderStatus, pageNumber, pageSize)`. **Model unverified** — every test query returned an empty list (no seed data), so `SuperAdminOrderModel` is inferred from the store-owner order shape plus plausible cross-store fields (`storeId`, `storeName`, `customerFullName`). Confirm field names against a real response before shipping this screen.

## 7. Inferred / unverified response shapes — verify before shipping

Everything in the tables above was hit live against the real API using the provided test accounts, **except**:

- **`MessageModel`** (`lib/models/complaint/message_model.dart`) — no message could be produced (no "send message" endpoint exists in the current Swagger spec, and every complaint had zero messages). Shape is a best-guess chat-message convention.
- **`SuperAdminOrderModel`** (`lib/models/admin/super_admin_order_model.dart`) — `GetAllFilterOrders` returned `[]` in every filter tried (no seed orders visible to SuperAdmin). Verify once real orders exist.
- **`StoreRequestBloc.AddStoreRequestEvent` response** — not live-tested (would create a real pending store-application against the platform); the bloc doesn't force-parse a typed model for it, it just refetches `GetAllRequestStoreByUserEvent` on success, so this is safe either way.
- **`AdminBloc.DeleteStoreEvent`** (`DELETE Admin/Delete/{storeId}`) — tagged `Admin` (not `SuperAdmin`) in Swagger, so it's unclear whether a store owner can delete their own store or whether this needs elevated auth in practice. Gate it behind SuperAdmin in the UI until confirmed, or test with a disposable store.
- **`PostBloc.UpdatePostEvent`** — the multipart `NewMedias`/`DeletedMediaIds` array binding follows standard ASP.NET conventions (repeated form keys) but wasn't live-tested; `AddPostEvent`'s indexed `mediaDtos[i].*` binding *was* confirmed live and works.

Everything else (Auth, Store, Product, ClothingItem, Cart, Order/Payment, Comment, Rating, Post/PostReaction, Category/StoreCategory, Wallet/Transaction, User, StoreFollower, Complaint create/list, SuperAdmin users/store-categories) was confirmed against real responses.

## 8. API quirks worth knowing

- **`DiscountPrecentage`** — yes, misspelled in the real API (`Product/AddProduct` and `Product/UpdateProduct` multipart field names). The bloc code intentionally reproduces this typo; don't "fix" it or requests will silently fail to bind.
- **Cart 404 means empty, not broken** — `GET Cart/GetCartItems` returns `404 "السلة غير موجودة"` when the user has no cart yet. `CartBloc` treats this as a `failure` state but still seeds `cart` with an empty `CartSummaryModel` so the UI can render an empty-cart view instead of an error screen — check `state.cart` first before branching on status.
- **Follow/React are toggles, not separate follow/unfollow calls** — `PUT StoreFollower/StoreFollow` and `POST PostReaction` both flip the current state and return the resulting `isFollow`/`isReacted` flag. Call the same event again to undo.
- **`Rating/GetProductRatingByUser`** returns a bare `int` (0 if the user hasn't rated), not an object.
- **PUT/DELETE with an empty body needs `body: const {}`, not `null`** — the host (IIS on somee.com) returns `411 Length Required` for a bodyless PUT/DELETE with no `Content-Length` header; passing an empty JSON object avoids it. Already applied in `CancelOrderEvent`/`CancelStoreRequestEvent`.
- **Refresh token rotates** — every successful `Auth/RefreshToken` call invalidates the previous refresh token and issues a new one; `ApiService` persists the new one via `MySharedPref.saveRefreshToken` automatically through the 401 interceptor, but if you ever call `RefreshTokenEvent` manually, don't reuse a stale refresh token.
- **Enums are sent as their string names** (`"Male"`, `"Processing"`, `"Shoe42"`, etc.) — no numeric enum values anywhere observed.

## 9. Wiring example

```dart
MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => AuthBloc()..add(LoadStoredAuthEvent())),
    BlocProvider(create: (_) => UserBloc()..add(GetUserProfileEvent())),
    // Store-admin dashboard route only:
    BlocProvider(create: (_) => StoreBloc()..add(GetStoreByAdminEvent())),
    BlocProvider(create: (_) => AdminBloc()..add(GetDashboardSummaryEvent())),
    BlocProvider(create: (_) => ProductBloc()),
    BlocProvider(create: (_) => ClothingItemBloc()),
    BlocProvider(create: (_) => OrderBloc()..add(GetAllOrdersEvent())),
    BlocProvider(create: (_) => ComplaintBloc()..add(GetAllComplaintsEvent())),
    BlocProvider(create: (_) => WalletBloc()..add(GetWalletEvent())),
    BlocProvider(create: (_) => CategoryBloc()..add(GetAllStoreCategoryByAdminEvent())),
    BlocProvider(create: (_) => PostBloc()),
  ],
  child: const AdminDashboardShell(),
)
```

For the SuperAdmin dashboard, swap `StoreBloc`/`AdminBloc`/etc. for `SuperAdminBloc` + `CategoryBloc` (global categories) + `StoreRequestBloc` (read-only, for KYC files).

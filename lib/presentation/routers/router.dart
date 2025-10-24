import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';

import 'router.gr.dart';

@injectable
@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: LoginV2Route.page),
        AutoRoute(page: SignupRoute.page),
        AutoRoute(page: ForgotPasswordRoute.page),
        AutoRoute(page: VerifyPasswordRoute.page),
        AutoRoute(page: ResetPasswordRoute.page),
        AutoRoute(page: ChangePasswordRoute.page),
        AutoRoute(page: HomeRoute.page),
        AutoRoute(page: QrBottomRoute.page),

        //Mark: Product
        AutoRoute(page: ProductManagerRoute.page),
        AutoRoute(page: ProductFilterRoute.page),
        AutoRoute(page: ProductCreateRoute.page),
        AutoRoute(page: ProductDetailRoute.page),
        AutoRoute(page: VariantDetailRoute.page),
        AutoRoute(page: VariantDetailMykiot.page),
        AutoRoute(page: EditVariantRoute.page),
        AutoRoute(page: ProductEditRoute.page),
        AutoRoute(page: ProductBarCodeScanRoute.page),
        AutoRoute(page: ProductScanForCreate.page),
        AutoRoute(page: AddProductRoute.page),
        AutoRoute(page: ProductDetailManagerRoute.page),

        //Mark: Brand
        AutoRoute(page: BrandCreateRoute.page),
        AutoRoute(page: BrandDetailRoute.page),
        AutoRoute(page: BrandEditRoute.page),

        //Mark: Group
        AutoRoute(page: GroupCreateRoute.page),
        AutoRoute(page: GroupDetailRoute.page),
        AutoRoute(page: GroupEditRoute.page),

        //Mark: Category
        AutoRoute(page: CreateCategoryRoute.page),
        AutoRoute(page: CategoryDetailRoute.page),
        AutoRoute(page: CategoryEditRoute.page),

        //Mark: Order
        AutoRoute(page: OrderManagerRoute.page),
        AutoRoute(page: OrderCreateRoute.page),
        AutoRoute(page: OrderCreateByBarcodeRoute.page),
        AutoRoute(page: OrderCreateConfirmRoute.page),
        AutoRoute(page: OrderDetailRoute.page),
        AutoRoute(page: OrderHistoryRoute.page),
        AutoRoute(page: OrderImportRoute.page),
        AutoRoute(page: QrCodePaymentRoute.page),

        //Mark: Bill
        AutoRoute(page: BillDetailRoute.page),

        //Mark: store
        AutoRoute(page: MykiotStoreRoute.page),
        AutoRoute(page: MykiotVariantPromotionRoute.page),
        //Mark: Noti
        AutoRoute(page: NotiRoute.page),

        //Mark: Map picker
        AutoRoute(page: MapPickerRoute.page),

        //Mark: Rich text editor
        // AutoRoute(page: RichTextEditorRoute.page),

        //Mark: Address Custom
        // AutoRoute(page: AddressCustomerRoute.page),

        //Mark: Customer
        AutoRoute(page: CustomerListRoute.page),
        AutoRoute(page: CustomerCreateRoute.page),
        AutoRoute(page: CustomerDetailRoute.page),
        AutoRoute(page: CustomerEditRoute.page),

        // store
        AutoRoute(page: StoreInformationRoute.page),
        AutoRoute(page: EditStoreRoute.page),
        AutoRoute(page: AddBankRoute.page),
        AutoRoute(page: AdditionalInformationRoute.page),

        AutoRoute(page: ShoppingCartRoute.page),

        //v2
        AutoRoute(page: LoginV2Route.page),
        AutoRoute(page: OtpRoute.page),
        AutoRoute(page: SignUpV2Route.page),
        AutoRoute(page: ConfirmAccountRoute.page),
        AutoRoute(page: AddressV2Route.page),
        AutoRoute(page: ResetPasseV2Route.page),
        //WareHouse
        AutoRoute(page: WarehouseListRouteV2.page),
        AutoRoute(page: CreateWarehouseReceiptRoute.page),
        AutoRoute(page: ParticipationEventRoute.page),

      ];
}

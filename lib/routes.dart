import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vcarez_new/ui/cart/view/cart_list_screen.dart';
import 'package:vcarez_new/ui/categorymedicinelist/view/category_medicine_list_screen.dart';
import 'package:vcarez_new/ui/dashboard/pages/dashboard/view/main_dashboard.dart';
import 'package:vcarez_new/ui/dashboard/pages/prescription/view/add_prescription.dart';
import 'package:vcarez_new/ui/feature_detail/view/featured_brand_detail.dart';
import 'package:vcarez_new/ui/forgotpassword/view/forgot_password_screen.dart';
import 'package:vcarez_new/ui/login/bloc/login_bloc.dart';
import 'package:vcarez_new/ui/login/view/login_screen.dart';
import 'package:vcarez_new/ui/medicine_list/view/medicine_list_screen.dart';
import 'package:vcarez_new/ui/medicinedetails/view/medicine_details.dart';
import 'package:vcarez_new/ui/my_prescription/view/my_prescription_screen.dart';
import 'package:vcarez_new/ui/myaddress/view/my_address_screen.dart';
import 'package:vcarez_new/ui/myaddress/view/save_address_screen.dart';
import 'package:vcarez_new/ui/myprofile/view/my_profile_screen.dart';
import 'package:vcarez_new/ui/myorderlist/view/my_order_list_screen.dart';
import 'package:vcarez_new/ui/orderconfirm/view/order_confirmation_screen.dart';
import 'package:vcarez_new/ui/payment/view/payment_method_screen.dart';
import 'package:vcarez_new/ui/privilegeplan/view/plan_confirm_success.dart';
import 'package:vcarez_new/ui/privilegeplan/view/privilage_plan_screen.dart';
import 'package:vcarez_new/ui/profile/bloc/edit_profile_bloc.dart';
import 'package:vcarez_new/ui/profile/view/edit_profile_screen.dart';
import 'package:vcarez_new/ui/quotationrecievedhistory/view/quotations_detail_screen.dart';
import 'package:vcarez_new/ui/quotationrecievedhistory/view/quotations_recieved_list_screen.dart';
import 'package:vcarez_new/ui/searchdetailist/view/search_detail_list_screen.dart';
import 'package:vcarez_new/ui/shopquotationdetail/view/shop_detail_screen.dart';
import 'package:vcarez_new/ui/signup/bloc/signup_bloc.dart';
import 'package:vcarez_new/ui/signup/view/signup_screen.dart';
import 'package:vcarez_new/ui/splash/view/splash_screen.dart';
import 'package:vcarez_new/ui/trendingmedicinelist/view/trending_medicine_list_screen.dart';
import 'ui/forgotpassword/bloc/forgot_password_bloc.dart';
import 'utils/route_names.dart';

class Routes {
  static Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case routeSplash:
        return MaterialPageRoute(
          builder: (context) =>
              // BlocProvider(
              //   create: (context) => LoginBloc(),
              //   child:
              const SplashScreen(),
          // )
        );
      case routeLogin:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => LoginBloc(),
                  child: const LoginScreen(),
                ));
      case routeSignup:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => SignupBloc(),
                  child: const SignupScreen(),
                ));

      case routeDashboard:
        return MaterialPageRoute(
          builder: (context) =>
              // BlocProvider(
              //   create: (context) => LoginBloc(),
              //   child:
              const MainDashBoard(),
          // )
        );
      case routeMyProfile:
        return MaterialPageRoute(
          builder: (context) => const MyProfileScreen(),
        );
      case routeQuotationHistory:
        return MaterialPageRoute(
            builder: (context) => const QuotationsReceivedListScreen(),
            settings: settings);
      case routePrivilegePlan:
        return MaterialPageRoute(
            builder: (context) => const PrivilegePlanScreen(),
            settings: settings);
      case routeMyAddressList:
        return MaterialPageRoute(
            builder: (context) => const MyAddressScreen(), settings: settings);
      case routeQuotationDetailList:
        return MaterialPageRoute(
            builder: (context) => const QuotationsDetailListScreen(),
            settings: settings);
      case routeFeatureBrandDetail:
        return MaterialPageRoute(
            builder: (context) => const FeaturedBrandDetailScreen(),
            settings: settings);
      case routeShopQuotationDetail:
        return MaterialPageRoute(
            builder: (context) => const ShopDetailScreen(), settings: settings);
      case routeEditProfile:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
              create: (context) => EditProfileBloc(),
              child: const EditProfileScreen()),
        );
      case routeUploadPrescription:
        return MaterialPageRoute(
          builder: (context) => AddPrescriptionPage(),
        );
      case routeSearchDetails:
        return MaterialPageRoute(
          builder: (context) => SearchDetailListScreen(),
        );
      case routeMedicineDetails:
        return MaterialPageRoute(
            builder: (context) =>
                // BlocProvider(
                //   create: (context) => LoginBloc(),
                //   child:
                const MedicineDetailPageWidget(),
            settings: settings
            // )
            );
      case routeMyPrescription:
        return MaterialPageRoute(
          builder: (context) => MyPrescriptionScreen(),
        );
      case routeForgotPassword:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
              create: (context) => ForgotPasswordBloc(),
              child: const ForgotPasswordScreen()),
        );
      case routeMedicineList:
        return MaterialPageRoute(
            builder: (context) =>
                // BlocProvider(
                //   create: (context) => LoginBloc(),
                //   child:
                const MedicineListScreen(),
            settings: settings
            // )
            );
      case routeMyOrderList:
        return MaterialPageRoute(
            builder: (context) =>
                // BlocProvider(
                //   create: (context) => LoginBloc(),
                //   child:
                const MyOrderListScreen(),
            settings: settings
            // )
            );
      case routeCartList:
        return MaterialPageRoute(
            builder: (context) =>
                // BlocProvider(
                //   create: (context) => LoginBloc(),
                //   child:
                const CartListScreen(),
            settings: settings
            // )
            );
      case routeTrendingMedicineList:
        return MaterialPageRoute(
            builder: (context) =>
                // BlocProvider(
                //   create: (context) => LoginBloc(),
                //   child:
                const TrendingMedicineListScreen(),
            settings: settings
            // )
            );
      case routeCategoryMedicineList:
        return MaterialPageRoute(
            builder: (context) => const CategoryMedicineListScreen(),
            settings: settings);

      case routeSaveAddress:
        return MaterialPageRoute(
            builder: (context) => const SaveAddressScreen(),
            settings: settings);

      case routePaymentMethod:
        return MaterialPageRoute(
            builder: (context) => const PaymentMethodScreen(),
            settings: settings);

      case routeOrderConfirmation:
        return MaterialPageRoute(
            builder: (context) => const OrderConfirmationScreen(),
            settings: settings);

      case routePlanConfirmScreen:
        return MaterialPageRoute(
            builder: (context) => const PlanConfirmScreen(),
            settings: settings);
    }
  }
}

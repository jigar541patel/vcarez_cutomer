class ApiEndpoint {
  // DEV API as on 14 june 2022
  static String baseUrl = "https://vcarez.com/adminmanagement/api/customer";
  static String baseAppUrl = "https://vcarez.com/adminmanagement/api";
  static String baseImageUrl = "https://home.dev.thebookus.com";
  static String socketUrl = "https://home.dev.thebookus.com/";
  static String baseUrlPwa = "https://home.dev.thebookus.com/api/pwa/";

  static String userLogin = "$baseUrl/login";
  static String forgotPassword = "$baseUrl/forget-password";
  static String updatePassword = "$baseUrl/update-password";
  static String userRegister = "$baseUrl/register";
  static String getUserprofile = "$baseUrl/edit-profile";
  static String getPrivilegePlanList = "$baseUrl/membership-plans";
  static String getBannerList = "$baseUrl/banners";
  static String getPrescriptionList = "$baseUrl/prescription";
  static String getCategoryList = "$baseUrl/category-list";
  static String getCurrentOrderList = "$baseUrl/current-orders";
  static String getPopularMedicineList = "$baseUrl/popular-list";
  static String getFeatureBrandList = "$baseUrl/featured-brands?limit=10&skip=0";
  static String getFeatureBrandDetail = "$baseUrl/featured-all";
  static String getFeatureProductList = "$baseUrl/products-all";
  static String getNotificationList = "$baseUrl/notification?limit=10&skip=0";
  static String getAddressList = "$baseUrl/delivery-address";
  static String getStateList = "$baseAppUrl/states";
  static String getCityList = "$baseAppUrl/cities";
  static String getCategoryMedicineList = "$baseUrl/product-by-category";
  static String getCartList = "$baseUrl/cart";
  static String getQuotationHistoryDetailList = "$baseUrl/prescription-quots";
  static String getQuotationHistoryList = "$baseUrl/quot-history?limit=10&skip=0";
  static String getMyOrderList = "$baseUrl/my-order";
  static String saveMyOrderList = "$baseUrl/my-order";
  static String getShopQuotationDetail = "$baseUrl/quot-detail";
  static String getTrendingMedicineList = "$baseUrl/trending-list";
  static String getMedicineDetail = "$baseUrl/product-details/";
  static String updateProfile = "$baseUrl/update-profile";
  static String createOrderSession = "$baseUrl/cashfree-session";
  static String saveAddress = "$baseUrl/delivery-address";
  static String buySubscription = "$baseUrl/purchase-plan";
  static String acceptQuote = "$baseUrl/accept-quots";
  static String verifyCFOrderID = "$baseUrl/cashfree-verify";
  static String saveOrderAccept = "$baseUrl/my-order";
  static String addToCart = "$baseUrl/cart";
  static String deleteAddress = "$baseUrl/delivery-address";
  static String placeOrder = "$baseUrl/cart-to-quot";
  static String searchMedicine = "$baseUrl/search-med";
  static String searchMedicineDetail = "$baseUrl/search-med-detail";
  static String uploadPrescription = "$baseUrl/upload-prescription";
  static String updatePrescription = "$baseUrl/update-prescription";
}

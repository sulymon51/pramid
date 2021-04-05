class NetworkUrl {
  static String baseUrl            =  "https://pyramidpharmacy.com/rxcare/api/mshop/";
  static String baseUrll            =  "https://pyramidpharmacy.com/rxcare/";
  static String baseApi            =  baseUrl + "api/";
  static String baseApii            =  baseUrll + "api/";
  static String getProduct         =  baseApi + "getProduct.php";
  static String addProduct         =  baseApi + "addProduct.php";
  static String orderProduct       =  baseApii + "buyproduct.php";
  static String getProductCategory =  baseApi + "getCategoryProduct.php";
  static String addFavoriteWithoutLogin = baseApi + "/addFavoriteWithoutLogin.php";

  static String getFavoriteWithoutLogin(String text){
    return baseApi + "getFavoriteWithoutLogin.php?deviceInfo=${text}";
  }
}
class Endpoint {
  //auth
  static const requestToken = '/auth';
  static const requestOtp = '/auth/signin';
  static const requestOtpProfile = '/customer/request-otp';
  static const signout = '/auth/signout';
  static const authInfo = '/auth/info';
  static const verificationOtp = '/auth/signin/verify';
  static const updateUser = '/customer';
  static const registerUser = '/auth/register';

  static const patchHome = '/pages/home';
  static const initialSearch = '/search';
  static const Searchresult = '/search';
  static const artikel = '/article';
  static const requestKota = '/city';
  static const getProvinsi = '/province';
  static const requestKecamatan = '/kecamatan';
  static const requestKelurahan = '/kelurahan';
  static const requestpekerjaan = '/occupation';
  static const initialCheckout = '/checkout';
  static const checkoutSubmit = '/checkout/submit';
  static const patchM2w = '/pages/m2w';
  static const requestM2wMotor = '/m2w/motor';
  static const requestM2wPrice = '/m2w/price';
  static const patchM4w = '/pages/m4w';
  static const requestM4wMobil = '/m4w/mobil';
  static const requestM4wPrice = '/m4w/price';
  static const requestVoucher = '/voucher';
  static const requestPromotion = '/promotion';
  static const patchHmc = '/pages/motor';
  static const getMotor = '/motor';
  static const orderList = '/customer/orders';
  static const orderDetail = '/customer/orders/';
  static const logging = '/logging';
  static const discussion = '/customer/discussion';
  static const sparepartDiscussion = '/sparepart/discussion';
  static const bookingServisDiscussion = '/booking-servis/discussion';
  static const m2wDiscussion = '/m2w/discussion';
  static const m4wDiscussion = '/m4w/discussion';
  static const ulasan = '/customer/reviews';
  static const settings = '/customer/settings';

  //sparepart
  static const patchSparepart = '/pages/sparepart';
  static const detailSparepart = '/sparepart';
  static const kategoriSparepart = '/sparepart/category';
  static const motorSparepart = '/sparepart/motor';
  static const brandSparepart = '/sparepart/brand';
  static const initialkategoriSparepart = '/pages/sparepart/category';
  static const initialmotorSparepart = '/pages/sparepart/motor';
  static const initialbrandSparepart = '/pages/sparepart/brand';
  static const addItemtoCart = '/cart';
  static const selectIteminCity = '/cart/items';
  static const updateCart = '/cart';
  static const initialCart = '/pages/cart';
  static const vouchersCartSparepart = '/cart/voucher';
  static const listAddress = '/customer/address';
  static const setDefault = '/customer/address/set-default';

  //sparepart flashsale
  static const landingPageFlashsale = '/campaign';

  static const getTipeAddress = '/customer/address/type';
  static const selectedItem = '/cart/item';
  static const deliveryOptions = '/checkout/delivery';
  static const paymentOptions = '/checkout/payment';
  static const vouchersCheckoutSparepart = '/checkout/voucher';

  //article
  static const article = '/article';

  //vehicles
  static const initialVehicle = '/customer/vehicles';

  static const patchBookingServis = '/pages/booking-servis';
  static const bookingService = '/booking-servis';
  static const getBookingServisMotor = '/booking-servis/motor';
  static const getBookingServisAhass = '/booking-servis/ahass';
  static const getBookingServisPackages = '/booking-servis/packages';
  static const bookingServicePayment = '/booking-servis/payment';

  static const checkout = '/checkout';
  static const confirm = '/checkout/submit';

  static const review = '/review';

  static const getMotordetail = '/pages/motor';
  static const notification = '/notification';
  static const subscribeNotification = '/notification/subscribe';
  static const getNotification = '/customer/notification';
  static const deepLink = '/deeplink';
  static const customPages = '/pages/custom';

  //global
  static const global = '/pages/global';

  //agen

  static const agentApplicatioinForm = '/agent/apply';
  static const agentProfile = '/agent';
  static const verificationAgent = '/agent/verify';
  static const requestOtpAgen = '/agent/resend-otp';

  //Agent HMC
  static const patchAgentHmcEmptyCity = '/pages/motor/agen';

  static const patchAgentHmcPricelist = "/motor/agen/price-list";


  //KLIKNSS EVOLVE 
  static const evolvePatchHome = "/pages";
}

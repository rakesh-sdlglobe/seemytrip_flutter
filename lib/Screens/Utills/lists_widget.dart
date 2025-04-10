import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Constants/images.dart';
import 'package:makeyourtripapp/Controller/login_controller.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/DrawerScreen/setting_screen.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/FlightBookScreen/FlightSearchScreen/flight_from_screen.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/FlightBookScreen/FlightSearchScreen/flight_to_screen.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/HolidayPackagesScreen/budget_screen.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/HolidayPackagesScreen/duration_screen.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/HolidayPackagesScreen/hotel_choice_screen.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/HolidayPackagesScreen/suitable_screen.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/HotelAndHomeStayScreens/HotelsScreen/hotel_and_homestay.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/HotelAndHomeStayScreens/HotelsScreen/localitiy_screen.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/HotelAndHomeStayScreens/HotelsScreen/popular_filter_screen.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/HotelAndHomeStayScreens/HotelsScreen/price_range_screen.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/HotelAndHomeStayScreens/HotelsScreen/property_type_screen.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/HotelAndHomeStayScreens/rooms_and_guest_screen.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/HotelAndHomeStayScreens/search_city_screen.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/HotelAndHomeStayScreens/select_checkin_date_screen.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/OffersScreen/offer_screen.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/SelfDriveCarsScreen/self_drive_cars_screen.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/TrainAndBusScreen/train_and_bus_from_screen.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/TrainAndBusScreen/train_and_bus_to_screen.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/VisaServicesScreen/apply_tourist_visa_screen.dart';
import 'package:makeyourtripapp/Screens/MyAccountScreen/my_giftcard_screen.dart';
import 'package:makeyourtripapp/Screens/MyAccountScreen/my_wishlist_screen.dart';
import 'package:makeyourtripapp/Screens/MyTripScreen/my_trip_screen.dart';
import 'package:makeyourtripapp/Screens/NotificationScreen/notification_screen.dart';
import 'package:makeyourtripapp/Screens/SelectPaymentMethodScreen/mobile_wallet_screen.dart';
import 'package:makeyourtripapp/Screens/SelectPaymentMethodScreen/net_banking_screen.dart';
import 'package:makeyourtripapp/Screens/SelectPaymentMethodScreen/pay_by_card_screen.dart';
import 'package:makeyourtripapp/Screens/SelectPaymentMethodScreen/pay_by_upi_screen.dart';
import 'package:makeyourtripapp/Screens/TransactionHistory/transaction_history_screen.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';
import 'package:makeyourtripapp/Screens/Where2GoScreen/international_screen.dart';

class Lists {
  final LoginController loginController = Get.find<LoginController>();

  static List<Map<String, dynamic>> welcomeList = [
    {
      "image": welcomeImage1,
      "text": "Embark on Your Adventure",
      "description":
          "Start your journey with us and explore breathtaking destinations. Every journey begins with a single step.",
    },
    {
      "image": welcomeImage2,
      "text": "Discover the World",
      "description":
          "Uncover hidden gems and iconic landmarks as you travel to places you've always dreamed of.",
    },
    {
      "image": welcomeImage3,
      "text": "Create Unforgettable Memories",
      "description":
          "Capture moments that last a lifetime and cherish experiences with loved ones as you travel the world.",
    },
  ];

  static List dayList = [
    "Thu 13",
    "Fri 14",
    "Sat 15",
    "Sun 16",
    "Mon 17",
    "The 18",
    "Wed 19",
    "Thu 20",
  ];

  static List<Map> welcome2List = [
    {
      "text1": "English",
      "text2": "A",
    },
    {
      "text1": "हिन्दी",
      "text2": "क",
    },
  ];

  static List countryList = [
    {"image": argentina, "country": "Argentina"},
    {"image": australia, "country": "Australia"},
    {"image": belgique, "country": "Belgique"},
    {"image": brazil, "country": "Brazil"},
    {"image": canadaEnglish, "country": "Canada (English)"},
    {"image": canadaEnglish, "country": "Canada (Francais)"},
    {"image": chile, "country": "Chile"},
    {"image": colombia, "country": "Colombia"},
    {"image": cesko, "country": "Cesko"},
    {"image": danmark, "country": "Danmark"},
    {"image": deutschland, "country": "Deutschland"},
    {"image": espana, "country": "Espana"},
    {"image": france, "country": "France"},
    {"image": india, "country": "India"},
    {"image": ireland, "country": "Ireland"},
    {"image": israel, "country": "Israel"},
    {"image": italia, "country": "Italia"},
    {"image": malaysia, "country": "Malaysia"},
    {"image": maxico, "country": "Maxico"},
    {"image": nederland, "country": "Nederland"},
    {"image": newZealand, "country": "New Zealand"},
    {"image": osterreich, "country": "Osterreich"},
    {"image": peru, "country": "Peru"},
    {"image": philippines, "country": "Philippines"},
    {"image": polska, "country": "Polska"},
    {"image": portugal, "country": "Portugal"},
    {"image": schweiz, "country": "Schweiz (Deutsch)"},
    {"image": singapore, "country": "Singapore"},
    {"image": slovensko, "country": "Slovensko"},
    {"image": suisse, "country": "Suisse (Francais)"},
    {"image": suomi, "country": "Suomi"},
    {"image": sverige, "country": "Sverige"},
    {"image": suisse, "country": "Svizzera (italiano)"},
    {"image": suisse, "country": "Switzerland (English)"},
    {"image": thailand, "country": "Thailand (English)"},
    {"image": turkiye, "country": "Turkiye"},
    {"image": unitedArabEmirates, "country": "United Arab Emirates"},
    {"image": uK, "country": "United Kingdom"},
    {"image": uS, "country": "United States"},
  ];

  static List<Map> homeList1 = [
    {
      "image": offerIcon,
      "text": "Offers",
      "onTap": () {
        Get.to(() => OfferScreen());
      },
    },
    {
      "image": selfDrive,
      "text": "Self Drive",
      "onTap": () {
        Get.to(() => SelfDriveCarsScreen());
      },
    },
    {
      "image": visaServices,
      "text": "Visa services",
      "onTap": () {
        Get.to(() => ApplyTouristVisaScreen());
      },
    },
    {
      "image": flightStatus,
      "text": "Flight Status",
      "onTap": () {},
    },
  ];

  static List<Map> homeList2 = [
    {
      "image": jaisalmer,
      "text1": "Jaisalmer",
      "text2": "Jaisalmer Desert",
      "text3": "₹ 6852  ",
    },
    {
      "image": delhi,
      "text1": "Delhi",
      "text2": "New Delhi Travelling",
      "text3": "₹ 5692",
    },
    {
      "image": udupi,
      "text1": "Udupi",
      "text2": "Catch Sunset",
      "text3": "₹ 5692",
    },
    {
      "image": mhableshwar,
      "text1": "Mahabaleshwar",
      "text2": "Exploring the beauty",
      "text3": "₹ 5630",
    },
    {
      "image": gokarna,
      "text1": "Gokarna",
      "text2": "Gokarna Beach",
      "text3": "₹ 4025",
    },
    {
      "image": banglore,
      "text1": "Bangalore",
      "text2": "Gokarna Beach",
      "text3": "₹ 4025",
    },
    {
      "image": kedarnath,
      "text1": "Kedarnath",
      "text2": "Piece of Heaven",
      "text3": "₹ 2033",
    },
    {
      "image": kochi,
      "text1": "Kochi",
      "text2": "Arabain Sea",
      "text3": "₹ 5230",
    },
  ];

  static List myTripList = [
    myTripImage1,
    myTripImage2,
    myTripImage3,
    myTripImage4,
  ];

  static List<Map> where2GoList1 = [
    {
      "image": where2GoFamilyTripImage,
      "text": "Family Trip",
    },
    {
      "image": where2GoFriendsTripImage,
      "text": "Friends Trip",
    },
    {
      "image": where2GoWeekendTripImage,
      "text": "Weekend Trip",
    },
  ];

  static List<Map> where2GoList2 = [
    {
      "image": international,
      "text": "International",
      "onTap": () {
        Get.to(() => InterNationalScreen());
      },
    },
    {
      "image": honyMoon,
      "text": "Honeymoon",
      "onTap": () {},
    },
    {
      "image": weekend,
      "text": "Weekend",
      "onTap": () {},
    },
    {
      "image": romantic,
      "text": "Romantic",
      "onTap": () {},
    },
    {
      "image": beach,
      "text": "Beach",
      "onTap": () {},
    },
    {
      "image": mountain,
      "text": "Mountain",
      "onTap": () {},
    },
  ];

  static List<Map> where2GoList3 = [
    {
      "image": shillong,
      "text": "Shillong",
    },
    {
      "image": cheraapunji,
      "text": "Cheraapunji",
    },
    {
      "image": kasol,
      "text": "Kasol",
    },
    {
      "image": ooty,
      "text": "Ooty",
    },
    {
      "image": coorg,
      "text": "Coorg",
    },
    {
      "image": nainital,
      "text": "Nainital",
    },
  ];

  static List<Map> where2GoList4 = [
    {
      "image": stayLike,
      "text": "stay Like a celebrity \nAt 5 Maldivies Res..",
    },
    {
      "image": mostBooked,
      "text": "Most Booked \nInt’l Destinations",
    },
    {
      "image": wellnessRestrat,
      "text": "Wellness Restrat \n in India",
    },
    {
      "image": hillHideaways,
      "text": "hill Hideaways for\n your Summer Break",
    },
    {
      "image": luxuryvillas,
      "text": "Luxury Villas with \nStunning Pools",
    },
  ];

  static List whereGo2SearchList = [
    "Top Indian Destinations For A Fun Trip",
    "Weekend getways bear me",
    "Budget destinations near me",
    "Places to visit in October",
  ];

  static List homeSearchList = [
    "Book Flights",
    "Travel Offers",
    "Explore",
    "Book Hotels",
    "Book Homestays",
    "Book Villas",
  ];

  static List<Map> notificationList = [
    {
      "image": bookingCancelledImage,
      "text1": "Booking Cancelled!",
      "text2": "Sep 21, 2022",
    },
    {
      "image": wallet,
      "text1": "Credit Card Transaction",
      "text2": "Sep 22, 2022",
    },
    {
      "image": bookingCancelledImage,
      "text1": "Booking Cancelled!",
      "text2": "Sep 19, 2022",
    },
    {
      "image": wallet,
      "text1": "Credit Card Transaction",
      "text2": "Sep 18,2022",
    },
  ];

  static List<Map> flightSearchList1 = [
    {
      "image": fromFlightImage,
      "text1": "FROM",
      "text2": "New Delhi ",
      "text3": "DEL",
      "text4": "Indira Gandhi international Airport",
      "onTap": () {
        Get.to(() => FlightFromScreen());
      },
    },
    {
      "image": toFlightImage,
      "text1": "TO",
      "text2": "Mumbai ",
      "text3": "BOM",
      "text4": "Chhatrapati Shivaji international Airport",
      "onTap": () {
        Get.to(() => FlightToScreen());
      },
    },
    {
      "image": calendarPlus,
      "text1": "DEPARTURE DATE",
      "text2": "22 Sep ",
      "text3": "Thu, 2022",
      "text4": "",
      "onTap": () {},
    },
  ];

  static List<Map> flightSearchRoundTripList1 = [
    {
      "image": fromFlightImage,
      "text1": "FROM",
      "text2": "New Delhi ",
      "text3": "DEL",
      "text4": "Indira Gandhi international Airport",
      "onTap": () {
        Get.to(() => FlightFromScreen());
      },
    },
    {
      "image": toFlightImage,
      "text1": "TO",
      "text2": "Mumbai ",
      "text3": "BOM",
      "text4": "Chhatrapati Shivaji international Airport",
      "onTap": () {
        Get.to(() => FlightToScreen());
      },
    },
    {
      "image": calendarPlus,
      "text1": "DEPARTURE DATE",
      "text2": "22 Sep ",
      "text3": "Thu, 2022",
      "text4": "",
      "onTap": () {},
    },
    {
      "image": calendarPlus,
      "text1": "DEPARTURE DATE",
      "text2": "23 Sep ",
      "text3": "Fri, 2022",
      "text4": "",
      "onTap": () {},
    },
  ];

  static List flightSearchList2 = [
    "Armed Forces",
    "Student",
    "Senior Citizen",
    "Double Seat",
  ];

  static List<Map> flightBookList1 = [
    {
      "text1": "Fri, Sep 23 ",
      "text2": "₹ 7,110",
    },
    {
      "text1": "Sat, Sep 24",
      "text2": "₹ 9,193",
    },
    {
      "text1": "Sun, Sep 25 ",
      "text2": "₹ 12,110",
    },
    {
      "text1": "Mon, Sep 26",
      "text2": "₹ 9,193",
    },
    {
      "text1": "Tue, Sep 27",
      "text2": "₹ 9,193",
    },
    {
      "text1": "Wed, Sep 28",
      "text2": "₹ 12,110",
    },
    {
      "text1": "Thu, Sep 29",
      "text2": "₹ 9,193",
    },
  ];

  static List flightBookList2 = [
    "Non Stop",
    "Morning Departues",
    "Indigo",
    "Vistata",
    "Air India",
    "Spicejet",
    "Go First",
    "Air Asia",
  ];

  static List<Map> cheapestList = [
    {
      "text1": "19.45",
      "text2": "2h",
      "text3": " 15m",
      "text4": "22.00",
      "text5": "₹ 5,950",
      "isSelected": false,
    },
    {
      "text1": "17.45",
      "text2": "1h",
      "text3": " 15m",
      "text4": "21.00",
      "text5": "₹ 6,950",
      "isSelected": false,
    },
    {
      "text1": "16.30",
      "text2": "3h",
      "text3": " 15m",
      "text4": "24.00",
      "text5": "₹ 8,950",
      "isSelected": false,
    },
    {
      "text1": "14.45",
      "text2": "2h",
      "text3": " 15m",
      "text4": "18.00",
      "text5": "₹ 5,950",
      "isSelected": false,
    },
    {
      "text1": "20.45",
      "text2": "2h",
      "text3": " 15m",
      "text4": "22.00",
      "text5": "₹ 3,950",
      "isSelected": false,
    },
    {
      "text1": "16.45",
      "text2": "2h",
      "text3": " 15m",
      "text4": "20.00",
      "text5": "₹ 8,950",
      "isSelected": false,
    },
  ];

  static List<Map> flightBookTicketDetailList = [
    {
      "text1": "Spicesaver",
      "text2": "₹ 5,950",
    },
    {
      "text1": "Spiceflex",
      "text2": "₹ 6,951",
    },
    {
      "text1": "Spicemax",
      "text2": "₹ 7,951",
    },
  ];

  static List<Map> sortList = [
    {
      "image": currencyInr,
      "text1": "Price",
      "text2": "Cheapest First",
    },
    {
      "image": timer,
      "text1": "Duration",
      "text2": "Shoetest First",
    },
    {
      "image": departureTime,
      "text1": "Departure Time",
      "text2": "Earliest first \nLatest First",
    },
    {
      "image": arrivalTime,
      "text1": "Arrival Time",
      "text2": "Earliest first \nLatest First",
    },
  ];

  static List<Map> filterList1 = [
    {
      "text1": "0",
      "text2": "Non Stop",
      "text3": "₹ 5,955",
    },
    {
      "text1": "1",
      "text2": "Stop",
      "text3": "₹ 8,160",
    },
    {
      "text1": "2+",
      "text2": "Stop",
      "text3": " ₹ 12,357",
    },
  ];

  static List filterList2 = [
    "Before 6AM",
    "6AM-12 Noon",
    "12 Noon-6PM \n  ₹8,256",
    "After-6PM\n  ₹5,256",
  ];

  static List<Map> filterList3 = [
    {
      "image": spicejet,
      "text1": "SpiceJet",
      "text2": "₹5,256",
    },
    {
      "image": indigo,
      "text1": "IndiGo",
      "text2": "₹8,256",
    },
    {
      "image": vistra,
      "text1": "Vistra",
      "text2": "₹8,256",
    },
  ];

  static List<Map> mealsList = [
    {
      "image": mealsImage1,
      "text1": "Cucumber tomato and "
          "cheese in multigrain",
      "text2": "FREE",
    },
    {
      "image": mealsImage2,
      "text1": "Chicken Junglee in "
          "Marblr Bread",
      "text2": "FREE",
    },
    {
      "image": mealsImage3,
      "text1": "Beverage",
      "text2": "₹ 70",
    },
    {
      "image": mealsImage4,
      "text1": "Vegetarian Meal",
      "text2": "₹ 350",
    },
    {
      "image": mealsImage5,
      "text1": "Non Vegetarian Meal",
      "text2": "₹ 376",
    },
  ];

  static List<Map> selectPaymentMethodList = [
    {
      "image": upi,
      "text1": "UPI",
      "text2": "Pay Directly From Your bank Account",
      "onTap": () {
        Get.to(() => PayByUpiScreen());
      },
    },
    {
      "image": creditCard,
      "text1": "Credit/Debit/ATM Card",
      "text2": "Visa, MasterCard, Amex, Rupay...",
      "onTap": () {
        Get.to(() => PayByCardScreen());
      },
    },
    {
      "image": netBanking,
      "text1": "Net Banking",
      "text2": "All Major Banks Available",
      "onTap": () {
        Get.to(() => NetBankingScreen());
      },
    },
    {
      "image": wallet1,
      "text1": "gift Cards, wallets & More",
      "text2": "Gift cards, Mobikwik, AmazonPay",
      "onTap": () {
        Get.to(() => MobileWalletScreen());
      },
    },
  ];

  static List<Map> netBankingList = [
    {
      "image": axixBank,
      "text": "Axis Bank",
    },
    {
      "image": hdfcBank,
      "text": "HDFC Bank",
    },
    {
      "image": icicBank,
      "text": "ICICI Bank",
    },
    {
      "image": stateBank,
      "text": "State Bank of India",
    },
    {
      "image": otherBank,
      "text": "Kotak Mahindra Bank",
    },
    {
      "image": otherBank,
      "text": "Punjab National Bank",
    },
    {
      "image": otherBank,
      "text": "Airtel Payment Bank",
    },
    {
      "image": otherBank,
      "text": "Allahbad Bank",
    },
    {
      "image": otherBank,
      "text": "Andra Bank",
    },
    {
      "image": otherBank,
      "text": "AU Small Finance Bank",
    },
    {
      "image": otherBank,
      "text": "Bandhan Bank",
    },
    {
      "image": otherBank,
      "text": "Bank of Bahrain",
    },
    {
      "image": otherBank,
      "text": "Bank of Boroda Corporate",
    },
    {
      "image": otherBank,
      "text": "Bank or Boroda Retail",
    },
    {
      "image": otherBank,
      "text": "Bank of India",
    },
    {
      "image": otherBank,
      "text": "Bank od Maharashtra",
    },
  ];

  static List<Map> mobileWalletList = [
    {
      "image": airtel,
      "text": "Airtel Money",
    },
    {
      "image": mobikwik,
      "text": "Mobikwik | Zip (Pay later)",
    },
    {
      "image": payzapp,
      "text": "PayZapp",
    },
    {
      "image": amazonPay,
      "text": "Amazon Pay",
    },
    {
      "image": payPal,
      "text": "PayPal",
    },
    {
      "image": otherBank,
      "text": "Gift Card",
    },
  ];

  static List<Map> upTo5RoomsList = [
    {
      "image": mapPin,
      "text1": "City/Area/LandMark/Property",
      "text2": "Goa",
      "text3": "",
      "onTap": () {
        Get.to(() => SearchCityScreen());
      },
    },
    {
      "image": calendarPlus,
      "text1": "Check-In-Date",
      "text2": "28 Sep",
      "text3": "’22, Wed",
      "onTap": () {
        Get.to(() => SelectCheckInDateScreen());
      },
    },
    {
      "image": calendarPlus,
      "text1": "Check-Out-Date",
      "text2": "29 Sep",
      "text3": "’22, Thu",
      "onTap": () {
        Get.to(() => SelectCheckInDateScreen());
      },
    },
    {
      "image": user,
      "text1": "Rooms & Guests",
      "text2": "1 Rooms, 2 Adults",
      "text3": "",
      "onTap": () {
        Get.bottomSheet(
          RoomsAndGuestScreen(),
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
        );
      },
    },
  ];

  static List improveYorSearchList = [
    "Hotels & Resorts",
    "Homestays",
    "Breakfast Available",
  ];

  static List<Map> fivePlusRoomsList = [
    {
      "image": mapPin,
      "text1": "Add City/Area/Landmark",
      "text2": "Eg. Goa",
      "onTap": () {
        Get.to(() => SearchCityScreen());
      },
    },
    {
      "image": calendarPlus,
      "text1": "Add Check In Date",
      "text2": "Date & Month",
      "onTap": () {
        Get.to(() => SelectCheckInDateScreen());
      },
    },
    {
      "image": calendarPlus,
      "text1": "Add Check Out Date",
      "text2": "Minimum 6 rooms",
      "onTap": () {
        Get.to(() => SelectCheckInDateScreen());
      },
    },
    {
      "image": user,
      "text1": "Add Rooms & Guests",
      "text2": "Minimum 6 rooms",
      "onTap": () {
        Get.bottomSheet(
          RoomsAndGuestScreen(),
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
        );
      },
    },
  ];

  static List purposeOfBookingList = [
    "Trip With Family/Friends",
    "Business Meeting",
  ];

  static List citySearchRecentSearchesList = [
    "Delhi",
    "Mumbai",
    "Bengaluru",
  ];

  static List<Map> roomsAndGuestsList = [
    {
      "text1": "Number of Rooms",
      "text2": "",
      "text3": "01",
    },
    {
      "text1": "Adults",
      "text2": "Age 13 years 7 above",
      "text3": "02",
    },
    {
      "text1": "Children",
      "text2": "Age 12 years & above",
      "text3": "00",
    },
  ];

  static List<Map> hotelList1 = [
    {
      "text": "Popular",
      "onTap": () {
        Get.to(() => PopularFilterScreen());
      },
    },
    {
      "text": "Price",
      "onTap": () {
        Get.to(() => PriceRangeScreen());
      },
    },
    {
      "text": "Locality",
      "onTap": () {
        Get.to(() => LocalityScreen());
      },
    },
    {
      "text": "Star Rating",
      "onTap": () {
        Get.to(() => PropertyTypeScreen());
      },
    },
  ];

  static List hotelList2 = [
    hotelImage1,
    hotelImage2,
    hotelImage3,
    hotelImage4,
    hotelImage5,
  ];

  static List localityList = [
    "North Goa",
    "South Goa",
    "calangute",
    "Baga",
    "Candolim",
    "Anjuna",
  ];

  static List<Map> fromToList = [
    {
      "text1": "Ahmedabad",
      "text2": "Sardar Vallabhbhai Patel International Airport",
      "text3": "AMD",
    },
    {
      "text1": "New Delhi",
      "text2": "Indira Gandhi International Airport",
      "text3": "DEL",
    },
    {
      "text1": "Mumbai, Maharashtra",
      "text2": "Chhatrapati Shivaji International",
      "text3": "BOM",
    },
    {
      "text1": "Chennai, Tamil Nadu",
      "text2": "Chennai Central",
      "text3": "MAS",
    },
    {
      "text1": "Hyderabad, Telangana",
      "text2": "Secunderbad Junction",
      "text3": "SC",
    },
    {
      "text1": "Bangalore, Karnataka",
      "text2": "Bangalore City Junction",
      "text3": "SBC",
    },
    {
      "text1": "Pune, Maharashtra",
      "text2": "Pune Juction",
      "text3": "PUNE",
    },
    {
      "text1": "Ahmedabad, Gujarat",
      "text2": "Ahmedabad Junction",
      "text3": "ADI",
    },
  ];

  static List<Map> checkInBaggageList = [
    {
      "text1": "Additional 5 Kg",
      "text2": "₹2,523",
    },
    {
      "text1": "Additional 10 Kg",
      "text2": "₹4,400",
    },
    {
      "text1": "Additional 15 Kg",
      "text2": "₹6,750",
    },
    {
      "text1": "Additional 20 Kg",
      "text2": "₹9,000",
    },
    {
      "text1": "Additional 30 Kg",
      "text2": "₹13,500",
    },
  ];

  static List<Map> fareBreakList = [
    {
      "text1": "Base Fare",
      "text2": "Adult(s) (1 X ₹ 5,575) ",
      "text3": "₹ 5,575 ",
    },
    {
      "text1": "Fee & Surcharges",
      "text2": "Total fee & surcharges",
      "text3": "₹ 789",
    },
    {
      "text1": "Other Services",
      "text2": "Total fee & surcharges",
      "text3": "₹ 2,250 ",
    },
  ];

  static List<Map> promoCodeList = [
    {
      "text1": "FLYNOW",
      "text2": "Get Rd. 158 instant discount on your Citibank Cards",
    },
    {
      "text1": "MMTBONUS",
      "text2":
          "Use this coupon and get Rd 300 Instant discount on your booking.",
    },
    {
      "text1": "MMTAU",
      "text2":
          "Use this coupon and get 569 instant discount on your AY Bank Credit and Debit Cards.",
    },
    {
      "text1": "MMTYESEMI",
      "text2":
          "Get INR 476 instant discount on your yes Bank Credit No Cost EMI.",
    },
    {
      "text1": "MMTYESMI",
      "text2":
          "Use this coupon and get 569 instant discount on your AY Bank Credit and Debit Cards.",
    },
    {
      "text1": "MMTOLAMONEY",
      "text2":
          "Get INR 476 instant discount on your yes Bank Credit No Cost EMI.",
    },
  ];

  static List<Map> bookBusAndTrainList = [
    {
      "image": bookTrainUndergroundImage,
      "text": "Book Trains Tickets",
    },
    {
      "image": bookBusFrontOfBusImage,
      "text": "Book Bus Tickets",
    },
  ];

  static List trainAndBusInformationServiceList = [
    "Live Train status",
    "Check PNR Status",
    "Food in Trains",
    "Train Schedule",
    "Train Availability",
    "Live Station",
    "Coch Position",
    "Vacant Chart",
  ];

  static List<Map> trainAndBusFromToList = [
    {
      "text1": "From",
      "text2": "Delhi ",
      "text3": "NDLS",
      "onTap": () {
        Get.to(() => TrainAndBusFromScreen());
      },
    },
    {
      "text1": "To",
      "text2": "Kolkata",
      "text3": "HWH",
      "onTap": () {
        Get.to(() => TrainAndBusToScreen());
      },
    },
  ];

  static List trainAndBusSearchList = [
    "All",
    "2S",
    "SL",
    "3A",
    "2A",
    "1A",
    "CC",
  ];

  static List trainAndBusDetailList2 = [
    "AC",
    "Available",
    "Departure after 6PM",
    "Arrival before 12PM",
  ];

  static List trainAndBusTravellerDetailList = [
    "Lower",
    "Middle",
    "Upper",
    "Side lower",
    "Side Upper",
    "No Preference",
  ];

  static List holidayPackagesList1 = [
    "Destinations",
    "Super Deals",
    "Featured",
    "Travel Guidelines",
  ];

  static List<Map> holidayPackagesList2 = [
    {
      "image": thailandImage,
      "text": "Thailand",
    },
    {
      "image": keralaImage,
      "text": "Kerala",
    },
    {
      "image": goaImage,
      "text": "Goa",
    },
    {
      "image": kashmirImage,
      "text": "Kashmir",
    },
    {
      "image": dubaiImage,
      "text": "Dubai",
    },
    {
      "image": rajsthanImage,
      "text": "Rajasthan",
    },
  ];

  static List holidayPackageSliderList = [
    holidayPackageSliderImage1,
    holidayPackageSliderImage2,
    holidayPackageSliderImage3,
  ];

  static List<Map> holidayPackagesList3 = [
    {
      "image": holidayPackageList3Image1,
      "text": "₹ 16,258  ",
    },
    {
      "image": holidayPackageList3Image2,
      "text": "₹ 45,258  ",
    },
    {
      "image": holidayPackageList3Image3,
      "text": "₹ 20,258  ",
    },
    {
      "image": holidayPackageList3Image4,
      "text": "₹ 45,258  ",
    },
    {
      "image": holidayPackageList3Image5,
      "text": "₹ 20,258  ",
    },
  ];

  static List<Map> holidayPackagesList4 = [
    {
      "image": honeyMoonImage,
      "text": "Honeymoon",
    },
    {
      "image": adventureImage,
      "text": "Adventure",
    },
    {
      "image": luxuryImage,
      "text": "Luxury",
    },
    {
      "image": kashmirImage2,
      "text": "Kashmir",
    },
    {
      "image": dubaiImage,
      "text": "Dubai",
    },
    {
      "image": rajsthanImage,
      "text": "Rajasthan",
    },
  ];

  static List searchDestinationList = [
    "Mauritius",
    "Himachal",
  ];

  static List startFromList = [
    "Bangalore",
    "Chennai",
    "Cochin",
    "Corbett",
    "Hyderabad",
    "Kolkata",
    "Mumbai",
  ];

  static List<Map> exploreList = [
    {
      "image": tamilNaduImage,
      "text": "TamilNadu",
    },
    {
      "image": gujarat,
      "text": "Gujarat",
    },
    {
      "image": krnatka,
      "text": "Karnataka",
    },
    {
      "image": meghalayaImage,
      "text": "Meghalaya",
    },
    {
      "image": uttarakhand,
      "text": "Uttarakhand",
    },
    {
      "image": rajsthanImage,
      "text": "Rajasthan",
    },
  ];

  static List<Map> holidayPackagesDetailList1 = [
    {
      "text": "for All",
      "onTap": () {
        Get.to(() => SuitableScreen());
      },
    },
    {
      "text": "Budget (Per Person)",
      "onTap": () {
        Get.to(() => BudgetScreen());
      },
    },
    {
      "text": "Duration",
      "onTap": () {
        Get.to(() => DurationScreen());
      },
    },
    {
      "text": "Hotel Choice",
      "onTap": () {
        Get.to(() => HotelChoiceScreen());
      },
    },
    {
      "text": "Flights",
      "onTap": () {},
    },
    {
      "text": "Premium Packages",
      "onTap": () {},
    },
  ];

  static List holidayPackagesDetailList2 = [
    holidayPackageDetailList2Image1,
    holidayPackageDetailList2Image2,
    holidayPackageDetailList2Image3,
    holidayPackageDetailList2Image4,
  ];

  static List holidayPackagesDetailList3 = [
    holidayPackageDetailList3Image1,
    holidayPackageDetailList3Image2,
    holidayPackageDetailList3Image3,
    holidayPackageDetailList3Image4,
  ];

  static List<Map> editYourSearchList = [
    {
      "image": mapPin,
      "text1": "Starting From",
      "text2": "New Delhi",
    },
    {
      "image": mapPin,
      "text1": "Travelling To",
      "text2": "Thailand",
    },
    {
      "image": calendarPlus,
      "text1": "Travel Date",
      "text2": "Add Travel Date",
    },
  ];

  static List<Map> suitableForList = [
    {
      "text1": "All",
      "text2": "(85)",
    },
    {
      "text1": "Couples",
      "text2": "(25)",
    },
    {
      "text1": "Family",
      "text2": "(12)",
    },
    {
      "text1": "Friends",
      "text2": "(10)",
    },
    {
      "text1": "Solo",
      "text2": "(5)",
    },
  ];

  static List<Map> budgetList = [
    {
      "text1": "₹45,000",
      "text2": "(25)",
    },
    {
      "text1": "₹45,000 - ₹70,000 ",
      "text2": "(35)",
    },
    {
      "text1": "₹70,000 - ₹90,000",
      "text2": "(38)",
    },
    {
      "text1": "Poppins",
      "text2": "(21)",
    },
  ];

  static List durationList = [
    "3N - 4N",
    "3N - 5N",
    "3N - 6N",
    "3N - 7N",
    "3N - 8N",
    "3N - 9N",
  ];

  static List<Map> hotelChoiceList = [
    {
      "text1": "3 star",
      "text2": "(18)",
    },
    {
      "text1": "4 star",
      "text2": "(75)",
    },
    {
      "text1": "5 star",
      "text2": "(80)",
    },
  ];

  static List packageDetailList = [
    "Summary",
    "Terms and Conditions",
    "Policies",
    "Policies",
  ];

  static List holidayPackageReviewList = [
    {
      "text1": "1",
      "text2": "Traveller Details",
    },
    {
      "text1": "2",
      "text2": "Package Inclusions",
    },
    {
      "text1": "3",
      "text2": "Cancellation & Date Change",
    },
    {
      "text1": "4",
      "text2": "Coupons & Offers",
    },
  ];

  static List cabSearchList1 = [
    "One Way",
    "Round Trip",
  ];

  static List<Map> cabSearchList2 = [
    {
      "text1": "Form",
      "text2": "705, ",
      "text3": " Shubh Square, Patel vadi...",
    },
    {
      "text1": "To",
      "text2": "Surat Airport,",
      "text3": "Surat Airport",
    },
  ];

  static List cabSearchList3 = [
    "Schedule",
    "Ride Now",
  ];

  static List<Map> airportTabList = [
    {
      "image": crosshair,
      "text1": "Using GPS",
      "text2": "Use Current location",
    },
    {
      "image": refreshIcon,
      "text1": "Recent Searches",
      "text2": "705, Subh Square, Patel vadi...",
    },
  ];

  static List cabTerminalList = [
    cabTerminalImage3,
    cabTerminalImage4,
    cabTerminalImage5,
    cabTerminalImage6,
  ];

  static List cabTerminal2List1 = [
    "Myself",
    "Someone Else",
  ];

  static List<Map> cabTerminal2List2 = [
    {
      "text1": "Make part payment now",
      "text2": "₹ 85",
    },
    {
      "text1": "Make full payment now",
      "text2": "₹ 385",
    },
  ];

  static List<Map> homeStayList1 = [
    {
      "image": mapPin,
      "text1": "City/Area/LandMark/Property",
      "text2": "Goa",
      "text3": "",
      "onTap": () {
        Get.to(() => SearchCityScreen());
      },
    },
    {
      "image": calendarPlus,
      "text1": "Check-In-Date",
      "text2": "20 Oct ",
      "text3": "’22, Wed",
      "onTap": () {
        Get.to(() => SelectCheckInDateScreen());
      },
    },
    {
      "image": calendarPlus,
      "text1": "Check-Out-Date",
      "text2": "22 Oct ",
      "text3": "’28, Fri",
      "onTap": () {
        Get.to(() => SelectCheckInDateScreen());
      },
    },
  ];

  static List<Map> homeStayList2 = [
    {
      "text1": "Adults",
      "text2": "Age 13y and above",
      "text3": "01",
    },
    {
      "text1": "Children",
      "text2": "Age 12y and above",
      "text3": "0",
    },
  ];

  static List outStationOneWayTabList = [
    "Pickup Address",
    "Drop Address",
  ];

  static List offerList1 = [
    "Hotels",
    "Trending",
    "Flight",
    "Homestays",
    "Trains",
    "Holidays",
    "Cabs",
    "Bus",
    "Activities",
  ];

  static List offerList2 = [
    offerImage1,
    offerImage2,
    offerImage3,
    offerImage4,
    offerImage5,
  ];

  static List applyTouristList = [
    arab,
    sriLanka,
    kenya,
    bangkok,
  ];

  static List<Map> priceBreakUpList = [
    {
      "text1": "Visa Embassy Fee",
      "text2": "₹ 6200.00  ",
    },
    {
      "text1": "Service Fee",
      "text2": "₹ 500.00  ",
    },
    {
      "text1": "GST Amount",
      "text2": "₹ 90.00  ",
    },
    {
      "text1": "Total Amount",
      "text2": "₹ 6790.00 ",
    },
  ];

  static List internationalList = [
    internationalImage1,
    internationalImage2,
    internationalImage3,
    internationalImage4,
  ];

  static List internationalSelectCityList = [
    "Ahmedabad",
    "Aizawl",
    "Bengaluru",
    "Bhopal",
    "Chandigarh",
    "Chennai",
    "Cochin",
    "Coimbatore",
    "Dehradun",
    "Dehradun",
  ];

  static List internationalDetail1List = [
    internationalDetail1Image2,
    internationalDetail1Image3,
    internationalDetail1Image4,
    internationalDetail1Image5,
  ];

  static List internationalDetail2List1 = [
    internationalDetail2Image3,
    internationalDetail2Image4,
  ];

  static List bookingOptionList = [
    bookingOptionImage1,
    bookingOptionImage2,
    bookingOptionImage3,
    bookingOptionImage4,
    bookingOptionImage5,
    bookingOptionImage6,
    bookingOptionImage7,
    bookingOptionImage8,
  ];

  static List<Map> myAccountList = [
    {
      "image": suitcaseIcon,
      "text": "My Trip",
      "onTap": () {
        Get.to(() => MyTripScreen());
      },
    },
     {
      "image": tagIcon,
      "text": "Transaction History",
      "onTap": () {
        Get.to(() => TransactionHistoryScreen());
      },
    },
    {
      "image": heartIcon,
      "text": "Wishlist",
      "onTap": () {
        Get.to(() => MyWishListScreen());
      },
    },
    {
      "image": giftCardIcon,
      "text": "My Gift Cards",
      "onTap": () {
        Get.to(() => MyGiftCardScreen());
      },
    },
    {
      "image": padlockIcon,
      "text": "Reset Password",
      "onTap": () {},
    },
    {
      "image": powerOffIcon,
      "text": "Logout",
      "onTap": () {
        Get.defaultDialog(
          backgroundColor: white,
          contentPadding: EdgeInsets.zero,
          title: "",
          titlePadding: EdgeInsets.zero,
          content: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                CommonTextWidget.PoppinsSemiBold(
                  text: "Log Out",
                  color: black2E2,
                  fontSize: 18,
                ),
                CommonTextWidget.PoppinsRegular(
                  text: "Are you sure?",
                  color: black2E2,
                  fontSize: 15,
                ),
                SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          height: 40,
                          width: Get.width,
                          decoration: BoxDecoration(
                            border: Border.all(color: black2E2, width: 1),
                            color: white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: CommonTextWidget.PoppinsMedium(
                              text: "Cancel",
                              color: black2E2,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final loginController = Get.find<LoginController>();
                          await loginController.logout();
                        },
                        child: Container(
                          height: 40,
                          width: Get.width,
                          decoration: BoxDecoration(
                            color: redCA0,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: CommonTextWidget.PoppinsMedium(
                              text: "Yes",
                              color: white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    },
  ];

  static List wishListList = [
    wishListImage1,
    wishListImage2,
    wishListImage3,
  ];

  static List giftCardList = [
    giftCardImage1,
    giftCardImage2,
    giftCardImage3,
    giftCardImage4,
  ];

  static List<Map> homeDrawerList = [
    {
      "image": suitcaseIcon,
      "text": "View/Manage Trips",
      "onTap": () {
        Get.to(() => MyTripScreen());
      },
    },
    {
      "image" : tagIcon,
      "text": "Transaction History",
      "onTap": () {
        Get.to(() => TransactionHistoryScreen());
      },
    },
    {
      "image": heartIcon,
      "text": "Wishlist",
      "onTap": () {
        Get.to(() => MyWishListScreen());
      },
    },
    {
      "image": giftCardIcon,
      "text": "My Gift Cards",
      "onTap": () {
        Get.to(() => MyGiftCardScreen());
      },
    },
    {
      "image": bellIcon,
      "text": "Notifactions",
      "onTap": () {
        Get.to(() => NotificationScreen());
      },
    },
    {
      "image": starIcon,
      "text": "Rate us",
      "onTap": () {},
    },
    {
      "image": settingIcon,
      "text": "Settings",
      "onTap": () {
        Get.to(() => SettingScreen());
      },
    },
    {
      "image": powerOffIcon,
      "text": "Logout",
      "onTap": () {
        Get.defaultDialog(
          backgroundColor: white,
          contentPadding: EdgeInsets.zero,
          title: "",
          titlePadding: EdgeInsets.zero,
          content: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                CommonTextWidget.PoppinsSemiBold(
                  text: "Log Out",
                  color: black2E2,
                  fontSize: 18,
                ),
                CommonTextWidget.PoppinsRegular(
                  text: "Are you sure?",
                  color: black2E2,
                  fontSize: 15,
                ),
                SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          height: 40,
                          width: Get.width,
                          decoration: BoxDecoration(
                            border: Border.all(color: black2E2, width: 1),
                            color: white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: CommonTextWidget.PoppinsMedium(
                              text: "Cancel",
                              color: black2E2,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final loginController = Get.find<LoginController>();
                          await loginController.logout();
                        },
                        child: Container(
                          height: 40,
                          width: Get.width,
                          decoration: BoxDecoration(
                            color: redCA0,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: CommonTextWidget.PoppinsMedium(
                              text: "Yes",
                              color: white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    },
  ];

  static List languageSuggestedList = [
    "English (US)",
    "English (UK)",
  ];

  static List languageList = [
    "Mandarin",
    "Hindi",
    "Spanish",
    "French",
    "Arabic",
    "Bengali",
    "Russian",
    "Indonesia",
    "Japanese",
    "Italian",
    "Ukrainian",
    "Romanian",
    "Nepali",
    "Greek",
    "Zulu",
    "Kazakh",
  ];

  static List<Map> hotelDetailList1 = [
    {
      "image": calendarPlus,
      "text1": "Check-In & Check-Out",
      "text2": "28 Sep, Thu - 30 Sep, Fri",
      "onTap": () {
        Get.to(() => SelectCheckInDateScreen());
      },
    },
    {
      "image": user,
      "text1": "Rooms & Guests",
      "text2": "1 Rooms, 2 Adults",
      "onTap": () {
        Get.to(() => HotelAndHomeStay());
      },
    },
  ];

  static List hotelDetailList2 = [
    hotelDetailImage7,
    hotelDetailImage8,
    hotelDetailImage9,
  ];

  static List seatsList1 = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12",
    "13",
    "14",
    "15",
    "16",
    "17",
    "18",
    "19",
    "20",
    "21",
    "22",
    "23",
    "24",
    "25",
    "26",
  ];

  static List seatsList2 = [
    seatsCrossImage,
    seatsXlImage,
    seatsCrossImage,
    seatsXlImage,
    seatsXlImage,
    seatsXlImage,
    seatsXlImage,
    seatsXlImage,
    seatsXlImage,
    seatsXlImage,
    seatsXlImage,
    seatsXlImage,
    seatsCrossImage,
    seatsCrossImage,
    seatsCrossImage,
    seatsCrossImage,
    seatsXlImage,
    seatsXlImage,
    seatsCrossImage,
    seatsCrossImage,
    seatsCrossImage,
    seatsXlImage,
    seatsXlImage,
    seatsXlImage,
    seatsCrossImage,
    seatsCrossImage,
    seatsCrossImage,
    seatsCrossImage,
    seatsXlImage,
    seatsXlImage,
    seatsCrossImage,
    seatsCrossImage,
    seatsCrossImage,
    seatsXlImage,
    seatsXlImage,
    seatsXlImage,
    seatsCrossImage,
    seatsCrossImage,
    seatsCrossImage,
    seatsCrossImage,
    seatsCrossImage,
    seatsCrossImage,
    seatsCrossImage,
    seatsCrossImage,
    seatsXlImage,
    seatsXlImage,
    seatsCrossImage,
    seatsXlImage,
    seatsXlImage,
    seatsCrossImage,
    seatsXlImage,
    seatsXlImage,
    seatsCrossImage,
    seatsXlImage,
    seatsXlImage,
    seatsCrossImage,
    seatsXlImage,
    seatsXlImage,
    seatsCrossImage,
    seatsCrossImage,
    seatsXlImage,
    seatsCrossImage,
    seatsXlImage,
    seatsXlImage,
    seatsCrossImage,
    seatsXlImage,
    seatsXlImage,
    seatsCrossImage,
    seatsXlImage,
    seatsXlImage,
    seatsCrossImage,
    seatsXlImage,
    seatsXlImage,
    seatsCrossImage,
    seatsXlImage,
    seatsXlImage,
    seatsXlImage,
    seatsXlImage,
  ];

  static List seatsList3 = [
    seatsXlImage,
    seatsCrossImage,
    seatsXlImage,
    seatsXlImage,
    seatsCrossImage,
    seatsXlImage,
    seatsXlImage,
    seatsXlImage,
    seatsXlImage,
    seatsXlImage,
    seatsXlImage,
    seatsXlImage,
    seatsCrossImage,
    seatsCrossImage,
    seatsCrossImage,
    seatsCrossImage,
    seatsXlImage,
    seatsXlImage,
    seatsCrossImage,
    seatsCrossImage,
    seatsCrossImage,
    seatsXlImage,
    seatsXlImage,
    seatsXlImage,
    seatsCrossImage,
    seatsCrossImage,
    seatsCrossImage,
    seatsCrossImage,
    seatsXlImage,
    seatsXlImage,
    seatsCrossImage,
    seatsCrossImage,
    seatsCrossImage,
    seatsCrossImage,
    seatsCrossImage,
    "",
    seatsCrossImage,
    seatsCrossImage,
    seatsCrossImage,
    seatsCrossImage,
    seatsCrossImage,
    seatsCrossImage,
    seatsXlImage,
    seatsCrossImage,
    seatsXlImage,
    seatsXlImage,
    seatsCrossImage,
    seatsXlImage,
    seatsXlImage,
    seatsCrossImage,
    seatsXlImage,
    seatsXlImage,
    seatsCrossImage,
    seatsXlImage,
    seatsXlImage,
    seatsCrossImage,
    seatsXlImage,
    seatsCrossImage,
    seatsCrossImage,
    seatsCrossImage,
    seatsXlImage,
    seatsCrossImage,
    seatsXlImage,
    seatsXlImage,
    seatsCrossImage,
    seatsXlImage,
    seatsXlImage,
    seatsCrossImage,
    seatsXlImage,
    seatsXlImage,
    seatsCrossImage,
    seatsXlImage,
    seatsXlImage,
    seatsCrossImage,
    seatsCrossImage,
  ];
}

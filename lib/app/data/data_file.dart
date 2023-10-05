// import 'package:pro_hotel_fullapps/app/modal/modal_past.dart';

// import '../modal/modal_card.dart';
// import '../modal/modal_event_category.dart';
// import '../modal/modal_favourite.dart';
// import '../modal/modal_feature_event.dart';
// import '../modal/modal_intro.dart';
// import '../modal/modal_notification.dart';
// import '../modal/modal_popular_event.dart';
// import '../modal/modal_select_interest.dart';
// import '../modal/modal_trending_event.dart';
// import '../modal/modal_upcoming.dart';
// import '../modal/model_country.dart';


import 'package:evente/evente.dart';

class DataFile {
  static List<ModalIntro> introList = [
    ModalIntro("intro1.png", "Create, Find and Join Your Circle Now!",
        "Events can also be used at instruction set level, where they interrupts."),
    ModalIntro("intro2.png", "Participate InYour Favourite Events!",
        "Events can also be used at instruction set level, where they interrupts."),
    ModalIntro("intro3.png", "Create, Find & Join to Event Now",
        "Events can also be used at instruction set level, where they interrupts."),
    ModalIntro("intro4.png", "Let’s Get Started",
        "Sign up or login into see what’s happeing near you")
  ];
  static List<ModelCountry> countryList = [
    ModelCountry("image_fghanistan.jpg", "Afghanistan (AF)", "+93"),
    ModelCountry("image_ax.jpg", "Aland Islands (AX)", "+358"),
    ModelCountry("image_albania.jpg", "Albania (AL)", "+355"),
    ModelCountry("image_andora.jpg", "Andorra (AD)", "+376"),
    ModelCountry("image_islands.jpg", "Aland Islands (AX)", "+244"),
    ModelCountry("image_angulia.jpg", "Anguilla (AL)", "+1"),
    ModelCountry("image_armenia.jpg", "Armenia (AN)", "+374"),
    ModelCountry("image_austia.jpg", "Austria (AT)", "+372"),
  ];

 static List<ModalSelectInterest> selectInterestList = [
    
    ModalSelectInterest("destination1.jpg", "Swimming", "#FDEEEC", false),
    ModalSelectInterest("destination5.jpg", "Game", "#FDEEEC", false),
    ModalSelectInterest("populer2.jpg", "Football", "#FDEEEC", false),
    ModalSelectInterest("destination4.png", "Comedy", "#FDEEEC", false),
    ModalSelectInterest("hotel.png", "Konser", "#FDEEEC", false),
    ModalSelectInterest("experience.png", "Trophy", "#FDEEEC", false),
    ];

//   static List<ModalEventCategory> eventCategoryList = [
//     ModalEventCategory("", "All"),
//     ModalEventCategory("event1.png", "Art"),
//     ModalEventCategory("event2.png", "Music"),
//     ModalEventCategory("event3.png", "Sport")
//   ];

//   static List<ModalTrendingEvent> trendingEventList = [
//     ModalTrendingEvent("trending_event1.png", "20 July, 3 pm", "Business Party",
//         "Mesa, New Jersey", "sponser1.png"),
//     ModalTrendingEvent("trending_event2.png", "22 July, 3 pm", "Music Festival",
//         "Shiloh, Hawaii", "sponser2.png"),
//     ModalTrendingEvent("trending_event3.png", "25 July, 6 pm",
//         "Esports on the path", "Inglewood, Maine", "sponser3.png")
//   ];

//   static List<ModalPopularEvent> popularEventList = [
//     ModalPopularEvent(
//         "popular1.png", "Art Festival", "25 July, 02:00 pm", "\$25.33"),
//     ModalPopularEvent(
//         "popular2.png", "Corporate Event", "27 July, 08:00 pm", "\$23.53"),
//     ModalPopularEvent(
//         "popular3.png", "Food Festivals", "29 July, 02:00 pm", "\$28.99")
//   ];

//   static List<ModalFavourite> favouriteList = [
//     ModalFavourite(
//         "25 July", "favourite1.png", "Art Festival", "South Dakota", "\$25.33"),
//     ModalFavourite("20 July", "favourite2.png", "Business Party",
//         "Mesa, New Jersey", "\$20.40"),
//     ModalFavourite("22 July", "favourite3.png", "Music Festival",
//         "Shiloh, Hawaii", "\$19.99"),
//     ModalFavourite("27 July", "favourite4.png", "Corporate Event",
//         "Celina, Delaware", "\$23.53"),
//     ModalFavourite(
//         "29 July", "favourite5.png", "Food Festivals", "New Mexico", "\$28.99"),
//     ModalFavourite("29 July", "favourite6.png", "Marketing Event",
//         "WestSanta Ana", "\$45.25")
//   ];

//   static List<ModalUpComing> upComingList = [
//     ModalUpComing("Business Party", "20 July, 3 pm", "\$20.40"),
//     ModalUpComing("Music Festival", "22 July, 3 pm", "\$19.99"),
//     ModalUpComing("Food Festivals", "29 July, 2 pm", "\$28.99")
//   ];

//   static List<ModalPast> pastList = [
//     ModalPast("Music Concert ", "18 June, 5 pm", "\$18.56"),
//     ModalPast("Music Festival", "16 July, 4 pm", "\$19.99"),
//     ModalPast("Food Festivals", "12 July, 1 pm", "\$28.99")
//   ];

//   static List<ModalNotification> notificationList = [
//     ModalNotification("Notifications 1", "15 m ago", "#46BCC3"),
//     ModalNotification("Notifications 2", "1 h ago", "#F5B333"),
//     ModalNotification("Notifications 3", "2 h ago", "#F97E7E"),
//     ModalNotification("Notifications 4", "3 h ago", "#87D2C0"),
//     ModalNotification("Notifications 5", "3 h ago", "#B187D2"),
//     ModalNotification("Notifications 6", "3 h ago", "#46BCC3")
//   ];

//   static List<ModalCard> cardLists = [
//     ModalCard("Paypal", "xxxx xxxx xxxx 5416", "paypal.png"),
//     ModalCard("Master Card", "xxxx xxxx xxxx 8624", "mastercard.png"),
//     ModalCard("Visa", "xxxx xxxx xxxx 4565", "visa.png")
//   ];

//   static List<ModalFeatureEvent> featureEventList = [
//     ModalFeatureEvent(
//         "feature-image.png", "National Creativity", "California, USA"),
//     ModalFeatureEvent(
//         "trending_event1.png", "Business Party", "Shiloh, Hawaii"),
//     ModalFeatureEvent(
//         "trending_event2.png", "Esports on the path", "Inglewood, Maine"),
//     ModalFeatureEvent(
//         "trending_event3.png", "National Creativity", "California, USA")
//   ];
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BookingHotel {
  String? image;
  String? checkIn;
  String? checkOut;
  String? dateBooking;
  String? email;
  String? hotelImage;
  String? hotelId;
  String? hotelName;
  String? informationRoom;
  String? name;
  String? photoProfile;
  num? priceHotel;
  num? rattingHotel;
  List? roomGallery;
  String? roomImage;
  num? roomPrice;
  num? roomQuantity;
  String? roomType;
  String? status;
  String? statusPayment;
  String? userID;
  num? timeBooking;
  num? totalBooking;
  double? lang;
  double? lat;
  String? category;
  String? date;
  String? description;
  String? id;
  String? location;
  List? gallery;
  num? price;
  double? ratting;
  List? serviceHotel;
  // String? title;
  List<Room>? room;
  LatLng? latLng;
  String? country;



  BookingHotel(
      {
        this.category,
      this.date,
      this.image,
      this.lang,
      this.lat,
      this.description,
      this.id,
      this.location,
      this.price,
      // this.title,
      this.gallery,
      this.ratting,
      this.serviceHotel,
      this.status,
      this.room,
      this.latLng,
      this.country,
      this.checkIn,
      this.checkOut,
      this.dateBooking,
      this.email,
      this.hotelId,
      this.hotelImage,
      this.hotelName,
      this.informationRoom,
      this.name,
      this.photoProfile,
      this.priceHotel,
      this.rattingHotel,
      this.roomGallery,
      this.roomImage,
      this.roomPrice,
      this.roomQuantity,
      this.roomType,
      this.statusPayment,
      this.timeBooking,
      this.totalBooking,
      this.userID,
      
      
      });

  factory BookingHotel.fromFirestore(DocumentSnapshot snapshot){
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      LatLng latLng = LatLng(data['lat'], data['lang']);
  
    return BookingHotel(
       category : data['category'],
       image: data['image'],
       checkIn: data['checkIn'],
       checkOut: data['checkOut'],
       dateBooking:  data['dateBooking'],
       email: data['email'],
       hotelId: data['hotelId'],
       hotelImage: data['hotelImage'],
       hotelName: data['hotelName'],
       informationRoom: data['informationRoom'],
       name: data['name'],
       photoProfile: data['photoProfile'],
       priceHotel: data['priceHotel'],
       rattingHotel: data['rattingHotel'],
       roomGallery: data['roomGallery'],
       roomImage: data['roomImage'],
       roomPrice: data['roomPrice'],
       roomQuantity: data['roomQuantity'],
       roomType: data['roomType'],
       statusPayment: data['statusPayment'],
       timeBooking: data['timeBooking'],
       totalBooking: data['totalBooking'],
       userID: data['userId'],
    lang  : data['lang'],
    lat  : data['lat'],
    latLng: latLng,
    country: data['country'],
    date  : data['date'],
    description  : data['description'],
    id  : data['id'],
    location  : data['location'],
    price  : data['price'],
    // title  : data['title'],
    gallery  : data['gallery'], 
    ratting  : data['ratting'],
    serviceHotel  : data['serviceHotel'],
    status  : data['status'],
    // room: List<Room>.from(data['room'].map((e) => Room.fromJson(e))),
    
       room: () {
        if (data['room'] == null) return <Room>[];

        return ((data['room'] ?? <String, dynamic>{}) as Map<String, dynamic>).entries.map((e) {
          return Room.fromJson(e.value);
        }).toList();
       }()
      // rooms: roomList,
    );
  }
  //   Map<String, dynamic> toJson() {
  //   List<Map<String, dynamic>>? roomsJson = [];
  //   if (room != null) {
  //     roomsJson = room!.map((room) => room.toJson()).toList();
  //   }

  //   return {
  //     'category': category,
  //     'date': date,
  //     'description': description,
  //     'id': id,
  //     'location': location,
  //     'gallery': gallery,
  //     'price': price,
  //     'ratting': ratting,
  //     'service': service,
  //     'title': title,
  //     'status': status,
  //     'rooms': roomsJson,
  //   };
  // }

}

class Room {
  String? type;
  String? nama;
  String? image;
  num? quantity;
  num? price;
  String? information;
  List? gallery;

  Room({
    this.nama,
    this.image,
    this.price,
    this.type,
    this.information,
    this.gallery,
    this.quantity,
  });

  factory Room.fromJson(final Map<String, dynamic> json) {  
      Map<String, dynamic> data = json;
    
    return Room(
      nama: data['nama'] as String?,
      image: data['image'] as String?,
      price: data['price'] as num?,
      type: data['type'] as String?,
      information: data['information'] as String?,
      gallery: data['gallery'] as List?,
      quantity: data['quantity'] as num?,
      
    );
  }


}
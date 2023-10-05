import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Hotel {
  String? image;
  double? lang;
  double? lat;
  String? category;
  Timestamp? date;
  String? description;
  String? id;
  String? location;
  List? gallery;
  num? price;
  double? ratting;
  List? service;
  String? title;
  String? status;
  List<Room>? room;
  LatLng? latLng;
  String? country;

  double? distance;


  Hotel(
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
      this.title,
      this.gallery,
      this.ratting,
      this.service,
      this.status,
      this.room,
      this.latLng,
      this.country,
      this.distance
      
      });

  factory Hotel.fromFirestore(DocumentSnapshot snapshot, double? distance){
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      LatLng latLng = LatLng(data['lat'], data['lang']);
  
    return Hotel(
       category : data['category'],
       image: data['image'],
    lang  : data['lang'],
    lat  : data['lat'],
    latLng: latLng,
    country: data['country'],
    date  : data['date'],
    description  : data['description'],
    id  : data['id'],
    location  : data['location'],
    price  : data['price'],
    title  : data['title'],
    gallery  : data['gallery'], 
    ratting  : data['ratting'],
    service  : data['service'],
    status  : data['status'],
      distance: distance,
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



class Hotel2 {
    String? image;
  double? lang;
  double? lat;
  String? category;
  Timestamp? date;
  String? description;
  String? id;
  String? location;
  List? gallery;
  num? price;
  double? ratting;
  List? service;
  String? title;
  String? status;
  List<Room>? room;
  LatLng? latLng;
  String? country;
  double? distance;

  Hotel2({
    
        this.category,
      this.date,
      this.image,
      this.lang,
      this.lat,
      this.description,
      this.id,
      this.location,
      this.price,
      this.title,
      this.gallery,
      this.ratting,
      this.service,
      this.status,
      this.room,
      this.latLng,
      this.country,
     this.distance,
  });

  factory Hotel2.fromSnapshot(DocumentSnapshot snapshot, double distance) {
   
    
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      LatLng latLng = LatLng(data['lat'], data['lang']);
    return Hotel2(
       category : data['category'],
       image: data['image'],
    lang  : data['lang'],
    lat  : data['lat'],
    latLng: latLng,
    country: data['country'],
    date  : data['date'],
    description  : data['description'],
    id  : data['id'],
    location  : data['location'],
    price  : data['price'],
    title  : data['title'],
    gallery  : data['gallery'], 
    ratting  : data['ratting'],
    service  : data['service'],
    status  : data['status'],
      distance: distance,
        room: () {
        if (data['room'] == null) return <Room>[];

        return ((data['room'] ?? <String, dynamic>{}) as Map<String, dynamic>).entries.map((e) {
          return Room.fromJson(e.value);
        }).toList();
       }()
      // rooms: roomList,
    
    );
  }
}

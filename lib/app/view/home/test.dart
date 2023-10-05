import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' as math;


class HotelList22 extends StatefulWidget {
  @override
  _HotelList22State createState() => _HotelList22State();
}

class _HotelList22State extends State<HotelList22> {
  late Position userPosition;
 late List<Hotel2> nearbyHotels = [];

  @override
  void initState() {
    super.initState();
    getUserLocation().then((position) {
      setState(() {
        userPosition = position;
      });
      fetchHotelsNearby(userPosition.latitude, userPosition.longitude).then((hotels) {
        hotels.sort((a, b) => a.distance.compareTo(b.distance));
        setState(() {
          nearbyHotels = hotels;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotel Terdekat'),
      ),
      body: nearbyHotels == null
  ? Center(child: CircularProgressIndicator())
  : nearbyHotels.isEmpty
    ? Center(child: CircularProgressIndicator())
    : ListView.builder(
      itemCount: nearbyHotels.length,
      itemBuilder: (context, index) {
        final hotel = nearbyHotels[index];
        return ListTile(
          title: Text(hotel.name),
          subtitle: Text('Jarak: ${hotel.distance.toStringAsFixed(2)} km'),
        );
      },
    ),
    );
  }
}

Future<Position> getUserLocation() async {
  LocationPermission permission = await Geolocator.requestPermission();
  if (permission == LocationPermission.denied) {
    // Handle izin ditolak
  }

  return await Geolocator.getCurrentPosition();
}

Future<List<Hotel2>> fetchHotelsNearby(double latitude, double longitude) async {
  List<Hotel2> hotels = [];
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('hotel').get();

  for (QueryDocumentSnapshot doc in querySnapshot.docs) {
double hotelLatitude = (doc.data() as Map<String, dynamic>)['lat'] as double? ?? 0.0;
double hotelLongitude = (doc.data() as Map<String, dynamic>)['lang'] as double? ?? 0.0;


    double distance = calculateDistance(latitude, longitude, hotelLatitude, hotelLongitude);

    if (distance < 50000000000000.0) { // Misalnya, tampilkan hotel yang berjarak kurang dari 10 km dari lokasi pengguna.
      hotels.add(Hotel2.fromSnapshot(doc, distance));
    }
  }

  return hotels;
}

class Hotel2 {
  final String name;
  final double latitude;
  final double longitude;
  final double distance;

  Hotel2({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.distance,
  });

  factory Hotel2.fromSnapshot(DocumentSnapshot snapshot, double distance) {
    Map data = snapshot.data() as Map;
    return Hotel2(
      name: data['title'],
      latitude: data['lat'],
      longitude: data['lang'],
      distance: distance,
    );
  }
}

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  // Implementasikan perhitungan jarak antara dua koordinat geografis di sini (misalnya, menggunakan haversine formula).
  // Anda dapat mencari library yang sesuai atau mengimplementasikan sendiri.
  const double earthRadius = 6371.0; // Radius Bumi dalam km
  final double dLat = _degreesToRadians(lat2 - lat1);
  final double dLon = _degreesToRadians(lon2 - lon1);
  final double a = (math.sin(dLat / 2) * math.sin(dLat / 2)) +
      (math.cos(_degreesToRadians(lat1)) * math.cos(_degreesToRadians(lat2)) * math.sin(dLon / 2) * math.sin(dLon / 2));
  final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  final double distance = earthRadius * c;
  return distance;
}

double _degreesToRadians(double degrees) {
  return degrees * math.pi / 180;
}

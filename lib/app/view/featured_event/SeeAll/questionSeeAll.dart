import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../question.dart';

class questionSeeAll extends StatelessWidget {
  questionSeeAll({Key? key, this.title, this.name, this.photoProfile})
      : super(key: key);
  final String? title, name, photoProfile;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            ('Question'),
            style: TextStyle(
                fontFamily: "RedHat",
                fontSize: 19.0,
                color: Colors.black,
                fontWeight: FontWeight.w700),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 0.0,
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Q&A")
                      .doc(title)
                      .collection('question')
                      .snapshots(),
                  builder: (
                    context,
                    snapshot,
                  ) {
                    if (!snapshot.hasData) {
                      return Center(
                          child: Column(children: [
                        SizedBox(
                          height: 15.0,
                        ),
                        Image.asset(
                          "assets/images/noQuestion.jpeg",
                          fit: BoxFit.cover,
                          height: 170,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(('Not Have Question'),
                          style: TextStyle(
                              fontFamily: "RedHat",
                              fontWeight: FontWeight.w600,
                              color: Colors.black45,
                              fontSize: 15.0),
                        )
                      ]));
                    } else {
                      if (snapshot.data!.docs.isEmpty) {
                        return Center(
                            child: Column(children: [
                          SizedBox(
                            height: 15.0,
                          ),
                          Image.asset(
                            "assets/images/noQuestion.jpeg",
                            fit: BoxFit.cover,
                            height: 170,
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Text(('Not Have Question'),
                            style: TextStyle(
                                fontFamily: "RedHat",
                                fontWeight: FontWeight.w600,
                                color: Colors.black45,
                                fontSize: 15.0),
                          )
                        ]));
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(bottom:20.0),
                          child: questionCard(
                              userId: "", list: snapshot.data!.docs),
                        );
                      }
                    }
                  }),
              SizedBox(
                height: 15.0,
              )
            ],
          ),
        ),
        floatingActionButton: new FloatingActionButton(
            elevation: 0.0,
            child: new Icon(Icons.add,color: Colors.white,),
            backgroundColor: new Color(0xFF09314F),
            onPressed: () {
              Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) => new QuestionDetail(
                        documentId: title,
                        name: name,
                        photoProfile: photoProfile,
                      )));
            }),
      
    );
  }
}

class questionCard extends StatelessWidget {
  final String? userId;
  questionCard({this.list, this.userId});
  final List<DocumentSnapshot>? list;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        bottom: 20.0
      ),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          primary: false,
          itemCount: list?.length,
          itemBuilder: (context, i) {
            String pp = list![i]['Photo Profile'].toString();
            String question = list![i]['Detail question'].toString();
            String name = list![i]['Name'].toString();
            String answer = list![i]['Answer'].toString();
            Timestamp date = list![i]['Date'];
            
// Ubah Timestamp ke dalam DateTime
DateTime dateTime = date.toDate();

// Format tanggal dan waktu ke dalam string yang diinginkan
String _timestamp = DateFormat('dd MMMM yyyy').format(dateTime);

   
   
            return Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Container(
                      //   height: 40.0.h,
                      //   width: 40.0.w,
                      //   decoration: BoxDecoration(
                      //     image: DecorationImage(
                      //         image: NetworkImage(pp), fit: BoxFit.cover),
                      //     borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      //   ),
                      // ),
                        // SizedBox(width: 10.0,),
                     Text(
                          name,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            fontFamily: "RedHat",
                              fontSize: 17.0.sp),
                        ),
                              SizedBox(width: 10.0,),
                        CircleAvatar(backgroundColor: Colors.black54,radius: 3.0,),
                        SizedBox(width: 5.0,),
                        Container(
                          width: 200.0.w,
                          child: Text(
                            _timestamp??"",
                            style: TextStyle(
                              fontFamily: "RedHat",
                                fontWeight: FontWeight.w300,
                                color: Colors.black38,
                                fontSize: 14.0.sp),
                                maxLines: 1,
                          ),
                        ),
             
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, top: 15.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(
                          left: 15.0, top: 0.0, bottom: 15.0, right: 15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                        color: Color(0xFF09314F).withOpacity(0.1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                     
        SizedBox(
                  height: 5,
                ),
                       Text(
                              question,
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black54,
                                  fontSize: 15.5.sp),
                              overflow: TextOverflow.fade,
                            ),     
                       
                         SizedBox(height: 5.0),
                         Container(
                          width: double.infinity,
                          color: Colors.black12,
                          height: 1.0,
                         ),
                          Wrap(
                            children: [
                              Text(
                          ('answer :'),
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                    fontSize: 15.5),
                              ),
                              Text(
                                answer,
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black54,
                                    fontSize: 15.5.sp),
                                overflow: TextOverflow.fade,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0,)
                ],
              ),
            );
          }),
    );
  }
}

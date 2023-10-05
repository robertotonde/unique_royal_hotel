import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';



class cardSuggeted extends StatelessWidget {
  @override
  String? img, txtTitle, txtHeader, txtDesc;
  double? txtSize;
  GestureTapCallback? navigatorOntap;
  cardSuggeted(
      {this.img,
      this.txtTitle,
      this.txtSize,
      this.navigatorOntap,
      this.txtHeader,
      this.txtDesc});
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 4.0, right: 12.0, top: 8.0, bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: navigatorOntap,
            child: Container(
              width: 285.0,
              height: 135.0,
              decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                      image: AssetImage(img!), fit: BoxFit.cover),
                  color: Colors.white,
                   gradient: LinearGradient(
                            colors: [
                              "#000000".toColor().withOpacity(0.0),
                              "#000000".toColor().withOpacity(0.88)
                            ],
                            stops: const [
                              0.0,
                              1.0
                            ],
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF656565).withOpacity(0.15),
                      blurRadius: 2.0,
                      spreadRadius: 1.0,
//           offset: Offset(4.0, 10.0)
                    )
                  ]),
              child: Container(  width: 285.0,
              height: 135.0,
              decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                  // image: DecorationImage(
                  //     image: AssetImage(img!), fit: BoxFit.cover),
                  color: Colors.white,
                   gradient: LinearGradient(
                            colors: [
                              "#000000".toColor().withOpacity(0.0),
                              "#000000".toColor().withOpacity(0.28)
                            ],
                            stops: const [
                              0.0,
                              1.0
                            ],
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF656565).withOpacity(0.15),
                      blurRadius: 2.0,
                      spreadRadius: 1.0,
//           offset: Offset(4.0, 10.0)
                    )
                  ]),
                child: Center(
                  child: Text(
                    txtTitle!,
                    style: TextStyle(
                        fontFamily: 'Amira',
                        color: Colors.white,
                        fontSize: txtSize,
                        letterSpacing: 2.0,
                        shadows: [
                          Shadow(
                            color: Colors.black12.withOpacity(0.1),
                            blurRadius: 2.0,
                          )
                        ]),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 10.0),
            child: Text(
              txtHeader!,
              style: TextStyle(
                fontFamily: "RedHat",
                fontSize: 16.0,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 5.0),
            child: Container(
                width: 270.0,
                child: Text(
                  txtDesc!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: TextStyle(
                    fontFamily: "RedHat",
                    fontSize: 13.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black26,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}

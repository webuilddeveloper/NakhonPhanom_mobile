import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactListVertical extends StatefulWidget {
  ContactListVertical({
    super.key,
    this.site,
    this.model,
    this.title,
    this.url,
  });

  final String? site;
  final Future<dynamic>? model;
  final String? title;
  final String? url;

  @override
  _ContactListVertical createState() => _ContactListVertical();
}

class _ContactListVertical extends State<ContactListVertical> {
  @override
  void initState() {
    super.initState();
  }

  final List<String> items =
      List<String>.generate(10, (index) => "Item: ${++index}");

  _makePhoneCall(String url) async {
    url = 'tel:' + url;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: widget.model,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Container(
              alignment: Alignment.center,
              height: 200,
              child: Text(
                'ไม่พบข้อมูล',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Sarabun',
                  color: Color.fromRGBO(0, 0, 0, 0.6),
                ),
              ),
            );
          } else {
            return Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        margin: EdgeInsets.only(bottom: 5.0),
                        child: Column(
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                minHeight: 80,
                                minWidth: double.infinity,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.circular(15.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 0,
                                    blurRadius: 7,
                                    offset: Offset(4, 4),
                                  ),
                                ],
                                color: Color(0xFFFFFFFF),
                              ),
                              padding: EdgeInsets.all(10.0),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                '${snapshot.data[index]['imageUrl']}'),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        alignment: Alignment.centerLeft,
                                        width: 55.0,
                                        height: 55.0,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.55,
                                            padding:
                                                EdgeInsets.only(left: 10.0),
                                            child: Text(
                                              '${snapshot.data[index]['phone']}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                fontFamily: 'Sarabun',
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.55,
                                            padding:
                                                EdgeInsets.only(left: 10.0),
                                            child: Text(
                                              '${snapshot.data[index]['title']}',
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                fontFamily: 'Sarabun',
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.6),
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _makePhoneCall(
                                          snapshot.data[index]['phone']);
                                    },
                                    child: Container(
                                      width: 50.00,
                                      height: 50.00,
                                      padding: EdgeInsets.all(10.00),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        // color: Color(0xFFA12624),
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      child: Image.asset(
                                          'assets/images/phone.png'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          }
        } else {
          return Container();
        }
      },
    );
  }
}

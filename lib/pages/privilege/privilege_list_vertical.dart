import 'package:flutter/material.dart';

import 'privilege_form.dart';

class PrivilegeListVertical extends StatefulWidget {
  PrivilegeListVertical({super.key, this.site, this.model});

  final String? site;
  final Future<dynamic>? model;

  @override
  _PrivilegeListVertical createState() => _PrivilegeListVertical();
}

class _PrivilegeListVertical extends State<PrivilegeListVertical> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: widget.model,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Container(
              height: 200,
              alignment: Alignment.center,
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
              padding: EdgeInsets.all(10.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return myCard(index, snapshot.data.length,
                      snapshot.data[index], context);
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

  demoItem(dynamic model) {
    return Column(
      children: <Widget>[
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PrivilegeForm(
                    code: model['code'],
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(1),
              decoration: new BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius: new BorderRadius.circular(6.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  model['imageUrl'],
                ),
              ),
            ),
          ),
        ),
        Container(
          child: Center(
            child: Image.asset('assets/images/bar.png'),
          ),
        ),
      ],
    );
  }

  myCard(int index, int lastIndex, dynamic model, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PrivilegeForm(code: model['code'], model: model),
          ),
        );
      },
      child: Container(
        margin: index % 2 == 0
            ? EdgeInsets.only(bottom: 5.0, right: 5.0)
            : EdgeInsets.only(bottom: 5.0, left: 5.0),
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.circular(5),
          color: Color(0xFFFFFFFF),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                height: 157.0,
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(5.0),
                    topRight: const Radius.circular(5.0),
                  ),
                  color: Colors.white.withAlpha(220),
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image: NetworkImage(model['imageUrl']),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              alignment: Alignment.topLeft,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: new BorderRadius.only(
                  bottomLeft: const Radius.circular(5.0),
                  bottomRight: const Radius.circular(5.0),
                ),
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model['title'],
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 10,
                      color: Color(0xFFFFFFFF),
                      fontFamily: 'Sarabun',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

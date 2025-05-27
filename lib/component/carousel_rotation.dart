import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CarouselRotation extends StatefulWidget {
  CarouselRotation({super.key, this.model, this.nav});

  final Future<dynamic>? model;
  final Function(String, String, dynamic, String)? nav;

  @override
  _CarouselRotation createState() => _CarouselRotation();
}

class _CarouselRotation extends State<CarouselRotation> {
  final txtDescription = TextEditingController();
  int _current = 0;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtDescription.dispose();
    super.dispose();
  }

  final List<String> imgList = [];

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
          if (snapshot.data.length > 0) {
            return _buildScreen(snapshot.data);
          } else {
            return Container();
          }
        } else if (snapshot.hasError) {
          return Container();
        } else {
          return Container();
        }
      },
    );
  }

  _buildScreen(dynamic model) {
    return Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height,
            viewportFraction: 1.0,
            enlargeCenterPage: false,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 15),
            autoPlayAnimationDuration: Duration(milliseconds: 1000),
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
          items: model.map<Widget>(
            (document) {
              return new InkWell(
                onTap: () {
                  widget.nav!(
                    model[_current]['linkUrl'],
                    model[_current]['action'],
                    model[_current],
                    model[_current]['code'],
                  );
                },
                child: Container(
                  child: Center(
                    child: Image.network(
                      document['imageUrl'],
                      fit: BoxFit.fitHeight,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                ),
              );
            },
          ).toList(),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Transform.translate(
            offset: const Offset(0, -50), // ขึ้นจากล่าง 60px
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: model.map<Widget>((url) {
                int index = model.indexOf(url);
                return Container(
                  width: _current == index ? 20.0 : 5.0,
                  height: 5.0,
                  margin: const EdgeInsets.only(
                      top: 100.0, left: 2.0, right: 2.0, bottom: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: _current == index
                        ? const Color(0xFFfad84c)
                        : const Color(0xFF9e6e19),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Transform.translate(
            offset: const Offset(0, -90), // ขึ้นจากล่าง 60px
            child: Text(
              'นครพนมเมืองวัฒนธรรมก้าวหน้า',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Transform.translate(
            offset: const Offset(0, -70), // ขึ้นจากล่าง 60px
            child: Text(
              'พัฒนาอย่างสมดุลบนพื้นฐานความพอเพียง',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Kanit',
              ),
            ),
          ),
        ),
      ],
    );
  }
}

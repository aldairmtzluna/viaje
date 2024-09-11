import 'package:flutter/material.dart';

class PhotosDriverView extends StatelessWidget {
  final int userId;

  PhotosDriverView({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFEF4136),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Color(0xFFEF4136),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      Icons.person,
                      color: Colors.black,
                      size: 70,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 0),
              Transform.translate(
                offset: Offset(35, -22.5),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Color(0xFFEF4136),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    icon: Transform.translate(
                      offset: Offset(-5, -5),
                      child: Icon(
                        Icons.camera_alt,
                        size: 15,
                      ),
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
              SizedBox(height: 0),
              Text(
                'Aldair Martinez Luna',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 124.2,
                      height: 71.3,
                      decoration: BoxDecoration(
                        color: Color(0xFFEF4136),
                      ),
                    ),
                    Container(
                      width: 124.2,
                      height: 71.3,
                      decoration: BoxDecoration(
                        color: Color(0xFFEF4136),
                      ),
                    ),
                  ],
                ),
              ),
              Transform.translate(
                offset: Offset(10, -82.5),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 124.2,
                        height: 71.3,
                        decoration: BoxDecoration(
                          color: Color(0xFFAACBE3),
                        ),
                        child: Row(
                          children: [
                            Transform.translate(
                              offset: Offset(5, -30),
                              child: Container(
                                width: 113.3,
                                height: 5.7,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(-136, -2.5),
                        child: Container(
                          width: 43.1,
                          height: 39,
                          color: Colors.white,
                          child: Icon(
                            Icons.person,
                            color: Colors.black,
                            size: 40,
                          ),
                        ),
                      ),
                      Container(
                        width: 124.2,
                        height: 71.3,
                        decoration: BoxDecoration(
                          color: Color(0xFFAACBE3),
                        ),
                        child: Row(
                          children: [
                            Transform.translate(
                              offset: Offset(5, -30),
                              child: Container(
                                width: 113.3,
                                height: 5.7,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(-30, -100),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Color(0xFFEF4136),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    icon: Transform.translate(
                      offset: Offset(-5, -5),
                      child: Icon(
                        Icons.camera_alt,
                        size: 15,
                      ),
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(170, -120),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Color(0xFFEF4136),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    icon: Transform.translate(
                      offset: Offset(-5, -5),
                      child: Icon(
                        Icons.camera_alt,
                        size: 15,
                      ),
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
              SizedBox(height: 0),
              Transform.translate(
                offset: Offset(0, -120),
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      'Licencia de conducir.',
                      textAlign: TextAlign.center,
                    )),
              ),
              Transform.translate(
                offset: Offset(0, -100),
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      'Unidad Asignada.',
                      textAlign: TextAlign.center,
                    )),
              ),
              Transform.translate(
                offset: Offset(0, -95),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'Unidad 1.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(0, -95),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 124.2,
                        height: 71.3,
                        decoration: BoxDecoration(
                          color: Color(0xFFEF4136),
                        ),
                      ),
                      Container(
                        width: 124.2,
                        height: 71.3,
                        decoration: BoxDecoration(
                          color: Color(0xFFEF4136),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(10, -177.5),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 124.2,
                        height: 71.3,
                        decoration: BoxDecoration(
                          color: Color(0xFFAACBE3),
                        ),
                        child: Row(
                          children: [
                            Transform.translate(
                              offset: Offset(5, -30),
                              child: Container(
                                width: 113.3,
                                height: 5.7,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(-136, -2.5),
                        child: Container(
                          width: 43.1,
                          height: 39,
                          color: Colors.white,
                          child: Icon(
                            Icons.person,
                            color: Colors.black,
                            size: 40,
                          ),
                        ),
                      ),
                      Container(
                        width: 124.2,
                        height: 71.3,
                        decoration: BoxDecoration(
                          color: Color(0xFFAACBE3),
                        ),
                        child: Row(
                          children: [
                            Transform.translate(
                              offset: Offset(5, -30),
                              child: Container(
                                width: 113.3,
                                height: 5.7,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(-30, -195),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Color(0xFFEF4136),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    icon: Transform.translate(
                      offset: Offset(-5, -5),
                      child: Icon(
                        Icons.camera_alt,
                        size: 15,
                      ),
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(170, -215),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Color(0xFFEF4136),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    icon: Transform.translate(
                      offset: Offset(-5, -5),
                      child: Icon(
                        Icons.camera_alt,
                        size: 15,
                      ),
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
              SizedBox(height: 0),
              Transform.translate(
                offset: Offset(0, -210),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'Identificación oficial (INE).',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(0, -195),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 30,
                  child: ElevatedButton(
                    onPressed: () {
                      // Aquí navega a la siguiente vista con el userId
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFEF4136),
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 0.9, 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Siguiente',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

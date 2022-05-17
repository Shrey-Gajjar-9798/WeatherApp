import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:chewie/chewie.dart';
import 'package:weatherapp/chewie.dart';
import 'package:weatherapp/searchpage.dart';

class Album {
  final int cod;
  final int id;
  final String name;
  List<Weather> weather;
  Main tempmain;
  Cordinates coord;

  Album({
    required this.cod,
    required this.id,
    required this.name,
    required this.weather,
    required this.tempmain,
    required this.coord,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    var list = json['weather'] as List;
    print(list.runtimeType);
    List<Weather> weatherlist = list.map((e) => Weather.fromJson(e)).toList();
    return Album(
      cod: json["cod"],
      id: json["id"],
      name: json['name'],
      weather: weatherlist,
      tempmain: Main.fromJson(json['main']),
      coord: Cordinates.fromJson(json['coord']),
    );
  }
}

class Weather {
  String main;
  String description;

  Weather({required this.main, required this.description});

  factory Weather.fromJson(Map<String, dynamic> json) {
    // ignore: unnecessary_new
    return new Weather(
      main: json["main"],
      description: json['description'],
    );
  }
}

class Cordinates {
  double lon;
  double lat;

  Cordinates({required this.lon, required this.lat});

  factory Cordinates.fromJson(Map<String, dynamic> json) {
    // ignore: unnecessary_new
    return new Cordinates(
      lon: json["lon"],
      lat: json['lat'],
    );
  }
}

class Main {
  double temp;
  double temp_min;
  double feels_like;
  double temp_max;
  int pressure;
  int humidity;

  Main({
    required this.temp,
    required this.temp_min,
    required this.feels_like,
    required this.temp_max,
    required this.pressure,
    required this.humidity,
  });

  factory Main.fromJson(Map<String, dynamic> json) {
    // ignore: unnecessary_new
    return new Main(
      temp: json["temp"],
      feels_like: json["feels_like"],
      temp_max: json['temp_max'],
      temp_min: json['temp_min'],
      pressure: json['pressure'],
      humidity: json['humidity'],
    );
  }
}

class StartPage extends StatefulWidget {
  String cityname;

  StartPage({Key? key, required this.cityname}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState(cityname: cityname);
}

class _StartPageState extends State<StartPage> {
  String cityname;
  _StartPageState({required this.cityname});

  late VideoPlayerController _controller;
  // var city = "diu";
  late Future<Album> futureAlbum;
  Future<Album> getApiData(var city) async {
    print(city);
    var url =
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=7fa2484b0c15d30f4d9942af5755c524";
    var response = await http.get(Uri.parse(url));
    print(url);
    if (response.statusCode == 200) {
      final jsonresponse = json.decode(response.body);
      return Album.fromJson(jsonresponse);
    } else {
      print(city);
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    futureAlbum = getApiData(cityname);
    print(widget.cityname);
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Weather App"),
        backgroundColor: Colors.black,
        elevation: 8,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {}, icon: Icon(Icons.search, color: Colors.white))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
            color: Colors.black,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: FutureBuilder<Album>(
              future: futureAlbum,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  String video = snapshot.data!.weather[0].main.toString();
                  String temperature =
                      (snapshot.data!.tempmain.temp.toInt() - 273).toString();
                  // const String temp = 0x00B0;
                  return Column(
                    children: [
                      Stack(
                        children: [
                          FittedBox(
                            fit: BoxFit.fill,
                            child: SizedBox(
                              height: 400,
                              width: MediaQuery.of(context).size.width,
                              child: ChewieVideo(
                                  videoPlayerController:
                                      VideoPlayerController.asset(
                                          "assets/$video.mp4"),
                                  looping: true),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              width: MediaQuery.of(context).size.width,
                              height: 100,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                colors: [
                                  Colors.black,
                                  Colors.black.withOpacity(0.7),
                                  Colors.black.withOpacity(0.5),
                                  Colors.transparent,
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              )),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Text(
                                    //   snapshot.data!.cod.toString(),
                                    //   style: GoogleFonts.lato(
                                    //     color: Colors.white,
                                    //     fontSize: 25,
                                    //   ),
                                    // ),
                                    Text(
                                      temperature,
                                      style: GoogleFonts.lato(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      // weatherResponse['main'].toString()
                                      snapshot.data!.weather[0].main,
                                      style: GoogleFonts.lato(
                                        color: Colors.white,
                                        fontSize: 30,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          height: 80,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Icon(Icons.location_city,
                                      color: Colors.white, size: 15),
                                  SizedBox(width: 5),
                                  Text(
                                    snapshot.data!.name,
                                    style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "id : ${snapshot.data!.id.toString()}",
                                    style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    "lon : ${snapshot.data!.coord.lon.toString()}",
                                    style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    "lat : ${snapshot.data!.coord.lat.toString()}",
                                    style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 15.0, left: 15.0, right: 15.0),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                      "feels_like : ${snapshot.data!.tempmain.feels_like.toString()}",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15)),
                                  Text(
                                      "temp_min : ${snapshot.data!.tempmain.temp_min.toString()}",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15)),
                                  Text(
                                      "temp_max : ${snapshot.data!.tempmain.temp_max.toString()}",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15)),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                      "pressure : ${snapshot.data!.tempmain.pressure.toString()}",
                                      style: TextStyle(color: Colors.white)),
                                  Text(
                                      "humidity : ${snapshot.data!.tempmain.humidity.toString()}",
                                      style: TextStyle(color: Colors.white)),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      // TextFormField(
                      //   controller: _city,
                      //   validator: (value) {
                      //     if (value!.isEmpty) {
                      //       return "Please enter City name";
                      //     } else if (value.length <= 1) {
                      //       return "Enter a valid city name";
                      //     } else {
                      //       return null;
                      //     }
                      //   },
                      //   // ignore: prefer_const_constructors
                      //   decoration: InputDecoration(
                      //     labelText: "Search",
                      //     suffixIcon: IconButton(
                      //         onPressed: () {
                      //           setState(() {
                      //             city = _city.toString();
                      //             getApiData(city);
                      //           });
                      //         },
                      //         icon: Icon(Icons.search)),
                      //     hintText: "Enter the city name",
                      //     border: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(12),
                      //         borderSide: BorderSide(color: Colors.white)),
                      //     filled: true,
                      //     fillColor: Colors.grey,
                      //   ),
                      // ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                // By default, show a loading spinner.
                return const Center(child: CircularProgressIndicator());
              },
            )),
      ),
    );
  }
}

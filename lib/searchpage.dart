import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weatherapp/startpage.dart';

class SearchPage extends StatelessWidget {
  // const SearchPage({ Key? key }) : super(key: key);
  TextEditingController _city = TextEditingController();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.black,
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Hey!",
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Search your favorite city's weather",
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              TextFormField(
                controller: _city,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter City name";
                  } else if (value.length <= 1) {
                    return "Enter a valid city name";
                  } else {
                    return null;
                  }
                },
                // ignore: prefer_const_constructors
                decoration: InputDecoration(
                  labelText: "Search",
                  hintText: "Enter the city name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white)),
                  filled: true,
                  fillColor: Colors.grey,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    print(_city.toString());
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StartPage(
                                  cityname: _city.text,
                                )));
                  }
                },
                child: Text("Search",
                    style: TextStyle(
                      color: Colors.white,
                    )),
                // ignore: prefer_const_constructors
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.grey),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

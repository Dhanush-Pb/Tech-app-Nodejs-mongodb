// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/view/screens/details_pag.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:frontend/view/screens/create_page.dart';

class DashboardPage extends StatefulWidget {
  final String token;
  const DashboardPage({Key? key, required this.token}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late String userId;
  List<dynamic>? items;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodeToken = JwtDecoder.decode(widget.token);
    userId = jwtDecodeToken['_id'];
    // Fetch user data when widget initializes
    getTodoList(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Changed to black color theme
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
              top: 60.0,
              left: 30.0,
              right: 30.0,
              bottom: 30.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  child: Icon(
                    Icons.list,
                    size: 30.0,
                  ),
                  backgroundImage: AssetImage(
                      'assets/images/robot-with-blue-eyes-black-background-artificial-intelligence-ai-high-tech-chat-gpt_872754-484.jpg'),
                  radius: 30.0,
                ),
                SizedBox(height: 10.0),
                Text(
                  'Welcome to your Dashboard',
                  style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.white), // Added white color for text
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.grey[800]!, Colors.black],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: items == null
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: items!.length,
                        itemBuilder: (context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              elevation: 0, // Remove elevation
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black,
                                      Color.fromARGB(255, 25, 92, 147),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => Detailspage(
                                                title: items![index]['title'],
                                                details: items![index]
                                                    ['desc'])));
                                  },
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    leading: Icon(Icons.task,
                                        color: Colors
                                            .white), // Customize leading icon color
                                    title: Text(
                                      '${items![index]['title']}',
                                      style: TextStyle(
                                        color:
                                            Colors.white, // Adjust text color
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trailing: Icon(Icons.delete,
                                        color: Colors
                                            .white), // Customize trailing icon color
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: SizedBox(
        width: 85,
        height: 60,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CreatePage(userid: userId),
            ));
            // Add your onPressed code here!
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          backgroundColor: Colors.grey[800],
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<void> getTodoList(String userId) async {
    try {
      var response = await http.get(
        Uri.parse('http://192.168.229.161:3000/getTududetails?userid=$userId'),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        print('Response success data: $jsonResponse'); // Debug print
        setState(() {
          items = jsonResponse['success'];
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }
}

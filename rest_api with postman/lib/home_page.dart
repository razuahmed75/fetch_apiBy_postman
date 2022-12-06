// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    getUsers();
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController titleEditingController = TextEditingController();
  TextEditingController descriptionEditingController = TextEditingController();
  List todos = [];
  Future getUsers() async {
    final getUrl = Uri.parse("https://jsonplaceholder.typicode.com/users");
    final response = await http.get(getUrl);

    if (response.statusCode == 200) {
      setState(() {
        todos = jsonDecode(response.body);
      });
    }
  }

  Future postUsers() async {
    final getUrl = Uri.parse("https://jsonplaceholder.typicode.com/users");
    final response = await http.post(getUrl, body: {
      "name": titleEditingController.text,
      "email": descriptionEditingController.text,
    });

    if (response.statusCode == 201) {
      setState(() {
        titleEditingController.clear();
        descriptionEditingController.clear();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("successfully added")));
        todos = jsonDecode(response.body);
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("something went wrong")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rest Api"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            postUsers();
          }),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: titleEditingController,
                    validator: (e) {
                      if (e!.isEmpty) {
                        return "Field must not be empty!";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "title",
                    ),
                  ),
                  TextFormField(
                    controller: descriptionEditingController,
                    validator: (e) {
                      if (e!.isEmpty) {
                        return "Field must not be empty!";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "description",
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(160, 40),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            postUsers();
                          }
                        },
                        child: Text("Add"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(150, 40),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {}
                        },
                        child: Text("Update"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      )),
                  title: Text(todos[index]['name']),
                  subtitle: Text(todos[index]['email']),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                        IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

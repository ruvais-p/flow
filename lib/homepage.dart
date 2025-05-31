import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController nameController = TextEditingController();
  late String userName = '';
  var channel = const MethodChannel('uniqueChannel');

  Future<void> callNativeCode(String name) async {
    try {
      userName =  await channel.invokeMethod('userName', {"name": name});
      setState(() {});
    } catch (e) {
      print(e);
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: "Enter your name",
              border: OutlineInputBorder(),
              labelText: 'Enter your name',
            )),
          ),
          MaterialButton(onPressed: (){
            String name = nameController.text;
            if(name.isEmpty){
              name = 'Flutter';
            }
            callNativeCode(name);
          }, color: Colors.amber, child: const Text('Click Here'),),
          SizedBox(height: 30,),
          Text(userName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),)
        ],
      ),
    );
  }
}
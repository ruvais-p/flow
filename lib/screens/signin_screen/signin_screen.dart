import 'package:flow/common/common_elevated_button.dart';
import 'package:flow/common/snackbar.dart';
import 'package:flow/screens/bankselection_screen/bank_selection_screen.dart';
import 'package:flow/screens/signin_screen/widgets/signin_section.dart';
import 'package:flow/services/database_servieces.dart';
import 'package:flutter/material.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController _controller = TextEditingController();
  final DatabaseService _databaseService = DatabaseService.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SigninSection(
            controller: _controller,
          ), 
          Spacer(),
          Padding(padding: EdgeInsetsGeometry.only(
            left: 30,right: 30, bottom: 60
          ), 
          child: CommonElevatedButton(onPressed: (){
            if(_controller.text.isEmpty){
              showAppSnackBar(context, "Enter your name");
            }else{
            _databaseService.addUserData(
              _controller.text.toString()
            );
            Navigator.push(context, MaterialPageRoute(builder:(context) => BankSelectionScreen(),));
            }
          })),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}
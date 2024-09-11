import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Rozgar/components/pages/shared/CommonScreen.dart';
import 'package:Rozgar/components/pages/shared/HeaderSection.dart';
import 'package:Rozgar/components/pages/ProductListScreen.dart';














class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  bool get _isLoginButtonEnabled {
    return _usernameController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  }

  Future<void> _login() async {
    if (!_isLoginButtonEnabled) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    String apiUrl = 'https://rrnew.easwdb.com/api/Auth/login';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'userName': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final dynamic res = jsonDecode(response.body);
        
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('VendorData', jsonEncode(res));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProductListScreen()),
        );
      } else {
        setState(() {
          _errorMessage = 'Invalid credentials. Please try again.';
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _errorMessage = 'Failed to connect to server. Please try again later.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CommonScreen(
        HeaderSection: HeaderSection(
          logoPath: 'assets/images/logo.png',
          title: 'Login',
          subtitle: 'Please enter your credentials',
          cTitle: 'User Login',
          titleFontSize: 24.0,
          subtitleFontSize: 14.0,
          titleColor: Colors.black,
          subtitleColor: Colors.black,
        ),
        bodyContent: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        errorText: _errorMessage.isNotEmpty ? ' ' : null,
                      ),
                    ),
                    SizedBox(height: 12.0),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        errorText: _errorMessage.isNotEmpty ? ' ' : null,
                      ),
                    ),
                    SizedBox(height: 12.0),
                    if (_errorMessage.isNotEmpty)
                      AlertDialog(
                         title: Text('Error'),
                    content: Text(_errorMessage),
                  actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
                       
                      ),
                    SizedBox(height: 24.0),
                    ElevatedButton(
                      onPressed:  _login, 
                      child: Text('Login'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

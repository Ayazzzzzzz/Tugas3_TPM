import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    bool _isPasswordVisible = false;
    String emailInput = '';
    String passwordInput = '';
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 242, 247, 255),
      body: Stack(
        children: [
          // Gelombang Kuning di Bawah
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              "asset/bg.png",
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),

          // Konten Utama (Form Login)
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 30,
              children: [
                Container(
                  child: Image.asset("asset/logo.png"),
                  alignment: Alignment.centerRight,
                ),
                SizedBox(height: 5.0),
                Text(
                  "LOG-IN",
                  style: GoogleFonts.rubikMonoOne(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 14, 49, 107),
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Your Email',
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      color: Color.fromARGB(255, 14, 49, 107),
                    ),
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 14, 49, 107),
                    ),
                  ),
                  onChanged: (value) {
                    emailInput = value; // Simpan email user
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatefulBuilder(
                      builder: (context, setState) {
                        return TextFormField(
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            labelText: 'Password',
                            labelStyle: const TextStyle(
                              color: Color.fromARGB(255, 14, 49, 107),
                            ),
                            hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 14, 49, 107),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: const Color.fromARGB(255, 14, 49, 107),
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          onChanged: (value) {
                            passwordInput = value; // Simpan password user
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 8.0), // Jarak antara field dan link
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {},
                        child: Text(
                          "Forget password?",
                          style: GoogleFonts.inriaSans(
                            fontSize: 14,
                            color: const Color.fromARGB(255, 14, 49, 107),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    if (emailInput == 'larasayodya04@gmail.com' &&
                        passwordInput == 'inipassword123') {
                      print('Login successful!');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Home()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Maaf, email atau password salah.',
                            style: TextStyle(
                              color: Color.fromARGB(
                                  255, 14, 49, 107), // Warna teks biru
                              fontSize: 14,
                            ),
                          ),
                          backgroundColor: Color.fromARGB(
                              255, 255, 221, 77), // Warna background kuning
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.fromLTRB(
                            20,
                            0,
                            20,
                            MediaQuery.of(context).size.height * 0.82,
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  }, // Respon ketika button ditekan
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color.fromARGB(255, 14, 49, 107), // Warna latar tombol
                    padding: EdgeInsets.symmetric(
                        vertical: 10, horizontal: 100), // Padding tombol
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(25), // Membuat tombol bulat
                    ),
                  ),
                  child: Text(
                    "LOGIN",
                    style: GoogleFonts.rubikMonoOne(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: GoogleFonts.inriaSans(
                        fontSize: 14,
                        color: const Color.fromARGB(255, 14, 49, 107),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        "Sign Up",
                        style: GoogleFonts.inriaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 14, 49, 107),
                        ),
                      ),
                    ),
                  ],
                ),
                Text("Or login with"),
                Row(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Image.asset(
                        "asset/google.png",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Image.asset(
                        "asset/facebook.png",
                      ),
                    )
                  ],
                )
              ],
            )),
          )
        ],
      ),
    );
  }
}

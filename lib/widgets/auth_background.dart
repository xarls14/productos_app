import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AuthBackground extends StatelessWidget {

  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.red,
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [

          _PurpleBox(),

          const _HeaderIphone(),

          child,


        ],
      ),
    );
  }

  
}

class _HeaderIphone extends StatelessWidget {
  const _HeaderIphone({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 30),
        child: const Icon(Icons.person_pin, color: Colors.white, size: 100,),
      ),
    );
  }
}

class _PurpleBox extends StatelessWidget {

  @override
  Widget build(BuildContext context){

    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height * 0.4,
      decoration: _purpleBackground(),
      child: Stack(
        children: [
          Positioned(child: _Bubble(), top: 90, left: 30,),
          Positioned(child: _Bubble(), top: -40, left: -30,),
          Positioned(child: _Bubble(), top: -50, right: -20,),
          Positioned(bottom: -50, left: 10,child: _Bubble(),),
          Positioned(bottom: 120, right: 20,child: _Bubble(),),
        ],
      ),
    );
  }

  BoxDecoration _purpleBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color.fromRGBO(63, 63, 156, 1),
          Color.fromRGBO(90, 70, 178, 1),
        ]
      ),
    );
  }
}

class _Bubble extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: const Color.fromRGBO(255, 255, 255, 0.05)
      ),
    );
  }
}

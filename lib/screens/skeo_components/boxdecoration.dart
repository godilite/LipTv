import 'package:flutter/material.dart';

class NeoPho {
    BoxDecoration neumorphicDecoration({double distance = 10.0, double blur = 20.0, double opacity = 0.5, BorderRadius borderRadius, DecorationImage image, BoxBorder border, Color backgroundScreenColor, LinearGradient backgroundGradient, Brightness mode = Brightness.light}) {
    Color _darkModeShadowOneColor = Colors.grey.withOpacity(0.5 * opacity);
    Color _darkModeShadowTwoColor = Color.fromRGBO(46, 250, 250, 0.3 * opacity);
    Color _lightModeShadowOneColor = Colors.black.withOpacity(0.4 * opacity);
    Color _lightModeShadowTwoColor = Colors.white.withOpacity(1.0 * opacity);
    return BoxDecoration(
            boxShadow: [
                BoxShadow(
                blurRadius: blur,
                color: mode == Brightness.dark ? _darkModeShadowOneColor : _lightModeShadowOneColor,
                offset: Offset(distance, distance),
               // spreadRadius: spreadRadius,
                ),
                BoxShadow(
                blurRadius: blur - 2,
                color: mode == Brightness.dark ? _darkModeShadowTwoColor : _lightModeShadowTwoColor,
                offset: Offset(-distance, -distance),
                //spreadRadius: spreadRadius,
                ),
            ],
            borderRadius: borderRadius,
            image: image,
            border: border,
            color: backgroundScreenColor,
            gradient: backgroundGradient,
        );
    }
}
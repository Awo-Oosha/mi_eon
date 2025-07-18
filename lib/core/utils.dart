import 'package:flutter/material.dart';

Widget gap(double size, {bool vertical = false}) =>
    vertical ? SizedBox(height: size) : SizedBox(width: size);

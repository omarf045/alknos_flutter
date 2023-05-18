import 'package:alknos_v1/pages/chemical_reactions/inorganic_reaction.dart';
import 'package:alknos_v1/pages/electrochemistry/electrolysis.dart';
import 'package:alknos_v1/pages/info/compound_info.dart';
import 'package:flutter/material.dart';

import 'pages/chemical_reactions/limiting_reagent.dart';
import 'pages/electrochemistry/galvanic_cell.dart';
import 'pages/login/login.dart';
import 'pages/info/compound_query.dart';
import 'pages/empirical_formula/empirical_formula.dart';
import 'package:alknos_v1/pages/quantum_mechanics/electromagnetic_wave.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LimitingReagentPage(),
    ));

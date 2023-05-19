import 'package:alknos_v1/pages/chemical_reactions/inorganic_reaction.dart';
import 'package:alknos_v1/pages/chemical_reactions/stoichiometry.dart';
import 'package:alknos_v1/pages/electrochemistry/electrolysis.dart';
import 'package:alknos_v1/pages/info/compound_info.dart';
import 'package:alknos_v1/pages/register/email.dart';
import 'package:alknos_v1/pages/register/password.dart';
import 'package:alknos_v1/pages/register/username.dart';
import 'package:flutter/material.dart';

import 'pages/chemical_reactions/limiting_reagent.dart';
import 'pages/electrochemistry/galvanic_cell.dart';
import 'pages/login/login.dart';
import 'pages/info/compound_query.dart';
import 'pages/empirical_formula/empirical_formula.dart';
import 'package:alknos_v1/pages/quantum_mechanics/electromagnetic_wave.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/stoichiometry',
      routes: {
        '/login': (context) => const LoginPage(),
        '/email': (context) => const EmailPage(),
        '/username': (context) => const UsernamePage(),
        '/password': (context) => const PasswordPage(),
        '/stoichiometry': (context) => const StoichiometryPage(),
        '/limiting-reagent': (context) => const LimitingReagentPage(),
        '/electrolysis': (context) => const ElectrolysisPage(),
        '/galvanic-cell': (context) => const GalvanicCellPage(),
        '/empirical-formula': (context) => const EmpiricalFormulaPage(),
        '/compound-query': (context) => const CompoundQueryPage(),
        '/compound-information': (context) => const CompoundInformationPage(),
        '/electromagnetic-waves': (context) => const ElectromagneticWavePage(),
      },
    ));

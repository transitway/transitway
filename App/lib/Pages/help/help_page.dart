import 'package:flutter/material.dart';
import 'package:transitway/Pages/help/faqcomp.dart';
import 'package:transitway/Pages/profile/profilepage.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfilePage()),
                        );
                      },
                      child: const Icon(Icons.arrow_back_ios_new)),
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      'Ajutor',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'UberMoveBold'),
                    ),
                  ),
                ],
              ),
            ),
            const Text(
              'Gaseste aici raspunsul la cele mai frecvente intrebari.',
              style: TextStyle(
                  fontFamily: 'UberMoveBold',
                  fontSize: 25,
                  color: Colors.purple),
            ),
            Expanded(
                child: ListView(
              children: const [
                FAQComponent(
                  title: 'Cum pot urmări locația live a unui autobuz?',
                  content:
                      'Pentru a urmări locația live a unui autobuz, deschideți aplicația și selectați traseul de autobuz dorit. Aplicația va afișa pe hartă locația în timp real a autobuzului, permițându-vă să urmăriți progresul acestuia de-a lungul traseului.',
                ),
                FAQComponent(
                  title:
                      'Cât de precise sunt predicțiile de timp pentru sosirile autobuzelor?',
                  content:
                      'Predicțiile noastre de timp se bazează pe datele în timp real furnizate de autoritatea de transport în comun. Deși ne străduim să fim exacți, vă rugăm să rețineți că întârzierile neașteptate sau condițiile de trafic pot avea un impact asupra orelor reale de sosire. Vă recomandăm să verificați aplicația pentru actualizări sau să acordați un anumit timp tampon atunci când vă planificați călătoria.',
                ),
                FAQComponent(
                  title:
                      'Cum pot găsi cea mai eficientă rută pentru călătoria mea?',
                  content:
                      'Pentru a găsi cel mai eficient traseu, introduceți locația de pornire și destinația dvs. în bara de căutare a aplicației. Aplicația vă va oferi mai multe opțiuni de traseu, luând în considerare factori precum distanța, timpul de călătorie și orice transferuri necesare. Puteți compara rutele și o puteți alege pe cea care se potrivește cel mai bine nevoilor dumneavoastră.',
                ),
              ],
            )),
          ]),
        ),
      ),
    );
  }
}

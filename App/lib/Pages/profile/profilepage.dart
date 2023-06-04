import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transitway/Pages/help/help_page.dart';
import 'package:transitway/Pages/onboarding/onboarding.dart';
import 'package:transitway/Pages/profile/customaddresspage.dart';
import 'package:transitway/components/customaddr.dart';
import 'package:transitway/components/iconbttn.dart';
import 'package:transitway/providers/account_provider.dart';
import 'package:transitway/utils/env.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AccountProvider>(builder: (context, auth, _) {
      return Scaffold(
          body: SafeArea(
              child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///nume
            Text(
              "${auth.account.lastName} ${auth.account.firstName}",
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: 'UberMoveBold',
              ),
            ),

            ///nr de telefon
            Text(
              "${auth.account.phone}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: darkGrey,
                fontFamily: 'UberMoveBold',
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
            ),

            ///acasa
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CustomAddressPage(
                            homeWork: false,
                          )),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: CustomAddr(
                    title: 'Acasa',
                    address: 'Strada Troienelor, Ploiesti',
                    icon: Icons.home,
                    map: false,
                    color: accentBlue),
              ),
            ),

            ///serviciu
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CustomAddressPage(
                            homeWork: true,
                          )),
                );
              },
              child: CustomAddr(
                  title: 'Serviciu',
                  address: 'Colegiul National "I. L. Caragiale" Ploiesti',
                  icon: Icons.work,
                  map: false,
                  color: accentBlue),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Divider(
                color: darkGrey,
              ),
            ),

            ///ajutor
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelpPage()),
                );
              },
              child: const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: IconBttn(
                  bttnColor: 0xFF1FD982,
                  text: 'Ajutor',
                  icon: Icons.help,
                ),
              ),
            ),

            ///log-out
            GestureDetector(
              onTap: () {
                auth.logout();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Onboarding()),
                );
              },
              child: const IconBttn(
                bttnColor: 0xFFF6493C,
                text: 'Deconecteaza-te',
                icon: Icons.logout_rounded,
              ),
            ),
          ],
        ),
      )));
    });
  }
}

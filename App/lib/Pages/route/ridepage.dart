import 'package:flutter/material.dart';

class RidePage extends StatefulWidget {
  const RidePage({super.key});

  @override
  State<RidePage> createState() => _RidePageState();
}

class _RidePageState extends State<RidePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Stack(children: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.white,
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
              ),
            ),
          ),
        ),
        DraggableScrollableSheet(
            initialChildSize: .35,
            minChildSize: .35,
            maxChildSize: .6,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(17),
                        topRight: Radius.circular(17))),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Container(
                        height: 4,
                        width: 30,
                        color: Colors.grey,
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        children: const <Widget>[
                          Text(
                            'Text 1',
                            style: TextStyle(fontSize: 24),
                          ),
                          Text(
                            'Text 2',
                            style: TextStyle(fontSize: 24),
                          ),
                          Text(
                            'Text 3',
                            style: TextStyle(fontSize: 24),
                          ),
                          Text(
                            'Text 4',
                            style: TextStyle(fontSize: 24),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            })
      ]),
    );
  }
}

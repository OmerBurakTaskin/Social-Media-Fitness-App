import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gym_application/custom_colors.dart';
import 'package:gym_application/providers/background_provider.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  List<Color> backGroundColors = [
    Color.fromARGB(255, 229, 106, 106),
    Color.fromARGB(255, 77, 51, 163),
    Color.fromARGB(255, 71, 223, 97),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BackgroundProvider>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 300,
          child: CarouselSlider(
              options: CarouselOptions(
                  initialPage: 0,
                  onPageChanged: (index, reason) {
                    provider.changeBackgroundColor(backGroundColors[index]);
                  },
                  height: 250,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.2),
              items: [
                _buildStreakCard(),
                _buildWorkoutCard(),
                _buildBodyStatsCard(),
              ]),
        ),
        _buildStatsBar(),
      ],
    );
  }

  Widget _buildStreakCard() {
    return Container(
      width: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
                color: Colors.black, blurRadius: 10, blurStyle: BlurStyle.solid)
          ]),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        blurRadius: 12,
                        blurStyle: BlurStyle.solid)
                  ]),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "17",
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Color.fromARGB(255, 241, 112, 5)),
                        ),
                        SvgPicture.asset("assets/icons/fire_icon.svg")
                      ],
                    ),
                    const Text("Days Streak",
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange)),
                  ],
                ),
              ),
            ),
            Container(
              height: 175,
              width: 150,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        blurRadius: 5,
                        blurStyle: BlurStyle.solid)
                  ]),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutCard() {
    return Container(
      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 46, 14, 153),
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
                color: Colors.black, blurRadius: 10, blurStyle: BlurStyle.solid)
          ]),
      child: Center(
        child: Column(
          children: [],
        ),
      ),
    );
  }

  Widget _buildBodyStatsCard() {
    return Container(
      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 14, 154, 37),
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
                color: Colors.black, blurRadius: 10, blurStyle: BlurStyle.solid)
          ]),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 80,
                    width: 130,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black,
                            blurRadius: 6,
                            blurStyle: BlurStyle.solid)
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Current Weight",
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "75 kg",
                            style: TextStyle(
                                color: Color.fromARGB(255, 35, 107, 38),
                                fontSize: 20,
                                fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 130,
                    height: 70,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black,
                            blurRadius: 6,
                            blurStyle: BlurStyle.solid)
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Total weight loss",
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "-",
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 16,
                              fontWeight: FontWeight.w800),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 180,
                    width: 160,
                    decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black,
                              blurRadius: 6,
                              blurStyle: BlurStyle.solid)
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _bodyStatText("Body fat: %25", Colors.orangeAccent),
                        _bodyStatText("Muscle %40", Colors.red),
                        _bodyStatText("Water %18", Colors.purple),
                        _bodyStatText("Height: 176cm ", Colors.cyan),
                        _bodyStatText("BMI: 25", Colors.blue),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsBar() {
    final lineChart = LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 0),
              FlSpot(1, 1),
              FlSpot(2, 2),
              FlSpot(3, 3),
              FlSpot(4, 4),
              FlSpot(5, 5),
              FlSpot(6, 6),
              FlSpot(7, 7),
              FlSpot(8, 8),
              FlSpot(9, 9),
              FlSpot(10, 10),
              FlSpot(11, 11),
              FlSpot(12, 12),
              FlSpot(13, 13),
              FlSpot(14, 14),
              FlSpot(15, 15),
              FlSpot(16, 16),
              FlSpot(17, 17),
              FlSpot(18, 18),
              FlSpot(19, 19),
              FlSpot(20, 20),
              FlSpot(21, 21),
              FlSpot(22, 22),
              FlSpot(23, 23),
              FlSpot(24, 24),
              FlSpot(25, 25),
              FlSpot(26, 26),
              FlSpot(27, 27),
              FlSpot(28, 28),
              FlSpot(29, 29),
              FlSpot(30, 30),
            ],
            isCurved: true,
            barWidth: 4,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(
              show: true,
            ),
          )
        ],
      ),
    );
    return SingleChildScrollView(
      child: Column(
        children: [SizedBox(height: 350, child: lineChart)],
      ),
    );
  }

  Widget _bodyStatText(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Text(
        text,
        style:
            TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fostr/router/router.dart';
import 'package:fostr/router/routes.dart';
import 'package:fostr/utils/theme.dart';
import 'package:fostr/widgets/Buttons.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AnalyzingPage extends StatefulWidget {
  const AnalyzingPage({Key? key}) : super(key: key);

  @override
  State<AnalyzingPage> createState() => _AnalyzingPageState();
}

class _AnalyzingPageState extends State<AnalyzingPage> with FostrTheme {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.6, -1),
            end: Alignment(1, 0.6),
            colors: [
              Color.fromRGBO(148, 181, 172, 1),
              Color.fromRGBO(229, 229, 229, 1),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: paddingH + const EdgeInsets.only(top: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        FostrRouter.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Reading Personality Quiz",
                      style: h1.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.only(
                      topStart: Radius.circular(32),
                      topEnd: Radius.circular(32),
                    ),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 100,
                        ),
                        SfCircularChart(
                          series: [
                            DoughnutSeries(
                              pointColorMapper: (data, idx) {
                                switch (idx) {
                                  case 0:
                                    return Colors.white;
                                  case 1:
                                    return Color(0xff9AC8B1);
                                  default:
                                    return Colors.black;
                                }
                              },
                              dataSource: [
                                {"x": 00, "y": 100},
                                {"x": 00, "y": 500},
                              ],
                              xValueMapper: (data, _) => data["x"],
                              yValueMapper: (data, _) => data["y"],
                              radius: "150",
                              innerRadius: "100",
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Text(
                          "Analysing Personality",
                          style: h1.copyWith(fontSize: 26),
                        ),
                        Spacer(),
                        PrimaryButton(
                          text: "Go next",
                          onTap: () {
                            FostrRouter.replaceGoto(context, Routes.bookClubSuggetion);
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

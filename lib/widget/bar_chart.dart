import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:kbc_quiz/util/util.dart';
import 'package:kbc_quiz/widget/button.dart';

class SimpleBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleBarChart(this.seriesList, {this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory SimpleBarChart.withData(List<OrdinalPoll> pollData) {
    return new SimpleBarChart(
      _createSampleData(pollData),
      // Disable animations for image tests.
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    var chart = new charts.BarChart(
      seriesList,
      animate: true,
      animationDuration: Duration(milliseconds: 700),
      domainAxis: new charts.OrdinalAxisSpec(
        renderSpec: new charts.SmallTickRendererSpec(
          // Tick and Label styling here.
          labelStyle: new charts.TextStyleSpec(
            fontSize: 25, // size in Pts.
            color: charts.MaterialPalette.white,
            fontWeight: "bold",
          ),

          // Change the line colors to match text color.
          lineStyle: new charts.LineStyleSpec(
            color: charts.MaterialPalette.white,
            thickness: 5,
          ),
        ),
      ),

      /// Assign a custom style for the measure axis.
      primaryMeasureAxis: new charts.NumericAxisSpec(
          renderSpec: new charts.GridlineRendererSpec(
              // Tick and Label styling here.
              labelStyle: new charts.TextStyleSpec(
                  fontSize: 18, // size in Pts.
                  color: charts.MaterialPalette.white),
              // Change the line colors to match text color.
              lineStyle: new charts.LineStyleSpec(
                  color: charts.MaterialPalette.white))),
    );

    var chartWidget = new Padding(
      padding: new EdgeInsets.symmetric(
        vertical: 150,
        horizontal: 30,
      ),
      child: new SizedBox(
        height: 100.0,
        child: chart,
      ),
    );
    return Scaffold(
      body: Container(
          decoration: Util.gradientBackground(),
          child: Column(
            children: <Widget>[
              Container(
                height: 60,
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "AUDIENCE POLL",
                  style: Util.getTextStyle(context).copyWith(
                    letterSpacing: 3.0,
                    fontSize: 30.0,
                  ),
                ),
              ),
              Flexible(
                flex: 10,
                child: chartWidget,
                fit: FlexFit.tight,
              ),
              Flexible(
                flex: 1,
                child: Button(
                  buttonText: "OK",
                  callback: (c) {
                    Navigator.pop(context);
                  },
                ),
              ),
              Flexible(
                flex: 1,
                child: SizedBox(
                  height: 40.0,
                ),
              )
            ],
          )),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalPoll, String>> _createSampleData(
      List<OrdinalPoll> pollData) {
    return [
      new charts.Series<OrdinalPoll, String>(
        id: 'AudiencePoll',
        colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
        domainFn: (data, _) => data.index,
        measureFn: (data, _) => data.percentage,
        data: pollData,
      )
    ];
  }
}

/// Sample ordinal data type.
class OrdinalPoll {
  final String index;
  final int percentage;

  OrdinalPoll(this.index, this.percentage);
}

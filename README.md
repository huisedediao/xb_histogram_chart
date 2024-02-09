# xb_histogram_chart
柱状图

![image.png](https://upload-images.jianshu.io/upload_images/3597041-6c9cc4a0dbcbb0d8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


```
import 'package:flutter/material.dart';
import 'package:xb_custom_widget_cabin/histogram_chart/histogram_chart_vm.dart';
import 'package:xb_custom_widget_cabin/histogram_chart/xb_histogram_chart/xb_histogram_chart.dart';
import 'package:xb_custom_widget_cabin/histogram_chart/xb_histogram_chart/xb_histogram_chart_y_model.dart';
import 'package:xb_scaffold/xb_scaffold.dart';

class HistogramChart extends XBPage<HistogramChartVM> {
  const HistogramChart({super.key});

  @override
  generateVM(BuildContext context) {
    return HistogramChartVM(context: context);
  }

  @override
  String setTitle(HistogramChartVM vm) {
    return "柱状图demo";
  }

  @override
  Widget buildPage(vm, BuildContext context) {
    final models = [
      XBHistogramYModel(name: '张益达', value: 10),
      XBHistogramYModel(name: 'snack', value: 9),
      XBHistogramYModel(name: '吕小布', value: 8),
      XBHistogramYModel(name: '曾小贤', value: 7),
      XBHistogramYModel(name: '吴彦祖', value: 6),
      XBHistogramYModel(name: '张震', value: 5)
    ];
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: XBHistogram(yModels: models),
            ),
          ),
        ),
      ),
    );
  }
}

```
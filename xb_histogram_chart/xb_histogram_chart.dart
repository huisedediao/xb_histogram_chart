import 'dart:math';
import 'package:flutter/material.dart';
import 'package:xb_custom_widget_cabin/histogram_chart/xb_histogram_chart/xb_histogram_chart_item.dart';
import 'package:xb_custom_widget_cabin/histogram_chart/xb_histogram_chart/xb_histogram_chart_y_model.dart';

// ignore: must_be_immutable
class XBHistogram extends StatelessWidget {
  /// 数据
  final List<XBHistogramYModel> yModels;

  /// 除去0以外，底部文字的数量
  final int xAxisTitleCount;

  /// 每个柱子的高度
  final double itemHeigth;

  /// 柱子的间距
  final double itemGap;

  /// 左侧文字的最大宽度
  final double maxLeftTitleWidth;

  /// 底部文字，会自动生成
  late List<String> xAxisTitlesList;

  /// 根据yModels中所有元素的value计算的最大值，用来计算柱子百分比
  late double maxValue;

  /// 左侧文字的宽度，会自动计算，最宽为maxTitleWidth
  late double leftTitleWidth;

  /// 底部文字的宽度，会自动计算
  late double bottomTitleWidth;

  XBHistogram(
      {required this.yModels,
      this.xAxisTitleCount = 4,
      this.itemHeigth = 18,
      this.itemGap = 15,
      this.maxLeftTitleWidth = 70,
      super.key}) {
    if (yModels.isEmpty) {
      yModels.add(XBHistogramYModel(name: "暂无数据", value: 0));
    }
    xAxisTitlesList = caculateXAxisTitlesList();
    leftTitleWidth = caculateMaxLeftTitleWidth();
    bottomTitleWidth = caculateMaxBottomTitleWidth();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [_top(), _bottom()],
    );
  }

  _top() {
    return Row(
      children: [_topLeft(), Expanded(child: _topRight())],
    );
  }

  double get _fontSize {
    if ((itemHeigth - 5) > 14) {
      return 14;
    }
    return itemHeigth - 5;
  }

  double get _paddingRight => 16;

  Widget _topLeft() {
    return Column(
      children: List.generate(yModels.length, (index) {
        XBHistogramYModel yModel = yModels[index];
        return Padding(
          padding: EdgeInsets.only(
              bottom: (index == yModels.length - 1) ? 0 : itemGap,
              right: _paddingRight - bottomTitleWidth * 0.5),
          child: Container(
              // color: Colors.orange,
              width: leftTitleWidth,
              alignment: Alignment.centerRight,
              height: itemHeigth,
              child: Text(
                yModel.name,
                overflow: TextOverflow.ellipsis,
                style: _leftTitleStyle,
              )),
        );
      }),
    );
  }

  TextStyle get _leftTitleStyle => TextStyle(fontSize: _fontSize);

  TextStyle get _bottomTitleStyle =>
      const TextStyle(color: Colors.grey, fontSize: 14);

  double get _topTotalHeight {
    return yModels.length * itemHeigth + (yModels.length - 1) * itemGap;
  }

  Widget _topRight() {
    return Stack(
      children: [
        FractionallySizedBox(
          widthFactor: 1.0,
          child: Container(
            // color: Colors.amber,
            alignment: Alignment.topLeft,
            height: _topTotalHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(xAxisTitlesList.length, (index) {
                return Visibility(
                  maintainAnimation: true,
                  maintainSize: true,
                  maintainState: true,
                  visible: index != 0,
                  child: Container(
                    // color: Colors.red,
                    width: bottomTitleWidth,
                    height: _topTotalHeight,
                    alignment: Alignment.center,
                    child: Container(
                      width: 1,
                      color: Colors.grey.withAlpha(30),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: bottomTitleWidth * 0.5),
          child: Container(
            decoration: BoxDecoration(
              // color: Colors.orange,
              border: Border(
                left: BorderSide(
                  color: Colors.grey.withAlpha(80), // 边框颜色
                  width: 1.0, // 边框宽度
                ),
              ),
            ),
            // color: Colors.orange,
            child: Column(
              children: List.generate(yModels.length, (index) {
                XBHistogramYModel yModel = yModels[index];
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: (index == yModels.length - 1) ? 0 : itemGap),
                  child: Padding(
                    padding: EdgeInsets.only(right: bottomTitleWidth * 0.5),
                    child: XBHistogramItem(
                        value: yModel.value / maxValue, height: itemHeigth),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  _bottom() {
    final xAxisTitles = xAxisTitlesList;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          SizedBox(
            width: leftTitleWidth + _paddingRight - bottomTitleWidth * 0.5,
          ),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(xAxisTitlesList.length, (index) {
              return Container(
                width: bottomTitleWidth,
                alignment: Alignment.center,
                child: Text(
                  xAxisTitles[index],
                  style: _bottomTitleStyle,
                ),
              );
            }),
          ))
        ],
      ),
    );
  }

  List<String> caculateXAxisTitlesList() {
    double max = 0;
    for (var element in yModels) {
      if (element.value > max) {
        max = element.value;
      }
    }

    int unit = 1;
    if (max != 0) {
      unit = (max / xAxisTitleCount).ceil();
    } else {
      unit = 1;
    }
    maxValue = (unit * xAxisTitleCount).toDouble();

    final ret =
        List.generate(xAxisTitleCount + 1, (index) => "${index * unit}");
    return ret;
  }

  double caculateMaxLeftTitleWidth() {
    double max = 0;
    for (var element in yModels) {
      final tempW = caculateTitleWidth(element.name, _leftTitleStyle);
      if (tempW > max) {
        max = tempW;
      }
    }
    return min(max, maxLeftTitleWidth);
  }

  double caculateMaxBottomTitleWidth() {
    double max = 0;
    for (var element in xAxisTitlesList) {
      final tempW = caculateTitleWidth(element, _bottomTitleStyle);
      if (tempW > max) {
        max = tempW;
      }
    }
    return min(max, maxLeftTitleWidth);
  }

  double caculateTitleWidth(String value, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: value, style: style),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final size = textPainter.size; // 这将返回一个Size对象，包含了文字的宽度和高度
    final width = size.width; // 文字的宽度
    // final height = size.height; // 文字的高度
    return width + 2;
  }
}

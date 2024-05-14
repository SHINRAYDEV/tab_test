import 'package:flutter/material.dart';

const kPageTitle = 'Settings';
List<String> kLabels = [
  "Edit Profile",
  "Accounts",
  "Security",
  "Notifications",
  "Privacy",
  "Activity",
  "Display",
  "Sound",
  "Accessibility"
];
const kTabBgColor = Color(0xFF8F32A9);
const kTabFgColor = Colors.white;

void main() {
  runApp(const TabBarDemo());
}

class TabBarDemo extends StatelessWidget {
  const TabBarDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: const Color(0xffF3F4FA)),
      home: const SettingsPage(),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with SingleTickerProviderStateMixin {
  late TabController _controller;
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: kLabels.length, vsync: this);
    _controller.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTabChange);
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_controller.indexIsChanging) return;
    _pageController.jumpToPage(_controller.index);
    _scrollToCurrentTab();
    setState(() {});
  }

  void _scrollToCurrentTab() {
    final double screenWidth = MediaQuery.of(context).size.width;
    const double tabWidth = 134.0;
    final double scrollOffset = (_controller.index * tabWidth) - (screenWidth / 2) + (tabWidth / 2);
    _scrollController.animateTo(
      scrollOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(kPageTitle),
        elevation: 0,
      ),
      body: Column(
        children: [
          CustomScrollableTabBar(
            controller: _controller,
            scrollController: _scrollController,
            labels: kLabels,
            backgroundColor: kTabBgColor,
            foregroundColor: kTabFgColor,
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              children: kLabels.map((label) => Center(child: Text(label))).toList(),
              onPageChanged: (index) => _controller.animateTo(index, duration: Duration.zero),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomScrollableTabBar extends StatelessWidget {
  final TabController controller;
  final ScrollController scrollController;
  final List<String> labels;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? activeBackgroundColor;
  final Color? activeForegroundColor;
  final double? fontSize;

  const CustomScrollableTabBar({
    super.key,
    required this.controller,
    required this.scrollController,
    required this.labels,
    required this.backgroundColor,
    required this.foregroundColor,
    this.activeBackgroundColor,
    this.activeForegroundColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = labels.asMap().entries.map((entry) {
      final index = entry.key;
      final label = entry.value;
      final active = controller.index == index;
      return Positioned(
        key: ValueKey(index),
        left: index * 114.0,
        child: MyTab(
          activePaint: index == 0 ? ActiveTabPainter() : RPSCustomPainter(),
          inactivePaint: index == 0 ? InactiveTabPainter() : RPSCustomPainter1(),
          padding: index == 0 ? EdgeInsets.zero : const EdgeInsets.only(left: 10),
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          activeBackgroundColor: activeBackgroundColor,
          activeForegroundColor: activeForegroundColor,
          fontSize: fontSize,
          active: active,
          label: label,
          onTap: () {
            controller.animateTo(index);
          },
        ),
      );
    }).toList();

    tabs.sort((a, b) {
      final aKey = a.key as ValueKey<int>;
      final bKey = b.key as ValueKey<int>;
      if (aKey.value == controller.index) {
        return 1;
      }
      if (bKey.value == controller.index) {
        return -1;
      }
      return 0;
    });

    return Container(
      color: Theme.of(context).primaryColor,
      height: 60,
      child: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: labels.length * 134.0, // 确保 SizedBox 宽度足以包含所有标签
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: tabs,
          ),
        ),
      ),
    );
  }
}

class MyTab extends StatelessWidget {
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? activeBackgroundColor;
  final Color? activeForegroundColor;
  final double? fontSize;
  final bool active;
  final String label;
  final VoidCallback? onTap;
  final CustomPainter activePaint;
  final CustomPainter inactivePaint;
  final EdgeInsets padding;

  const MyTab({
    super.key,
    this.active = false,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.activePaint,
    required this.inactivePaint,
    required this.padding,
    this.activeBackgroundColor,
    this.activeForegroundColor,
    this.fontSize,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: active ? 41 : 36,
        width: 134, // 设置宽度以确保标签可以部分重叠
        child: CustomPaint(
          painter: active ? activePaint : inactivePaint,
          child: Padding(
            padding: padding,
            child: Center(
              child: Text(
                label,
                style: TextStyle(color: Colors.black, fontSize: fontSize),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ActiveTabPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(0, 8);
    path_0.cubicTo(0, 3.58172, 3.58172, 0, 8, 0);
    path_0.lineTo(117.717, 0);
    path_0.cubicTo(121.405, 0, 124.615, 2.5213, 125.489, 6.10435);
    path_0.lineTo(134, 41);
    path_0.lineTo(0, 41);
    path_0.lineTo(0, 8);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class InactiveTabPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(0, 8);
    path_0.cubicTo(0, 3.58172, 3.58172, 0, 8, 0);
    path_0.lineTo(117.919, 0);
    path_0.cubicTo(121.513, 0, 124.666, 2.39629, 125.627, 5.85885);
    path_0.lineTo(134, 36);
    path_0.lineTo(0, 36);
    path_0.lineTo(0, 8);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = const Color(0xffE6E6E6).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(8.51113, 6.10435);
    path_0.cubicTo(9.38505, 2.5213, 12.5952, 0, 16.2833, 0);
    path_0.lineTo(127.717, 0);
    path_0.cubicTo(131.405, 0, 134.615, 2.5213, 135.489, 6.10435);
    path_0.lineTo(144, 41);
    path_0.lineTo(0, 41);
    path_0.lineTo(8.51113, 6.10435);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class RPSCustomPainter1 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(8.37254, 5.85885);
    path_0.cubicTo(9.33436, 2.3963, 12.487, 0, 16.0807, 0);
    path_0.lineTo(117.919, 0);
    path_0.cubicTo(121.513, 0, 124.666, 2.39629, 125.627, 5.85885);
    path_0.lineTo(134, 36);
    path_0.lineTo(0, 36);
    path_0.lineTo(8.37254, 5.85885);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = const Color(0xffE6E6E6).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

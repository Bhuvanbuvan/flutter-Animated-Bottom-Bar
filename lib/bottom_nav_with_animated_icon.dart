import 'package:bottomsheet/model/nav_item_model.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

const bottomNavBgColor = Color(0xFF17203A);

class BottomNavWithAnimatedIcon extends StatefulWidget {
  const BottomNavWithAnimatedIcon({super.key});

  @override
  State<BottomNavWithAnimatedIcon> createState() =>
      _BottomNavWithAnimatedIconState();
}

class _BottomNavWithAnimatedIconState extends State<BottomNavWithAnimatedIcon> {
  List<SMIBool> riveIconList = [];

  List<StateMachineController> controllers = [];

  int selectedNavIndex = 0;
  void animateTheIcon(int index) {
    riveIconList[index].change(true);
    Future.delayed(Duration(seconds: 1), () {
      riveIconList[index].change(false);
    });
  }

  void _riveOnInIt(Artboard artboart, {required String stateMachineName}) {
    final StateMachineController? controller =
        StateMachineController.fromArtboard(artboart, stateMachineName);

    if (controller != null) {
      artboart.addController(controller);
      controllers.add(controller);
      final SMIBool? input = controller.findInput<bool>('active') as SMIBool?;

      if (input != null) {
        riveIconList.add(input);
      } else {
        print("Error: 'active' input not found in the state machine");
      }
    } else {
      print("Error: StateMachineController not found for ${stateMachineName}");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    for (var controler in controllers) {
      controler.dispose();
    }
    super.dispose();
  }

  List<String> _pages = ["Chat", "Search", "Timer", "Notification", "Home"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(_pages[selectedNavIndex]),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 67,
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: bottomNavBgColor.withOpacity(0.8),
            borderRadius: BorderRadius.all(
              Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                  color: bottomNavBgColor.withOpacity(0.3),
                  offset: Offset(0, 20),
                  blurRadius: 20),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(bottomNavItems.length, (index) {
              final riveIcon = bottomNavItems[index].rive;
              return GestureDetector(
                onTap: () {
                  animateTheIcon(index);
                  setState(() {
                    selectedNavIndex = index;
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Animatedbar(
                      isActive: selectedNavIndex == index,
                    ),
                    SizedBox(
                      height: 36,
                      width: 36,
                      child: Opacity(
                        opacity: selectedNavIndex == index ? 1 : 0.5,
                        child: RiveAnimation.asset(
                          riveIcon.srcs,
                          artboard: riveIcon.artboard,
                          onInit: (artboard) {
                            _riveOnInIt(artboard,
                                stateMachineName: riveIcon.stateMachineName);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class Animatedbar extends StatelessWidget {
  const Animatedbar({super.key, required this.isActive});
  final bool isActive;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(
        milliseconds: 200,
      ),
      margin: EdgeInsets.only(bottom: 2),
      height: 4,
      width: isActive ? 20 : 0,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
    );
  }
}

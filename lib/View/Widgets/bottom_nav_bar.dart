import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:superstate/Blocs/Bottom%20Navigation%20Bloc/bottom_navigation_bloc.dart';
import 'package:superstate/Blocs/Bottom%20Navigation%20Bloc/bottom_navigation_events.dart';
import 'package:superstate/Blocs/Bottom%20Navigation%20Bloc/bottom_navigation_states.dart';
import 'package:superstate/View/Home/home.dart';
import 'package:superstate/View/Profile/profile.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context){
    return BlocConsumer<BottomBarBloc, BottomBarState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: state.currentIndex == 0
                ? const HomePage()
                : state.currentIndex == 1
                ? const Placeholder()
                : const Profile(),
          ),
          //child: _options[widget.bottomIndex],
          bottomNavigationBar: FlashyTabBar(
            animationCurve: Curves.linear,
            selectedIndex: state.currentIndex,
            iconSize: 30,
            showElevation: false, // use this to remove appBar's elevation
            onItemSelected: (index) {
              BlocProvider.of<BottomBarBloc>(context)
                  .add(IndexChange(currentIndex: index));
            } /*setState(() {
              widget.bottomIndex = index;
            })*/,
            items: [
              FlashyTabBarItem(
                icon: const Icon(MingCute.home_1_fill), //Icons.home_rounded
                title: const Text('Home'),
              ),
              FlashyTabBarItem(
                icon: const Icon(Icons.notifications_rounded), //Icons.notifications_rounded
                title: const Text('Notifications'),
              ),
              FlashyTabBarItem(
                icon: const Icon(Icons.person), //EvaIcons.person
                title: const Text('Info'),
              ),
            ],
          ),
        );
      },
    );
  }
}

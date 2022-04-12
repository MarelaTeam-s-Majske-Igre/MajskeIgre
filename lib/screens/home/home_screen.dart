import 'dart:ui';

import 'package:app/data/event_type/event_type.dart';
import 'package:app/data/event_type/event_type_services.dart';
import 'package:app/data/events/events_repo.dart';
import 'package:app/data/models/event_card_model.dart';
import 'package:app/screens/cubit_screens/error_screen.dart';
import 'package:app/screens/cubit_screens/loading_screen.dart';
import 'package:app/screens/drawer/app_drawer.dart';
import 'package:app/screens/home/cubit/home_screen_cubit.dart';
import 'package:app/style/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:intl/intl.dart';
import 'package:app/extensions/capitalize.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (context) => HomeScreenCubit(EventsRepo()),
      child: BlocBuilder<HomeScreenCubit, HomeScreenState>(
        builder: (context, state) {
          if (state is HomeScreenInitial) {
            context.read<HomeScreenCubit>().loadData();
            return LoadingScreen();
          } else if (state is HomeScreenLoadingState) {
            return LoadingScreen();
          } else if (state is HomeScreenErrorState) {
            return ErrorScreen(
              refresh: () => context.read<HomeScreenCubit>().loadData(),
            );
          } else if (state is HomeScreenLoadedState) {
            return _buildWithData(context, state, h, w);
          } else {
            return Scaffold(
              body:
                  Center(child: Text("Nekaj je šlo narobe, še sam ne vem kaj")),
            );
          }
        },
      ),
    );
  }

  Scaffold _buildWithData(
      BuildContext context, HomeScreenLoadedState state, double h, double w) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ThemeColors.primaryBlue,
      drawer: AppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.02,
                vertical: h * 0.02,
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          iconSize: 20,
                          onPressed: () =>
                              _scaffoldKey.currentState?.openDrawer(),
                          icon: Icon(
                            FlutterRemix.menu_2_line,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 2),
                          child: Text(
                            "Majske igre",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 22),
                          ),
                        )
                      ],
                    ),
                    IconButton(
                      iconSize: 20,
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, "/search"),
                      icon: Icon(
                        FlutterRemix.search_eye_line,
                        color: Colors.white.withOpacity(0.75),
                      ),
                    ),
                  ]),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40)),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: w * 0.04,
                        top: 20,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 15, 2),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: ThemeColors.primaryBlue,
                                        width: 2))),
                            child: Text(
                              "Prihajajoči dogodki",
                              style: TextStyle(
                                color: ThemeColors.primaryBlue,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: CustomScrollView(
                        physics: BouncingScrollPhysics(),
                        slivers: [
                          for (var card in _cardListView(context, state, h, w))
                            SliverPadding(
                              padding: EdgeInsets.only(top: h * 0.01),
                              sliver: SliverToBoxAdapter(child: card),
                            ),
                          // SliverToBoxAdapter(
                          //   child: TextButton(
                          //       onPressed: () =>
                          //           Navigator.of(context).pushNamed("/events"),
                          //       child: Row(
                          //         mainAxisAlignment: MainAxisAlignment.end,
                          //         children: [
                          //           Text(
                          //             "Pokaži več",
                          //             style: TextStyle(
                          //                 color: Colors.white,
                          //                 fontSize: 14,
                          //                 fontWeight: FontWeight.w600),
                          //           ),
                          //           SizedBox(
                          //             width: 5,
                          //           ),
                          //           Icon(
                          //             FlutterRemix.arrow_right_line,
                          //             color: Colors.white,
                          //             size: 20,
                          //           )
                          //         ],
                          //       )),
                          // ),
                          SliverToBoxAdapter(
                            child: SizedBox(height: 30),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _cardListView(
    BuildContext context,
    HomeScreenLoadedState state,
    double h,
    double w,
  ) {
    var todaysEvents = state.getNextEvents();
    List<Widget> eventCards = [
      SizedBox(
        width: 20,
      ),
    ];

    eventCards.addAll(EventCardListModel.fromRepo(todaysEvents)
        .events
        .map(
          (e) => _eventCard(context,
              w: w,
              h: h,
              title: e.title,
              type: e.type,
              date: e.startTime,
              background: e.imageUrl,
              onClick: () => e.onClick(context)),
        )
        .toList());

    // +1 Padding is first element
    if (eventCards.length > (5 + 1)) {
      eventCards = eventCards.sublist(0, 5 + 1);
    }

    return eventCards;
  }

  Widget _eventCard(
    BuildContext context, {
    required double w,
    required double h,
    EventType type = EventType.SPORT,
    required String title,
    DateTime? date,
    required Function onClick,
    String? background,
  }) {
    return GestureDetector(
      onTap: () => onClick(),
      child: Container(
        clipBehavior: Clip.hardEdge,
        margin: EdgeInsets.symmetric(horizontal: w * 0.05),
        decoration: BoxDecoration(
          color: Color.alphaBlend(
            Colors.black.withOpacity(0.25),
            EventTypeService.getEventTypeColor(type),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: h * 0.1, left: w * 0.25),
                child: Image.asset(
                  EventTypeService.getEventTypeAssetImage(type),
                  height: h * 0.15,
                ),
              ),
            ),
            if (background != null)
              Positioned.fill(
                  child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      background,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                      child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                          Colors.transparent,
                          EventTypeService.getEventTypeBackgroundColor(type),
                        ])),
                  ))
                ],
              )),
            Container(
              padding: EdgeInsets.fromLTRB(
                w * 0.06,
                h * 0.02,
                w * 0.02,
                h * 0.02,
              ),
              height: h * 0.17,
              width: w * 0.65,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (date != null)
                    Text(
                      type == EventType.FUN
                          ? DateFormat('EEE, dd. MMM', "sl").format(date)
                          : DateFormat('EEE, dd. MMM ob H:mm', "sl")
                              .format(date),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Text(
                      title.capitalize(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

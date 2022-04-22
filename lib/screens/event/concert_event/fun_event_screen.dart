import 'package:app/data/events/events_repo.dart';
import 'package:app/screens/cubit_screens/error_screen.dart';
import 'package:app/screens/cubit_screens/loading_screen.dart';
import 'package:app/screens/event/concert_event/cubit/concert_detail_cubit.dart';
import 'package:app/style/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:intl/intl.dart';

class FunEventDetailScreen extends StatelessWidget {
  const FunEventDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    return BlocProvider(
      create: (context) => ConcertDetailCubit(EventsRepo()),
      child: BlocBuilder<ConcertDetailCubit, ConcertDetailState>(
        builder: (context, state) {
          if (state is ConcertDetailInitial) {
            context.read<ConcertDetailCubit>().loadEvent(arguments['id']);
            return LoadingScreen();
          } else if (state is ConcertDetailLoadingState) {
            return LoadingScreen();
          } else if (state is ConcertDetailErrorState) {
            return ErrorScreen(
              refresh: () =>
                  context.read<ConcertDetailCubit>().loadEvent(arguments['id']),
            );
          } else if (state is ConcertDetailLoadedState) {
            return _buildWithData(context, state, h, w);
          } else {
            return ErrorScreen(
              errorMessage: "Napaka, še sam ne vem kakšna",
            );
          }
        },
      ),
    );
  }

  Scaffold _buildWithData(
    BuildContext context,
    ConcertDetailLoadedState state,
    double h,
    double w,
  ) {
    return Scaffold(
        backgroundColor: Color.alphaBlend(
            Colors.black.withOpacity(0.15), ThemeColors.blueFun),
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _header(state, h, w),
                ),
                for (var band in state.event.concertGroups)
                  _groupCard(band.musicGroup, band.titleSize),
              ],
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: w * 0.015, vertical: h * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        FlutterRemix.arrow_left_s_line,
                        color: Colors.white,
                      ),
                    ),
                    // IconButton(
                    //     onPressed: () => null,
                    //     icon: Icon(
                    //       FlutterRemix.notification_3_line,
                    //       color: Colors.white,
                    //     ))
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _header(ConcertDetailLoadedState state, double h, double w) {
    return Padding(
      padding: EdgeInsets.only(bottom: h * 0.02),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: h * 0.4),
        child: DecoratedBox(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                ThemeColors.primaryBlue,
                ThemeColors.primaryBlue.withOpacity(0.8),
                ThemeColors.primaryBlue.withOpacity(0.75),
                ThemeColors.primaryBlue.withOpacity(0.65),
                ThemeColors.primaryBlue.withOpacity(0.55),
                ThemeColors.primaryBlue.withOpacity(0.4),
                ThemeColors.primaryBlue.withOpacity(0.2),
                ThemeColors.primaryBlue.withOpacity(0.1),
                ThemeColors.primaryBlue.withOpacity(0.05),
                Colors.transparent,
              ],
                  stops: [
                0,
                0.65,
                0.7,
                0.75,
                0.8,
                0.85,
                0.9,
                0.92,
                0.95,
                1
              ])),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: h * 0.15),
                height: h * 0.18,
                child: Image.asset(
                  "assets/img/zabavko.png",
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: h * 0.04),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Text(
                        DateFormat("EEEE - d. MMM", "sl").format(state.event.date),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w300),
                      ),
                      Text(
                        state.event.concertName,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        state.event.concertLocation,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _groupCard(String name, String header) {
    return SliverToBoxAdapter(
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
          child: Center(
            child: Text(name,
                textAlign: TextAlign.center,
                style: _createStyleForGroup(header)),
          )),
    );
  }

  TextStyle _createStyleForGroup(String header) {
    if (header == "h1") {
      return TextStyle(
          fontSize: 38, color: Colors.white, fontWeight: FontWeight.w800);
    } else if (header == "h2") {
      return TextStyle(
          fontSize: 28, color: Colors.white, fontWeight: FontWeight.w600);
    } else if (header == "h3") {
      return TextStyle(fontSize: 24, color: Colors.white);
    } else if (header == "h4") {
      return TextStyle(
          fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600);
    } else if (header == "h5") {
      return TextStyle(fontSize: 20, color: Colors.white);
    } else {
      return TextStyle(fontSize: 16, color: Colors.white);
    }
  }
}

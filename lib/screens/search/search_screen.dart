import 'package:app/data/events/events_repo.dart';
import 'package:app/screens/cubit_screens/error_screen.dart';
import 'package:app/screens/cubit_screens/loading_screen.dart';
import 'package:app/screens/search/cubit/search_cubit.dart';
import 'package:app/services/stats/plausible_analitics.dart';
import 'package:app/style/theme_colors.dart';
import 'package:app/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, "/");
        return false;
      },
      child: BlocProvider(
          create: (context) => SearchCubit(EventsRepo()),
          child: Scaffold(
              backgroundColor: ThemeColors.primaryBlue,
              body: SafeArea(
                  child: Column(children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: w * 0.02,
                    top: h * 0.01,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () =>
                            Navigator.pushReplacementNamed(context, "/"),
                        icon: Icon(
                          FlutterRemix.arrow_left_s_line,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
                Center(
                  child: Image.asset(
                    "assets/img/logo_big.png",
                    height: h * 0.15,
                  ),
                ),
                Expanded(
                  child: BlocBuilder<SearchCubit, SearchState>(
                    builder: (context, state) {
                      if (state is SearchInitial) {
                        context.read<SearchCubit>().onSearchQueryChange("");
                        PlausibleAnalitics.logEvent("search");
                        return LoadingScreen(
                          withScaffold: false,
                        );
                      } else if (state is SearchLoadingState) {
                        return LoadingScreen(
                          withScaffold: false,
                        );
                      } else if (state is SearchLoadedState) {
                        return _buildSerachView(context, state, w, h);
                      } else {
                        return ErrorScreen(
                            errorMessage: "Napak, še sam ne vem kakšna");
                      }
                    },
                  ),
                ),
              ])))),
    );
  }

  Widget _buildSerachView(
    BuildContext context,
    SearchLoadedState state,
    double w,
    double h,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: w * 0.04),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: w * 0.04),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: TextField(
              decoration: InputDecoration(
                isDense: true,
                focusedBorder: InputBorder.none,
                label: Row(
                  children: [
                    Icon(
                      FlutterRemix.search_eye_line,
                      size: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Iskanje"),
                  ],
                ),
              ),
              onChanged: (value) =>
                  context.read<SearchCubit>().onSearchQueryChange(value),
            ),
          ),
          Expanded(
            child: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                for (var event in state.events)
                  EventCard(
                    title: event.title,
                    eventType: event.type,
                    onClick: () => event.onClick(context),
                    location: event.location,
                    time: event.startTime,
                    longTimeFormat: true,
                  ),
                SliverToBoxAdapter(
                  child: SizedBox(height: h * 0.05),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

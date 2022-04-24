import 'package:app/data/event_type/event_type.dart';
import 'package:app/data/events/day_event_model.dart';
import 'package:app/data/events/events_repo.dart';
import 'package:app/data/models/event_card_model.dart';
import 'package:app/screens/cubit_screens/error_screen.dart';
import 'package:app/screens/cubit_screens/loading_screen.dart';
import 'package:app/screens/events_list/calendar_view.dart';
import 'package:app/screens/events_list/cubit/event_list_cubit.dart';
import 'package:app/services/stats/plausible_analitics.dart';
import 'package:app/style/theme_colors.dart';
import 'package:app/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:app/extensions/capitalize.dart';
import 'package:app/extensions/date_only_compare.dart';

class EventListScreen extends StatelessWidget {
  const EventListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => EventListCubit(EventsRepo()),
      child: BlocBuilder<EventListCubit, EventListState>(
        builder: (context, state) {
          if (state is EventListInitial) {
            context.read<EventListCubit>().loadData();
            PlausibleAnalitics.logEvent("events");
            return LoadingScreen();
          } else if (state is EventListLoadingState) {
            return LoadingScreen();
          } else if (state is EventListErrorState) {
            return ErrorScreen(
              refresh: () => context.read<EventListCubit>().loadData(),
            );
          } else if (state is EventListLoadedState) {
            return _buildWithData(context, state, h, w);
          } else {
            return Scaffold(
              body: Center(child: Text("Napaka, še sam ne vem kaka")),
            );
          }
        },
      ),
    );
  }

  Scaffold _buildWithData(
      BuildContext context, EventListLoadedState state, double h, double w) {
    return Scaffold(
        backgroundColor: ThemeColors.primaryBlue,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          FlutterRemix.arrow_left_s_line,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: w * 0.04, right: w * 0.04, bottom: h * 0.01),
                child: Text(
                  "Koledar dogodkov",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w500),
                ),
              ),
              CalendarView(),
              SizedBox(
                height: 5,
              ),
              _buildEventCards(context, state, h, w),
            ],
          ),
        ));
  }

  Widget _buildEventCards(
    BuildContext context,
    EventListLoadedState state,
    double h,
    double w,
  ) {
    List<Widget> cards = [];

    bool compare(DayEventModel element, DateTime date) {
      if (element.date == null) {
        return false;
      }
      return date.isSameDate(DateTime(
        element.date!.year,
        element.date!.month,
        element.date!.day,
      ));
    }

    if (state.events.any((element) => compare(element, state.selectedDate))) {
      cards = _generateCardsForDay(
        context,
        state.events
            .firstWhere((element) => compare(element, state.selectedDate)),
      );
    }

    if (cards.isEmpty) {
      return Expanded(
          child: Padding(
        padding: EdgeInsets.only(bottom: h * 0.08),
        child: Center(
          child: Text(
            "Za izbrani termin ni dogodkov",
            style: TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.w300),
          ),
        ),
      ));
    } else {
      return Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.04),
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              for (var card in cards) card,
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 20,
                ),
              )
            ],
          ),
        ),
      );
    }
  }

  List<Widget> _generateCardsForDay(BuildContext context, DayEventModel day) {
    List<Widget> widgets = [
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.only(bottom: 10, top: 20),
          child: Text(
            DateFormat("EEEE, dd. MMMM", "sl")
                .format(DateTime(
                  day.date!.year,
                  day.date!.month,
                  day.date!.day,
                ))
                .capitalize(),
            style: TextStyle(color: Colors.white.withOpacity(0.8)),
          ),
        ),
      ),
    ];

    widgets.addAll(
      EventCardListModel.fromRepo([day])
          .events
          .map((e) => EventCard(
                title: e.title,
                location: e.location,
                time: e.startTime,
                eventType: e.type,
                onClick: () => e.onClick(context),
              ))
          .toList(),
    );

    return widgets;
  }
}

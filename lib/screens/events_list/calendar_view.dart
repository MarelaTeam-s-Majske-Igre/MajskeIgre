import 'package:app/data/event_type/event_type.dart';
import 'package:app/data/events/events_repo.dart';
import 'package:app/screens/events_list/cubit/event_list_cubit.dart';
import 'package:app/style/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends StatelessWidget {
  const CalendarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (context) => EventListCubit(EventsRepo()),
      child: _buildWithData(context, h, w),
    );
  }

  Container _buildWithData(BuildContext context, double h, double w) {
    final state = context.read<EventListCubit>().state as EventListLoadedState;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.symmetric(vertical: h * 0.01, horizontal: w * 0.02),
      margin: EdgeInsets.symmetric(vertical: h * 0.01, horizontal: w * 0.02),
      child: TableCalendar(
        locale: 'sl',
        startingDayOfWeek: StartingDayOfWeek.monday,
        rowHeight: 40,
        calendarFormat: CalendarFormat.month,
        onDaySelected: (selectedDay, focusedDay) {
          context.read<EventListCubit>().changeSelectedDate(state, selectedDay);
        },
        calendarBuilders: _calendarBuilder(state),
        headerVisible: false,
        daysOfWeekVisible: false,
        firstDay: DateTime.utc(2022, 5, 1),
        lastDay: DateTime.utc(2022, 5, 31),
        focusedDay: state.selectedDate,
      ),
    );
  }

  CalendarBuilders _calendarBuilder(EventListLoadedState state) {
    return CalendarBuilders(
      defaultBuilder: ((context, day, focusedDay) {
        if (focusedDay == day) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    day.day.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                _dateRow(state, day)
              ],
            ),
          );
        }
        return Container(
            decoration: BoxDecoration(
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    day.day.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                _dateRow(state, day)
              ],
            ),
          );
      }),
    );
  }

  Row _dateRow(EventListLoadedState state, DateTime date) {
    date = DateTime(date.year, date.month, date.day);
    List<Widget> widgets = [];
    if (state.typeOfEventOnDate(date, EventType.SPORT)) {
      widgets.add(
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 1),
          child: CircleAvatar(
            backgroundColor: ThemeColors.greenSport,
            minRadius: 2,
          ),
        ),
      );
    }
    if (state.typeOfEventOnDate(date, EventType.CULTURE)) {
      widgets.add(
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 1),
          child: CircleAvatar(
            backgroundColor: ThemeColors.orangeCulture,
            minRadius: 2,
          ),
        ),
      );
    }
    if (state.typeOfEventOnDate(date, EventType.FUN)) {
      widgets.add(
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 1),
          child: CircleAvatar(
            backgroundColor: ThemeColors.blueFun,
            minRadius: 2,
          ),
        ),
      );
    }

    if (widgets.isEmpty) {
      widgets.add(
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 1),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            minRadius: 2,
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widgets,
    );
  }
}

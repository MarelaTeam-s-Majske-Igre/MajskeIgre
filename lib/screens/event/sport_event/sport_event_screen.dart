import 'package:app/data/event_type/event_type.dart';
import 'package:app/data/events/day_event_model.dart';
import 'package:app/data/events/events_repo.dart';
import 'package:app/data/firebase/notification_repo.dart';
import 'package:app/screens/cubit_screens/error_screen.dart';
import 'package:app/screens/cubit_screens/loading_screen.dart';
import 'package:app/screens/event/sport_event/sport_cubit/sport_detail_cubit.dart';
import 'package:app/services/firebase/push_notification_bloc/push_notification_bloc.dart';
import 'package:app/services/global/launch_link.dart';
import 'package:app/services/stats/plausible_analitics.dart';
import 'package:app/style/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class SportEventDetailScreen extends StatelessWidget {
  const SportEventDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (context) => SportDetailCubit(EventsRepo()),
      child: BlocBuilder<SportDetailCubit, SportDetailState>(
        builder: (context, state) {
          if (state is SportDetailInitial) {
            final id = arguments['id'];
            context.read<SportDetailCubit>().loadEvent(id);
            PlausibleAnalitics.logEvent("sport/$id");
            return LoadingScreen();
          } else if (state is SportDetailLoadingState) {
            return LoadingScreen();
          } else if (state is SportDetailErrorState) {
            return ErrorScreen(
              refresh: () =>
                  context.read<SportDetailCubit>().loadEvent(arguments['id']),
            );
          } else if (state is SportDetailLoadedState) {
            return _buildWithData(
              context,
              (context.read<SportDetailCubit>().state as SportDetailLoadedState)
                  .event,
              h,
              w,
            );
          } else {
            return Scaffold(
              body: Center(child: Text("Napaka, ne vem kakšna")),
            );
          }
        },
      ),
    );
  }

  Scaffold _buildWithData(
      BuildContext context, SportEvent event, double h, double w) {
    return Scaffold(
        backgroundColor: ThemeColors.sportBackground,
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CustomScrollView(
                  // physics: BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: _header(event, h, w),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: h * 0.035,
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.055),
                      sliver: SliverToBoxAdapter(
                          child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                FlutterRemix.file_list_3_fill,
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Opis",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          if (event.description != null)
                            for (var p in event.description!)
                              Row(
                                children: [
                                  Flexible(
                                    child: Html(
                                      data: p,
                                      onLinkTap: (url, _, __, ___) =>
                                          url != null ? launch(url) : null,
                                      style: {
                                        "body": Style.fromTextStyle(
                                          TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        )
                                      },
                                    ),
                                  )
                                ],
                              ),
                          SizedBox(
                            height: h * 0.1,
                          ),
                        ],
                      )),
                    ),
                    // SliverToBoxAdapter(child: SizedBox(height: h *0.2),)
                  ],
                ),
                if (event.registrationLink != null)
                  Container(
                    padding: EdgeInsets.fromLTRB(
                      w * 0.02,
                      h * 0.015,
                      w * 0.02,
                      h * 0.015,
                    ),
                    decoration: BoxDecoration(
                        color: ThemeColors.primaryBlue,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20))),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => LaunchLink.open(event.registrationLink!, event.registrationLink!, "/sport"),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: h * 0.01),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      FlutterRemix.ticket_line,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Prijava",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    )
                                  ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                    _notificationButton(context, event),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _notificationButton(
    BuildContext context,
    SportEvent event,
  ) {
    return BlocProvider(
      create: (context) => PushNotificationBloc(NotificationRepo()),
      child: BlocBuilder<PushNotificationBloc, PushNotificationState>(
        builder: (context, state) {
          if (state is PushNotificationInitial) {
            context.read<PushNotificationBloc>().add(
                  PushNotificationInitialLoadEvent(
                    EventType.SPORT,
                    event.id,
                  ),
                );
          }

          if (state is PushNotificationLoadedState) {
            return IconButton(
                onPressed: () {
                  if (state.subscribed) {
                    context.read<PushNotificationBloc>().add(
                          PushNotificationUnsubscribeEvent(
                            state.eventType,
                            state.eventId,
                          ),
                        );
                  } else {
                    context.read<PushNotificationBloc>().add(
                          PushNotificationSubscribeEvent(
                            state.eventType,
                            state.eventId,
                          ),
                        );
                  }
                },
                icon: Icon(
                  !state.subscribed
                      ? FlutterRemix.notification_4_line
                      : FlutterRemix.notification_off_line,
                  color: Colors.white,
                ));
          } else {
            return IconButton(
              icon: Icon(
                FlutterRemix.a_b,
                color: Colors.transparent,
              ),
              onPressed: () => null,
            );
          }
        },
      ),
    );
  }

  Widget _eventDataRow(
    double w, {
    required String leadingText,
    required IconData leadingIcon,
    required String endText,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: w * 0.015),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            leadingIcon,
            color: Colors.white,
            size: 18,
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text(
                endText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(SportEvent event, double h, double w) {
    return Padding(
      padding: EdgeInsets.only(bottom: h * 0.01),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: h * 0.85),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned.fill(
                child: Stack(
              children: [
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: h * 0.1),
                    child: FittedBox(
                        fit: h > w ? BoxFit.cover : BoxFit.contain,
                        child: event.imageUrls != null &&
                                event.imageUrls!.isNotEmpty
                            ? Image.network(
                                event.imageUrls![0],
                              )
                            : Image.asset(
                                "assets/img/sportko.png",
                              )),
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            ThemeColors.primaryBlue,
                            ThemeColors.primaryBlue.withOpacity(0.5),
                            Colors.transparent,
                            ThemeColors.sportBackground.withOpacity(0.5),
                            ThemeColors.sportBackground,
                          ],
                          stops: [
                            0,
                            0.1,
                            0.3,
                            0.7,
                            0.85,
                          ]),
                    ),
                  ),
                ),
              ],
            )),
            Container(
              padding: EdgeInsets.symmetric(horizontal: w * 0.04),
              width: double.infinity,
              child: Column(
                children: [
                  Text(
                    event.title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.015),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Icon(
                            FlutterRemix.calendar_fill,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('EEE, d. MMMM', 'sl')
                                  .format(event.startTime!),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w300),
                            ),
                            Text(
                              DateFormat('Hm', 'sl').format(event.startTime!),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w300),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (event.price != null)
                    _eventDataRow(w,
                        leadingIcon: FlutterRemix.money_euro_box_fill,
                        leadingText: "Prijavnina",
                        endText:
                            "${NumberFormat("###.##", "sl").format(event.price)} €"),
                  if (event.team != null)
                    _eventDataRow(w,
                        leadingIcon: FlutterRemix.team_fill,
                        leadingText: "Sestava ekip",
                        endText: event.team!),
                  _eventDataRow(w,
                      leadingIcon: FlutterRemix.map_fill,
                      leadingText: "Lokacija",
                      endText: event.location),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

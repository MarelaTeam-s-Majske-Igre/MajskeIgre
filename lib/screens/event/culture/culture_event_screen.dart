import 'package:app/data/event_type/event_type.dart';
import 'package:app/data/events/day_event_model.dart';
import 'package:app/data/events/events_repo.dart';
import 'package:app/data/firebase/notification_repo.dart';
import 'package:app/screens/cubit_screens/error_screen.dart';
import 'package:app/screens/cubit_screens/loading_screen.dart';
import 'package:app/screens/event/culture/cubit/culture_detail_cubit.dart';
import 'package:app/services/firebase/push_notification_bloc/push_notification_bloc.dart';
import 'package:app/style/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:intl/intl.dart';
import 'package:app/extensions/capitalize.dart';
import 'package:url_launcher/url_launcher.dart';

class CultureEventDetailScreen extends StatelessWidget {
  const CultureEventDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    return BlocProvider(
      create: (context) => CultureDetailCubit(EventsRepo()),
      child: BlocBuilder<CultureDetailCubit, CultureDetailState>(
        builder: (context, state) {
          if (state is CultureDetailInitial) {
            context.read<CultureDetailCubit>().loadEvent(arguments['id']);
            return LoadingScreen();
          } else if (state is CultureDetailLoadingState) {
            return LoadingScreen();
          } else if (state is CultureDetailErrorState) {
            return ErrorScreen(
              refresh: () =>
                  context.read<CultureDetailCubit>().loadEvent(arguments['id']),
            );
          } else if (state is CultureDetailLoadedState) {
            return _buildWithData(context, state.event, h, w);
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
      BuildContext context, CultureEvent event, double h, double w) {
    return Scaffold(
        backgroundColor: Color.alphaBlend(
            Colors.black.withOpacity(0.15), ThemeColors.orangeCulture),
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _header(event, h, w),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                  sliver: SliverToBoxAdapter(
                      child: Column(
                    children: [
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
                          )
                    ],
                  )),
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
                    _notificationButton(context, event)
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _notificationButton(
    BuildContext context,
    CultureEvent event,
  ) {
    return BlocProvider(
      create: (context) => PushNotificationBloc(NotificationRepo()),
      child: BlocBuilder<PushNotificationBloc, PushNotificationState>(
        builder: (context, state) {
          if (state is PushNotificationInitial) {
            context.read<PushNotificationBloc>().add(
                  PushNotificationInitialLoadEvent(
                    EventType.CULTURE,
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

  Widget _header(CultureEvent event, double h, double w) {
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
                  "assets/img/kultko.png",
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                width: double.infinity,
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (event.dayTitle != null)
                      Text(
                        event.dayTitle!.capitalize(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w200),
                      ),
                    Text(
                      event.title,
                      textAlign: TextAlign.center,
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  FlutterRemix.calendar_line,
                                  color: Colors.white.withOpacity(0.75),
                                  size: 18,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  DateFormat('EEE, d. MMMM', 'sl')
                                      .format(event.startTime!),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w300),
                                )
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  FlutterRemix.time_line,
                                  color: Colors.white.withOpacity(0.75),
                                  size: 18,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  DateFormat('Hm', 'sl')
                                      .format(event.startTime!),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w300),
                                )
                              ],
                            ),
                          ]),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

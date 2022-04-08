import 'package:app/data/event_type/event_type.dart';
import 'package:app/style/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  const EventCard(
      {Key? key,
      required this.title,
      this.location,
      this.time,
      required this.eventType,
      required this.onClick,
      this.longTimeFormat = false})
      : super(key: key);

  final EventType eventType;
  final String? location;
  final Function onClick;
  final DateTime? time;
  final String title;
  final bool longTimeFormat;

  Color _background() {
    if (eventType == EventType.SPORT) {
      return Color.alphaBlend(
        Colors.black.withOpacity(0.15),
        ThemeColors.greenSport,
      );
    } else if (eventType == EventType.CULTURE) {
      return Color.alphaBlend(
        Colors.black.withOpacity(0.15),
        ThemeColors.orangeCulture,
      );
    } else {
      return Color.alphaBlend(
        Colors.black.withOpacity(0.15),
        ThemeColors.blueFun,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return SliverToBoxAdapter(
      child: GestureDetector(
        onTap: () => onClick(),
        child: Container(
          margin: EdgeInsets.only(top: h * 0.015),
          padding:
              EdgeInsets.symmetric(vertical: h * 0.015, horizontal: w * 0.02),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: _background()),
          child: Row(
            children: [
              if (!longTimeFormat)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      eventType == EventType.FUN
                          ? "12"
                          : DateFormat("H").format(time!),
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          color: eventType == EventType.FUN
                              ? Colors.transparent
                              : Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    Column(
                      children: [
                        Text(
                          eventType == EventType.FUN
                              ? "00"
                              : DateFormat("mm").format(time!),
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: eventType == EventType.FUN
                                  ? Colors.transparent
                                  : Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              VerticalDivider(
                color: Colors.white,
                thickness: 2,
              ),
              Flexible(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (longTimeFormat && time != null)
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                eventType != EventType.FUN
                                    ? DateFormat("EEE, dd. MMM ob HH:mm", "sl")
                                        .format(time!)
                                    : DateFormat("EEE, dd. MMM", "sl")
                                        .format(time!),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ],
                        ),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (location != null)
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                location!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

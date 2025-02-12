import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import '../resources/style_config.dart';

void showBottomSheetNotif(
    {required BuildContext context,
    bool isDismissible = false,
    bool enableDrag = false,
    required List<Map<String, dynamic>> notificationItem}) {
  showModalBottomSheet(
    context: context,
    isDismissible: isDismissible,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              height: MediaQuery.of(context).size.height,
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.77,
            minChildSize: 0.2,
            maxChildSize: 1,
            builder: (context, scrollController) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: FontList.font30),
                decoration: BoxDecoration(
                  color: ColorList.whiteColor300,
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(FontList.font30)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: FontList.font36,
                      height: 2,
                      decoration: BoxDecoration(
                        color: ColorList.grayColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Gap(37),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: FontList.font30),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IntrinsicWidth(
                              child: Text(
                                "Your notification",
                                style: GoogleFonts.overpass(
                                  fontSize: FontList.font20,
                                  fontWeight: FontWeight.w900,
                                  color: ColorList.blueColor,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(-2, 3),
                                      blurRadius: 2,
                                      color:
                                          Colors.black.withValues(alpha: 0.1),
                                    ),
                                    Shadow(
                                      offset: Offset(-1, 1),
                                      blurRadius: 1,
                                      color:
                                          Colors.white.withValues(alpha: 0.25),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: FontList.font18),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: notificationItem.length,
                      itemBuilder: (context, index) {
                        final notification = notificationItem[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (index == 0)
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 8,
                                    bottom: 8,
                                    right: FontList.font30,
                                    left: FontList.font30),
                                child: Text("New",
                                    style: GoogleFonts.overpass(
                                        color: ColorList.blueColor,
                                        fontSize: FontList.font12,
                                        fontWeight: FontWeight.w400)),
                              ),
                            if (index == 1)
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 8,
                                    bottom: 8,
                                    right: FontList.font30,
                                    left: FontList.font30),
                                child: Text("Earlier",
                                    style: GoogleFonts.overpass(
                                        color: ColorList.grayColor,
                                        fontSize: FontList.font12,
                                        fontWeight: FontWeight.w400)),
                              ),
                            Container(
                              padding: EdgeInsets.only(
                                  top: FontList.font16,
                                  bottom: FontList.font16),
                              decoration: BoxDecoration(
                                color: notification["isNew"]
                                    ? ColorList.selectedColor
                                        .withValues(alpha: 0.28)
                                    : Colors.transparent,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: FontList.font30),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      notification["icon"].toString(),
                                      colorFilter: ColorFilter.mode(
                                          notification['isNew'] == true
                                              ? ColorList.blueColor
                                              : ColorList.grayColor,
                                          BlendMode.srcIn),
                                    ),
                                    SizedBox(width: 30),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(notification["time"],
                                              style: GoogleFonts.overpass(
                                                color: notification['isNew'] ==
                                                        true
                                                    ? ColorList.blueColor
                                                    : ColorList.grayColor,
                                              )),
                                          SizedBox(height: 4),
                                          Text(
                                            notification["message"],
                                            style: GoogleFonts.overpass(
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  notification['isNew'] == true
                                                      ? ColorList.blueColor
                                                      : ColorList.grayColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Gap(22),
                                    SvgPicture.asset(
                                      'assets/icons/down.svg',
                                      colorFilter: ColorFilter.mode(
                                          notification['isNew'] == true
                                              ? ColorList.blueColor
                                              : ColorList.grayColor,
                                          BlendMode.srcIn),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      );
    },
  );
}

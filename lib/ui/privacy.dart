import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../theme/color.dart';
import '../theme/font.dart';

const String _text1 = "Hapk built the WordTape app as a Free app. This service"
    " is provided by Hapk at no cost and is intended for use as is.";

const String _text2 = "This page is used to inform visitors regarding"
    " our policies with the collection, use, and disclosure of Personal Information "
    "if anyone decided to use our Service.";

const String _text3 = "If you choose to use our Service, then you agree "
    "to the collection and use of information in relation to this policy. "
    "The Personal Information that we collect is used for providing and "
    "improving the Service. We will not use or share your information with anyone except "
    "as described in this Privacy Policy.";

const String _text4 = "The terms used in this Privacy Policy "
    "have the same meanings as in our Terms and Conditions, which are accessible "
    "at WordTape unless otherwise defined in this Privacy Policy.";

const String _text5 = "For a better experience, while using our Service, we may"
    " require you to provide us with certain personally identifiable information. "
    "The information that we request will be retained by us "
    "and used as described in this privacy policy.";

const String _text6 = "The app does use third-party services "
    "that may collect information used to identify you.";

const String _text7 = "Link to the privacy policy of third-party service "
    "providers used by the app";

const String _text8 = "We want to inform you that whenever you use our Service,"
    " in a case of an error in the app we collect data and information "
    "(through third-party products) on your phone called Log Data. "
    "This Log Data may include information such as your device Internet Protocol"
    " (“IP”) address, device name, operating system version, "
    "the configuration of the app when utilizing our Service, "
    "the time and date of your use of the Service, and other statistics.";

const String _text9 = "Cookies are files with a small amount of data that are "
    "commonly used as anonymous unique identifiers. "
    "These are sent to your browser from the websites that you visit and "
    "are stored on your device's internal memory.";

const String _text10 = "This Service does not use these “cookies” explicitly."
    " However, the app may use third-party code and libraries that use “cookies”"
    " to collect information and improve their services. "
    "You have the option to either accept or refuse these cookies and "
    "know when a cookie is being sent to your device. "
    "If you choose to refuse our cookies, you may not be able to use some"
    " portions of this Service.";

const String _text11 = "We may employ third-party companies and individuals "
    "due to the following reasons:";

const String _text12 = "•  To facilitate our Service;\n"
    "•  To provide the Service on our behalf;\n"
    "•  To perform Service-related services; or\n"
    "•  To assist us in analyzing how our Service is used.";

const String _text13 = "We want to inform users of this Service that these"
    " third parties have access to their Personal Information. "
    "The reason is to perform the tasks assigned to them on our behalf. "
    "However, they are obligated not to disclose or use the information "
    "for any other purpose.";

const String _text14 = "We value your trust in providing us your Personal "
    "Information, thus we are striving to use commercially acceptable means of"
    " protecting it. But remember that no method of transmission "
    "over the internet, or method of electronic storage is 100% secure and "
    "reliable, and we cannot guarantee its absolute security.";

const String _text15 = "This Service may contain links to other sites. If you"
    " click on a third-party link, you will be directed to that site. Note that"
    " these external sites are not operated by us. Therefore, we strongly "
    "advise you to review the Privacy Policy of these websites. We have no "
    "control over and assume no responsibility for the content, privacy "
    "policies, or practices of any third-party sites or services.";

const String _text16 = "These Services do not address anyone under the "
    "age of 13. We do not knowingly collect personally identifiable information"
    " from children under 13 years of age. In the case we discover that a child"
    " under 13 has provided us with personal information, we immediately delete"
    " this from our servers. If you are a parent or guardian and you are aware"
    " that your child has provided us with personal information, please contact"
    " us so that we will be able to do the necessary actions.";

const String _text17 = "We may update our Privacy Policy from time to time."
    " Thus, you are advised to review this page periodically for any changes."
    " We will notify you of any changes by posting the new Privacy Policy on"
    " this page.";

const String _text18 = "This policy is effective as of 10th June, 2025";

const String _text19 = "If you have any questions or suggestions about our "
    "Privacy Policy, do not hesitate to contact us at ";

const String _text20 = "hapk.inc@gmail.com.";

TextSpan get _singleLine => const TextSpan(text: "\n");
TextSpan get _doubleLine => const TextSpan(text: "\n\n");

class PrivacyPage1 extends StatelessWidget {
  const PrivacyPage1({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final TextStyle? titleStyle = textTheme.titleMedium?.copyWith(
      color: midnightGreen,
      height: 2.1,
    );
    final TextStyle? subtitle = textTheme.titleSmall?.copyWith(
      color: midnightGreen,
      height: 2.1,
    );
    return ColoredBox(
      color: ghostWhite,
      child: Column(
        children: [
          AppBar(toolbarHeight: 75.h),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: "Privacy Policy", style: titleStyle),
                      _doubleLine,
                      const TextSpan(text: _text1), _doubleLine,
                      const TextSpan(text: _text2), _doubleLine,
                      const TextSpan(text: _text3), _doubleLine,
                      const TextSpan(text: _text4), _doubleLine,
                      TextSpan(
                        text: "Information Collection and Use",
                        style: subtitle,
                      ),
                      _doubleLine,
                      const TextSpan(text: _text5), _doubleLine,
                      const TextSpan(text: _text6), _doubleLine,
                      const TextSpan(text: _text7), _doubleLine,
                      TextSpan(
                        text: "•  ",
                        children: [
                          TextSpan(
                            text: "Google Play Services",
                            /*recognizer: TapGestureRecognizer()
                              ..onTap = () => launch(
                                'https://policies.google.com/privacy',
                              ),
                            style: const TextStyle(color: filledColor),*/
                          ),
                        ],
                      ),
                      _singleLine,
                      TextSpan(
                        text: "•  ",
                        children: [
                          /* TextSpan(
                            text: "Google Analytics for Firebase",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => launch(
                                'https://firebase.google.com/policies/analytics',
                              ),
                            style: const TextStyle(color: filledColor),
                          )*/
                        ],
                      ),
                      _singleLine,
                      TextSpan(
                        text: "•  ",
                        children: [
                          TextSpan(
                            text: "Firebase Crashlytics",
                            /*style: const TextStyle(color: filledColor),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => launch(
                                'https://firebase.google.com/support/privacy/',
                              ),*/
                          )
                        ],
                      ),
                      _doubleLine,
                      TextSpan(text: "Log Data", style: subtitle),
                      _doubleLine,
                      const TextSpan(text: _text8),
                      _doubleLine,
                      TextSpan(text: "Cookies", style: subtitle),
                      _doubleLine,
                      const TextSpan(text: _text9), _doubleLine,
                      const TextSpan(text: _text10), _doubleLine,
                      TextSpan(text: "Service Providers", style: subtitle),
                      _doubleLine,
                      const TextSpan(text: _text11), _doubleLine,
                      const TextSpan(text: _text12), _doubleLine,
                      const TextSpan(text: _text13), _doubleLine,

                      TextSpan(text: "Security", style: subtitle),
                      _doubleLine,
                      const TextSpan(text: _text14), _doubleLine,
                      TextSpan(text: "Links to Other Sites", style: subtitle),
                      _doubleLine,
                      const TextSpan(text: _text15), _doubleLine,
                      TextSpan(text: "Children’s Privacy", style: subtitle),
                      _doubleLine,
                      const TextSpan(text: _text16), _doubleLine,
                      TextSpan(
                        text: "Changes to This Privacy Policy",
                        style: subtitle,
                      ),
                      _doubleLine,
                      const TextSpan(text: _text17), _doubleLine,
                      const TextSpan(text: _text18), _doubleLine,
                      TextSpan(text: "Contact us", style: subtitle),
                      _singleLine,
                      const TextSpan(text: _text19),
                      const TextSpan(
                        text: _text20,
                        //style: TextStyle(color: teal),
                      ),
                      _doubleLine,
                      //
                      _doubleLine,
                    ],
                    style: textTheme.bodyMedium?.copyWith(
                      height: 1.8,
                      color: slateGray,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

final DefaultTextTheme textTheme = DefaultTextTheme();

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          leading: BackButton(
            //onPressed: () => context.pushReplacement("/daily-challenge"),
            onPressed: () => context.canPop()
                ? context.pop()
                : context.replace("/daily-challenge"),
          ),
          leadingWidth: 60.r,
          title: Text("Privacy Policy"),
          titleTextStyle: textTheme.bodyMedium?.copyWith(color: seaWhite),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(15.r),
              child: FadeIn(
                delay: const Duration(milliseconds: 450),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: "$_text1$_nnt$_text2$_nnt$_text3$_nnt$_text4"),
                      _Header("Information Collection and Use"),
                      TextSpan(text: "$_nt$_text5$_nnt$_text6$_nnt$_text7"),
                      _Header("Log Data"),
                      TextSpan(text: _text8),
                      _Header("Cookies"),
                      TextSpan(text: "$_text9$_nnt$_text10"),
                      _Header("Service Providers"),
                      TextSpan(text: _text11),
                      TextSpan(text: _nnt),
                      TextSpan(text: "$_text12$_nnt$_text13"),
                      _Header("Security"),
                      TextSpan(text: _text14),
                      _Header("Link to Other Sites"),
                      TextSpan(text: _text15),
                      _Header("Children's Privacy"),
                      TextSpan(text: _text16),
                      _Header("Changes to This Privacy Policy"),
                      TextSpan(text: "$_text17$_nnt$_text18"),
                      _Header("Contact us"),
                      TextSpan(text: _text19),
                    ],
                    style: textTheme.bodySmall?.copyWith(color: slateGray),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

const String _nnt = "\n\n";
const String _nt = "\n";

class _Header extends TextSpan {
  final String str;

  const _Header(this.str);

  @override
  List<InlineSpan>? get children => [
        WidgetSpan(
          child: Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.symmetric(vertical: 24.r),
            // height: 60.r,
            child: AutoSizeText(
              str,
              style: textTheme.displaySmall,
              maxLines: 2,
              presetFontSizes: [27.r, 24.r],
            ),
          ),
        )
      ];
}

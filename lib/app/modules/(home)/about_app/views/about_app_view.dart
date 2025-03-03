import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../controllers/about_app_controller.dart';

class AboutAppView extends GetView<AboutAppController> {
  const AboutAppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('About Application',
            style: GoogleFonts.inter(
                color: Color(0xff181D18),
                fontSize: 18,
                fontWeight: FontWeight.w600)),
        leading: IconButton(
          onPressed: () => Get.offAllNamed(Routes.PROFILE),
          icon: Image.asset('assets/icons/back.png'),
        ),
        backgroundColor: Color(0xffF7FBF2),
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : WebViewWidget(
                controller: WebViewController()
                  ..loadHtmlString(controller.aboutContent.value)
                  ..setJavaScriptMode(JavaScriptMode.unrestricted)
                  ..setBackgroundColor(Colors.white)
                  ..setNavigationDelegate(
                    NavigationDelegate(
                      onNavigationRequest: (request) =>
                          NavigationDecision.navigate,
                    ),
                  )
                  ..enableZoom(true),
              ),
      ),
    );
  }
}

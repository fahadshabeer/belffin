import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../utils/constants.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late WebViewController controller;
  var isLoading = ValueNotifier(false);
  var isError = ValueNotifier(false);

  @override
  void initState() {
    controller = WebViewController()
      ..setOnScrollPositionChange((position) {
        log("${position.y}");
      })
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {
            isLoading.value = true;
          },
          onPageFinished: (String url) {
            isLoading.value = false;
          },
          onHttpError: (HttpResponseError error) {
            log("Error", error: error);
          },
          onWebResourceError: (WebResourceError error) {
            log("${error.errorType}");

            String msg = "";
            if (error.errorType == WebResourceErrorType.connect) {
              msg =
              "unable to establish connection. please check your internet and try again";
            } else if (error.errorType == WebResourceErrorType.hostLookup) {
              msg =
              "unable to lookup host. please check your internet and try again";
            }
            // else if(error.errorType==WebResourceErrorType.){
            //
            // }
            if (msg.isNotEmpty && !isError.value) {
              isError.value = true;
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) =>
                    PopScope(
                      canPop: false,
                      child: AlertDialog(
                        title: const Center(
                          child: Icon(
                            Icons.error,
                            color: Colors.red,
                            size: 80,
                          ),
                        ),
                        content: SizedBox(
                          height: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Center(
                                  child: Text(
                                    "Error",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  )),
                              const SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: Text(
                                  msg,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                controller.reload();
                                isError.value=false;
                                Navigator.pop(context);
                              },
                              child: const Text("Reload"))
                        ],
                      ),
                    ),
              );
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(websiteUrl));
    super.initState();
  }

  Future<void> _reloadPage() async {

    controller.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(
              controller: controller,
              gestureRecognizers: {}, // Keep this for handling gestures
            ),
            ValueListenableBuilder(
              valueListenable: isError,
              builder: (context, err, child) {
                return Visibility(
                  visible: err,
                  child: Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    color: Colors.white,
                    child: Center(
                      child: Text(
                        "Error loading page. Please try again.",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                );
              },
            ),
            Positioned(
              child: ValueListenableBuilder(
                builder: (context, val, _) {
                  return Visibility(
                    visible: val,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
                valueListenable: isLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
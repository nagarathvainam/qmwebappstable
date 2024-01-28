import 'package:flutter/material.dart';

/// Flutter code sample for [Overlay].

//void main() => runApp(const OverlayApp());

class OverlayApp extends StatelessWidget {
  const OverlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: OverlayExample(),
    );
  }
}

class OverlayExample extends StatefulWidget {
  const OverlayExample({super.key});

  @override
  State<OverlayExample> createState() => _OverlayExampleState();
}

class _OverlayExampleState extends State<OverlayExample> {
  OverlayEntry? overlayEntry;
  int currentPageIndex = 0;
 String clicked="";
  void createHighlightOverlay({
    required AlignmentDirectional alignment,
    required Color borderColor,
  }) {
    // Remove the existing OverlayEntry.
    removeHighlightOverlay();

    assert(overlayEntry == null);

    overlayEntry = OverlayEntry(
      // Create a new OverlayEntry.
      builder: (BuildContext context) {
        // Align is used to position the highlight overlay
        // relative to the NavigationBar destination.
        return SafeArea(
          child: Align(
            alignment: alignment,
            heightFactor: 1.0,
            child: DefaultTextStyle(
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[

                  Builder(builder: (BuildContext context) {
                        return  Column(
                          children: <Widget>[
                            Text(
                              '',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),

                          ],
                        );

                  }),
                  SizedBox(
                    width: MediaQuery.of(context).size.width ,
                    height: 50.0,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: borderColor,
                            width: 4.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    // Add the OverlayEntry to the Overlay.
    Overlay.of(context, debugRequiredFor: widget).insert(overlayEntry!);
  }

  // Remove the OverlayEntry.
  void removeHighlightOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  @override
  void dispose() {
    // Make sure to remove OverlayEntry when the widget is disposed.
    removeHighlightOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Overlay Sample'),
      ),
      bottomNavigationBar:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.black.withOpacity(0.05),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(12), // <-- Radius
                        ) // foreground
                    ),
                    onPressed: () async {
                      setState(() {
                        clicked="You Have Clicked";
                      });
                      createHighlightOverlay(
                        alignment: AlignmentDirectional.bottomStart,
                        borderColor: Colors.white,
                      );
                    },
                    child:  Text(
                     'Submit Answer',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ))
            ],
          )
       // Auto Click Enable / Disabled
          ,
      body: Text(clicked),
    );
  }
}

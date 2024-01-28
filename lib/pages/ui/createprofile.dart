import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:quizmaster/pages/ui/login.dart';
import 'package:quizmaster/utils.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:quizmaster/constant/constants.dart';
import 'package:quizmaster/pages/ui/noconnection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:quizmaster/model/databasehelper.dart';
import 'package:quizmaster/pages/user/model/user.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:io' show Platform, exit;
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:quizmaster/pages/transaction/model/paymentgateway.dart';
import 'package:quizmaster/constant/duration.dart';
class CreateProfileUiPage extends StatefulWidget {
  CreateProfileUiPage({Key? key}) : super(key: key);
  @override
  _CreateProfileUiPageState createState() => _CreateProfileUiPageState();
}
class BarChartModel {
  String days;
  int financial;
  final charts.Color color;

  BarChartModel({
    required this.days,
    required this.financial,
    required this.color,
  });
}
class _CreateProfileUiPageState extends State<CreateProfileUiPage> {
  late StreamSubscription<ConnectivityResult> subscription;
  PaymentGatewayModel PaymentGateway = new PaymentGatewayModel();
  String imageBase64='';
  //DatabaseHelper databaseHelper = new DatabaseHelper();
  User databaseUser = new User();
  String otpdisplay="";
  Color _colorFromHex(String hexColor) {
    final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
    return Color(int.parse('FF$hexCode', radix: 16));
  }
  final _formKey = GlobalKey<FormBuilderState>();
  //void _onChanged(dynamic val) => debugPrint(val.toString());
  int selectedIndex = -1;
  var surOptions=['Mr','Ms','Mrs'];
  var stateOptions = ['Andaman and Nicobar Islands','Andhra Pradesh', 'Arunachal Pradesh','Assam', 'Bihar','Chandigarh', 'Chhattisgarh', 'Dadra and Nagar Haveli', 'Daman and Diu','Delhi', 'Goa','Gujarat'
    ,'Haryana','Himachal Pradesh','Jammu and Kashmir','Jharkhand', 'Karnataka','Kerala','Lakshadweep','Madhya Pradesh','Maharashtra', 'Manipur', 'Meghalaya','Mizoram', 'Nagaland', 'Odisha'
    , 'Puducherry', 'Punjab','Rajasthan','Sikkim', 'Tamil Nadu','Telangana','Tripura', 'Uttar Pradesh', 'Uttarakhand','West Bengal'];
  bool _genderHasError = false;
  bool maleselected=true;
  bool femaleselected=false;
  bool otherselected=false;
  bool aadhar_is_verified=false;
  bool pan_is_verified=false;
  // Camera Functionl Variable Declaration Start Here
  bool isVideo = false;
  bool ispopover= false;
  String ismobile_gallery="Camera";
  List<XFile>? _imageFileList;
  void _setImageFileListFromFile(XFile? value) {
    _imageFileList = value == null ? null : <XFile>[value];
  }
  dynamic _pickImageError;
  VideoPlayerController? _controller;
  VideoPlayerController? _toBeDisposed;
  String? _retrieveDataError;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();
  final TextEditingController TextEditingname = TextEditingController();
  final TextEditingController TextEditingmailID = TextEditingController();
  final TextEditingController TextEditingdob = TextEditingController();
  @override
  void initState() {
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(result==ConnectivityResult.none){
        navigateofflinescreen();
      }
      if(result==ConnectivityResult.mobile){
      }
      // Got a new connectivity status!
    });

    getStateData();
  }
  List statedata=[];
  getStateData() async {
    databaseUser
        .getStateData()
        .whenComplete(() async{
      setState(() {
        statedata=databaseUser.statedata as List;
      });
    });
  }

  GetotpBottomSheet(ref_id) {
    final GlobalKey<State> _LoaderDialog = new GlobalKey<State>();
    showModalBottomSheet<void>(

      context: context,
      builder: (BuildContext context) {
        double baseWidth = 414;
        double fem = MediaQuery.of(context).size.width / baseWidth;
        double ffem = fem * 0.97;
        return Container(

            height: fem*300,
            color: Color(0xff666666),
            child: Center(
              child:Container(
                // frame7531yY7 (1029:875)

                width: double.infinity,
                decoration: BoxDecoration (
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.only (
                    topLeft: Radius.circular(12*fem),
                    topRight: Radius.circular(12*fem),
                  ),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children:  <Widget>[

                        Padding(padding: EdgeInsets.only(left: 10),child: Text('Enter the 6-digit OTP for Verify Aadhar',style: TextStyle(color: Colors.black,fontWeight:FontWeight.w800, fontSize: 20),),),
                       // (Durations.otpdisplay==0)?Text(otpdisplay,style: TextStyle(color: Colors.red,fontSize: 18.0),):SizedBox(),


                        Expanded(
                          child:  Align(alignment:Alignment.topRight,

                            child: IconButton(
                              icon:  Icon(Icons.close, color: Colors.black, size: 30,),

                              onPressed: () {
Navigator.pop(context);

                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    //SizedBox(height: 10),

                    ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(15.0),


                        children: <Widget>[




                          FormBuilder(
                            // key: _formKey,
                            // enabled: false,
                            onChanged: () {
                              // _formKey.currentState!.save();
                              //debugPrint(_formKey.currentState!.value.toString());
                            },
                            autovalidateMode: AutovalidateMode.disabled,
                            initialValue: const {

                            },
                            skipDisabled: true,
                            child: Column(
                              children: <Widget>[
                                // SizedBox(height: 20,),



                                SizedBox(height: 20,),
                                Align( alignment:Alignment.topLeft,  child: Text("Enter the 6 Digit OTP below Textbox",style: TextStyle(color: Colors.black,fontWeight:FontWeight.w400, fontSize: 12),)),

                                SizedBox(height: 10,),
                                OtpTextField(
                                  numberOfFields:6 ,
                                  borderColor: Color(0xFF512DA8),
                                  //set to true to show as box or false to show as dash
                                  showFieldAsBox: true,
                                  //runs when a code is typed in
                                  onCodeChanged: (String code) {
                                    //handle validation or checks here
                                  },
                                  //runs when every textfield is filled
                                  onSubmit: (String verificationCode){
                                   PaymentGateway.pggetsignature()
                                       .whenComplete(() async {
                                            setState(() {
                                                PaymentGateway
                                                    .getAadhaarInfo(
                                                PaymentGateway.signature,ref_id,verificationCode)
                                                    .whenComplete(() async {
                                                      Navigator.pop(context);
                                                      if(PaymentGateway.status=="INVALID"){
                                                        showSnackBar(PaymentGateway.message);
                                                      }else{
                                                        aadhar_is_verified=true;
                                                        if(PaymentGateway.aadhar_gender=="M"){
                                                          maleselected=true;
                                                          Constants.surName="Mr";
                                                        }
                                                        if(PaymentGateway.aadhar_gender=="F"){
                                                          femaleselected=true;
                                                          Constants.surName="Miss";
                                                        }
                                                        TextEditingname.text=PaymentGateway.aadhar_name;
                                                        TextEditingmailID.text=PaymentGateway.aadhar_email;
                                                        //TextEditingdob.text=PaymentGateway.aadhar_dob;
                                                        Constants.dob=PaymentGateway.aadhar_dob;
                                                        showSnackBar(PaymentGateway.message);
                                                      }

                                                });
                                            });
                                   });



                                  }, // end onSubmit
                                ),
                                SizedBox(height: 25,),
                                 SizedBox(height: 25,),
                                new SizedBox(
                                  width: MediaQuery.of(context).size.width-20,
                                  height: 50.0,
                                ),
                              ],
                            ),
                          ),
                        ]
                    ),
                  ],
                ),
              ),
            ));
      },
    );

    SizedBox(height: 30);

  }
  showSnackBar(message) {
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  navigateofflinescreen(){
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
                NoConnectionUiPage()),
            (e) => false);
  }
  // Camera Functional Code Start Here
  @override
  void dispose() {
    _disposeVideoController();
    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();
    super.dispose();
  }
  Future<void> _disposeVideoController() async {
    if (_toBeDisposed != null) {
      await _toBeDisposed!.dispose();
    }
    _toBeDisposed = _controller;
    _controller = null;
  }
  Future<void> _playVideo(XFile? file) async {
    if (file != null && mounted) {
      await _disposeVideoController();
      late VideoPlayerController controller;
      if (kIsWeb) {
        controller = VideoPlayerController.network(file.path);
      } else {
        controller = VideoPlayerController.file(File(file.path));
      }
      _controller = controller;
      const double volume = kIsWeb ? 0.0 : 1.0;
      await controller.setVolume(volume);
      await controller.initialize();
      await controller.setLooping(true);
      await controller.play();
      setState(() {});
    }
  }


  Future<void> _displayPickImageDialog(
      BuildContext context, OnPickImageCallback onPick) async {



    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm to Continue Process'),
            content:SizedBox(
                height: 100, // set this
                child: Column(

                  children: <Widget>[
                    TextField(
                      controller: maxWidthController,
                      keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                      decoration:  InputDecoration(
                          hintText: 'Are you sure want to open $ismobile_gallery?'),
                    ),

                  ],
                )),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  child: const Text('PICK'),
                  onPressed: () {
                    final double? width = maxWidthController.text.isNotEmpty
                        ? double.parse(maxWidthController.text)
                        : null;
                    final double? height = maxHeightController.text.isNotEmpty
                        ? double.parse(maxHeightController.text)
                        : null;
                    final int? quality = qualityController.text.isNotEmpty
                        ? int.parse(qualityController.text)
                        : null;
                    onPick(width, height, quality);
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }
  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }
  Widget _previewVideo() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_controller == null) {
      return const Text(
        'You have not yet picked a video',
        textAlign: TextAlign.center,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: AspectRatioVideo(_controller),
    );
  }

  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFileList != null) {
      return Semantics(
        label: 'image_picker_example_picked_images',
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          key: UniqueKey(),
          itemBuilder: (BuildContext context, int index) {
            // Why network for web?
            // See https://pub.dev/packages/image_picker#getting-ready-for-the-web-platform
            return Semantics(
              label: 'image_picker_example_picked_image',
              child: kIsWeb
                  ?Image.network(_imageFileList![index].path)
                  :  CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 45,
                  child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 115,
                      child: CircleAvatar(
                        backgroundImage:FileImage(File(_imageFileList![index].path)),radius: 40,))),
            );
          },
          itemCount: _imageFileList!.length,
        ),
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }
  Widget _handlePreview() {
    if (isVideo) {
      return _previewVideo();
    } else {
      return _previewImages();
    }
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      if (response.type == RetrieveType.video) {
        isVideo = true;
        await _playVideo(response.file);
      } else {
        isVideo = false;
        setState(() {
          if (response.files == null) {

            _setImageFileListFromFile(response.file);
          } else {
            _imageFileList = response.files;
          }
        });
      }
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }
  Future<void> _onImageButtonPressed(String ?action,ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {
    if (_controller != null) {
      await _controller!.setVolume(0.0);
    }
    if (isVideo) {
      final XFile? file = await _picker.pickVideo(
          source: source, maxDuration: const Duration(seconds: 10));
      await _playVideo(file);
    } else if (isMultiImage) {
      await _displayPickImageDialog(context!,
              (double? maxWidth, double? maxHeight, int? quality) async {
            try {
              maxHeight=480;
              maxWidth=640;
              quality=50;
              final List<XFile> pickedFileList = await _picker.pickMultiImage(
                maxWidth: maxWidth,
                maxHeight: maxHeight,
                imageQuality: quality,
              );
              setState(() {
                final bytes = File(pickedFileList[0]!.path).readAsBytesSync();
                databaseUser
                    .fileUpload('1','.png',base64Encode(bytes));
                String base64Image =  base64Encode(bytes);
                imageBase64=base64Image;
                _imageFileList = pickedFileList;
              });
            } catch (e) {
              setState(() {
                _pickImageError = e;
              });
            }
          });
    } else {
      await _displayPickImageDialog(context!,
              (double? maxWidth, double? maxHeight, int? quality) async {
            try {
              maxHeight=480;
              maxWidth=640;
              quality=50;
              final XFile? pickedFile = await _picker.pickImage(
                source: source,
                maxWidth: maxWidth,
                maxHeight: maxHeight,
                imageQuality: quality,
              );
              setState(() {
                final bytes = File(pickedFile!.path).readAsBytesSync();
                //String base64Image =  "data:image/png;base64,"+base64Encode(bytes);
                databaseUser
                    .fileUpload('1','.png',base64Encode(bytes));
                String base64Image =  base64Encode(bytes);
                imageBase64=base64Image;
                _setImageFileListFromFile(pickedFile);
              });
            } catch (e) {
              setState(() {
                _pickImageError = e;
              });
            }
          });
    }
  }
  // Camera Functional Code End Here
  @override
  Widget build(BuildContext context) {


    double baseWidth = 414;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.85;//0.97;

    showSnackBar(message) {
      final snackBar = SnackBar(
        closeIconColor: Colors.white,
        backgroundColor: _colorFromHex(Constants.baseThemeColor),
        content: Text(message),
        action: SnackBarAction(
          label: 'Close',
          textColor: Colors.white,
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );

      // Find the ScaffoldMessenger in the widget tree
      // and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    return WillPopScope(
        onWillPop: () async {

      return false; // return false if you want to disable device back button click
    },
    child: Scaffold(
        backgroundColor: _colorFromHex(Constants.baseThemeColor),
        body: SingleChildScrollView(
          child:Container(
            width: double.infinity,
            child: Container(
              // quizfinalleaderboard5ATV (888:1691)
              width: double.infinity,
              height: 896*fem,
              decoration: BoxDecoration (
                color: _colorFromHex(Constants.baseThemeColor),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 31.0668945312*fem,
                    top: 21*fem,
                    child: Align(
                      child: SizedBox(
                        width: 370.74*fem,
                        height: 13*fem,
                        child: SizedBox(),
                      ),
                    ),
                  ),

                  Positioned(
                    // frame11DyV (888:1716)
                    left: 0*fem,
                    top: 150*fem,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(19*fem, 24*fem, 18*fem, 26*fem),
                      width: 414*fem,
                      height: 756*fem,
                      decoration: BoxDecoration (
                        color: Color(0xffedecfb),
                        borderRadius: BorderRadius.only (
                          topLeft: Radius.circular(24*fem),
                          topRight: Radius.circular(24*fem),
                        ),
                      ),
                      child: SingleChildScrollView(child:Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 75,),
                          Text("OR Select Avatar"),
                          Padding(
                              padding: EdgeInsets.only(left: 10.0,right: 10.0),
                              child:

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 75,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: 5,
                                      itemBuilder: (BuildContext context, int position) {
                                        return InkWell(
                                          onTap: () => setState(() => selectedIndex=position
                                          ),

                                          child: Container(
                                            width: 50,

                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                (position==0)?CircleAvatar(
                                                    radius: 25,
                                                    backgroundColor:_colorFromHex(Constants.baseThemeColor),
                                                    child: Padding(
                                                        padding:  EdgeInsets.all((position==selectedIndex || selectedIndex==-1)?3:0), // Border radius
                                                        child: ClipOval(child:Image.network(Constants.photo)))):CircleAvatar(
                                                    radius: 25,
                                                    backgroundColor: _colorFromHex(Constants.baseThemeColor),
                                                    child: Padding(
                                                        padding:  EdgeInsets.all((position==selectedIndex)?3:0), // Border radius
                                                        child: ClipOval(child:Image.asset("assets/avatarlarge$position.png")))),



                                                //Text(iconList[position].titleIcon)
                                              ],
                                            ),

                                          ),
                                        );
                                      },
                                    ),
                                  )
                                ],
                              )


                          ),
                          Padding(
                              padding: EdgeInsets.all(16.0),
                              child: FormBuilder(
                                key: _formKey,
                                // enabled: false,
                                onChanged: () {
                                  _formKey.currentState!.save();
                                  debugPrint(
                                      _formKey.currentState!.value.toString());
                                },
                                autovalidateMode: AutovalidateMode.always,
                                initialValue: const {
                                  'movie_rating': 5,
                                  'best_language': 'Dart',
                                  'age': '13',
                                  'gender': 'Male',
                                  'languages_filter': ['Dart']
                                },
                                skipDisabled: true,
                                child: Column(
                                  children: <Widget>[






                                    /// Your Aadhaar No Auto Verification
                                    (Constants.kycAutoApprove==1)?Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          "Your Aadhaar ID",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.normal),
                                        )):SizedBox(),
                                    (Constants.kycAutoApprove==1)?const SizedBox(height: 5):SizedBox(),


                                    (Constants.kycAutoApprove==1)?Container(
                                        decoration: BoxDecoration (
                                          border: Border.all(color: Color(0xffDADADA)),
                                          color: Color(0xffedecfb),
                                          borderRadius: BorderRadius.only (
                                            topLeft: Radius.circular(12*fem),
                                            topRight: Radius.circular(12*fem),
                                            bottomRight: Radius.circular(12*fem),
                                            bottomLeft: Radius.circular(12*fem),
                                          ),
                                        ),
                                        child:Row(
                                          children:  <Widget>[
                                            Expanded(child: SizedBox(
                                                width: 50.0,
                                                child:FormBuilderTextField(
                                                  name: 'aadhar',
                                                  //initialValue: null,
                                                  decoration: InputDecoration(

                                                    border: InputBorder.none,
                                                    // suffixIcon: Icon(Icons.close_rounded,color: Colors.red,),

                                                    labelText: '',
                                                    hintText: "Enter Your Aadhaar ID",
                                                  ),
                                                  onChanged: (val) {
                                                    setState(() {
                                                    });
                                                  },
                                                  inputFormatters: [
                                                    LengthLimitingTextInputFormatter(12),
                                                    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                                                  ],
                                                  validator: FormBuilderValidators.compose([
                                                    FormBuilderValidators.required(),
                                                    FormBuilderValidators.numeric(),
                                                    // FormBuilderValidators.max(12),

                                                  ]),

                                                  keyboardType: Platform.isIOS?
                                                  TextInputType.numberWithOptions(signed: true, decimal: true)
                                                      : TextInputType.number,
                                                 // keyboardType: TextInputType.text,
                                                  textInputAction: TextInputAction.next,
                                                ))),

                                            SizedBox(
                                              width: 70.0,
                                              child:  ElevatedButton(

                                                style: ElevatedButton.styleFrom(
                                                  shadowColor: (aadhar_is_verified==false)?Color(0xffD9D9D9):Color(0xff85AD00),
                                                  backgroundColor:  (aadhar_is_verified==false)?Color(0xffD9D9D9):Color(0xff85AD00),
                                                  elevation: 3,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(32.0)),
                                                  minimumSize: Size(100, 40), //////// HERE
                                                ),
                                                onPressed: () {
                                                  if(_formKey.currentState
                                                      ?.value['aadhar']==null){
                                                    showSnackBar("Aadhar number should be required");
                                                  }else {
                                                    int aadhar = int.parse(_formKey.currentState
                                                        ?.value['aadhar']);
                                                    if (aadhar > 12) {
                                                      PaymentGateway.pggetsignature()
                                                          .whenComplete(() async {
                                                        setState(() {
                                                          PaymentGateway
                                                              .generateOtpAadhaar(
                                                              PaymentGateway.signature,
                                                              _formKey.currentState
                                                                  ?.value['aadhar'])
                                                              .whenComplete(() async {
                                                            if (PaymentGateway.status ==
                                                                "SUCCESS") {
                                                              GetotpBottomSheet(PaymentGateway.ref_id);
                                                            }else{
                                                              showSnackBar(PaymentGateway.message);
                                                            }
                                                          });
                                                        });
                                                      });
                                                    } else {
                                                      showSnackBar(
                                                          "Aadhar number should be required 12 numbers");
                                                    }
                                                  }

                                                },
                                                child: Text('Verify',style: TextStyle(color: (aadhar_is_verified==false)?Colors.black:Colors.white,),)
                                              ),
                                            ),

                                            SizedBox(width: 5.0,)
                                          ],
                                        )):SizedBox(),


                                    const Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          "Sur Name",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.normal),
                                        )),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                        height: 55.0,
                                        child: FormBuilderDropdown<String>(
                                          name: 'surName',
                                          initialValue: (Constants.surName=='')?'Mr':Constants.surName,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(10.0),
                                              borderSide: BorderSide(
                                                  width: 3,
                                                  color: Color(0xFFC8C8C8)),
                                            ),

                                            hintText: 'Sur Name',
                                          ),
                                          items: surOptions
                                              .map((state) => DropdownMenuItem(
                                            alignment:
                                            AlignmentDirectional.centerStart,
                                            value: state,
                                            child: Text(state),
                                          ))
                                              .toList(),
                                          onChanged: (val) {
                                            setState(() {

                                            });
                                          },
                                          valueTransformer: (val) =>
                                              val?.toString(),
                                        )),
                                    const SizedBox(height: 5),
                                    const Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          "Your Name (as per your Aadhaar Card)",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.normal),
                                        )),
                                  //  const SizedBox(height: 5),
                                    SizedBox(
                                        height: 70.0,
                                        child: FormBuilderTextField(
                                          textCapitalization: TextCapitalization.characters,
                                          name: 'Name',
                                          controller: TextEditingname,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(10.0),
                                              borderSide: BorderSide(
                                                  width: 3,
                                                  color: Color(0xFFC8C8C8)),
                                            ),
                                            labelText: '',
                                            hintText: "Enter your name",
                                          ),
                                          onChanged: (val) {
                                            setState(() {});
                                          },
                                          validator: FormBuilderValidators.compose([
                                            FormBuilderValidators.required(),
                                          ]),
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(30),
                                          ],
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                        )),
                                   // const SizedBox(height: 5),
                                    const Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          "Your Display Name*",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.normal),
                                        )),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                        height: 70.0,
                                        child: FormBuilderTextField(
                                          textCapitalization: TextCapitalization.characters,
                                          name: 'displayName',
                                          controller: TextEditingname,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(10.0),
                                              borderSide: BorderSide(
                                                  width: 3,
                                                  color: Color(0xFFC8C8C8)),
                                            ),
                                            labelText: '',
                                            hintText: "Enter display name",
                                          ),
                                          onChanged: (val) {
                                            setState(() {});
                                          },
                                          //keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.next,
                                          validator: FormBuilderValidators.compose([
                                            FormBuilderValidators.required(),
                                          ]),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.deny(RegExp(r'[0-9_=+/!@#$%^&*(),.?":{}|<>]')),
                                            LengthLimitingTextInputFormatter(10),
                                          ],
                                        )),
                                   // const SizedBox(height: 5),
                                    const Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          "Your Email Address",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.normal),
                                        )),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                        height: 70.0,
                                        child: FormBuilderTextField(
                                          name: 'mailID',
                                          controller: TextEditingmailID,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(10.0),
                                              borderSide: BorderSide(
                                                  width: 3,
                                                  color: Color(0xFFC8C8C8)),
                                            ),
                                            labelText: '',
                                            hintText: "E-Mail Address",
                                          ),
                                          onChanged: (val) {
                                            setState(() {});
                                          },
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,

                                          validator: FormBuilderValidators.compose([
                                            FormBuilderValidators.required(),
                                            FormBuilderValidators.email()
                                          ]),

                                        )),
                                    //const SizedBox(height: 5),
                                    const Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          "Your Gender",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.normal),
                                        )),
                                    FormBuilderChoiceChip<String>(
                                      autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                      name: 'GenderType',
                                      initialValue: 'Male',
                                      /*decoration: InputDecoration(

                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                              borderSide: BorderSide(width: 3, color: Color(0xFFC8C8C8)),
                                            ),


                                          ),*/
                                      options:  [
                                        FormBuilderChipOption(
                                          value: 'Male',
                                          avatar: CircleAvatar(
                                              child: Icon(
                                                  (maleselected==false)?Icons.check_circle:Icons.check_circle_outline)),
                                        ),
                                        FormBuilderChipOption(
                                          value: 'Female',
                                          avatar: CircleAvatar(
                                              child: Icon(
                                                  (femaleselected==false)?Icons.check_circle:Icons.check_circle_outline)),
                                        ),
                                        FormBuilderChipOption(
                                          value: 'Other',
                                          avatar: CircleAvatar(
                                              child: Icon(
                                                  (otherselected==false)?Icons.check_circle:Icons.check_circle_outline)),
                                        ),
                                      ],
                                      onChanged: (val) {
                                        setState(() {
                                          maleselected=false;
                                          femaleselected=false;
                                          otherselected=false;
                                          if(val=='Male'){
                                            maleselected=true;
                                          }
                                          if(val=='Female'){
                                            femaleselected=true;
                                          }
                                          if(val=='Other'){
                                            otherselected=true;
                                          }
                                        });
                                      },

                                      validator: FormBuilderValidators.compose([
                                        FormBuilderValidators.required(),
                                      ]),


                                    ),
                                    const SizedBox(height: 5),
                                    const Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          "Your Date of Birth",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.normal),
                                        )),
                                  //  const SizedBox(height: 5),
                                    SizedBox(
                                        height: 70.0,
                                        child: FormBuilderDateTimePicker(
                                          name: 'dob',
                                          initialValue:(Constants.dob=='')?DateTime.now():DateTime.parse(Constants.dob),
                                          initialEntryMode:
                                          DatePickerEntryMode.calendar,
                                          //initialValue: Ht,
                                          inputType: InputType.date,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(10.0),
                                              borderSide: BorderSide(
                                                  width: 3,
                                                  color: Color(0xFFC8C8C8)),
                                            ),
                                            suffixIcon: IconButton(
                                              icon: const Icon(
                                                  Icons.calendar_today_sharp),
                                              onPressed: () {
                                                _formKey.currentState!
                                                    .fields['date']
                                                    ?.didChange(null);
                                              },
                                            ),
                                          ),

                                          validator: FormBuilderValidators.compose([
                                            FormBuilderValidators.required(),
                                          ]),

                                          initialTime: const TimeOfDay(
                                              hour: 8, minute: 0),
                                          // locale: const Locale.fromSubtags(languageCode: 'fr'),
                                        )),
                                    //const SizedBox(height: 5),
                                    const Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          "Your State of Residence",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.normal),
                                        )),
                                    const SizedBox(height: 15),
                                    SizedBox(
                                        height: 55.0,
                                        child: FormBuilderDropdown<String>(
                                          name: 'stateRefID',
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(10.0),
                                              borderSide: BorderSide(
                                                  width: 3,
                                                  color: Color(0xFFC8C8C8)),
                                            ),
                                            suffix: _genderHasError
                                                ? const Icon(Icons.error)
                                                : const Icon(Icons.check),
                                            hintText: 'Select State',
                                          ),
                                          items:  statedata.map((item) {
                                            return new DropdownMenuItem(
                                              child: new Text(item['state']),
                                              value: item['stateRefID'].toString(),

                                            );
                                          }).toList(),
                                          onChanged: (val) {
                                            setState(() {

                                            });
                                          },
                                          valueTransformer: (val) =>
                                              val?.toString(),
                                        )),
                                   // const SizedBox(height: 5),



                                    /// Your Aadhaar No Manual Verification
                                    (Constants.kycAutoApprove==0)?Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          "Your Aadhaar ID",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.normal),
                                        )):SizedBox(),
                                    (Constants.kycAutoApprove==0)?const SizedBox(height: 5):SizedBox(),
                                    (Constants.kycAutoApprove==0)?SizedBox(
                                        height: 70.0,
                                        child: FormBuilderTextField(
                                          name: 'aadhar',
                                          //initialValue: null,
                                          decoration: InputDecoration(
                                            suffixIcon: Icon(Icons.close_rounded,color: Colors.red,),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(10.0),
                                              borderSide: BorderSide(
                                                  width: 3,
                                                  color: Color(0xFFC8C8C8)),
                                            ),
                                            labelText: '',
                                            hintText: "Enter Your Aadhaar ID",
                                          ),
                                          onChanged: (val) {
                                            setState(() {

                                            });
                                          },
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(12),
                                            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                                          ],
                                          validator: FormBuilderValidators.compose([
                                            FormBuilderValidators.required(),
                                            FormBuilderValidators.numeric(),
                                            // FormBuilderValidators.max(12),

                                          ]),

                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                        )):SizedBox(),

                                    //Your PAN Manual Verification
                                    (Constants.kycAutoApprove==0)?const Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          "Your PAN Number",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.normal),
                                        )):SizedBox(),
                                    (Constants.kycAutoApprove==0)?const SizedBox(height: 5):SizedBox(),
                                    (Constants.kycAutoApprove==0)?SizedBox(
                                        height: 70.0,
                                        child: FormBuilderTextField(
                                          name: 'pan',
                                          textCapitalization: TextCapitalization.characters,
                                          //initialValue: null,
                                          decoration: InputDecoration(
                                            suffixIcon:  Icon(Icons.close_rounded,color: Colors.red,),
                                            //  radius: 100,


                                            border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(10.0),
                                              borderSide: BorderSide(
                                                  width: 3,
                                                  color: Color(0xFFC8C8C8)),
                                            ),
                                            labelText: '',
                                            hintText: "Enter Your PAN Number",
                                          ),
                                          onChanged: (val) {
                                            setState(() {});
                                          },
                                          //textCapitalization: TextCapitalization.sentences,
                                          //textCapitalization: TextCapitalization.characters,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(10),
                                          ],
                                          validator: FormBuilderValidators.compose([
                                            FormBuilderValidators.required(),
                                          ]),
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                        )):SizedBox(),
                                    (Constants.kycAutoApprove==0)?const SizedBox(height: 5):SizedBox(),




                                    /// Your Pan Auto Verification
                                    (Constants.kycAutoApprove==1)?Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          "Your PAN",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.normal),
                                        )):SizedBox(),
                                    (Constants.kycAutoApprove==1)?const SizedBox(height: 5):SizedBox(),


                                    (Constants.kycAutoApprove==1)?Container(
                                        decoration: BoxDecoration (
                                          border: Border.all(color: Color(0xffDADADA)),
                                          color: Color(0xffedecfb),
                                          borderRadius: BorderRadius.only (
                                            topLeft: Radius.circular(12*fem),
                                            topRight: Radius.circular(12*fem),
                                            bottomRight: Radius.circular(12*fem),
                                            bottomLeft: Radius.circular(12*fem),
                                          ),
                                        ),
                                        child:Row(
                                          children:  <Widget>[
                                            Expanded(child: SizedBox(
                                                width: 50.0,
                                                child:FormBuilderTextField(
                                                  name: 'pan',
                                                  //initialValue: null,
                                                  textCapitalization: TextCapitalization.characters,
                                                  decoration: InputDecoration(

                                                    border: InputBorder.none,
                                                    // suffixIcon: Icon(Icons.close_rounded,color: Colors.red,),

                                                    labelText: '',
                                                    hintText: "Enter Your PAN",
                                                  ),
                                                  onChanged: (val) {
                                                    setState(() {
                                                    });
                                                  },
                                                  inputFormatters: [
                                                    LengthLimitingTextInputFormatter(10),
                                                  ],
                                                  validator: FormBuilderValidators.compose([
                                                    FormBuilderValidators.required(),
                                                  ]),
                                                  keyboardType: TextInputType.text,
                                                  textInputAction: TextInputAction.next,
                                                ))),

                                            SizedBox(
                                              width: 70.0,
                                              child:  ElevatedButton(

                                                  style: ElevatedButton.styleFrom(
                                                    shadowColor: (pan_is_verified==false)?Color(0xffD9D9D9):Color(0xff85AD00),
                                                    backgroundColor:  (pan_is_verified==false)?Color(0xffD9D9D9):Color(0xff85AD00),
                                                    elevation: 3,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(32.0)),
                                                    minimumSize: Size(100, 40), //////// HERE
                                                  ),
                                                  onPressed: () {
   /* if (_formKey.currentState
        ?.saveAndValidate() ??
    false) {*/
      if (_formKey.currentState
          ?.value['pan'] == null) {
        showSnackBar("PAN number should be required");
      } else {
        PaymentGateway.pggetsignature()
            .whenComplete(() async {
          setState(() {
            PaymentGateway
                .getPanInfo(
                PaymentGateway.signature, Constants.name, _formKey.currentState
                ?.value['pan'])
                .whenComplete(() async {
              if (PaymentGateway.status == "INVALID") {
                showSnackBar(PaymentGateway.message);
              } else {
                pan_is_verified = true;
                showSnackBar(PaymentGateway.message);
              }
            });
          });
        });
      }
    //}
                                                  },
                                                  child: Text('Verify',style: TextStyle(color: (aadhar_is_verified==false)?Colors.black:Colors.white,),)
                                              ),
                                            ),

                                            SizedBox(width: 5.0,)
                                          ],
                                        )):SizedBox(),



                                    SizedBox(
                                      // height: 45.0,
                                        child: FormBuilderCheckbox(
                                          name: 'accept_terms',
                                          initialValue: false,
                                          //onChanged: _onChanged,
                                          title: RichText(
                                            text: const TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                  'By Continuing, you are accepting our Terms of  ',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                TextSpan(
                                                  text:
                                                  'Services & Privacy Policy .',
                                                  style:
                                                  TextStyle(color: Colors.blue),
                                                ),
                                              ],
                                            ),
                                          ),
                                          validator: FormBuilderValidators.equal(
                                            true,
                                            errorText:
                                            'You must accept terms and conditions to continue',
                                          ),
                                        )),
                                  ],
                                ),
                              )),
                          SizedBox(height: 50,)
                          //Profile Form
                        ],
                      )),
                    ),
                  ),
                  Positioned(
                    left: 140*fem,
                    top: 85*fem,
                    child: Container(
                      width: 129.81*fem,
                      height: 163*fem,
                      decoration: BoxDecoration (
                        borderRadius: BorderRadius.circular(48*fem),
                      ),
                      child: Container(
                        // group1188qQP (888:1793)
                        padding: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 4*fem),
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration (
                          borderRadius: BorderRadius.circular(48*fem),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            Container(
                              // ellipse389AB (888:1795)
                              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 8.82*fem),
                              width: 129.81*fem,
                              height: 134.18*fem,
                              child: Stack(
                                clipBehavior: Clip.none,
                                fit: StackFit.expand,
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        setState(() {
                                        });
                                      },
                                      child:(_imageFileList != null)?_handlePreview():CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 115,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: 110,
                                            child: (selectedIndex==-1 || selectedIndex==0)? CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  Constants.photo), //NetworkImage
                                              radius: 55,
                                            ):CircleAvatar(
                                              backgroundImage:AssetImage("assets/avatar$selectedIndex.png"),
                                              radius: 55,
                                            ), //CircleAvatar
                                          ))
                                  ),
                                  Positioned(
                                      bottom: 0,
                                      right: -25,
                                      child: RawMaterialButton(
                                        onPressed: () {
                                          //showImageSelectionBottomSheet(context);
                                          setState(() {

                                            ispopover=true;
                                          });

                                        },
                                        elevation: 2.0,
                                        fillColor: Color(0xFFF5F6F9),
                                        child: Image.asset("assets/camera.png"),
                                        padding: EdgeInsets.all(15.0),
                                        shape: CircleBorder(),
                                      )),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),




                  (ispopover==true)?Positioned(
                    // rectangle45V3c (344:1036)
                    left: 0*fem,
                    top: -50*fem,
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur (
                          sigmaX: 0*fem,
                          sigmaY: 0*fem,
                        ),
                        child: Align(
                          child: SizedBox(
                            width: 414*fem,
                            height: 996*fem,
                            child: Container(
                              decoration: BoxDecoration (
                                color: Color(0x7f000000),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ):SizedBox(),
                  (ispopover==true)?Positioned(
                    // frame762370XUz (1244:636)
                    left: 45*fem,
                    top: 200*fem,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(30*fem, 52*fem, 34*fem, 70*fem),
                      width: 317*fem,
                      height: 334*fem,
                      decoration: BoxDecoration (
                        color: Color(0xffffffff),
                        borderRadius: BorderRadius.circular(33*fem),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            // frame1470BpS (1244:610)
                              margin: EdgeInsets.fromLTRB(3*fem, 0*fem, 0*fem, 12*fem),
                              padding: EdgeInsets.fromLTRB(73*fem, 10*fem, 59*fem, 10*fem),
                              width: 250*fem,
                              height: 44*fem,
                              decoration: BoxDecoration (
                                border: Border.all(color: Color(0xff808080)),
                                color: Color(0xffffffff),
                                borderRadius: BorderRadius.circular(12*fem),
                              ),
                              child:GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isVideo = false;
                                    ismobile_gallery="Camera";
                                    _onImageButtonPressed('camera',ImageSource.camera, context: context);
                                    ispopover=false;
                                  });
                                },
                                child: Container(
                                  // group7623344tE (1244:611)
                                  padding: EdgeInsets.fromLTRB(2*fem, 3*fem, 0*fem, 3*fem),
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: SingleChildScrollView(child:Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        // materialsymbolscameraenhancero (1244:613)
                                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 8*fem, 0*fem),
                                        width: 20*fem,
                                        height: 18*fem,
                                        child: Image.asset(
                                          'assets/icons/material-symbols-camera-enhance-rounded.png',
                                          width: 20*fem,
                                          height: 18*fem,
                                        ),
                                      ),
                                      Text(
                                        // usecameraGjQ (1244:612)
                                        'Use Camera ',
                                        textAlign: TextAlign.center,
                                        style: SafeGoogleFont (
                                          'Open Sans',
                                          fontSize: 12*ffem,
                                          fontWeight: FontWeight.w700,
                                          height: 1.1428571429*ffem/fem,
                                          color: Color(0xff000000),
                                        ),
                                      ),
                                    ],
                                  )),
                                ),
                              )),
                          Container(
                            // group762335Cd4 (1244:622)
                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 3*fem, 25*fem),
                            width: 250*fem,
                            height: 18*fem,
                            child: Stack(
                              children: [
                                Positioned(
                                  // frame762306Jvz (1244:624)
                                  left: 110*fem,
                                  top: 0*fem,
                                  child: Container(
                                    width: 36*fem,
                                    height: 18*fem,
                                    decoration: BoxDecoration (
                                      color: Color(0xffffffff),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'OR',
                                        style: SafeGoogleFont (
                                          'Open Sans',
                                          fontSize: 14*ffem,
                                          fontWeight: FontWeight.w400,
                                          height: 1.2857142857*ffem/fem,
                                          color: Color(0xff808080),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  // Toggle light when tapped.
                                  isVideo = false;
                                  _onImageButtonPressed('gallery',ImageSource.gallery, context: context);
                                  ismobile_gallery="Gallery";
                                  ispopover=false;
                                });
                              },
                              child:Container(
                                // frame7623069wc (1244:615)
                                  margin: EdgeInsets.fromLTRB(3*fem, 0*fem, 0*fem, 0*fem),
                                  padding: EdgeInsets.fromLTRB(27*fem, 16*fem, 30*fem, 13*fem),
                                  width: 250*fem,
                                  height: 113*fem,
                                  decoration: BoxDecoration (
                                    border: Border.all(color: Color(0xff808080)),
                                    color: Color(0xffffffff),
                                    borderRadius: BorderRadius.circular(12*fem),
                                  ),
                                  child: Container(
                                    // group762334SA2 (1244:616)
                                    padding: EdgeInsets.fromLTRB(0*fem, 3.33*fem, 0*fem, 0*fem),
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: SingleChildScrollView(child:Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          // materialsymbolsuploadfilesharp (1244:619)
                                          margin: EdgeInsets.fromLTRB(1*fem, 0*fem, 0*fem, 11.33*fem),
                                          width: 26.67*fem,
                                          height: 33.33*fem,
                                          child: Image.asset(
                                            'assets/icons/material-symbols-upload-file-sharp.png',
                                            width: 26.67*fem,
                                            height: 33.33*fem,
                                          ),
                                        ),
                                        Container(
                                          // uploadfromphonestoragepAa (1244:617)
                                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 4*fem),
                                          child: Text(
                                            'Upload from Phone Storage',
                                            style: SafeGoogleFont (
                                              'Open Sans',
                                              fontSize: 14*ffem,
                                              fontWeight: FontWeight.w700,
                                              height: 1.1428571429*ffem/fem,
                                              color: Color(0xff000000),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          // pdfpngjpegW3Q (1244:618)
                                          margin: EdgeInsets.fromLTRB(1*fem, 0*fem, 0*fem, 0*fem),
                                          child: Text(
                                            'PDF, PNG, JPEG',
                                            style: SafeGoogleFont (
                                              'Open Sans',
                                              fontSize: 12*ffem,
                                              fontWeight: FontWeight.w400,
                                              height: 1.3333333333*ffem/fem,
                                              color: Color(0xff808080),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    ),
                                  ))),
                        ],
                      ),
                    ),
                  ):SizedBox(),


                ],
              ),
            ),
          ),
        ),bottomNavigationBar:  Container(color: Color((ispopover==true)?0xff7F7F7F:0xffedecfb),child:Padding(padding:EdgeInsets.all(10),child:SizedBox(
        height: 44.0,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor:
              _colorFromHex(Constants.buttonColor),
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(
                    12), // <-- Radius
              ) // foreground
          ),
          onPressed: () {
            if (_formKey.currentState
                ?.saveAndValidate() ??
                false) {
                          databaseUser
                  .profileupdatecreate(

                  _formKey.currentState
                      ?.value['surName'],_formKey.currentState
                  ?.value['displayName'],_formKey.currentState
                  ?.value['Name'],_formKey.currentState
                  ?.value['dob'],_formKey.currentState
                  ?.value['GenderType'],_formKey.currentState
                  ?.value['mailID'],_formKey.currentState
                  ?.value['ReferBy'],_formKey.currentState
                  ?.value['stateRefID'],_formKey.currentState
                              ?.value['pan'],_formKey.currentState
                              ?.value['aadhar'],selectedIndex)
                  .whenComplete(() {
                if(databaseUser.responseCode=="0"){

                  showSnackBar("Profile has been created");

                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              LoginUiPage(title: '',url: '',)),
                          (e) => false);
                }

              });


            } else {

            }
          },
          child: const Text(
            'Create Profile',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18.0),
          ),
        ))
    ))));
  }


}


typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);

class AspectRatioVideo extends StatefulWidget {
  const AspectRatioVideo(this.controller, {Key? key}) : super(key: key);

  final VideoPlayerController? controller;

  @override
  AspectRatioVideoState createState() => AspectRatioVideoState();
}

class AspectRatioVideoState extends State<AspectRatioVideo> {
  VideoPlayerController? get controller => widget.controller;
  bool initialized = false;

  void _onVideoControllerUpdate() {
    if (!mounted) {
      return;
    }
    if (initialized != controller!.value.isInitialized) {
      initialized = controller!.value.isInitialized;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    controller!.addListener(_onVideoControllerUpdate);
  }

  @override
  void dispose() {
    controller!.removeListener(_onVideoControllerUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (initialized) {
      return Center(
        child: AspectRatio(
          aspectRatio: controller!.value.aspectRatio,
          child: VideoPlayer(controller!),
        ),
      );
    } else {
      return Container();
    }
  }
}

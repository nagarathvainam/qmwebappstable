import '../question/schedule.dart';
import 'package:flutter/material.dart';
import 'package:quizmaster/utils.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:quizmaster/constant/constants.dart';
import 'package:quizmaster/pages/ui/noconnection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:quizmaster/pages/ui/hold-processing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../class/LoadingDialog.dart';
//import '../../model/databasehelper.dart';
import 'package:quizmaster/pages/user/model/user.dart';
import 'package:quizmaster/pages/transaction/model/transaction.dart';
class KYCVerification extends StatefulWidget {

  KYCVerification({Key? key}) : super(key: key);

  @override
  KYCVerificationState createState() => KYCVerificationState();
}

class KYCVerificationState extends State<KYCVerification>{//   with WidgetsBindingObserver
  late StreamSubscription<ConnectivityResult> subscription;
  //DatabaseHelper databaseHelper = new DatabaseHelper();
  User databaseUser = new User();
  Transactions databaseTransaction = new Transactions();

  @override
  void initState() {
    //WidgetsBinding.instance.removeObserver(this);
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(result==ConnectivityResult.none){
        navigateofflinescreen();
      }
      if(result==ConnectivityResult.mobile){



        
      }
      // Got a new connectivity status!
    });
    super.initState();
    _filecontroller.addListener(() => _extension = _filecontroller.text);
    userinfo();
    userKycinfo();

  }

  String pan="";
  String aadhar="";
  bool is_passbookupload=false;
  String mailID="";
  userinfo() async{
    final prefs = await SharedPreferences.getInstance();
    databaseUser
        .userinfo(await prefs.getString('qsid'))
        .whenComplete(() async{
      setState(() {
        mailID=databaseUser.mailID;
        print(databaseUser.aadhar);
        TextEditingaadhar.text=databaseUser.aadhar;
        TextEditingpan.text=databaseUser.pan;
      }
      );


    });
  }
  String aadharURL="";
  String panurl="";
  String bankURL="";
  userKycinfo() async{
    databaseUser
        .userKycinfo()
        .whenComplete(() async{
      setState(() {
        aadharURL=databaseUser.aadharURL;
        panurl=databaseUser.panurl;
        bankURL=databaseUser.bankURL;
      }
      );


    });
  }
  navigateofflinescreen(){
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
                NoConnectionUiPage()),
            (e) => false);
  }
  Color _colorFromHex(String hexColor) {
    final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
    return Color(int.parse('FF$hexCode', radix: 16));
  }
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  String? _fileName;
  String fileBase64='';
  String? _saveAsFileName;
  List<PlatformFile>? _paths;
  String? _directoryPath;
  String? _extension;
  bool _isLoading = false;
  bool _userAborted = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;
  TextEditingController _filecontroller = TextEditingController();


  final _formKeyaadhar = GlobalKey<FormBuilderState>();
  final _formKeypan = GlobalKey<FormBuilderState>();
  final _formKeypassbook = GlobalKey<FormBuilderState>();
  bool button_enable_aadhaar=false;
  bool button_enable_pan=false;
  bool first_wizard=true;
  bool second_wizard=false;
  bool third_wizard=false;
  bool _genderHasError = false;
  var genderOptions = ['iob', 'sbi', 'icici'];
// Camera Functionl Variable Declaration Start Here
  bool isVideo = false;
  bool ispopover= false;
  String ismobile_gallery="Camera";
  String doctype="";
  List<XFile>? _imageFileListAadhar;
  List<XFile>? _imageFileListPan;
  List<XFile>? _imageFileListBankPassBook;
  void _setImageFileListFromFile(XFile? value) {
    _imageFileListAadhar = value == null ? null : <XFile>[value];
    _imageFileListPan = value == null ? null : <XFile>[value];
    _imageFileListBankPassBook = value == null ? null : <XFile>[value];
  }

  showSnackBar(message) {
    final snackBar = SnackBar(
      closeIconColor: Colors.white,
      content: Text(message),
      action: SnackBarAction(
        label: 'Dismiss',
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

  dynamic _pickImageError;
  VideoPlayerController? _controller;
  VideoPlayerController? _toBeDisposed;
  String? _retrieveDataError;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();
  final TextEditingController TextEditingaadhar = TextEditingController();
  final TextEditingController TextEditingpan = TextEditingController();

  // Camera Functionl Variable Declaration End Here
  // Camera Functional Code Start Here

  void _pickFiles(filetype) async {
    print("File Type:$filetype");
    _resetState();
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: _multiPick,
        onFileLoading: (FilePickerStatus status) => print(" pick File Status:$status"),
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;
      //File imgfile = File(files);
      //Uint8List imgbytes1 = files.readAsBytesSync();

    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e) {
      _logException(e.toString());
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _fileName =
      _paths != null ? _paths!.map((e) => e.name).toString() : '...';
      _userAborted = _paths == null;
      String? filepath=_paths!
          .map((e) => e.path)
          .toList()[0];
      File imgfile = File(filepath!);
      Uint8List imgbytes1 = imgfile.readAsBytesSync();
      String bs4str = base64.encode(imgbytes1);
      //print("Base 64 File: $bs4str");
      fileBase64=bs4str;

      databaseUser
          .fileUpload(filetype,'.jpg',base64.encode(imgbytes1))  .whenComplete(() {
        if (databaseUser.responseCode ==
            "0") {
              if(filetype=='2'){
                  showSnackBar("Aadhar uploading successfully from phone storage");
              }
               if(filetype=='4'){
                  showSnackBar("Pan uploading successfully from phone storage");
              }
              if(filetype=='5'){
                showSnackBar("Pan uploading successfully from phone storage");
              }
              userKycinfo();
        }
        });

    });
  }

  void _clearCachedFiles() async {
    _resetState();
    try {
      bool? result = await FilePicker.platform.clearTemporaryFiles();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: result! ? Colors.green : Colors.red,
          content: Text((result
              ? 'Temporary files removed with success.'
              : 'Failed to clean temporary files')),
        ),
      );
    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e) {
      _logException(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _selectFolder() async {
    _resetState();
    try {
      String? path = await FilePicker.platform.getDirectoryPath();
      setState(() {
        _directoryPath = path;
        _userAborted = path == null;
      });
    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e) {
      _logException(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveFile() async {
    _resetState();
    try {
      String? fileName = await FilePicker.platform.saveFile(
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
        type: _pickingType,
      );
      setState(() {
        _saveAsFileName = fileName;
        _userAborted = fileName == null;
      });
    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e) {
      _logException(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _logException(String message) {
    print(message);
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = true;
      _directoryPath = null;
      _fileName = null;
      _paths = null;
      _saveAsFileName = null;
      _userAborted = false;
    });
  }

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
    if (_imageFileListAadhar != null) {
      //print("Print");
      //print(_imageFileList![0].readAsBytes());
      return Semantics(
        label: 'image_picker_example_picked_images',
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          key: UniqueKey(),
          itemBuilder: (BuildContext context, int index) {
            return Semantics(
              label: 'image_picker_example_picked_image',
              child: kIsWeb
                  ?Image.network(_imageFileListAadhar![index].path)
                  :  Image.file(File(_imageFileListAadhar![index].path),height: 75,),
            );
          },
          itemCount: _imageFileListAadhar!.length,
        ),
      );
    }else if (_imageFileListPan != null) {
      //print("Print");
      //print(_imageFileList![0].readAsBytes());
      return Semantics(
        label: 'image_picker_example_picked_images',
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          key: UniqueKey(),
          itemBuilder: (BuildContext context, int index) {
            return Semantics(
              label: 'image_picker_example_picked_image',
              child: kIsWeb
                  ?Image.network(_imageFileListPan![index].path)
                  :  Image.file(File(_imageFileListPan![index].path),height: 75,),
            );
          },
          itemCount: _imageFileListPan!.length,
        ),
      );
    }else if (_imageFileListBankPassBook != null) {
      //print("Print");
      //print(_imageFileList![0].readAsBytes());
      return Semantics(
        label: 'image_picker_example_picked_images',
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          key: UniqueKey(),
          itemBuilder: (BuildContext context, int index) {
            return Semantics(
              label: 'image_picker_example_picked_image',
              child: kIsWeb
                  ?Image.network(_imageFileListBankPassBook![index].path)
                  :  Image.file(File(_imageFileListBankPassBook![index].path),height: 75,),
            );
          },
          itemCount: _imageFileListBankPassBook!.length,
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
            _imageFileListAadhar = response.files;
            _imageFileListPan = response.files;
            _imageFileListBankPassBook = response.files;
          }
        });
      }
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }
  Future<void> _onImageButtonPressed(String ?action,ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {
    print("Image Upload Calling....");
    print("Doc type:$doctype");
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
              final List<XFile> pickedFileList = await _picker.pickMultiImage(
                maxWidth: maxWidth,
                maxHeight: maxHeight,
                imageQuality: quality,
              );
              setState(() {

                String? filepath=_paths!
                    .map((e) => e.path)
                    .toList()[0];
                File imgfile = File(filepath!);
                Uint8List imgbytes1 = imgfile.readAsBytesSync();
                String bs4str = base64.encode(imgbytes1);
                print("Base 64 File Upload Image: $bs4str");
                fileBase64=bs4str;
                if(doctype=='aadhar') {
                  _imageFileListAadhar = pickedFileList;
                }
                if(doctype=='pan') {
                  _imageFileListPan = pickedFileList;
                }
                if(doctype=='passbook') {
                  _imageFileListBankPassBook = pickedFileList;
                }
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
              final XFile? pickedFile = await _picker.pickImage(
                source: source,
                // maxWidth: maxWidth,
                //maxHeight: maxHeight,
                // imageQuality: quality,
              );
              setState(() {
                print(" pickedFile : $pickedFile");
                final bytes = File(pickedFile!.path).readAsBytesSync();
                //String base64Image =  "data:image/png;base64,"+base64Encode(bytes);
                if(doctype=='aadhar'){
                      databaseUser
                      .fileUpload('2','.png',base64Encode(bytes))  .whenComplete(() {
                    if (databaseUser.responseCode ==
                        "0") {
                        showSnackBar("Aadhar uploading successfully from camera");
                        userKycinfo();
                    }
                  });
                }
                if(doctype=='pan'){
                  databaseUser
                      .fileUpload('4','.png',base64Encode(bytes))  .whenComplete(() {
                    if (databaseUser.responseCode ==
                        "0") {
                      showSnackBar("Pan uploading successfully from camera");
                      userKycinfo();
                    }
                  });
                }
                if(doctype=='passbook'){
                  databaseUser
                      .fileUpload('5','.png',base64Encode(bytes))  .whenComplete(() {
                    if (databaseUser.responseCode ==
                        "0") {
                      showSnackBar("PassBook uploading successfully from camera");
                      userKycinfo();
                    }
                  });
                }






                String base64Image =  base64Encode(bytes);
                print("Start");
                print("img_pan : $base64Image");
                userKycinfo();

                print("End");
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
    double c_width = MediaQuery.of(context).size.width*0.8;
    double baseWidth = 414;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.85;//0.97;
    return WillPopScope(
        onWillPop: () async {
      // await showDialog or Show add banners or whatever
      // return true if the route to be popped
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => QuestionDynamicUiPage()),
              (e) => false);
      return false; // return false if you want to disable device back button click
    },
    child: Scaffold(
        backgroundColor: _colorFromHex(Constants.baseThemeColor),

        appBar: AppBar(
          elevation: 0,
          backgroundColor:_colorFromHex(Constants.baseThemeColor) ,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back,color: Colors.white,),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => QuestionDynamicUiPage()),
                          (e) => false);

                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),

          title: const Text('Complete Your KYC',style: TextStyle(color:Colors.white),),
          actions: <Widget>[
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(0.0),
            children: <Widget>[

// Aadhar Card
              (first_wizard)?Container(
                width: double.infinity,

                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration (
                    color: _colorFromHex(Constants.baseThemeColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        // addnewupikWS (1232:597)
                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 22*fem),
                        width: double.infinity,
height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration (
                          color: Color(0xffffffff),
                          borderRadius: BorderRadius.only (
                            topLeft: Radius.circular(24*fem),
                            topRight: Radius.circular(24*fem),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x28000000),
                              offset: Offset(0*fem, -4*fem),
                              blurRadius: 2*fem,
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (Constants.kycStatus=="3")?SizedBox(height: 5,):SizedBox(),
                            (Constants.kycStatus=="3")?Padding(padding: EdgeInsets.only(left: 15,top: 5),child:Text("Note:-",style:TextStyle(color:Colors.black,fontWeight: FontWeight.bold),)):SizedBox(),
                            (Constants.kycStatus=="3")?Padding(padding: EdgeInsets.only(left: 15,top: 5),child:Text(Constants.KycapprovedCommentcomment,style:TextStyle(color:Colors.red),)):SizedBox(),
                            Container(
                              // autogrouptdhq2D4 (17DENVRkndWnTDg7k3tdhQ)
                              padding: EdgeInsets.fromLTRB(24*fem, 32*fem, 24*fem, 32*fem),
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [

                                  Container(

                                    // frame762305YBQ (1232:609)
                                    // margin: EdgeInsets.fromLTRB(115*fem, 0*fem, 115*fem, 32*fem),
                                    width: double.infinity,
                                    height: 24*fem,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          // group762302rC6 (1232:610)
                                          width: 24*fem,
                                          height: double.infinity,
                                          decoration: BoxDecoration (
                                            color: Color(0xff5a2dbc),
                                            borderRadius: BorderRadius.circular(12*fem),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '1',
                                              textAlign: TextAlign.center,
                                              style: SafeGoogleFont (
                                                'Open Sans',
                                                fontSize: 14*ffem,
                                                fontWeight: FontWeight.w700,
                                                height: 1.2857142857*ffem/fem,
                                                color: Color(0xffffffff),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 2*fem,
                                        ),
                                        Image.asset("assets/wizard-separator.png"),
                                        SizedBox(
                                          width: 2*fem,
                                        ),
                                        Container(
                                          // group762303HYJ (1232:614)
                                          width: 24*fem,
                                          height: double.infinity,
                                          decoration: BoxDecoration (
                                            border: Border.all(color: Color(0xffc7c7c7)),
                                            color: Color(0xffffffff),
                                            borderRadius: BorderRadius.circular(12*fem),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '2',
                                              textAlign: TextAlign.center,
                                              style: SafeGoogleFont (
                                                'Open Sans',
                                                fontSize: 14*ffem,
                                                fontWeight: FontWeight.w700,
                                                height: 1.2857142857*ffem/fem,
                                                color: Color(0xff000000),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 2*fem,
                                        ),
                                        (is_passbookupload==true)?Image.asset("assets/wizard-separator.png"):SizedBox(),
                                        (is_passbookupload==true)?SizedBox(
                                          width: 2*fem,
                                        ):SizedBox(),
                                        (is_passbookupload==true)?Container(
                                          // group762304LFg (1232:618)
                                          width: 24*fem,
                                          height: double.infinity,
                                          decoration: BoxDecoration (
                                            border: Border.all(color: Color(0xffc7c7c7)),
                                            color: Color(0xffffffff),
                                            borderRadius: BorderRadius.circular(12*fem),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '3',
                                              textAlign: TextAlign.center,
                                              style: SafeGoogleFont (
                                                'Open Sans',
                                                fontSize: 14*ffem,
                                                fontWeight: FontWeight.w700,
                                                height: 1.2857142857*ffem/fem,
                                                color: Color(0xff000000),
                                              ),
                                            ),
                                          ),
                                        ):SizedBox(),



                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 24*fem,
                                  ),
                                  Container(
                                    // addaadharcardciz (1232:599)
                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 24*fem),
                                    child: Text(
                                      'Your Aadhar Card Number',
                                      style: SafeGoogleFont (
                                        'Open Sans',
                                        fontSize: 16*ffem,
                                        fontWeight: FontWeight.w700,
                                        height: 1*ffem/fem,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    // group6jHp (1232:600)
                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 24*fem),
                                    width: double.infinity,
                                    decoration: BoxDecoration (
                                      borderRadius: BorderRadius.circular(12*fem),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        //
                                        // (Constants.kycStatus!='2')?Container(
                                        //   // enteryouraadhaarid4L6 (1232:604)
                                        //   margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 8*fem),
                                        //   child: Text(
                                        //     'Enter your Aadhaar ID',
                                        //     style: SafeGoogleFont (
                                        //       'Open Sans',
                                        //       fontSize: 12*ffem,
                                        //       fontWeight: FontWeight.w400,
                                        //       height: 1.3333333333*ffem/fem,
                                        //       color: Color(0xff000000),
                                        //     ),
                                        //   ),
                                        // ):SizedBox(),

                                        Container(
                                          //color: Colors.grey,

                                            child:(Constants.aadhar!='')?Text(Constants.aadhar):Text("Kindly update your aadhar in profile section")/*FormBuilder(
                                              key: _formKeyaadhar,
                                              child:   SizedBox(
                                                  height: 40,
                                                  child:FormBuilderTextField(
                                                    readOnly: (Constants.kycStatus=='2')?true:false,
                                                    //autovalidateMode: AutovalidateMode.always,
                                                   // controller: TextEditingaadhar,
                                                    initialValue: Constants.aadhar,
                                                    name: 'Your Aadhaar ID',
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      filled: true,
                                                      hintText: 'Your Aadhaar ID',

                                                    ),
                                                    onChanged: (val) {
                                                      setState(() {

                                                      });
                                                    },
                                                    // valueTransformer: (text) => num.tryParse(text),
                                                    validator: FormBuilderValidators.compose([
                                                      FormBuilderValidators.required(),
                                                      FormBuilderValidators.numeric(),
                                                      // FormBuilderValidators.max(12),

                                                    ]),
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(12),
                                                    ],
                                                    // initialValue: aadhar,
                                                    keyboardType: TextInputType.number,
                                                    textInputAction: TextInputAction.next,
                                                  )),
                                            )*/
                                        )

                                      ],
                                    ),
                                  ),
                                  Center(
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width-60,
                                      height: 45.0,

                                      child:(button_enable_aadhaar==true )?ElevatedButton(

                                        style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: _colorFromHex(Constants.buttonColor),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  12), // <-- Radius
                                            )


                                          // foreground
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            //button_enable_aadhaar=false;
                                          });
                                        },
                                        child: const Text(
                                          'Check Aadhaar ID ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14.0),
                                        ),
                                      ):

                                      //  mainAxisAlignment : MainAxisAlignment.center,

                                      Row(
                                        mainAxisAlignment : MainAxisAlignment.center,
                                        children:  <Widget>[
                                         Image.asset("assets/tick.png"),
                                          Align( alignment:Alignment.center,  child: Text("Valid Aadhar ID",style: TextStyle(color: Color(0xff36C4BD),fontWeight:FontWeight.w700, fontSize: 14),))
                                      ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              // rectangle5279q7t (1232:621)
                              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 32*fem),
                              width: double.infinity,
                              height: 8*fem,
                              decoration: BoxDecoration (
                                color: Color(0xfff1f1f1),
                              ),
                            ),
                            (Constants.kycStatus!="2")?Container(
                              // uploadproofforaadharcardZpa (1232:633)
                              margin: EdgeInsets.fromLTRB(24*fem, 0*fem, 0*fem, 0*fem),
                              child: Text(
                                'Upload Proof for Aadhar Card',
                                style: SafeGoogleFont (
                                  'Open Sans',
                                  fontSize: 16*ffem,
                                  fontWeight: FontWeight.w700,
                                  height: 1*ffem/fem,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ):SizedBox(),


                           // (_imageFileListAadhar != null)?_handlePreview():SizedBox(),

                            (aadharURL!='')?
                            Align(alignment:Alignment.center,child:Container(decoration: BoxDecoration(
                              color: Color(0xffffffff),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                  bottomRight: Radius.circular(12)
                              ),
                            ),padding: EdgeInsets.only(left: 20.0,right: 20.0),child:ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child:Image.network(aadharURL,width: MediaQuery.of(context).size.width,)))):SizedBox(), (Constants.kycStatus!="2")?Container(
                              // autogroupxyxnURk (17DEpyfd2Z9s8WGsK5XYxn)
                              padding: EdgeInsets.fromLTRB(24*fem, 24*fem, 24*fem, 59*fem),
                              width: double.infinity,

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    // frame1470CMk (1232:622)
                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 24*fem),
                                    padding: EdgeInsets.fromLTRB(20*fem, 10*fem, 123*fem, 10*fem),
                                    width: double.infinity,
                                    height: 44*fem,
                                    decoration: BoxDecoration (
                                      border: Border.all(color: Color(0xff808080)),
                                      color: Color(0xffffffff),
                                      borderRadius: BorderRadius.circular(12*fem),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        print("Upload Camera");
                                        setState(() {
                                          isVideo = false;
                                          ismobile_gallery="Camera";
                                          doctype="aadhar";
                                          _onImageButtonPressed('camera',ImageSource.camera, context: context);
                                          ispopover=false;

                                        });
                                      },
                                      child:Container(

                                      // group762334Vre (1232:623)
                                      padding: EdgeInsets.fromLTRB(2*fem, 3*fem, 0*fem, 3*fem),
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: SingleChildScrollView(child:Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            // materialsymbolscameraenhancero (1232:625)
                                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 8*fem, 0*fem),
                                            width: 20*fem,
                                            height: 18*fem,
                                            child: Image.asset(
                                              'assets/icons/material-symbols-camera-enhance-rounded-4Fx.png',
                                              width: 20*fem,
                                              height: 18*fem,
                                            ),
                                          ),
                                          Text(
                                            // usecameraK4z (1232:624)
                                            'Upload Aadhar By Camera',
                                            textAlign: TextAlign.center,
                                            style: SafeGoogleFont (
                                              'Open Sans',
                                              fontSize: 14*ffem,
                                              fontWeight: FontWeight.w700,
                                              height: 1.1428571429*ffem/fem,
                                              color: Color(0xff000000),
                                            ),
                                          ),
                                        ],
                                      )),
                                    )),
                                  ),
                                  Container(
                                    // group762335FjL (1232:634)
                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 24*fem),
                                    width: double.infinity,
                                    height: 18*fem,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          // line16aWi (1232:635)
                                          left: 0*fem,
                                          top: 9*fem,
                                          child: Align(
                                            child: SizedBox(
                                              width: 366*fem,
                                              height: 1*fem,
                                              child: Container(
                                                decoration: BoxDecoration (
                                                  color: Color(0xffc7c7c7),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          // frame7623066jx (1232:636)
                                          left: 163*fem,
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
                                  Container(

                                    // frame762306C2J (1232:627)
                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 73*fem),
                                    padding: EdgeInsets.fromLTRB(87*fem, 16*fem, 86*fem, 16*fem),
                                    width: double.infinity,
                                    height: 116*fem,
                                    decoration: BoxDecoration (
                                      border: Border.all(color: Color(0xff808080)),
                                      color: Color(0xffffffff),
                                      borderRadius: BorderRadius.circular(12*fem),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        _pickFiles('2');
                                      },
                                      child:Container(
                                      padding: EdgeInsets.fromLTRB(0*fem, 3.33*fem, 0*fem, 0*fem),
                                      width: double.infinity,
                                      height: double.infinity,
                                      color: Colors.white,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.fromLTRB(1*fem, 0*fem, 0*fem, 11.33*fem),
                                            width: 26.67*fem,
                                            height: 33.33*fem,
                                            child: Image.asset(
                                              'assets/icons/material-symbols-upload-file-sharp-ELv.png',
                                              width: 26.67*fem,
                                              height: 33.33*fem,
                                            ),
                                          ),
                                          Container(
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
                                            margin: EdgeInsets.fromLTRB(1*fem, 0*fem, 0*fem, 0*fem),
                                            child: Text(
                                              'JPG',
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
                                  )),


                                ],
                              ),
                            ):SizedBox(),
                          ],
                        ),
                      )),


                    ],
                  ),
                ),
              ):SizedBox(),
// Aadhar Card

// Pan Card
              (second_wizard==true)?Container(
               // color: Colors.white,
                // addnewupiDj4 (1232:937)
                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 22*fem),
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration (
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.only (
                    topLeft: Radius.circular(24*fem),
                    topRight: Radius.circular(24*fem),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x28000000),
                      offset: Offset(0*fem, -4*fem),
                      blurRadius: 2*fem,
                    ),
                  ],
                ),
                child: SingleChildScrollView(child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      // autogroupdjsn6H4 (17DPceC4STfxgjSmDWdjSn)
                      padding: EdgeInsets.fromLTRB(24*fem, 32*fem, 24*fem, 32*fem),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            // frame762305D6n (1232:946)
                            margin: EdgeInsets.fromLTRB(110*fem, 0*fem, 115*fem, 32*fem),
                            width: double.infinity,
                            height: 24*fem,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  // group762306mGi (1232:950)
                                  width: 24*fem,
                                  height: double.infinity,
                                  decoration: BoxDecoration (

                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: fem*26.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 2*fem,
                                ),
                                Image.asset("assets/wizard-separator.png"),
                                SizedBox(
                                  width: 2*fem,
                                ),
                                Container(
                                  // group762306mGi (1232:950)
                                  width: 24*fem,
                                  height: double.infinity,
                                  decoration: BoxDecoration (
                                    color: Color(0xff5a2dbc),
                                    borderRadius: BorderRadius.circular(12*fem),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '2',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont (
                                        'Open Sans',
                                        fontSize: 14*ffem,
                                        fontWeight: FontWeight.w700,
                                        height: 1.2857142857*ffem/fem,
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 2*fem,
                                ),
                                (is_passbookupload==true)?Image.asset("assets/wizard-separator.png"):SizedBox(),
                                (is_passbookupload==true)?SizedBox(
                                  width: 2*fem,
                                ):SizedBox(),
                                (is_passbookupload==true)?Container(
                                  // group762304u1Y (1232:954)
                                  width: 24*fem,
                                  height: double.infinity,
                                  decoration: BoxDecoration (
                                    border: Border.all(color: Color(0xffc7c7c7)),
                                    color: Color(0xffffffff),
                                    borderRadius: BorderRadius.circular(12*fem),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '3',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont (
                                        'Open Sans',
                                        fontSize: 14*ffem,
                                        fontWeight: FontWeight.w700,
                                        height: 1.2857142857*ffem/fem,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ):SizedBox(),
                              ],
                            ),
                          ),
                          Container(
                            // addaadharcardciz (1232:599)
                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 24*fem),
                            child: Text(
                              'Your Pan Card Number',
                              style: SafeGoogleFont (
                                'Open Sans',
                                fontSize: 16*ffem,
                                fontWeight: FontWeight.w700,
                                height: 1*ffem/fem,
                                color: Color(0xff000000),
                              ),
                            ),
                          ),

                          Container(
                            // group6jHp (1232:600)
                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 24*fem),
                            width: double.infinity,

                            decoration: BoxDecoration (
                              borderRadius: BorderRadius.circular(12*fem),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [



                                Container(
                                    child:Text(Constants.pan))
                              ],
                            ),
                          ),
                          Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width-60,
                              height: 45.0,

                              child:(button_enable_pan==true )?ElevatedButton(


                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: _colorFromHex(Constants.buttonColor),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          12), // <-- Radius
                                    )


                                  // foreground
                                ),
                                onPressed: () {
                                  setState(() {button_enable_pan=false;

                                  });


                                },
                                child: Text(
                                  'Check PAN Number ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14.0),
                                ),
                              ):

                              //  mainAxisAlignment : MainAxisAlignment.center,

                              Row(
                                mainAxisAlignment : MainAxisAlignment.center,
                                children:  <Widget>[


                                  Image.asset("assets/tick.png"),

                                  Align( alignment:Alignment.center,  child: Text("Valid PAN Number",style: TextStyle(color: Color(0xff36C4BD),fontWeight:FontWeight.w700, fontSize: 14),))



                                ],
                              ),
                              ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // rectangle52796Nr (1232:957)
                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 32*fem),
                      width: double.infinity,
                      height: 8*fem,
                      decoration: BoxDecoration (
                        color: Color(0xffffffff),
                      ),
                    ),

                    (panurl!='')?
                    Align(alignment:Alignment.center,child:Container(decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12)
                      ),
                    ),padding: EdgeInsets.only(left: 20.0,right: 20.0),child:ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child:Image.network(panurl,width: MediaQuery.of(context).size.width,)))):SizedBox(),
                    (Constants.kycStatus!="2")?Container(
                      // uploadproofforpannumberddg (1232:969)
                      margin: EdgeInsets.fromLTRB(24*fem, 0*fem, 0*fem, 0*fem),
                      child: Text(
                        'Upload Proof for PAN Number',
                        style: SafeGoogleFont (
                          'Open Sans',
                          fontSize: 16*ffem,
                          fontWeight: FontWeight.w700,
                          height: 1*ffem/fem,
                          color: Color(0xff000000),
                        ),
                      ),
                    ):SizedBox(),
                   // (_imageFileListPan != null)?_handlePreview():SizedBox(),
                    (Constants.kycStatus!="2")?Container(

                      padding: EdgeInsets.fromLTRB(24*fem, 24*fem, 24*fem, 59*fem),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                          onTap: () {
                    setState(() {
                    isVideo = false;
                    ismobile_gallery="Camera";
                    doctype="pan";
                    _onImageButtonPressed('camera',ImageSource.camera, context: context);
                    ispopover=false;
                    });
                    },
                      child:Container(
                            // frame1470sY2 (1232:958)
                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 24*fem),
                            padding: EdgeInsets.fromLTRB(72*fem, 10*fem, 123*fem, 10*fem),
                            width: double.infinity,
                            height: 44*fem,
                            decoration: BoxDecoration (
                              border: Border.all(color: Color(0xff808080)),
                              color: Color(0xffffffff),
                              borderRadius: BorderRadius.circular(12*fem),
                            ),
                            child: Container(
                              // group762334NUn (1232:959)
                              padding: EdgeInsets.fromLTRB(2*fem, 3*fem, 0*fem, 3*fem),
                              width: double.infinity,
                              height: double.infinity,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    // materialsymbolscameraenhancero (1232:961)
                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 8*fem, 0*fem),
                                    width: 20*fem,
                                    height: 18*fem,
                                    child: Image.asset(
                                      'assets/icons/material-symbols-camera-enhance-rounded-ece.png',
                                      width: 20*fem,
                                      height: 18*fem,
                                    ),
                                  ),
                                  Text(
                                    // usecameracP8 (1232:960)
                                    'Upload PAN By Camera',
                                    textAlign: TextAlign.center,
                                    style: SafeGoogleFont (
                                      'Open Sans',
                                      fontSize: 14*ffem,
                                      fontWeight: FontWeight.w700,
                                      height: 1.1428571429*ffem/fem,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                          Container(
                            // group7623358MU (1232:970)
                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 24*fem),
                            width: double.infinity,
                            height: 18*fem,
                            child: Stack(
                              children: [
                                Positioned(
                                  // line164W2 (1232:971)
                                  left: 0*fem,
                                  top: 9*fem,
                                  child: Align(
                                    child: SizedBox(
                                      width: 366*fem,
                                      height: 1*fem,
                                      child: Container(
                                        decoration: BoxDecoration (
                                          color: Color(0xffc7c7c7),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  // frame762306nS2 (1232:972)
                                  left: 163*fem,
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
                          Container(
                            // frame762306fVp (1232:963)
                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 73*fem),
                            padding: EdgeInsets.fromLTRB(87*fem, 16*fem, 86*fem, 16*fem),
                            width: double.infinity,
                            height: 116*fem,
                            decoration: BoxDecoration (
                              border: Border.all(color: Color(0xff808080)),
                              color: Color(0xffffffff),
                              borderRadius: BorderRadius.circular(12*fem),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                _pickFiles('4');

                              },
                              child:Container(
                              color: Colors.white,
                              // group762334mYr (1232:964)
                              padding: EdgeInsets.fromLTRB(0*fem, 3.33*fem, 0*fem, 0*fem),
                              width: double.infinity,
                              height: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    // materialsymbolsuploadfilesharp (1232:967)
                                    margin: EdgeInsets.fromLTRB(1*fem, 0*fem, 0*fem, 11.33*fem),
                                    width: 26.67*fem,
                                    height: 33.33*fem,
                                    child: Image.asset(
                                      'assets/icons/material-symbols-upload-file-sharp-ELv.png',
                                      width: 26.67*fem,
                                      height: 33.33*fem,
                                    ),
                                  ),
                                  Container(
                                    color: Colors.white,
                                    // uploadfromphonestoragezwQ (1232:965)
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

                                    color: Colors.white,
                                    // pdfpngjpeguYa (1232:966)
                                    margin: EdgeInsets.fromLTRB(1*fem, 0*fem, 0*fem, 0*fem),
                                    child: Text(
                                      'JPG',
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
                          )),
                        ],
                      ),
                    ):SizedBox(),



                   // autogroupeuuyLKp (17DVV4FBDv4vc3ohEJeuuY)
                    Container(
                      padding: EdgeInsets.fromLTRB(24*fem, 24*fem, 24*fem, 59*fem),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            // frame762307fst (1232:1159)
                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 247*fem),
                            padding: EdgeInsets.fromLTRB(16*fem, 16*fem, 16*fem, 16*fem),
                            width: double.infinity,
                            height: 72*fem,
                            decoration: BoxDecoration (
                              border: Border.all(color: Color(0xffffffff)),
                              color: Color(0xffffffff),
                              borderRadius: BorderRadius.circular(12*fem),
                            ),
                          ),

                        ],
                      ),
                    ),

                  ],
                ),
                )):SizedBox(),
// Pan Card
// Bank Details
              (third_wizard==true)?SingleChildScrollView(child:Container(
                // addnewupihhQ (1232:1369)
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration (
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.only (
                    topLeft: Radius.circular(24*fem),
                    topRight: Radius.circular(24*fem),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x28000000),
                      offset: Offset(0*fem, -4*fem),
                      blurRadius: 2*fem,
                    ),
                  ],
                ),
                child: SingleChildScrollView(child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      // autogroupze2szwQ (17DbmiNn8T52oorTmCFze2S)
                      padding: EdgeInsets.fromLTRB(24*fem, 32*fem, 24*fem, 32*fem),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [


                          Container(
                            // frame762305D6n (1232:946)
                            margin: EdgeInsets.fromLTRB(110*fem, 0*fem, 110*fem, 32*fem),
                            width: double.infinity,
                            height: 24*fem,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  // group762306mGi (1232:950)
                                  width: 24*fem,
                                  height: double.infinity,
                                  decoration: BoxDecoration (

                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: fem*26.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 2*fem,
                                ),
                                Image.asset("assets/wizard-separator.png"),
                                SizedBox(
                                  width: 2*fem,
                                ),
                                Container(
                                  // group762306mGi (1232:950)
                                  width: 24*fem,
                                  height: double.infinity,
                                  decoration: BoxDecoration (

                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: fem*26.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 2*fem,
                                ),
                                Image.asset("assets/wizard-separator.png"),
                                SizedBox(
                                  width: 2*fem,
                                ),
                                Container(
                                  // group762306mGi (1232:950)
                                  width: 24*fem,
                                  height: double.infinity,
                                  decoration: BoxDecoration (
                                    color: Color(0xff5a2dbc),
                                    borderRadius: BorderRadius.circular(12*fem),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '3',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont (
                                        'Open Sans',
                                        fontSize: 14*ffem,
                                        fontWeight: FontWeight.w700,
                                        height: 1.2857142857*ffem/fem,
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 20,),
                          Container(
                            // group76217483x (1232:1380)
                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 0*fem),
                            width: double.infinity,

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  // addbankdetailsqyx (1232:1396)
                                  ' Bank Details',
                                  style: SafeGoogleFont (
                                    'Open Sans',
                                    fontSize: 18*ffem,
                                    fontWeight: FontWeight.w700,
                                    height: 1*ffem/fem,
                                    color: Color(0xff000000),
                                  ),
                                ),

                              //  Text("Select a Bank",style: TextStyle(color: Colors.black,fontWeight:FontWeight.w400, fontSize: 12),),


                                //Text("Select a Bank",style: TextStyle(color: Colors.black,fontWeight:FontWeight.w400, fontSize: 12),),
                                SizedBox(height: 0,),



                              ],
                            ),
                          ),

                        ],
                      ),
                    ),

                    (Constants.kycStatus!="2")?Container(
                      // proofforbankaccountWRC (1232:1401)
                      margin: EdgeInsets.fromLTRB(24*fem, 0*fem, 0*fem, 0*fem),
                      child: Text(
                        'Upload Proof for Bank Account',
                        style: SafeGoogleFont (
                          'Open Sans',
                          fontSize: 16*ffem,
                          fontWeight: FontWeight.w700,
                          height: 1*ffem/fem,
                          color: Color(0xff000000),
                        ),
                      ),
                    ):SizedBox(),
                    SizedBox(height: 10,),
                    (Constants.kycStatus!="2")?Container(
                      // iherebycertifythattheinformati (1232:1334)
                      // constraints: BoxConstraints (
                      //   maxWidth: 3*fem,
                      // ),
                      margin: EdgeInsets.fromLTRB(24*fem, 0*fem, 0*fem, 0*fem),
                      child: Text(
                        'Upload Bank Passbook, Statement or Cancelled cheques as a proof so that we can verify your bank account.',
                        style: SafeGoogleFont (
                          'Open Sans',
                          fontSize: 14*ffem,
                          fontWeight: FontWeight.w400,
                          height: 1.2857142857*ffem/fem,
                          color: Color(0xff000000),
                        ),
                      ),
                    ):SizedBox(),
                    SizedBox(height: 30,),
                    //(_imageFileListBankPassBook != null)?_handlePreview():SizedBox(),
                    (bankURL!='')?
                    Align(alignment:Alignment.center,child:Image.network(bankURL,width: MediaQuery.of(context).size.width-75,)):SizedBox(),
                    Container(

                      padding: EdgeInsets.fromLTRB(24*fem, 24*fem, 24*fem, 59*fem),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  isVideo = false;
                                  ismobile_gallery="Camera";
                                  doctype="passbook";
                                  _onImageButtonPressed('camera',ImageSource.camera, context: context);
                                  ispopover=false;
                                });
                              },
                              child:Container(
                                // frame1470sY2 (1232:958)
                                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 24*fem),
                                padding: EdgeInsets.fromLTRB(30*fem, 10*fem, 123*fem, 10*fem),
                                width: double.infinity,
                                height: 44*fem,
                                decoration: BoxDecoration (
                                  border: Border.all(color: Color(0xff808080)),
                                  color: Color(0xffffffff),
                                  borderRadius: BorderRadius.circular(12*fem),
                                ),
                                child: Container(
                                  // group762334NUn (1232:959)
                                  padding: EdgeInsets.fromLTRB(2*fem, 3*fem, 0*fem, 3*fem),
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: SingleChildScrollView(child:Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        // materialsymbolscameraenhancero (1232:961)
                                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 8*fem, 0*fem),
                                        width: 20*fem,
                                        height: 18*fem,
                                        child: Image.asset(
                                          'assets/icons/material-symbols-camera-enhance-rounded-ece.png',
                                          width: 20*fem,
                                          height: 18*fem,
                                        ),
                                      ),
                                      Text(
                                        // usecameracP8 (1232:960)
                                        'Upload PASSBOOK By Camera',
                                        textAlign: TextAlign.center,
                                        style: SafeGoogleFont (
                                          'Open Sans',
                                          fontSize: 14*ffem,
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
                            // group7623358MU (1232:970)
                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 24*fem),
                            width: double.infinity,
                            height: 18*fem,
                            child: Stack(
                              children: [
                                Positioned(
                                  // line164W2 (1232:971)
                                  left: 0*fem,
                                  top: 9*fem,
                                  child: Align(
                                    child: SizedBox(
                                      width: 366*fem,
                                      height: 1*fem,
                                      child: Container(
                                        decoration: BoxDecoration (
                                          color: Color(0xffc7c7c7),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  // frame762306nS2 (1232:972)
                                  left: 163*fem,
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
                          Container(
                            // frame762306fVp (1232:963)
                              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 73*fem),
                              padding: EdgeInsets.fromLTRB(87*fem, 16*fem, 86*fem, 16*fem),
                              width: double.infinity,
                              height: 116*fem,
                              decoration: BoxDecoration (
                                border: Border.all(color: Color(0xff808080)),
                                color: Color(0xffffffff),
                                borderRadius: BorderRadius.circular(12*fem),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  _pickFiles('5');
                                },
                                child:Container(
                                  color: Colors.white,
                                  // group762334mYr (1232:964)
                                  padding: EdgeInsets.fromLTRB(0*fem, 3.33*fem, 0*fem, 0*fem),
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        // materialsymbolsuploadfilesharp (1232:967)
                                        margin: EdgeInsets.fromLTRB(1*fem, 0*fem, 0*fem, 11.33*fem),
                                        width: 26.67*fem,
                                        height: 33.33*fem,
                                        child: Image.asset(
                                          'assets/icons/material-symbols-upload-file-sharp-ELv.png',
                                          width: 26.67*fem,
                                          height: 33.33*fem,
                                        ),
                                      ),
                                      Container(
                                        color: Colors.white,
                                        // uploadfromphonestoragezwQ (1232:965)
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

                                        color: Colors.white,
                                        // pdfpngjpeguYa (1232:966)
                                        margin: EdgeInsets.fromLTRB(1*fem, 0*fem, 0*fem, 0*fem),
                                        child: Text(
                                          'JPG',
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
                              )),
                        ],
                      ),
                    ),

                    //image picker and upload from storage




                    Container(
                      // group762343qbU (1232:1333)
                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 40*fem),
                      padding: EdgeInsets.fromLTRB(15*fem, 0*fem, 1*fem, 0*fem),
                      width: double.infinity,
                      decoration: BoxDecoration (
                        borderRadius: BorderRadius.circular(4*fem),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                        ],
                      ),


                    ),


                    SizedBox( height:40),



                  ],
                ),
              ))):SizedBox(),
              // Bank Details


            ],
          ),
        )

        ,bottomNavigationBar:  Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.white,
          ),
        ],
      ),
      child:Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            (first_wizard==true)?SizedBox(
                width: MediaQuery.of(context).size.width-60,
                height: 45.0,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:_colorFromHex(Constants.buttonColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            12), // <-- Radius
                      )
                    // foreground
                  ),
                  onPressed: () {
                    setState(() {
                      if(aadharURL==''){
                        showSnackBar('Kindly upload valid aadhar document for KYC');
                      }else {
                        // if (_formKeyaadhar.currentState
                        //     ?.saveAndValidate() ??
                        //     false) {
                          first_wizard = false;
                          second_wizard = true;
                        // } else {
                        //   debugPrint(_formKeyaadhar.currentState?.value
                        //       .toString());
                        //   debugPrint('validation failed');
                        // }
                      }

                    });
                  },
                  child: Text(
                    (Constants.kycStatus!="2")?'Save & Continue':'Preview to Pan Card Detail',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 14.0),
                  ),
                )):SizedBox(),


            (second_wizard==true)?SizedBox(
                width: MediaQuery.of(context).size.width-60,
                height: 45.0,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: _colorFromHex(Constants.buttonColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            12), // <-- Radius
                      )
                    // foreground
                  ),
                  onPressed: () {

                      if(panurl==''){
                      showSnackBar('Kindly upload valid PAN document for KYC');
                      }else {
                        setState(() {


                          if(is_passbookupload==false){
                            first_wizard = true;
                            second_wizard = false;
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder:
                                        (context) =>
                                        QuestionDynamicUiPage()),
                                    (e) => false);
                            /*Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder:
                                     (context) =>
                                      HoldProcessing(
                                          title: 'KYC Verification Pending',
                                          message: 'You wil receive a notification once its completed.',
                                          isloading: false,
                                          color: 'FC9700')),
                                  (e) => false);*/
                        }else{
                        second_wizard = false;
                        third_wizard = true;

                        }
                        });
                      }
                  },
                  child: Text(
                    (Constants.kycStatus!="2")?'Save & Continue':'Done',//Preview to PassBook Detail
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 14.0),
                  ),
                )):SizedBox(),


            (third_wizard==true)?SizedBox(
                width: MediaQuery.of(context).size.width-60,
                height: 45.0,

                child:  SizedBox(
                      width: MediaQuery.of(context).size.width-60,
                      height: 45.0,

                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: _colorFromHex(Constants.buttonColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  12), // <-- Radius
                            )
                          // foreground
                        ),
                        onPressed: () {
                          if(bankURL==''){
                            showSnackBar('Kindly upload valid Bank PassBook document for KYC');
                          }else {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HoldProcessing(
                                            title: 'KYC Verification Pending',
                                            message: 'You wil receive a notification once its completed.',
                                            isloading: false,
                                            color: 'FC9700')),
                                    (e) => false);
                          }
                        },
                        child: Text(
                          'Submit',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 14.0),
                        ),
                      )),
                ):SizedBox(),

           
          ]
      ),

    )));
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
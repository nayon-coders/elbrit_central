import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:elbrit_central/controllers/app_bar.dart';
import 'package:elbrit_central/models/wall_info.dart';
import 'package:elbrit_central/views/single-wall.dart';
import 'package:elbrit_central/views/video-play.dart';
import 'package:extended_image/extended_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_html/flutter_html.dart';



class WallPage extends StatefulWidget {
  WallPage({Key? key}) : super(key: key);

  @override
  State<WallPage> createState() => _WallPageState();
}

class _WallPageState extends State<WallPage> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  var dio = Dio();
  bool _isDowloading = false;

  List<WallModel> wallModels = [];
  List<WallModel> pinnedWallModel = [];

  bool _isPlayingVideo = false;

  bool isLoading = false;

  List<String> fileType =[
    "images/pdf.png",
    "images/doc.png",
    "images/csv.jpeg",
    "images/xl.png",
  ];
  @override
  void initState() {
    super.initState();
    // _controller = VideoPlayerController.network(
    //     'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
    //   ..initialize().then((_) {
    //     print("video init");
    //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    //     setState(() {});
    //   });
    // _controller =
    //     VideoPlayerController.network("http://admin.elbrit.org/uploads/20220806202630.mp4");
    // getWallData = _controller.initialize();

    getWallData = getWallDataMethod();
    getWallDataMethod();
  }
  var downloadPreogres;

int count = 0;
  var inputFormat = DateFormat('dd/MM/yyyy HH:mm');

  var getWalldataList;
  late Future getWallData;
  getWallDataMethod() async {
    SharedPreferences localDatabase = await SharedPreferences.getInstance();
    var userID = localDatabase.getString("userId");
    //var response = await client.get(uri);
    var response = await http.get(Uri.parse('http://admin.elbrit.org/api/walls/$userID'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body.toString());
      //print(json["data"].toString());
       //getWalldataList = json["data"].toString();
       //print(getWalldataList);
      print(data);


      // print(inputFormat.parse(data["data"]));
       return data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 3,
          leading: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: const Color(0xffFFFFFF),
                ),
                height: 200,
                width: 200,
                child: Image.asset(
                  'images/logo.png',
                  scale: 1.2,
                )),
          ),
          flexibleSpace: SafeArea(
            child: Container(
              child: const Padding(
                padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                child: NewAppBar(),
              ),
            ),
          ),
          bottom: isStartDownload ? PreferredSize(
            preferredSize: const Size.fromHeight(40.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 30,
              color: Colors.green,
              padding: EdgeInsets.only(left: 20, right: 20, ),
              child: Center(
                child: Row(
                  children: [
                    Text("File Downloading... ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),),
                  ],
                ),
              ),
            ),
            
          ) : PreferredSize(preferredSize: Size.fromHeight(0.0), child: Center(),),
        ),
        body:  Container(
          color: const Color(0xffEFF3F8),
          width: MediaQuery.of(context).size.width,
          child: FutureBuilder(
            future: getWallData,
            builder: (context, AsyncSnapshot<dynamic> snapshot){
              if(snapshot.hasData){
                return ListView.builder(
                  shrinkWrap: true,
                  //   physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                      vertical: 20, horizontal: 10),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data;

                    DateTime y = DateTime.parse(data[index]["created_at"]);
                    final DateFormat formatter = DateFormat('dd-MM-yyyy, HH:mm');
                    final String formatted = formatter.format(y);
                    print(formatted);
                    return Container(
                      width: 380,
                      margin: EdgeInsets.only(bottom: 20),
                      decoration: const BoxDecoration(
                        color: Color(0xffFFFFFF),
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 12, right: 12, top: 12),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Stack(
                                      children: [
                                        SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: Image.asset(
                                            'images/Vector-11.png',
                                            scale: .8,
                                          ),
                                        ),
                                        const Positioned(
                                          top: 8,
                                          left: 6,
                                          child: Center(
                                            child: Text(
                                              'EC',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight:
                                                  FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Elbrit Central',
                                      style: GoogleFonts.dmSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xff262930),
                                      ),
                                    ),
                                  ],
                                ),
                                data[index]["pin_post"] == 1 ?
                                Row(
                                  children: [
                                    Image.asset(
                                      'images/Vector-12.png',
                                      scale: 1,
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),

                                    Text(
                                      'Pinned Post',
                                      style: GoogleFonts.dmSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color:
                                        const Color(0xff8394AA),
                                      ),
                                    )
                                  ],
                                ): Center(),
                              ],
                            ),
                          ),
                          data[index]["image"].length > 0 ?
                          InkWell(
                            onTap: ()=>data[index]["image"].length > 0 ?
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>SingleWall(singleWall: snapshot.data[index]["image"], text: snapshot.data[index]["details"],)))
                                : null,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xffFFFFFF),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: data[index]["image"].length > 3 ? 150 : 300,
                                            decoration:
                                            BoxDecoration(
                                                borderRadius:BorderRadius.circular(12)
                                            ),
                                            child:  data[index]["image"][0].isNotEmpty?  ExtendedImage.network(
                                              "http://admin.elbrit.org/uploads/${data[index]["image"][0]}",
                                              fit: BoxFit.cover,
                                            ):Center(),
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        if(data[index]["image"].length > 2)
                                          Expanded(
                                            child: Container(
                                              height: data[index]["image"].length > 2? 150 : 300,
                                              margin: EdgeInsets.only(left: 10),
                                              decoration:
                                              BoxDecoration(
                                                borderRadius:BorderRadius.circular(12),
                                              ),
                                              child:data[index]["image"].length > 3?  ExtendedImage.network(
                                                "http://admin.elbrit.org/uploads/${data[index]["image"][1]}",
                                                fit: BoxFit.cover,
                                              ):Center(),
                                            ),
                                          ),
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    data[index]["image"].length > 2 ?
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                      children: [

                                        Expanded(
                                          child: Container(
                                            height: 150,
                                            decoration:
                                            BoxDecoration(
                                              borderRadius:BorderRadius.circular(12),
                                            ),
                                            child:  data[index]["image"][2] != null? ExtendedImage.network(
                                              "http://admin.elbrit.org/uploads/${data[index]["image"][2]}",
                                              fit: BoxFit.cover,
                                            ):Center(),
                                          ),
                                        ),
                                        if(data[index]["image"].length > 3)
                                          Expanded(
                                            child: Container(
                                              height: 150,
                                              margin: EdgeInsets.only(left: 10),
                                              decoration:
                                              BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: data[index]["image"][3] != null?   ExtendedImage.network(
                                                "http://admin.elbrit.org/uploads/${data[index]["image"][3]}",
                                                fit: BoxFit.cover,
                                              ):Center(),
                                            ),
                                          ),
                                      ],
                                    )
                                        :Center(),
                                  ],
                                ),
                              ),
                            ),
                          ):Center(),

                          //=======================================
                          //=========== Video Sections =============
                          data[index]["video"] != null ?
                          Stack(
                            children: [

                              Container(
                                margin: EdgeInsets.only(left: 30, right: 30, ),
                                // color: Colors.w.withOpacity(0.1),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.grey.shade200,
                                ),
                                width: double.infinity,
                                height: 150,
                              ),
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(top: 50, bottom: 50, left: MediaQuery.of(context).size.width/2.4, right: 100),
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.blueAccent,
                                ),
                                child: IconButton(
                                  onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>VideoApp(video: data[index]["video"],)));
                                    //Navigator.push(context, MaterialPageRoute(builder: (context)=>BasicPlayerPage()));
                                    print("object");
                                  },
                                  icon: Icon(Icons.play_arrow, color: Colors.white,),
                                ),
                              ),

                            ],
                          ):Center(),
                          //=======================================
                          //=========== File Sections =============
                          data[index]["filenames"] != null ?
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: data[index]["filenames"].length,
                              itemBuilder: (_, fileIndex){


                                var completePath = "https://admin.elbrit.org/uploads/${data[index]["filenames"][fileIndex]}";
                                //print(completePath);
                                var fileName = (completePath.split('.').last);

                                print("File name ================== $fileName");
                                return Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: GestureDetector(
                                    onTap: () async{
                                      print("object");
                                      setState((){
                                        count++;
                                      });
                                      downloadFileandOpen(context, completePath, "elbrit_central_doc");
                                      //_showMyDialog();
                                      // openFile(
                                      //   url: "https://admin.elbrit.org/uploads/2022091010050363.xlsx",
                                      //   fileName: "elbrit_task$count.$fileName",
                                      // );

                                      // var tempDir = await getTemporaryDirectory();
                                      // String fullPath = tempDir.path + "/elbrit_central.pdf'";
                                      // print('full path ${fullPath}');
                                      //
                                      // download2(dio, completePath, fullPath);

                                    },child: fileName == "pdf" ? Image.asset("images/pdf.png",height: 80,width: 80,)
                                      :  fileName == "cvs" ? Image.asset("images/cvs.jpeg",height: 80,width: 80,)
                                      :  fileName == "docx" ? Image.asset("images/doc.png",height: 120,width: 80, fit: BoxFit.cover,)
                                      : fileName == "xlsx" ? Image.asset("images/xl.png",height: 80,width: 80,)
                                      : Image.asset("images/pdf.png",height: 80,width: 80,),
                                  ),
                                  //   child: InkWell(
                                  //     onTap: (){
                                  //       print("asdfdsfsd");
                                  //     },
                                  //     child: fileName == "pdf" ? Image.asset("images/pdf.png",height: 80,width: 80,)
                                  //         :  fileName == "cvs" ? Image.asset("images/cvs.jpeg",height: 80,width: 80,)
                                  //         :  fileName == "doc" ? Image.asset("images/doc.png",height: 80,width: 80,)
                                  //         : fileName == "doc" ? Image.asset("images/xl.png",height: 80,width: 80,)
                                  //         : Image.asset("images/pdf.png",height: 80,width: 80,),
                                  //     // onTap: () async{
                                  //     //   print("daf");
                                  //       openFile(
                                  //           url: completePath,
                                  //           fileName: "Elbrit_center.$fileName",
                                  //
                                  //       );
                                  //     // },
                                  //     // onTap: ()async{
                                  //     //

                                  //     // },
                                  //     // child: fileName == "pdf" ? Image.asset("images/pdf.png",height: 80,width: 80,)
                                  //     //     :  fileName == "cvs" ? Image.asset("images/cvs.jpeg",height: 80,width: 80,)
                                  //     //     :  fileName == "doc" ? Image.asset("images/doc.png",height: 80,width: 80,)
                                  //     //     : fileName == "doc" ? Image.asset("images/xl.png",height: 80,width: 80,)
                                  //     //     : Image.asset("images/pdf.png",height: 80,width: 80,),
                                  // ),
                                );
                              },
                            ),
                          ):Center(),





                          //  Stack(
                          //   children: [
                          //     Container(
                          //       width: 380,
                          //       child: _controller.value.isInitialized
                          //           ? AspectRatio(
                          //         aspectRatio: _controller.value.aspectRatio,
                          //         child: VideoPlayer(_controller),
                          //       )
                          //           : Container(),
                          //     ),
                          //     Positioned(
                          //         left: MediaQuery.of(context).size.width/2.4,
                          //         right: MediaQuery.of(context).size.width/2.4,
                          //         top: 0,
                          //         bottom: 10,
                          //         child: FloatingActionButton(
                          //           backgroundColor: _isPlayingVideo? Colors.transparent: Colors.blueAccent,
                          //           child: Icon(_isPlayingVideo? Icons.play_arrow_outlined:Icons.play_arrow, color: Colors.white,),
                          //           onPressed: () {
                          //             print("Dasfds");
                          //             setState(() {
                          //               if (_controller.value.isPlaying) {
                          //                 _controller.pause();
                          //               } else {
                          //
                          //                 setState(() {
                          //                   VideoPlayerController.network(
                          //                       'https://admin.elbrit.org/uploads/${snapshot.data[index]["video"] }').play();
                          //                   _isPlayingVideo = true;
                          //                 });
                          //               }
                          //             });
                          //           },
                          //         )),
                          //   ],
                          // ):Center(),



                          data[index]["details"] != null?
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 12, right: 12, top: 8),
                            child: Html(
                                data: "${data[index]["details"]}",
                                onLinkTap: (dynamic? url, RenderContext context, Map<String, String> attributes, element) {
                                  print(url);
                                  launchUrl(Uri.parse(url));
                                }


                              // onLinkTap: (url, _, __, ___) async {
                              //   if (await canLaunch(url!)) {
                              //     await launch(
                              //       url,
                              //     );
                              //   }
                              // },
                            ),



                            // Text(
                            //
                            // "${snapshot.data[index]["details"]}",
                            //   textAlign: TextAlign.left,
                            //   maxLines: 100,
                            //   overflow: TextOverflow.ellipsis,
                            //   textScaleFactor: 1.1,
                            //   style: GoogleFonts.dmSans(
                            //     fontSize: 14,
                            //     fontWeight: FontWeight.w400,
                            //     color: const Color(0xff262930),
                            //   ),
                            // ),
                          ):Center(),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 30,
                            padding: const EdgeInsets.only(
                                left: 12, bottom: 10),
                            child: Text(
                              '$formatted',
                              style: GoogleFonts.dmSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff8394AA),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },

                );
              }else if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }else{
                return const Center(
                  child: Text("No data found"),
                );
              }
            },
          ),
        ),
      ),
    );
  }
  //
  // Future download2(Dio dio, String url, String savePath) async {
  //   try {
  //     Response response = await dio.get(
  //       url,
  //       onReceiveProgress: showDownloadProgress,
  //       //Received data with List<int>
  //       options: Options(
  //           responseType: ResponseType.bytes,
  //           followRedirects: false,
  //           validateStatus: (status) {
  //             return status! < 500;
  //           }),
  //     );
  //     print('Download Progresh ====== ${response.headers}');
  //     File file = File(savePath);
  //     var raf = file.openSync(mode: FileMode.write);
  //     // response.data is List<int> type
  //     raf.writeFromSync(response.data);
  //     await raf.close();
  //   } catch (e) {
  //     print(e);
  //   }
  // }
  bool isStartDownload = false;
  void downloadFileandOpen(BuildContext context, String url, String fileName) async {
setState(() {
  isStartDownload = true;
});
print(url);
print("url set");
    var directory = Platform.isAndroid
        ? await getExternalStorageDirectory() //FOR ANDROID
        : await getApplicationSupportDirectory();

    String? dir = directory?.path;

    File file = new File('$dir/$fileName');

    if (await file.exists()) {
      OpenFile.open(file.path);
    } else {
      print("file is download");
      //Utils.showLoaderDialogwithTitle(context, "Downloading...");

      HttpClient httpClient = new HttpClient();

      try {
        var request = await httpClient.getUrl(Uri.parse(url));
        var response = await request.close();
        print(response.statusCode);
        if (response.statusCode == 200) {
          var bytes = await consolidateHttpClientResponseBytes(response);
          print(file.path);
          await file.writeAsBytes(bytes);
        }
        Navigator.pop(context);
      } catch (ex) {
        Navigator.pop(context);
        print(ex.toString());
       // Utils.displayToast(context, ex.toString());
      } finally {
        OpenFile.open(file.path);
      }
    }

    setState(() {
      isStartDownload = false;
    });
  }
// bool isStartDownload = false;
//   Future openFile({required String url, required String fileName})async{
//     setState(() {
//       isStartDownload = true;
//     });
//     print("object");
//     final file = await DownLoadFile(url, fileName);
//     //print("File is ============== ${file!.path}");
//    if(file!=null) {
//      print("file ================= ${file.path}");
//      OpenFile.open(file.path);
//      print("file downloaded");
//    }else{
//      print("file not download");
//    }
//    print(file);
//     setState(() {
//       isStartDownload = false;
//     });
//
//
//
//   }
//   Future<File?>DownLoadFile(String url, String name)async{
//     try {
//       final appStore = await getApplicationDocumentsDirectory();
//       final file = await File('${appStore.path}/$name');
//
//       final response = await Dio().get(
//         "https://admin.elbrit.org/uploads/2022091010050363.xlsx",
//         options: Options(
//             responseType: ResponseType.bytes,
//             followRedirects: true,
//             receiveTimeout: 0
//         ),
//       );
//       final raf = file.openSync(mode: FileMode.write);
//       raf.writeFromSync(response.data);
//       await raf.close();
//       print("file===============$file");
//       return file;
//     }catch(e){
//       return null;
//     }
//
//   }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Row(
              children: <Widget>[
                CircularProgressIndicator(),
                Text("Downloading..."),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // void showDownloadProgress(received, total) {
  //   if (total != -1) {
  //     print("Downloading" + (received / total * 100).toStringAsFixed(0) + "%");
  //     setState(() {
  //       _isDowloading = true;
  //       downloadPreogres = (received / total * 100).toStringAsFixed(0);
  //
  //       if(downloadPreogres == "100"){
  //         _isDowloading = false;
  //         showDialog(
  //             context: context,
  //             builder: (BuildContext context) => new AlertDialog(
  //               title: new Text('File Downloaded'),
  //               actions: <Widget>[
  //                 TextButton( onPressed: () {
  //         Navigator.pop(context);
  //         }, child: Text("Close"))
  //                 ]
  //                 ));
  //       }
  //     });
  //   }
  // }

}






  // child: SingleChildScrollView(
          //   child: Column(
          //     children: [
          //       const SizedBox(
          //         height: 15,
          //       ),
          //       const SizedBox(
          //         height: 15,
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.only(
          //           left: 15,
          //           right: 15,
          //         ),
          //         child: Container(
          //           height: 130,
          //           width: 380,
          //           decoration: BoxDecoration(
          //             color: const Color(0xffFFFFFF),
          //             borderRadius: BorderRadius.circular(12),
          //           ),
          //           child: Padding(
          //             padding:
          //                 const EdgeInsets.only(left: 8, right: 8, top: 20),
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Row(
          //                   children: [
          //                     Stack(
          //                       children: [
          //                         Container(
          //                           height: 30,
          //                           width: 30,
          //                           child: Image.asset(
          //                             'images/Vector-11.png',
          //                             scale: .8,
          //                           ),
          //                         ),
          //                         const Positioned(
          //                           top: 8,
          //                           left: 6,
          //                           child: Center(
          //                             child: Text(
          //                               'EC',
          //                               style: TextStyle(
          //                                   color: Colors.white,
          //                                   fontWeight: FontWeight.bold),
          //                             ),
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                     const SizedBox(
          //                       width: 10,
          //                     ),
          //                     Text(
          //                       'Elbrit Central',
          //                       style: GoogleFonts.dmSans(
          //                         fontSize: 14,
          //                         fontWeight: FontWeight.w500,
          //                         color: const Color(0xff262930),
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //                 const SizedBox(
          //                   height: 20,
          //                 ),
          //                 Row(
          //                   mainAxisAlignment: MainAxisAlignment.start,
          //                   children: [
          //                     const Icon(Icons.attachment_sharp),
          //                     const SizedBox(
          //                       width: 20,
          //                     ),
          //                     Text(
          //                       'new.pdf',
          //                       style: GoogleFonts.dmSans(
          //                         fontSize: 14,
          //                         fontWeight: FontWeight.bold,
          //                         color: const Color(0xff191919),
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //                 const SizedBox(
          //                   height: 15,
          //                 ),
          //                 Padding(
          //                   padding: const EdgeInsets.only(
          //                     left: 12,
          //                   ),
          //                   child: Text(
          //                     '20 hours ago',
          //                     style: GoogleFonts.dmSans(
          //                       fontSize: 10,
          //                       fontWeight: FontWeight.w500,
          //                       color: const Color(0xff8394AA),
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //       const SizedBox(
          //         height: 20,
          //       )
          //     ],
          //   ),
          // ),
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../api/api.dart';
import '../../components/loading.dart';
import '../../components/video_three.dart';
import '../../entity/album_video_list_entity.dart';
import '../../entity/video_album_entity.dart';
import '../../style/layout.dart';
import '../video_detail/detail.dart';

class VideoAlbum extends StatefulWidget {
  //接受路由传递过来的props id
  final int id;
  const VideoAlbum({super.key, required this.id});

  @override
  VideoAlbumState createState() => VideoAlbumState();
}

class VideoAlbumState extends State<VideoAlbum>
    with SingleTickerProviderStateMixin {
  // 提取常量
  static const _gradientColors = [
    Color.fromRGBO(255, 218, 112, 1),
    Color.fromRGBO(255, 255, 255, 1),
  ];
  static const _gradientStops = [0.2, 0.8];
  static const _hdTagTextStyle = TextStyle(
    fontSize: 11,
    color: Colors.white,
    fontWeight: FontWeight.w400,
  );
  static const _videoNoteTextStyle = TextStyle(
    fontSize: 10,
    color: Colors.white,
    fontWeight: FontWeight.w400,
  );

  var _futureBuilderFuture;
  VideoAlbumData? albumInfoData;
  List<AlbumVideoListDataList>? videoPageData;

  Future<void> getAlbumVideoList() async {
    try {
      videoPageData =
          (await Api.getAlbumVideoList({"album_id": widget.id})).data?.list ??
          [] as List<AlbumVideoListDataList>;
    } catch (e) {
      debugPrint('Initialization getAlbumListByCategoryIds failed: $e');
    }
  }

  Future<void> getAlbumById() async {
    try {
      albumInfoData =
          (await Api.getAlbumById({"id": widget.id})).data as VideoAlbumData;
      debugPrint(
        'Initialization getAlbumListByCategoryIds success${albumInfoData}',
      );
    } catch (e) {
      debugPrint('Initialization getAlbumListByCategoryIds failed: $e');
    }
  }

  Future<String> init() async {
    try {
      await getAlbumById();
      await getAlbumVideoList();
      return "init success";
    } catch (e) {
      print('Initialization failed: $e');
      return "init success";
    }
  }

  @override
  void initState() {
    _futureBuilderFuture = init();
    super.initState();
  }

  Widget _buildContent() {
    return FutureBuilder<String>(
      future: _futureBuilderFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return PageLoading();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Stack(
                  children: [
                    TDImage(
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                      imgUrl: albumInfoData?.surfacePlot ?? "",
                      errorWidget: const TDImage(
                        width: 150,
                        assetUrl: 'assets/images/loading.gif',
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20, left: 20),
                      child: Text(
                        albumInfoData?.title ?? "",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    _buildList(),
                  ],
                ),
              ],
            ),
          );
        } else {
          return Text('No data available');
        }
      },
    );
  }

  Widget _buildList() {
    return Container(
      margin: const EdgeInsets.only(top: 150),
      padding: const EdgeInsets.only(
        left: Layout.paddingL,
        right: Layout.paddingR,
        top: Layout.paddingT,
        bottom: Layout.paddingB,
      ),
      width: double.infinity,
      //动态计算高度
      height: MediaQuery.of(context).size.height - 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(child: VideoThree(videoPageData: videoPageData)),
      ),
    );
  }

  void _buildvideo_onClick(int id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Video_Detail(id: id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 20, backgroundColor: _gradientColors[0]),
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            padding: EdgeInsets.only(top: 10),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: _gradientStops,
                colors: _gradientColors,
              ),
            ),
            child: _buildContent(),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../api/api.dart';
import '../../components/loading.dart';
import '../../components/video_three.dart';
import '../../entity/album_video_list_entity.dart';
import '../../entity/video_album_entity.dart';
import '../../style/layout.dart';

class VideoAlbum extends StatefulWidget {
  //接受路由传递过来的props id
  final int id;
  const VideoAlbum({super.key, required this.id});

  @override
  VideoAlbumState createState() => VideoAlbumState();
}

class VideoAlbumState extends State<VideoAlbum> {
  late Future<String> _futureBuilderFuture;
  VideoAlbumData? albumInfoData;
  List<AlbumVideoListDataList>? videoPageData;
  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = init();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> getAlbumVideoList() async {
    try {
      if (!mounted) return;
      videoPageData =
          (await Api.getAlbumVideoList({"album_id": widget.id})).data?.list ??
          [] as List<AlbumVideoListDataList>;
    } catch (e) {
      debugPrint('Initialization getAlbumListByCategoryIds failed: $e');
    }
  }

  Future<void> getAlbumById() async {
    try {
      if (!mounted) return;
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
      if (!mounted) return "init failed";
      
      // 并发执行所有异步操作，提升加载速度
      await Future.wait([
        getAlbumById(),
        getAlbumVideoList(),
      ]);
      
      if (mounted) {
        setState(() {});
      }
      return "init success";
    } catch (e) {
      debugPrint('Initialization failed: $e');
      return "init success";
    }
  }

  Widget _buildContent() {
    return FutureBuilder<String>(
      future: _futureBuilderFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const PageLoading();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Stack(
                  children: [
                    TDImage(
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 300,
                      imgUrl: albumInfoData?.surfacePlot ?? "",
                      errorWidget: const TDImage(
                        width: 150,
                        assetUrl: 'assets/images/loading.gif',
                      ),
                    ),
                    Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent, // 顶部透明
                            Colors.black, // 底部黑色
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, top: 80),
                        child: Column(
                          //左對齊
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              albumInfoData?.title ?? "",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              albumInfoData?.introduce ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ],
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
          return const Text('No data available');
        }
      },
    );
  }

  Widget _buildList() {
    return Card(
      margin: const EdgeInsets.only(top: 200),
      child: Container(
        padding: const EdgeInsets.only(
          left: Layout.paddingL,
          right: Layout.paddingR,
          top: Layout.paddingT,
          bottom: Layout.paddingB,
        ),
        width: double.infinity,
        //动态计算高度
        height: MediaQuery.of(context).size.height - 150,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: SmartRefresher(
          onRefresh: () async {
            await init();
            if (mounted) {
              _refreshController.refreshCompleted();
            }
          },
          onLoading: () async {
            if (mounted) {
              _refreshController.loadComplete();
            }
          },
          enablePullDown: true,
          enablePullUp: true,
          controller: _refreshController,
          child: ListView(
            padding: const EdgeInsets.only(top: 0),
            cacheExtent: 200,
            children: [VideoThree(videoPageData: videoPageData)],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        //透明
        backgroundColor: Colors.transparent,
        centerTitle: true,
        toolbarHeight: 40,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [Container(child: _buildContent())],
      ),
    );
  }
}

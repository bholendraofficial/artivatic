import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/data_model.dart';
import '../provider/home_screen_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final HomeScreenProvider homeScreenProvider =
        Provider.of<HomeScreenProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(homeScreenProvider.dataModel != null
              ? homeScreenProvider.dataModel!.title!.toString()
              : "Artivatic"),
          actions: [
            IconButton(
                onPressed: () {
                  homeScreenProvider.reloadData();
                },
                tooltip: "Reload",
                icon: const Icon(Icons.refresh))
          ],
        ),
        body: SafeArea(child: Builder(
          builder: (BuildContext context) {
            if (homeScreenProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (homeScreenProvider.dataModel != null) {
              DataModel dataModel = homeScreenProvider.dataModel!;
              return ListView.separated(
                itemCount: dataModel.rows!.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(dataModel.rows![index].title.toString()),
                    subtitle:
                        Text(dataModel.rows![index].description.toString()),
                    leading: CachedNetworkImage(
                      imageUrl: dataModel.rows![index].imageHref.toString(),
                      height: kToolbarHeight,
                      width: kToolbarHeight,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
              );
            } else {
              return const Center(child: Text("No Record(s)"));
            }
          },
        )));
  }

  @override
  void initState() {
    final homeScreenProvider =
        Provider.of<HomeScreenProvider>(context, listen: false);
    homeScreenProvider.loadData(); // calling restful api
    super.initState();
  }
}

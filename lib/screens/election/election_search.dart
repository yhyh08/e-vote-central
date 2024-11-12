import 'package:e_vote/widgets/top_bar.dart';
import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';

class ElectionSearch extends StatefulWidget {
  const ElectionSearch({super.key});

  @override
  ElectionSearchState createState() => ElectionSearchState();
}

class ElectionSearchState extends State<ElectionSearch> {
  List<DataSample> electionData = [
    DataSample('Election 1'),
    DataSample('Election 2'),
    DataSample('Election 3'),
  ];
  List<DataSample> filteredData = [];

  Future<void> afterBuildFunction(BuildContext context) async {
    setState(() {
      filteredData = electionData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TopBar(
      text: 'ElectionSearch',
      index: 1,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              style: const TextStyle(color: Colors.black),
              cursorColor: Theme.of(context).primaryColor,
              decoration: InputDecoration(
                  suffixIcon: const Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  hintText: 'Search',
                  hintStyle: Theme.of(context).textTheme.labelMedium,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 212, 212, 212))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 212, 212, 212)))),
              onChanged: (String searchText) {
                debugPrint(searchText);
                setState(
                  () {
                    filteredData = electionData
                        .where((data) => data.title
                            .toLowerCase()
                            .contains(searchText.toLowerCase()))
                        .toList();
                  },
                );
              },
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 30),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.52,
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: filteredData.length,
                itemBuilder: (BuildContext context, int index) {
                  return product(filteredData[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget product(DataSample data) {
    return Container(
      padding: const EdgeInsets.all(10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
              color: Color.fromARGB(11, 0, 0, 0),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image(
                      image: Assets.images.logo.image().image,
                      fit: BoxFit.contain,
                    ))),
          ),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                data.title,
                maxLines: 2,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold),
              )),
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: Text(
              'RM',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(
            thickness: 1,
            height: 5,
            color: Color(0xffC8C8C8),
          ),
          TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).hintColor,
                minimumSize: const Size.fromHeight(16)),
            child: Text('S.of(context).viewItem',
                style: Theme.of(context).textTheme.headlineSmall),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}

class DataSample {
  DataSample(
    this.title,
  );

  final String title;
}

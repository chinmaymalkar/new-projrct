import 'package:flutter/material.dart';

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 2, vsync: this);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(

          height: double.infinity,
          width: double.infinity,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  "Notes",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 10,
                  child: Container(
                    height: 50,
                    width: 350,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20)),
                    child: TabBar(
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.redAccent[100],
                      ),
                      controller: tabController,
                      tabs: [
                        Text(
                          "All",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "Starred",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      notesAll(),
                      notesStarred(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class notesAll extends StatefulWidget {
  const notesAll({Key? key}) : super(key: key);

  @override
  State<notesAll> createState() => _notesAllState();
}

class _notesAllState extends State<notesAll> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: 20,
        itemBuilder: (BuildContext, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.8, horizontal: 10),
            child: Card(
              child: InkWell(
                onTap: () {},
                child: ListTile(
                  leading: Text(
                    "${index + 1}",
                    style: TextStyle(
                        fontSize: 20, textBaseline: TextBaseline.alphabetic),
                  ),
                  title: Text("Demo text"),
                  subtitle: Text("Detailed text"),
                  trailing: Container(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class notesStarred extends StatefulWidget {
  const notesStarred({Key? key}) : super(key: key);

  @override
  State<notesStarred> createState() => _notesStarredState();
}

class _notesStarredState extends State<notesStarred> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: 20,
        itemBuilder: (BuildContext, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0.8),
            child: Card(
              child: InkWell(
                onTap: () {},
                child: ListTile(
                  leading: Text(
                    "${index + 1}",
                    style: TextStyle(
                        fontSize: 20, textBaseline: TextBaseline.alphabetic),
                  ),
                  title: Text("Demo text"),
                  subtitle: Text("Detailed text"),
                  trailing: Container(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}

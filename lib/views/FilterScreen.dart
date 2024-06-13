import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  final String tags;
  final String sort;

  const FilterScreen({super.key, required this.tags, required this.sort});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late TextEditingController tagsController;
  late String selectedSort;

  @override
  void initState() {
    super.initState();
    tagsController = TextEditingController(text: widget.tags);
    selectedSort = widget.sort;
  }

  @override
  void dispose() {
    tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter Photos'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: tagsController,
              decoration: InputDecoration(labelText: 'Tags'),
            ),
            DropdownButton<String>(
              value: selectedSort,
              items: const [
                DropdownMenuItem(value: 'relevance', child: Text('Relevance')),
                DropdownMenuItem(value: 'date-posted-desc', child: Text('Date Posted')),
                DropdownMenuItem(value: 'interestingness-desc', child: Text('Interestingness')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedSort = value!;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'tags': tagsController.text,
                  'sort': selectedSort,
                });
              },
              child: Text('Apply Filters'),
            ),
          ],
        ),
      ),
    );
  }
}

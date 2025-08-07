import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class DocumentViewer extends StatefulWidget {
  final String filePath; // This is a URL (not a local file path)

  const DocumentViewer({super.key, required this.filePath});

  @override
  State<DocumentViewer> createState() => _DocumentViewerState();
}

class _DocumentViewerState extends State<DocumentViewer> {
  String? localPath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    downloadAndLoadPDF();
  }

  Future<void> downloadAndLoadPDF() async {
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/temp.pdf');

      // Download PDF file to temp path
      final response = await Dio().download(widget.filePath, file.path);

      if (response.statusCode == 200) {
        setState(() {
          localPath = file.path;
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load PDF");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error loading PDF: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Document')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : localPath != null
          ? PDFView(filePath: localPath!)
          : const Center(child: Text("Failed to load document")),
    );
  }
}

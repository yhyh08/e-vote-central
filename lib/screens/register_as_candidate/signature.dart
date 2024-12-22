import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:signature/signature.dart';

class SignatureCandidate extends StatefulWidget {
  const SignatureCandidate({super.key});

  @override
  State<SignatureCandidate> createState() => _SignatureCandidateState();
}

class _SignatureCandidateState extends State<SignatureCandidate> {
  // initialize the signature controller
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 1,
    penColor: Colors.red,
    exportBackgroundColor: Colors.transparent,
    exportPenColor: Colors.black,
    onDrawStart: () => log('onDrawStart called!'),
    onDrawEnd: () => log('onDrawEnd called!'),
  );

  bool _isDisabled = false;

  @override
  void initState() {
    super.initState();
    _controller
      ..addListener(() => log('Value changed'))
      ..onDrawEnd = () => setState(
            () {
              // setState for build to update value of "empty label" in gui
            },
          );
  }

  @override
  void dispose() {
    // IMPORTANT to dispose of the controller
    _controller.dispose();
    super.dispose();
  }

  Future<void> exportImage(BuildContext context) async {
    if (_controller.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          key: Key('snackbarPNG'),
          content: Text('No content'),
        ),
      );
      return;
    }

    final Uint8List? data =
        await _controller.toPngBytes(height: 1000, width: 1000);
    if (data == null) {
      return;
    }

    if (!mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => convertToImage(data),
      ),
    );
  }

  Future<void> exportSVG(BuildContext context) async {
    if (_controller.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          key: Key('snackbarSVG'),
          content: Text('No content'),
        ),
      );
      return;
    }

    final SvgPicture data = _controller.toSVG()!;

    if (!mounted) return;

    await Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (BuildContext context) => convertToSVG(data),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Signature Candidate',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        color: Theme.of(context).secondaryHeaderColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Signature(
            key: const Key('signature'),
            controller: _controller,
            height: 300,
            backgroundColor: Theme.of(context).primaryColorLight,
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          decoration: const BoxDecoration(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              IconButton(
                key: const Key('exportPNG'),
                icon: const Icon(Icons.image),
                color: Theme.of(context).primaryColor,
                onPressed: () => exportImage(context),
                tooltip: 'Export Image',
              ),
              IconButton(
                icon: const Icon(Icons.undo),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  setState(() => _controller.undo());
                },
                tooltip: 'Undo',
              ),
              IconButton(
                icon: const Icon(Icons.redo),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  setState(() => _controller.redo());
                },
                tooltip: 'Redo',
              ),
              IconButton(
                key: const Key('clear'),
                icon: const Icon(Icons.clear),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  setState(() => _controller.clear());
                },
                tooltip: 'Clear',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget convertToImage(Uint8List data) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PNG Image',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        color: Theme.of(context).secondaryHeaderColor,
        child: Center(
          child: Container(
            color: Theme.of(context).primaryColorLight,
            child: Image.memory(data),
          ),
        ),
      ),
    );
  }

  Widget convertToSVG(SvgPicture data) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SVG Image'),
      ),
      body: Center(
        child: Container(
          color: Colors.grey[300],
          child: data,
        ),
      ),
    );
  }
}

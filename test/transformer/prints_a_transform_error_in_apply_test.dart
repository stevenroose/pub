// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS d.file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../descriptor.dart' as d;
import '../test_pub.dart';
import '../serve/utils.dart';

final transformer = """
import 'dart:async';

import 'package:barback/barback.dart';

class RewriteTransformer extends Transformer {
  RewriteTransformer.asPlugin();

  String get allowedExtensions => '.txt';

  Future apply(Transform transform) => throw new Exception('oh no!');
}
""";

main() {
  integration("prints a transform error in apply", () {
    serveBarback();

    d.dir(appPath, [
      d.pubspec({
        "name": "myapp",
        "transformers": ["myapp/src/transformer"],
        "dependencies": {"barback": "any"}
      }),
      d.dir("lib", [d.dir("src", [
        d.file("transformer.dart", transformer)
      ])]),
      d.dir("web", [
        d.file("foo.txt", "foo")
      ])
    ]).create();

    pubGet();
    var server = pubServe();
    server.stderr.expect(emitsLines(
        'Build error:\n'
        'Transform Rewrite on myapp|web/foo.txt threw error: oh no!'));
    endPubServe();
  });
}

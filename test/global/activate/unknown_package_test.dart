// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:pub/src/exit_codes.dart' as exit_codes;
import 'package:scheduled_test/scheduled_test.dart';

import '../../test_pub.dart';

main() {
  integration('errors if the package could not be found', () {
    serveNoPackages();

    schedulePub(args: ["global", "activate", "foo"],
        error: startsWith("Could not find package foo at"),
        exitCode: exit_codes.UNAVAILABLE);
  });
}

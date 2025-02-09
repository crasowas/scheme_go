#!/bin/bash

# Copyright (c) 2025, crasowas.
#
# Use of this source code is governed by a MIT-style license
# that can be found in the LICENSE file or at
# https://opensource.org/licenses/MIT.

# Run Flutter analysis
#echo "Running 'flutter analyze'..."
#flutter analyze

# Run Flutter tests
echo "Running 'flutter test'..."
flutter test

# Apply Dart fixes
echo "Running 'dart fix --apply'..."
dart fix --apply

# Format Dart code
echo "Running 'dart format .'"
dart format .

# Build Flutter web
echo "Running 'flutter build web --release --web-renderer html'..."
flutter build web --release --web-renderer html

echo ""
echo "Script completed."

// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

const Set<Song> songs = {
  // Filenames with whitespace break package:audioplayers on iOS
  // (as of February 2022), so we use no whitespace.
  // if you want to add song
    // Song('ili.mp3', 'ILI ILI TULOG ANAY', artist: 'Flor Ristagno'),
    Song('misty_cave.mp3', 'MISTY CAVE', artist: ''),
    Song('nameless.mp3', 'NAMELESS', artist: ''),
    Song('other_worldly_buddy.mp3', 'OTHER WORLDLY BUDDY', artist: ''),
    Song('phobia.mp3', 'PHOBIA', artist: ''),
    Song('wandering_darkness.mp3', 'WANDERING DARKNESS', artist: ''),


};

class Song {
  final String filename;

  final String name;

  final String? artist;

  const Song(this.filename, this.name, {this.artist});

  @override
  String toString() => 'Song<$filename>';
}

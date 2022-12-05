// Advent of Code 2022 day 4, with Dart
// try this at https://tio.run/#dart

import 'dart:io';

// let's do it the *object-oriented* way, I guess...
class Range {
  int lower;
  int upper;

  Range(this.lower, this.upper);

  static Range parse(String s) {
    List<String> sections = s.split('-');
    
    return Range(int.parse(sections.first), int.parse(sections.last));
  }
}

// what? no tuples?! FINE
class Assignment {
  Range left;
  Range right;

  Assignment(this.left, this.right);

  static Assignment parse(String s) {
    List<String> ranges = s.split(',');

    return Assignment(Range.parse(ranges.first), Range.parse(ranges.last));
  }

  static bool containing(Assignment p) {
    Range a = p.left;
    Range b = p.right;

    return (b.lower >= a.lower && b.upper <= a.upper) 
        || (a.lower >= b.lower && a.upper <= b.upper);
  }

  // can't quite get my brain around why only these two conditions are needed
  // here, but I can't argue with the fact that it gives the right answer!
  static bool overlapping(Assignment p) {
    Range a = p.left;
    Range b = p.right;

    return (b.lower <= a.upper && a.lower <= b.upper);
  } 
}

// it was weirdly much easier to read input in a nice way from a file
// than from stdin, but I want to be consistent, so we do it like this
void main() {
  List<String> lines = [];

  while (true) {
    String? line = stdin.readLineSync();
    if (line == null) { break; }
    lines.add(line);
  }

  Iterable<Assignment> assignments = lines.map(Assignment.parse);
  
  int part1 = assignments.where(Assignment.containing).length;
  int part2 = assignments.where(Assignment.overlapping).length;
 
  print('Number of assignment pairs where one range fully contains the other: $part1');
  print('Number of assignment pairs where ranges overlap at all: $part2');
}
// Advent of Code 2022 day 7, with Go
// try this at https://tio.run/#go

package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"strconv"
	"strings"
)

// we store all the directory paths and their total sizes in a map, so this
// function does all the hard work of tracking new info after each command!
func processCommands(filesystem map[string]int, commands string) map[string]int {
	path := []string{"/"}

	for _, cmd := range strings.Split(string(commands), "\n") {

		switch {

		// `path` is the current directory, so "cd /" resets this to "/"
		case strings.HasPrefix(cmd, "$ cd /"):
			path = []string{"/"}

		// "cd .." means we pop the last directory off the path to go up a level
		case strings.HasPrefix(cmd, "$ cd .."):
			path = path[:len(path)-1]

		// "cd anything_else" means we append a new dir to the end of the path
		case strings.HasPrefix(cmd, "$ cd"):
			path = append(path, strings.Fields(cmd)[2]+"/")

		// "ls" commands are irrelevant, we already know where we are...
		case strings.HasPrefix(cmd, "ls"): // don't do anything

		// ...and we don't need to know what dirs are around, unless we `cd` into one!
		case strings.HasPrefix(cmd, "dir"): // don't do anything

		// otherwise, it's a file... we add the filesize to every prefix of the
		// current path (so, every enclosing directory up to and including `/`)
		default:
			filesize, _ := strconv.Atoi(strings.Fields(cmd)[0])

			var current string

			for _, dir := range path {
				current += dir
				filesystem[current] += filesize
			}
		}
	}
	return filesystem
}

func main() {
	input, _ := ioutil.ReadAll(os.Stdin)

	filesystem := processCommands(make(map[string]int), string(input))

	// after all of that, this part ends up being pretty easy!
	part1, part2 := 0, filesystem["/"]
	for _, size := range filesystem {
		if size <= 100000 {
			part1 += size
		}

		if size < part2 && size >= filesystem["/"]-40000000 {
			part2 = size
		}
	}

	fmt.Println("Sum of all directories with size smaller than the given bound:", part1)
	fmt.Println("Smallest directory that would free up enough space for the update:", part2)
}

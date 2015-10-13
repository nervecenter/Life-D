// And implementation of Conway's Game of Life in D
// by Chris Collazo
// Licensed under the GNU GPLv3 - General Public License

import std.stdio,
	core.thread,
	std.random,
	core.exception;

enum l = 50;
enum w = 50;

bool randStart() {
	int gen = uniform(0, 100);
	return (gen > 25) ? false : true;
}

void clear() {
	foreach(l; 0..w) {
		writeln();
	}
}

uint livingNeighbors(uint x, uint y, immutable bool[l][w] grid) {
	uint alive = 0;

	foreach (xp; x-1..x+2) {
		foreach (yp; y-1..y+2) {
			try {
				if (grid[xp][yp]) {
					alive++;
				}
			} catch (RangeError) { }
		}
	}

	if (grid[x][y] == true) {
		alive--;
	}

	return alive;
}

immutable(bool[l][w]) seed() {
	bool[l][w] grid;

	foreach (ref row; grid) {
		foreach (ref cell; row) {
			cell = randStart();
		}
	}

	return grid;
}

immutable(bool[l][w]) life(immutable bool[l][w] before) {
	bool[l][w] grid;
	uint living;

	foreach (x; 0..l) {
		foreach (y; 0..w) {
			living = livingNeighbors(x, y, before);

			if (before[x][y] == false && living == 3) {
				grid[x][y] = true;
			} else if (before[x][y] == true) {
				if (living < 2 || living > 3) {
					grid[x][y] = false;
				} else if (living == 2 || living == 3) {
					grid[x][y] = true;
				}
			}
		}
	}

	return grid;
}

void renderScreen(immutable bool[l][w] grid) {
	foreach (x; 0..l) {
		foreach (y; 0..w) {
			if (grid[x][y] == true) {
				write("X");
			} else {
				write(" ");
			}
		}
		writeln();
	}
}

void main() {
	bool[l][w] grid = seed();

	while (true) {
		// Run life
		grid = life(grid);
		// Render
		renderScreen(grid);
		Thread.sleep( dur!("msecs")( 300 ) );
	}
}
// And implementation of Conway's Game of Life in D, using Dgame
// by Chris Collazo
// Licensed under the GNU GPLv3 - General Public License

import std.stdio,
    core.thread,
    std.random,
    core.exception,
    Dgame.Graphic,
    Dgame.System,
    Dgame.Window,
    Dgame.Math;

enum l = 60;
enum w = 60;

bool randStart() {
    int gen = uniform(0, 100);
    return (gen > 25) ? false : true;
}

/*void clear() {
    foreach(l; 0..w) {
        writeln();
    }
}*/

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

    //writeln("x: ", x, " y: ", y);
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

/*void renderScreen(immutable bool[l][w] grid) {
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
}*/

void renderScreen(ref Window wnd, immutable bool[l][w] grid) {
    Shape black_cell = new Shape(Geometry.Quads, [Vertex(0, 0), Vertex(10, 0), Vertex(10, 10), Vertex(0, 10)]);
    black_cell.setColor(Color4b.Black);
    black_cell.setOrigin(0, 0);
    /*Shape white_cell = new Shape(Geometry.Quads, [Vertex(0, 0), Vertex(10, 0), Vertex(10, 10), Vertex(0, 10)]);
    white_cell.setColor(Color4b.White);
    white_cell.setOrigin(0, 0);*/

    foreach (x; 0..l) {
        foreach (y; 0..w) {
            if (grid[x][y] == true) {
                // Draw a black cell
                black_cell.setPosition(x*10, y*10);
                wnd.draw(black_cell);
            }
        }
    }
}

void main() {
    bool[l][w] grid = seed();
    Window wnd = Window(l*10+10, w*10+10, "Conway's Game of Life - Dgame", Window.Style.Default);

    //Shape target = new Shape(Geometry.Quads, [Vertex(0, 0), Vertex(50, 0), Vertex(50, 50), Vertex(0, 50)]);
    //target.setColor(Color4b.Black);
    //target.setOrigin(0, 0);
    //target.setPosition(0, 0);

    while (true) {
        // Run life
        grid = life(grid);
        // Render
        wnd.clear();
        renderScreen(wnd, grid);
        //wnd.draw(target);
        wnd.display();
        Thread.sleep( dur!("msecs")( 300 ) );
    }
}
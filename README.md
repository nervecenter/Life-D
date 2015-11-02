# Life-D #

An implementation of Conway's Game of Life in D, using Dgame.

The original non-Dgame source is /lifeorig.d.

Dgame version is /Dgame/life/life.d. In that folder, run dub build. Then run life.exe from command line or by double-clicking.

### Issues ###

* Only works with n x n square grid layouts.
* Padded for unknown reasons on left and top. Added matching padding to right and bottom for aesthetics' sake.
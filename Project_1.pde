/**
 * Creative Embedded Systems Generative Art
 * by Chianna Cohen derived from Spore 1 examble by Mike Davis 
 * 
 * A short program for alife experiments. Click in the window to restart.
 * Each cell is represented by a pixel on the display as well as an entry in
 * the array 'cells'. Each cell has a run() method, which performs actions
 * based on the cell's surroundings.  Cells run one at a time (to avoid conflicts
 * like wanting to move to the same space) and in random order.
 */

World w;
int numcells = 0;
int maxcells = 6700;
Cell[] cells = new Cell[maxcells];
color dust_color;
// set lower for smoother animation, higher for faster simulation
int runs_per_loop = 1000;
color background = color(66, 71, 64);
int start = millis();
  
void setup() {
  fullScreen();
  //size(640, 360);
  frameRate(24);
  reset();
  
}



void reset() {
  clearScreen();  
  w = new World();
  
  // if (w.getpix(cX, cY) == black) {
  dust_color = color(254, 254, 230);
  seed();
  
  drawLights();
}

void drawLights() {
  
  // Light one from top left to bottom right 
  int x1 = (int) random(displayWidth/2);
  int y1 = 0;
  int x2 = displayWidth;
  int y2 =(int) random(displayHeight);
  int x3 = displayWidth;
  int y3 = displayHeight;
  int x4 = (int) random(displayWidth);
  int y4 = displayHeight;
  
  fill(250, 224, 44, 50);
  quad(x1, y1, x2, y2, x3, y3, x4, y4);
  
  
  //
  x1 = (int) random(displayWidth/3, displayWidth);
  y1 = 0;
  x2 = x1 + 30;
  y2 = 0;
  
  
  x3 = (int) random(displayWidth);
  y3 = displayHeight;
  x4 = (int) random(displayWidth);
  while (x4 + 40 > x3) {
    x4 = (int) random(displayWidth);
  }
  y4 = displayHeight;
  
  fill(250, 242, 44, 70);
  quad(x1, y1, x2, y2, x3, y3, x4, y4);
}

void seed() {
  // Add cells at random places
  for (int i = 0; i < maxcells; i++)
  {
    int cX = (int)random(width);
    int cY = (int)random(height);
    if (w.getpix(cX, cY) != dust_color) {
      w.setpix(cX, cY, dust_color);
      cells[numcells] = new Cell(cX, cY);
      numcells++;
    }
  }
}

void draw() {
  // Run cells in random order
    for (int i = 0; i < runs_per_loop; i++) {
      int selected = min((int)random(numcells), numcells - 1);
      cells[selected].run();
    }
      
  if (millis() > start + 6000) {
       start = millis();
       changeLights();
  }
}

void clearScreen() {
  background(0);
}

class Cell {
  int x, y;
  
  Cell(int xin, int yin) {
    x = xin;
    y = yin;
  }

    // Perform action based on surroundings
  void run() {
    // Fix cell coordinates
    while(x < 0) {
      x+=width;
    }
    while(x > width - 1) {
      x-=width;
    }
    while(y < 0) {
      y+=height;
    }
    while(y > height - 1) {
      y-=height;
    }
    
    // Cell instructions
    if (w.getpix(x + 1, y) != dust_color ) {
      move(0, 1);
    } else if (w.getpix(x, y - 1) == dust_color && w.getpix(x, y + 1) == dust_color) {
      move((int)random(9) - 4, (int)random(9) - 4);
    }
  }
  
  // Will move the cell (dx, dy) units if that space is empty
  void move(int dx, int dy) {
    if (w.getpix(x + dx, y + dy) != dust_color) {
      w.setpix(x + dx, y + dy, w.getpix(x, y));
      w.setpix(x, y, color(0));
      x += dx;
      y += dy;
    }
  }
}

//  The World class simply provides two functions, get and set, which access the
//  display in the same way as getPixel and setPixel.  The only difference is that
//  the World class's get and set do screen wraparound ("toroidal coordinates").
class World {
  
  void setpix(int x, int y, int c) {
    while(x < 0) x+=width;
    while(x > width - 1) x-=width;
    while(y < 0) y+=height;
    while(y > height - 1) y-=height;
    set(x, y, c);
  }
  
  color getpix(int x, int y) {
    while(x < 0) x+=width;
    while(x > width - 1) x-=width;
    while(y < 0) y+=height;
    while(y > height - 1) y-=height;
    return get(x, y);
  }
}

void changeLights() {
  numcells = 0;
  reset();
}

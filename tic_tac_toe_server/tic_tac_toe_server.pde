
//server (sends X's (2))
import processing.net.*;

color green = #00DA3C; //our turn
color red = #DF151A;  //waiting
boolean itsMyTurn = true;

Server myServer;

int[][] grid;

void setup() { 
  size(300, 400);
  grid = new int [3][3];
  strokeWeight(3);
  textAlign(CENTER, CENTER);
  textSize(50);
  //grid [0][2] = 9;
  myServer = new Server(this, 1234);
}


void draw() {
  if (itsMyTurn == true) {
    background (green);
  } else {
    background (red);
  }
  stroke(0);
  line(0, 100, 300, 100);
  line(0, 200, 300, 200);
  line(100, 0, 100, 300);
  line(200, 0, 200, 300);


  int col = 0;
  int row = 0;
  while (row < 3) {
    //print(grid[row][col]);
    drawXO(row, col);
    col++;
    if (col == 3) {
      col = 0;
      row++;
      println("");
    }
  }
  fill(0);
  text(mouseX + "," + mouseY, 150, 350);

  Client myClient = myServer.available();
  if (myClient != null) {
    String incoming = myClient.readString();
    int r = int(incoming.substring(0, 1));
    int c = int(incoming.substring(2, 3));
    grid[r][c] = 1;
    itsMyTurn = true;
  }
}


void drawXO(int row, int col) {
  pushMatrix();
  translate(row*100, col*100);
  if (grid[row][col] == 1) {
    fill(255);
    ellipse(50, 50, 90, 90);
  } else if (grid[row][col] == 2) {
    line(10, 10, 90, 90);
    line(90, 10, 10, 90);
  }
  popMatrix();
}


void mouseReleased() {
  if (mouseY < 300 && mouseX < 300) {
    int row = mouseX/100;
    int col = mouseY/100;
    if (itsMyTurn == true && grid[row][col] == 0) { //&& mouseY < 300 && mouseX < 300 && mouseY > 0 && mouseX > 0)
      grid[row][col] = 2;
      myServer.write(row + "," + col);
      itsMyTurn = false;
      println(row + "," + col);
    }
  }
}

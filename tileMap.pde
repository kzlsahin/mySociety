/*this is the working version of tilemap game prototype.
Please do not change original files
@date  : 04.05.2020
@Author: Mustafa Şentürk
@version 1.0
*/
import java.util.Map;
PImage homeImg, roadImg, grassImg, parkImg, emptyImg;
PImage[] terrainImages = new PImage[10];
PImage[] buildingImages = new PImage[10];
int pixelSquare = 100; // 100x100 images
float centerX; // center tile is the one on the left corner of a diomand
float centerY;
float sqHorizontalWidth = 120;
float ratioYtoX = 0.5;
float viewScale = 1.0;
int tileNumber = 100; // tile number in a single row
int tileNumberTotal = tileNumber * tileNumber; //sonra isimleri düzeltmeliyim
float[] tiles = new float[tileNumberTotal];
PVector[] tileVectors = new PVector[tileNumberTotal];

String imageFilePath = "data/images/";
PImage[] tileImages = new PImage[tileNumberTotal];
int[] tileImageIDs = new int[tileNumberTotal];

float circleX, circleY, circleSpeed = 0.1, circleI = 0., circleJ = 0.;
Boolean showCoords = false;
Boolean dataSetted = false;
Boolean loadData = false;
Boolean movingMap = false;
color gridColor = color(80);
MapIndex map_index;
Construction construction = new Construction();
//Selection Grid coordinate system origin to image origin
PVector offsets = new PVector(0., 0.);
float mapMoveX, mapMoveY;
PVector mapViewPoint = new PVector(0., 0.);
float mapScrollSpeed = 15.;
int timer = 0;

//whic building is selected?
SelectedItem item_selected = new SelectedItem();
String[] map_terrain_IDS;
MapObstacleArray obstacles = new MapObstacleArray(tileNumberTotal);

Envanter envanter;
ToolBar Tools;
ImageData imageData;

void setup() {
  size(800,500);
  surface.setTitle("mySociaty");
  surface.setResizable(true);
  surface.setLocation(100, 100);
  frameRate(30);
  background(90);
  cursor(HAND);
  //sqEdgeLength = viewScale * sqrt((sq(sqHorizontalWidth) / 4) * (ratioYtoX +1));
}

void draw() {

  if (loadData) {
    setData();
  } else if (!dataSetted) {
    textSize(20);
    stroke(255, 0, 0);
    text("loading...", 300., 300.);
    loadData = true;
  } else {
    background(90);
    map_index.drawLines();
    renderTiles();
    Tools.drawToolBar();
    construction.render();
    moveMap();
  }
  //ellipse(width/2, height/2, 5, 5);
  //end of draw
}

void renderTiles() {
  int n = tileNumber -1;
  for (int i=0; i < tileNumber; i++) {
    for (int k=0; k <= i; k++) {
      //println(i + " " + k);
      int index = n - i + (n + 2) * k;
      if (tileImages[index] != null && tileVectors[index].x > -200 && tileVectors[index].y > -100) {
        //image(tileImages[index], tileVectors[index].x - 17, tileVectors[index].y - 73);
         imageData.getImage(tileImageIDs[index]).render(tileVectors[index].x, tileVectors[index].y);
      }
    }
  }
  for (int i=1; i <= n; i++) {
    for (int k=0; k <= n - i; k++) {
      // println(i + " " + k);
      int index = i * tileNumber + (n + 2) * k;
      if (tileImages[index] != null && tileVectors[index].x > - 200 && tileVectors[index].y > -100) {
        //image(tileImages[index], tileVectors[index].x - 17, tileVectors[index].y - 73);
         imageData.getImage(tileImageIDs[index]).render(tileVectors[index].x, tileVectors[index].y);
    }
    }
  }
  //end of render tiles
}

void insertTiles() {
  //sets the coordinates of the tiles
  for (int i = 0; i< tileNumber; i++) {
    for (int j = 0; j<tileNumber; j++) {
      int index = i * tileNumber + j;
      float createdX = centerX + (i + j) * (sqHorizontalWidth / 2) * viewScale;
      float createdY = centerY + (i - j) * (sqHorizontalWidth / 2) * ratioYtoX * viewScale;
      tileVectors[index] = new PVector(createdX, createdY);
    }
  }
  //end of insertTiles
}

void updateTileCoords() {
  //updates the coordinates of the tiles
  for (int i = 0; i< tileNumber; i++) {
    for (int j = 0; j<tileNumber; j++) {
      int index = i * tileNumber + j;
      float createdX = centerX + (i + j) * (sqHorizontalWidth / 2) * viewScale;
      float createdY = centerY + (i - j) * (sqHorizontalWidth / 2) * ratioYtoX * viewScale;
      tileVectors[index].x = createdX;
      tileVectors[index].y = createdY;
    }
  }
  //end of updateTiles
}

void setTerrainImages() {
  //assigns images to tiles
  for (int i = 0; i< tileNumber; i++) {
    for (int j = 0; j<tileNumber; j++) {
      int index = i * tileNumber + j;
      tileImages[index] = buildingImages[2];
      tileImageIDs[index] = floor(random(6));
      /*if ((i % 5) == 0) {
       tileImages[index] = roadImg;
       } else if (j%5 == 0) {
       tileImages[index] = roadImg;
       } else if (i%5 == 1) {
       tileImages[index] = grassImg;
       } else if (j%5 == 2) {
       if (i%6 == 1) {
       tileImages[index] = parkImg;
       }
       else {
       tileImages[index] = grassImg;
       }
       } else {
       tileImages[index] = homeImg;
       }*/
    }
  }
  //tileImages[2] = emptyImg;
  //end of updateTileİmages
}

void mousePressed() {
  if (mouseButton == LEFT) {
    if (item_selected.ready) {
      int index = map_index.selectedGridIndex(mouseX, mouseY);
        construction.addConstruction(index);
    }
  }
  if (mouseButton == RIGHT) {
    if (item_selected.ready) {
      item_selected.ready = false;
       construction.releaseItem();
    }
  }
  //end of mouseClicked
}

void releaseTile() {
}

void setData() {

  centerX = - 100;
  centerY = height / 2;
  circleX = centerX + 25.;
  circleY = centerY + 100.;
  insertTiles();
  map_index = new MapIndex(new PVector(centerX, centerY), offsets, tileNumber);
  envanter = new Envanter();
  buildingImages = envanter.Buildings.requestImages();
  Tools = new ToolBar();
  dataSetted = true;
  loadData = false;
  setTerrainImages();
  imageData = new ImageData();
}



static class ControlerKeys {
  static Boolean _right = false;
  static Boolean _left = false;
  static Boolean _up = false;
  static Boolean _down= false;
  static Boolean _center= false;
  ControlerKeys() {
  }

  static void updateCodedControler(boolean b, int k) {
    switch (k) {
    case UP:
      ControlerKeys._up = b;
      //println(Controlers._up );
      break;
    case DOWN:
      ControlerKeys._down = b;
      break;
    case LEFT:
      ControlerKeys._left = b;
      break;
    case RIGHT:
      ControlerKeys._right = b;
      break;
    default:
      break;
    }
  }

  static void updateTypedControler(boolean b, int k) {
    switch (k) {
    case 'c':
      ControlerKeys._center = b;
      println("pressed");
      break;
    }
  }
}

void keyPressed() {
  if (key == CODED) {
    ControlerKeys.updateCodedControler(true, keyCode);
  } else {
    ControlerKeys.updateTypedControler(true, key);
  }
  if (key == 'b') {
    item_selected.ready = true;
  }
}

void keyReleased() {
  if (key == CODED) {
    ControlerKeys.updateCodedControler(false, keyCode);
  } else {
    ControlerKeys.updateTypedControler(false, key);
  }
}

void moveMap() {
  if (ControlerKeys._up) {
    centerY += mapScrollSpeed;
  }
  if (ControlerKeys._down) {
    centerY -= mapScrollSpeed;
  }
  if (ControlerKeys._left) {
    centerX += mapScrollSpeed;
  }
  if (ControlerKeys._right) {
    centerX -= mapScrollSpeed;
  }
  updateTileCoords();
  map_index.updateCoords(centerX, centerY);

  //scroll the map by mouse
  if (mousePressed && movingMap && !item_selected.ready) {
    centerX += mouseX - pmouseX;
    centerY += mouseY - pmouseY;
    updateTileCoords();
    map_index.updateCoords(centerX, centerY);
  } else if (mousePressed && !item_selected.ready) {  //inorder to gain smoothness
    movingMap = true;
  } else {
    movingMap = false;
  }
  //end of moveMap
}

class SelectedItem {
  String category;
  String name;
  int ID;
  int[] parcel = new int[2];
  Boolean ready = false;
  SelectedItem() {
  }
  //end of class SelectedItem
}

class MapObstacleArray {
  int map_tile_number;
  String[] name_of_obstacle;
  //is the obstacle bonded
  Boolean[] bonded;
  int[] map_index_bonded_to;

  
  MapObstacleArray(int arrayLength) {
    map_tile_number = arrayLength;
    name_of_obstacle = new String[arrayLength];
    //is the obstacle bonded
    bonded = new Boolean[arrayLength];
    map_index_bonded_to = new int[arrayLength];
    for (int i = 0; i < map_tile_number; i++) {
      name_of_obstacle[i] = "grass"; //get from terrain map
      bonded[i] = false;
      map_index_bonded_to = null;
    }
//end of initialiser
  }

    Boolean parcel_available(int indis) {
    int[] parcel = item_selected.parcel;
    Boolean multiParcel = parcel[0] > 1 || parcel[1] > 1;
    //is parcel available to build
    Boolean available = name_of_obstacle[indis] == "grass";

      if (multiParcel) {
        int i;
        for (int row = 0; row < parcel[0]; row++) {
          for (int col=0; col < parcel[1]; col++) {
            //row * tileNumber moves the indis one row
            i = indis + (row * tileNumber) + col;
            if (available) {
              available = name_of_obstacle[i] == "grass";
            }
            //map_index_bonded_to[i] = indis;
          }
        } 
        return available;
      }
      
return available;
//end of parcel_available
}

void change(int indis, String name) {
  int[] parcel = item_selected.parcel;
  //is parcel consist of multiple tiles
  Boolean multiParcel = parcel[0] > 1 || parcel[1] > 1;



  if (multiParcel) {
    int i;
    for (int row = 0; row < parcel[0]; row++) {
      for (int col=0; col < parcel[1]; col++) {
        //row * tileNumber moves the indis one row
        i = indis + (row * tileNumber) + col;
        name_of_obstacle[i] = name;
        bonded[i] = true;
        //map_index_bonded_to[i] = indis;
      }
    }
  } else {
    name_of_obstacle[indis] = name;
  }

  //end of change
}
//end of class  MapObstacleArray
}

void changeViewScale(float scale, float recentScale){
  if((viewScale > 0.4 && scale < 0) || (scale > 0 && viewScale < 2.0)){
  viewScale += scale;

  //centerX to screen center
  float distX = centerX - width/2;
  float distY = centerY - height/2;
  //new position distances
  distX *= viewScale / recentScale;
  distY *= viewScale / recentScale;
  centerX = distX + width / 2;
  centerY = distY + height / 2;
  imageData.resizeImages();
  updateTileCoords();
  updateTileCoords();
  map_index.scale();
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  changeViewScale(0.1*abs(e)/e, viewScale);
  println(viewScale);
  // end of mousewheel
}

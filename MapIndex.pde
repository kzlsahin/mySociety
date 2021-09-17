class MapIndex {
  int index;
  int rowNumber;
  float slope; //mX + k = y: m = grdiRatioYtoX, k = offsetGrid
  float centerX, centerY;
  float horizontal_length;
  float vertical_length;
  float mapDepth;
  PVector offsets = new PVector(0., 0.);
  Boolean insideTileMap = false;

  MapIndex(PVector center, PVector centerOffset, int tileNumberInRow) {
    rowNumber = tileNumberInRow;
    slope = ratioYtoX;
    offsets.x = centerOffset.x;
    offsets.y = centerOffset.y;
    centerX = center.x + offsets.x;
    centerY = center.y + offsets.y;
    //screen parallel lengths in pixel
    horizontal_length = sqHorizontalWidth * viewScale;
    vertical_length = horizontal_length * slope * viewScale;
    mapDepth = vertical_length * 2 * rowNumber;
    //end of selectGridIndex
  }

  int selectedGridIndex(float posX, float posY) {
    /*
    Attention! This function returns index value of input position. 
    ***It is not guaranteed to be in the tileMap
    relative coordinate system transformation
    positive upwards, j coloumn, left to bottom, i row, left to top
    */
    
    float X = posX - centerX;
    float Y = (-1) * (posY - centerY);//as height are inversely positive
    int row, coloumn;
    float m, kquery;
    m = slope;

    //looking for coloumn
    kquery = Y + m * X;
    coloumn = floor(kquery/vertical_length);
    //println(mapDepth);
    //println(vertical_length);
    //print(kquery);
    //looking for row
    kquery = (Y - m * X) * -1;
    row = floor(kquery/vertical_length);
    //println("  " + kquery);
    //println(row + "  " + coloumn);

    index = coloumn + row * rowNumber;
    //println(row + "   " + coloumn);
    if(index > 0 && index < tileNumberTotal && !insideTileMap)
    {
      insideTileMap = true;
    }
    return index;
    //end of selectGridIndex
  }
  
  void releaseSelected(){
    
  }

  void drawLines() {
    /*
    bu fonksiyonun işleyişi biraz karmaşık gelebilir.
    Esas olan şu ki, gridin center noktasından çıktığı ve tam farklarla 
    kenara en yaklaştığı hizaları belirleyip 
    buraları başlangıç noktası yaparak çizgileri çiziyor.
    kenarlarda boşluk kalmaması için bir tam dörtgenlik harita dışına taşıyor.
    horizontal_length bir dörtgenin yatay köşegen uzunluğunu
    vertical_length ise bir dörtgenin dikey köşegen uzunluğunu ifade eder
    */
    float offsetY = vertical_length;
    float offsetX =  horizontal_length;
    stroke(gridColor);
    strokeWeight(2);

    float lineY = centerY % offsetY;
    float lineX = centerX % offsetX - offsetX;
    for (; lineY<height; lineY += offsetY) {
      line(lineX, lineY, width, lineY - (width - lineX) * slope);
      line(lineX, lineY, lineX + (height - lineY) / slope, height);
    }
    float lastHeight = lineY;
    lineY = centerY % offsetY;
    lineX = centerX % offsetX - offsetX;
    for (; lineX<width; lineX += offsetX) {
      line(lineX, lineY, lineX + (height-lineY) / slope, height);
      line(lineX, lastHeight, width, lastHeight - (width - lineX) * slope);
    }
    ellipse(centerX, centerY, 10, 10);
    //end of drawLines
  }

  void updateCoords(float X, float Y) {
    this.centerX = X + this.offsets.x;
    this.centerY = Y + this.offsets.y;

    //end of updateCoords
  }
  
 void scale(){
   this.horizontal_length = sqHorizontalWidth * viewScale;
   this.vertical_length = horizontal_length * slope;
   println(this.horizontal_length);
   
 }

  //end of MapIndex Class
}

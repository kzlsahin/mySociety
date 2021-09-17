class Construction {
  Boolean followMouse = false;
  Boolean roadBegan = false;
  Boolean roadRow = true;
  Boolean roadDirected = false;
  int roadFirstTileIndex = 0;
  int[] path;

  Boolean parcelAssigning = false;
  int parcelFirstTileIndex = 0;
  void render()
  {  

    int index = map_index.selectedGridIndex(mouseX, mouseY);
    textSize(20);
    fill(0);
    if (item_selected.ready) {
      preview(index);
    }
    if (roadBegan) {
      roadPreview();
    }
    if (parcelAssigning) {
      parcelPreview();
    }
  }

  void addConstruction(int index) {
    Boolean onTheMap = index >= 0 && index < tileNumberTotal;
    if (onTheMap) {
      switch (item_selected.category) {
      case "Buildings":
        constructBuilding(index);
        break;
      case "Roads":
        constructRoad();
        break;
      case "Farms":
        assignParcel();
        break;
      case "Residents":
        assignParcel();
        break;
      }
    }
    // end of addConstruction
  }

  void removeParcels(int i, int[] parcel) {
    int leftTileNum = parcel[0];
    int rightTileNum = parcel[1];
    //index is of the tile at the left top
    int indis;
    for (int row = 0; row < leftTileNum; row++) {
      for (int col=0; col < rightTileNum; col++) {
        //row * tileNumber moves the indis one row
        indis = i + (row * tileNumber) + col;
        tileImages[indis] =  null;
      }
    }
    // end of removeParcels
  }

  void preview(int index) {
    ImageDataObject preImage;
    Boolean imageSet = false;
    Boolean onTheMap = index >= 0 && index < tileNumberTotal;
    Boolean available = false;

    preImage = imageData.getImage(item_selected.name);
    imageSet = true;

    if (imageSet) {
      if (onTheMap) {

        available = obstacles.parcel_available(index);
        if (available) {
          //indicate by color if parcel availble to build or not
          tint(255, 180);
        } else if (!available) {
          tint(180, 0, 0, 140);
        }

        preImage.render(tileVectors[index].x, tileVectors[index].y);
      } else {
        preImage.render(mouseX, mouseY);
      }

      tint(255, 255);
    }
    //end of preview
  }



  void planConstruction() {
  }//end of begibBuilding


  void beginConstruction() {
  }

  void constructionFinished() {
  }

  void assignParcel() {
    int mouseIndex = map_index.selectedGridIndex(mouseX, mouseY);
    Boolean available = false;
    int rowStart = floor(parcelFirstTileIndex / tileNumber);
    int colStart = parcelFirstTileIndex % tileNumber;
    int row = floor(mouseIndex / tileNumber);
    int col = mouseIndex % tileNumber;
    int index;
    int rowStep = 1;
    int colStep = 1;
    if ((row - rowStart)  != 0) {
      rowStep = (row - rowStart) / abs(row - rowStart);
    }
    if ((col - colStart)!= 0) {
      colStep = (col - colStart) / abs(col - colStart);
    }
    if (item_selected.ready && parcelAssigning) {
      for (int i = 0; i < abs(row - rowStart) +1; i++) {
        for (int j = 0; j < abs(col - colStart) + 1; j++) {
          index = (rowStart + i * rowStep) * tileNumber + colStart + j * colStep;
          println(index);
          available = obstacles.parcel_available(index);
          if (available) {
            removeParcels(index, item_selected.parcel);
            tileImages[index] = buildingImages[item_selected.ID];
            tileImageIDs[index] = imageData.getImage(item_selected.name).ID;
            obstacles.change(index, item_selected.name);
          }
        }
      }
      parcelAssigning = false;
    } else if (item_selected.ready && !parcelAssigning) {
      parcelFirstTileIndex = mouseIndex;
      println("roadFirstTileIndex is set" + parcelFirstTileIndex);
      parcelAssigning = true;
    }
    //end of assingParcel
  }
  void constructBuilding(int index) {
    Boolean available  = obstacles.parcel_available(index);
    if (item_selected.ready && available) {
      //first clear the parcel
      removeParcels(index, item_selected.parcel );
      tileImages[index] = buildingImages[item_selected.ID];
      tileImageIDs[index] = imageData.getImage(item_selected.name).ID;
      obstacles.change(index, item_selected.name);
    } else if (item_selected.ready) {
      fill(255, 50, 50);
      text("Sory! cant build there", mouseX, mouseY - 50);
    }
    //end of constructBuilding
  }


  void constructRoad() {
    int mouseIndex = map_index.selectedGridIndex(mouseX, mouseY);
    Boolean available = false;

    println(roadFirstTileIndex);
    if (item_selected.ready && roadBegan) {
      path = drawPath(roadFirstTileIndex, mouseIndex);
      for (int i = 0; i < path.length; i++) {
        available = obstacles.parcel_available(path[i]);
        //println(path);
        if (available) {
          removeParcels(path[i], item_selected.parcel);
          //println(item_selected.parcel);
          tileImages[path[i]] = buildingImages[item_selected.ID];
          tileImageIDs[path[i]] = imageData.getImage(item_selected.name).ID;
          obstacles.change(path[i], item_selected.name);
        }
      }
      roadBegan = false;
    } else if (!roadBegan) {
      roadFirstTileIndex = map_index.selectedGridIndex(mouseX, mouseY);
      println("roadFirstTileIndex is set" + roadFirstTileIndex);
      roadBegan = true;
    } 
    //end of construct Road
  }

  int[] drawPath(int startIndex, int targetIndex) {
    int[] path; 
    int[] startTile = new int[2];
    int[] destTile = new int[2];
    startTile[0] = rowCoord(startIndex);
    startTile[1] = colCoord(startIndex);
    destTile[0] = rowCoord(targetIndex);
    destTile[1] = colCoord(targetIndex);
    int diffRow = destTile[0] - startTile[0];
    int diffCol = destTile[1] - startTile[1];
    path = new int[abs(diffRow) + abs(diffCol) + 1];
    println("first tile index  " + roadFirstTileIndex);
    println("targetIndex :" + targetIndex);
    //println("coord target :" + rowCoord(targetIndex) + colCoord(targetIndex));
    //println("diffRow  " + diffRow + "  " +  startTile[0]);
    //println("diffCol  " + diffCol + "   "+  startTile[1]);
    path[0] = startIndex;

    if ( path.length > 1) {
      if (!roadRow) {
        int indis = 1;
        if (diffCol != 0) {
          int diff = diffCol / abs(diffCol);
          for (int j = 1; j <= abs(diffCol); j++) {
            path[indis] = startTile[0] * tileNumber + startTile[1] + diff * j;
            indis++;
          }
        }
        if (diffRow != 0) {
          int diff = diffRow / abs(diffRow);
          for (int i = 1; i <= abs(diffRow); i++) {
            path[indis] = (startTile[0] + diff * i) * tileNumber + destTile[1];
            indis++;
          }
        }
      } else {
        int indis = 1;
        if (diffRow != 0) {
          int diff = diffRow / abs(diffRow);
          for (int i = 1; i <= abs(diffRow); i++) {
            path[indis++] = (startTile[0] + diff * i) * tileNumber + startTile[1];
          }
        }
        if (diffCol != 0) {
          int diff = diffCol / abs(diffCol);
          for (int j = 1; j <= abs(diffCol); j++) {
            path[indis++] = destTile[0] * tileNumber + startTile[1] + diff * j;
          }
        }
      }
    }
    return path;
  }

  void roadPreview() {
    if(!mousePressed){
      constructRoad();
      roadBegan = false;
    }
    ImageDataObject preRoadImage;
    int mouseIndex = map_index.selectedGridIndex(mouseX, mouseY);
    Boolean imageSet = false;
    Boolean onTheMap = mouseIndex >= 0 && mouseIndex < tileNumberTotal;
    Boolean available = false;

    //set image
    preRoadImage = imageData.getImage(item_selected.name);
    imageSet = true;

    if (roadBegan && imageSet && onTheMap) {

      if (!roadDirected && mouseIndex != roadFirstTileIndex) {
        roadRow = colCoord(mouseIndex) == colCoord(roadFirstTileIndex);
        roadDirected = true;
      } else if ( mouseIndex == roadFirstTileIndex) {
        roadDirected = false;
      }

      path = drawPath(roadFirstTileIndex, mouseIndex);
      //get availablity
      for (int i = 0; i < path.length; i++) {
        available = obstacles.parcel_available(path[i]);
        if (available) {
          tint(255, 180);
          preRoadImage.render(tileVectors[path[i]].x, tileVectors[path[i]].y);
          //println(path);
        } else {
          tint(180, 0, 0, 140);
          preRoadImage.render(tileVectors[path[i]].x, tileVectors[path[i]].y);
        }
      }
    }
    tint(255, 255);
    println(roadRow);
    //end of roadPreview
  }

  void parcelPreview() {
    if(!mousePressed){
      assignParcel();
      parcelAssigning = false;
    }
    ImageDataObject preRoadImage;
    int mouseIndex = map_index.selectedGridIndex(mouseX, mouseY);
    Boolean available = false;
    Boolean imageSet = false;
    Boolean onTheMap = mouseIndex >= 0 && mouseIndex < tileNumberTotal;
    preRoadImage = imageData.getImage(item_selected.name);
    imageSet = true;
    int rowStart = floor(parcelFirstTileIndex / tileNumber);
    int colStart = parcelFirstTileIndex % tileNumber;
    int row = floor(mouseIndex / tileNumber);
    int col = mouseIndex % tileNumber;
    int index;
    int rowStep = 1;
    int colStep = 1;
    if ((row - rowStart) != 0) {
      rowStep = (row - rowStart) / abs(row - rowStart);
    }
    if ((col - colStart) != 0) {
      colStep = (col - colStart) / abs(col - colStart);
    }
    if (item_selected.ready && parcelAssigning && onTheMap) {
      for (int i = 0; i < abs(row - rowStart) +1; i++) {
        for (int j = 0; j < abs(col - colStart) + 1; j++) {
          index = (rowStart + i * rowStep) * tileNumber + colStart + j * colStep;
          println(index);
          available = obstacles.parcel_available(index);
          if (available) {
            tint(255, 180);
            preRoadImage.render(tileVectors[index].x, tileVectors[index].y);
          } else {
            tint(180, 0, 0, 140);
            preRoadImage.render(tileVectors[index].x, tileVectors[index].y);
          }
        }
      }
    }
    tint(255, 255);
    //end of parcelPreview
  }


  int rowCoord(int i) {
    int row = floor(i/tileNumber);
    return row;
  }

  int colCoord(int i) {
    int col = i - floor(i/tileNumber) * tileNumber;
    return col;
  }

  void releaseItem() {
    if (!item_selected.ready) {
      roadBegan = false;
      println("item released");
    }

    roadDirected = false;
  }



  //end of class Building
}

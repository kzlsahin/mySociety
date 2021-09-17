class ImageData {
  HashMap<String, ImageDataObject> imagesEnvanter = new HashMap<String, ImageDataObject>();
  StringList imageDataNameArray = new StringList();
  
  ImageData() {
    loadData();
  }
  
  void resizeImages(){
    loadData();
    for(int i = 0; i < imagesEnvanter.size(); i++){
      imagesEnvanter.get(imageDataNameArray.get(i)).selfResize();
    }
  }
  
   ImageDataObject getImage(String name) {
    return imagesEnvanter.get(name);
  }
  
     ImageDataObject getImage(int ID) {
    return imagesEnvanter.get(imageDataNameArray.get(ID));
  }
  
  void loadData(){
    JSONArray JSONImages = loadJSONArray("data/images/images.json");
    int ID = 0;
    for (int i = 0; i < JSONImages.size(); i++) {
      JSONObject obj = JSONImages.getJSONObject(i);
      ImageDataObject imageObject = new ImageDataObject(obj.getString("fileName"), obj.getJSONArray("offset"), ID);
      imagesEnvanter.put(obj.getString("fileName"), imageObject);
      imageDataNameArray.append(imageObject.name);
      ID++;
    }
  }

  //End of Image Data
}

class ImageDataObject {
  String name;
  /*
  offset of the tile left corner from the image left top corner
   */
  int[] initialOffset = new int[2];
  int[] offset = new int[2];
  PImage image;
  int ID;
  int[] initialSize = new int[2];

  ImageDataObject(String name, JSONArray offset, int ID) {
    this.name = name;
    this.initialOffset[0] = offset.getInt(0);
    this.initialOffset[1] = offset.getInt(1);
    this.image = loadImage(imageFilePath + name);
    initialSize[0]= this.image.width;
    initialSize[1]= this.image.height;
    this.ID = ID;
    println(name + " imageObject created ID: " + this.ID );
    selfResize();
  }

  void render(float xPos, float yPos) {
    image(this.image, xPos - this.offset[0], yPos - this.offset[1]);
  }
  
  void selfResize(){
    this.offset[0] = int(this.initialOffset[0] * viewScale);
    this.offset[1] = int(this.initialOffset[1] * viewScale);
    this.image.resize(int(initialSize[0] * viewScale), int(initialSize[1] * viewScale));
  }
}

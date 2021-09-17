class Envanter {
  //envanter IDs are the index of JSON array
  HashMap<String, EnvanterData> envanterDict = new HashMap<String, EnvanterData>();
  
  EnvanterData Buildings = new EnvanterData("Buildings");//category names should start UpperCase
  EnvanterData Roads = new EnvanterData("Roads");
  EnvanterData Farms = new EnvanterData("Farms");
  EnvanterData Residents = new EnvanterData("Residents");
   
  Envanter() {
  
  }

  class EnvanterData {
    String category;
    JSONObject[] data;
    IntDict dict;

    EnvanterData(String category) {
      this.category = category;
      loadData();
      envanterDict.put(this.category, this);
    }
    void loadData() {
      JSONArray arr = loadJSONArray("data/"+category+".json");
      data = new JSONObject[arr.size()];
      dict = new IntDict();
      for (int i = 0; i < arr.size(); i++) {
        data[i] = arr.getJSONObject(i);
        dict.set(data[i].getString("name"), i);
        println(data[i].getString("name"));
      }
    }
    
    String getNameByID(int id) {
    String name;
    name = data[id].getString("name");
    return name;
  }
  
    int getIDByName(String name) {
    int id;
    id = dict.get(name);
    return id;
  }
   PImage[] requestImages(){
    int size = data.length;
    PImage[] images = new PImage[size];
    for (int i = 0; i < size; i++) {
          images[i] = loadImage(this.data[i].getString("imageFile"));
      }
      return images;
  }
  //end of EnvanterData
  }
  //end of Envanter
}

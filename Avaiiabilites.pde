
static class Availabilities

{ 
  String[] categories = { "Buildings", "Land", "Trees", "Walls", "Towers", "FarmLand" };
  String[] obstacles = {"structure", "freeLand", "terrainObj", "fertileLand", "wall"};
  StringDict obstacleDict = new StringDict();
  HashMap <String, Boolean> Buildings = new HashMap <String, Boolean>();
  Boolean[] Terrain = { false, true, false, false, true};
  Boolean[] Trees = { false, true, false, false, true};
  Boolean[] Walls = { false, true, false, false, true};
  Boolean[] Towers = { false, false, false, true, false};


  void setAvailibilitiyData(){
        obstacleDict.set("Buildings", "Structure");
        obstacleDict.set("Land", "freeLand");
        obstacleDict.set("Trees", "terrainObj");
        obstacleDict.set("Walls", "Structure");
        obstacleDict.set("Towers", "Structure");
        obstacleDict.set("FarmLand", "fertileLand");
        
        Buildings.put("Structure", false);
        Buildings.put("freeLand", true);
        Buildings.put("terrainObj", true);
        Buildings.put("fertileLand", true);
        Buildings.put("wall", false);
  }

  String getObstacleType(String name) {
    String obstacle;
    obstacle = obstacleDict.get(name);
    return obstacle;
  }
  
  Boolean doesContain(String[] Arr, String name){
    Boolean res = false;
    for(String n : Arr){
      if(!res){
      res = n == name;
      }
    }
    return res;
  }
  
  Boolean isAvailable(String name){
    Boolean res = false;
    if(doesContain(categories, name)){
       res =Buildings.get(getObstacleType(name));
    }
    return res;
  }

 
}

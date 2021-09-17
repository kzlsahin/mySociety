class ToolBar {
  color buttonFrame = #5F4A29;
  color buttonFill = #D1902E;
  color textFill = #E5D6BE;
  color toolBarFill = #8E532C;
  int textFont = 20;
  int textFontSub = 10;
  PFont font = loadFont("Arial-BoldItalicMT-48.vlw");
  SelectionWindow[] Windows = new SelectionWindow[4];
  RadioButton[] radioButtons = new RadioButton[4];
  Boolean aWindowIsOpen = false;
  float selectionWindowWidth = 150;
  float buttonsTopLine = 35;
  float buttonsThickness = 60.;


  ToolBar() {
    //name should be the reference of envanterData
    radioButtons[0] = new RadioButton("Buildings", 70., buttonsTopLine, buttonsThickness, envanter.Buildings.dict);
    radioButtons[1] = new RadioButton("Roads", 210., buttonsTopLine, buttonsThickness, envanter.Roads.dict);
    radioButtons[2] = new RadioButton("Farms", 350., buttonsTopLine, buttonsThickness, envanter.Farms.dict);
    radioButtons[3] = new RadioButton("Residents", 490., buttonsTopLine, buttonsThickness, envanter.Residents.dict);
  }

  void drawToolBar() {
    stroke(buttonFrame);
    fill(toolBarFill);
    rect(0, 0, width, 40);

    if (mouseOverBar()) {
      drawBar();
      drawResourcesBar();
      drawButtons();
    } 
    //end of drawToolBar
  }

  void drawBar() {
    stroke(buttonFrame);
    fill(toolBarFill);
    rect(0, 0, width*0.4, 70);
  }

  void drawButtons() {
    for (RadioButton Button : radioButtons)
    {
      Button.renderButton();
    }
  }

  void drawResourcesBar() {
  }

  Boolean mouseOverBar() {
    Boolean res = false;
    if (mouseX<width*0.4 && mouseY < 70 || aWindowIsOpen) {
      res = true;
    }
    return res;
    //end of mouseOverBar
  }



  class RadioButton {
    float[] center = new float[2];
    float D;
    float diameterRatio = 2;
    String buttonName;
    SelectionWindow Window;
    float topLeftX;
    float topLeftY;

    RadioButton(String Name, float X, float Y, float diameter, IntDict list) {
      buttonName = Name;
      center[0] = X;
      center[1] = Y;
      D = diameter;
      topLeftX = center[0] - D * diameterRatio / 2;
      topLeftY = center[1] + D / 2;
      Window = new SelectionWindow(Name, list, selectionWindowWidth, topLeftX, topLeftY);
    }

    void renderButton() {
      stroke(buttonFrame);
      fill(buttonFill);
      ellipse(center[0], center[1], D * diameterRatio, D);
      fill(textFill);
      textAlign(CENTER, CENTER);
      textFont(font, textFont);
      text(buttonName, center[0], center[1], textFont);

      if (Window.opened) {
        Window.render();
      }
      //İf mouse over button open the list window
      trackMouse(mouseX, mouseY);

      //ende of render button
    }

    void trackMouse(float X, float Y) {
      float distence = sqrt(sq(X - center[0]) + sq(Y - center[1]));
      if (distence < D && !aWindowIsOpen) {
        Window.open(X, Y);
      }
      //return over;
      //end of overButton
    }

    //End of class RadioButton
  }




  class SelectionWindow {
    Boolean opened = false;
    //is the mouse over one of the items
    Boolean mouseOverItem = false;
    float cornerX, cornerY;
    String category;
    float windowW, windowH;
    float itemListTopX;
    float itemListTopY;
    float lineOffset = textFont * 1.3;
    String[] textArray;



    SelectionWindow(String category, IntDict EList, float w, float topLeftX, float toplLeftY) {
      cornerX = topLeftX;
      cornerY = toplLeftY;
      this.category = category;
      windowW = w;
      windowH = EList.size() * lineOffset + lineOffset * 0.5 ;
      itemListTopX = cornerX + windowW * 0.1;
      itemListTopY = cornerY + textFontSub;
      textArray = EList.keyArray();
    }
      
    void render() {
      if (opened) {
        drawListingWindow();
        closeWindow(mouseX, mouseY);
      }
      //end of render
    }

    void drawListingWindow() {
      stroke(buttonFrame);
      fill(buttonFill);
      rectMode(CORNER);
      rect(cornerX, cornerY, windowW, windowH);

      //Enlisting Envanter Keys

      fill(textFill);
      textAlign(LEFT, TOP);
      textSize(textFontSub);
      textFont(font, textFont);
      //even if the mouse is not over an item the value of this index will be zero
      int index_mouse_over = index_of_item();
      for (int i = 0; i < textArray.length; i++) {
        if (mouseOverItem && index_mouse_over == i && !item_selected.ready) {
          highLightItem(i);
          if(mousePressed){
          selectItem(i);
          }
        }
        text(textArray[i], itemListTopX, itemListTopY + (lineOffset * i), textFont);
      }
      //end of drawListingWindow
    }

    int index_of_item() {
      int index = 0;
      float relativeMouseY = mouseY - itemListTopY;
      float listLength = lineOffset * (textArray.length + 1); 
      Boolean x = (mouseX > itemListTopX && mouseX < itemListTopX + listLength);
      Boolean y = (mouseY < itemListTopY + windowH && mouseY > itemListTopY);

      if(x && y){
        index = floor(relativeMouseY/lineOffset); 
        mouseOverItem = true;
      } else {
        mouseOverItem = false;
      }
      
      return index;
      //end of index_of_item
    }

    void highLightItem(int i) {
      rectMode(CORNER);
      fill(232, 107, 50, 150);
      noStroke();
      float Y = itemListTopY + (lineOffset * i);
      rect(cornerX, Y, windowW, lineOffset);
      fill(textFill);
      //end of highlightItem
    }
    
    void selectItem(int i){
      if(mousePressed && mouseButton == LEFT){
      item_selected.category = this.category;
      item_selected.name = textArray[i];
      item_selected.ID = i;
      item_selected.ready = true;
      println(this.category + " " + textArray[i]);
      }
      //*****performans iyileştirmesi yapılabilir
      String[] args = split(envanter.envanterDict.get(this.category).data[item_selected.ID].getString("parcel"), 'x');
      item_selected.parcel[0] = int(args[0]);
      item_selected.parcel[1] = int(args[1]);
      //end of selectedItem
    }

    void open(float X, float Y) {
      if (!opened) {
        opened = true;
        aWindowIsOpen = true;
      }
      //end of open
    }

    void closeWindow(float X, float Y) {
      Boolean boolX = X > cornerX && ((X - cornerX) < windowW);
      Boolean boolY = Y < (windowH + buttonsTopLine * 2);
      if (!(boolX && boolY)) {
        opened = false;
        aWindowIsOpen = false;
      }
      //end of close
    }


    //end of class SelectionWindow
  }

  //End of ToolBar
}

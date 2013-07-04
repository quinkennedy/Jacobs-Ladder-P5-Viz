float realHeight = 6;//feet
float realWidth = 2;//feet
int inchesPerFoot = 12;
float scale = .16;
int printDPI = 300;
int screenDPI = 72;
int virtualHeight = (int)(realHeight * inchesPerFoot * screenDPI * scale);
int virtualWidth = (int)(realWidth * inchesPerFoot * screenDPI * scale);
int slatHeight = 3;//inches
int slatHeightPixels = (int)(slatHeight * screenDPI * scale);
PGraphics slatDrawer;
PImage[][] slats = 
    new PImage[2][(int)(realHeight * inchesPerFoot / slatHeight)];
int numRibbons = 4;
float ribbonWidth = .5;//inches
float ribbonSpacing = .25;//inches
int ribbonWidthPixels = (int)(ribbonWidth * screenDPI * scale);
int ribbonSpacingPixels = (int)(ribbonSpacing * screenDPI * scale);
int ribbonColor = 0xFF0000FF;//ARGB
int currSlats = 0;
String[] sideText = new String[2];
int textHeight = 90;
int lineHeight = (int)(textHeight * 1.15);
PImage[] ribbon = new PImage[2];

void setup(){
  size(virtualWidth, virtualHeight);
  slatDrawer = createGraphics(virtualWidth, slatHeightPixels);
  for(int i = 0; i < sideText.length; i++){
    sideText[i] = "";
  }
  drawRibbons();
}

void drawRibbons(){
  for(int i = 0; i < ribbon.length; i++){
    slatDrawer.beginDraw();
    slatDrawer.background(0, 0);
    slatDrawer.fill(ribbonColor);
    for(int k = 0; k < numRibbons/2; k++){
      if (i%2 != k%2){continue;}
      int ribbonEdge = 
          ribbonSpacingPixels + k * (ribbonWidthPixels + ribbonSpacingPixels);
      slatDrawer.rect(ribbonEdge, 0, ribbonWidthPixels, slatHeightPixels);
      slatDrawer.rect(virtualWidth - ribbonEdge, 0, -ribbonWidthPixels, slatHeightPixels);
    }
    if (numRibbons%2 == 1 && i%2 == 1){
      //we have an odd number of ribbons, lets put one in the center
      slatDrawer.rect(
          (virtualWidth-ribbonWidthPixels)/2, 0, 
          ribbonWidthPixels, slatHeightPixels);
    }
    slatDrawer.endDraw();
    ribbon[i] = slatDrawer.get();
  }
}

void draw(){
  background(0);
  blendMode(ADD);
  for(int i = 0; i < slats.length; i++){
    pushMatrix();
    for(int j = 0; j < slats[i].length; j++){
      if (slats[i][j] != null){
        image(slats[i][j], 
            0, 0, //x1, y1
            virtualWidth, slatHeightPixels, //x2, y2
            0, (i == currSlats ? 0 : slatHeightPixels), //x1, y1
            virtualWidth, (i == currSlats ? slatHeightPixels : 0)); //x2, y2
      }
      //draw the ribbons the second time since they go over everything
      if(i == slats.length - 1){
        image(ribbon[(i+j+currSlats)%ribbon.length], 0, 0);
      }
      translate(0, slatHeightPixels);
    }
    popMatrix();
  }
}

void keyTyped(){
  sideText[currSlats] += key;
  println(sideText[currSlats]);
  updateSlats(currSlats);
  currSlats = (currSlats + 1) % slats.length;
}

void updateSlats(int i){
  for(int j = 0; j < slats[i].length; j++){
    slatDrawer.beginDraw();
    slatDrawer.background(0, 0);
    int baseFill = 0xFF0000;
    int fullAlpha = 0xFF000000;
    
    /*
    slatDrawer.textAlign(LEFT, TOP);
    slatDrawer.textSize(12);
    slatDrawer.fill(255);
    slatDrawer.text(j, 0, 0);
    */
    slatDrawer.textAlign(CENTER, TOP);
    slatDrawer.textSize(textHeight);
    slatDrawer.fill((baseFill >>> (i * 8)) | fullAlpha);
    slatDrawer.pushMatrix();
      slatDrawer.translate(0, -slatHeightPixels * j);
      for(int k = 0; k < sideText[i].length(); k++){
        slatDrawer.text(
            sideText[currSlats].substring(k, k+1), 
            virtualWidth/2,//virtualWidth/4 * (i*2+1), 
            0);
        slatDrawer.translate(0, lineHeight);
      }
    slatDrawer.popMatrix();
    slatDrawer.endDraw();
    slats[i][j] = slatDrawer.get();
  }
}



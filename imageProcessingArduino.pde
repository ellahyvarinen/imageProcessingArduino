/**
 *   blobfinder  -  detect blobs of given color and size in videoimage
 */
 
//Hello Beautiful World

import processing.serial.*;

Serial myPort;
boolean drawModeOn = false;

color samplecolor = color(0,0,0);  // the color we are looking for (if zero, face color is a default)

int xcr, ycr; // center of a found blob

int showmode = 0;  // 0 = original image, 1 = pixels with found color, 2 = cumulative sums, 3 = correlation with searched blob
boolean HALFSIZE = true;
boolean calibratesize = false;

int blobW, blobH;  // size of colored block to be searched for

PImage img;

int time;

void setup()
{
  if(HALFSIZE) size(320,240);  // this is faster
//  else size(640, 480, P2D);
  cam = new Capture(this, width, height);

  // Start capturing the images from the camera
  cam.start();

  // default blob size (useful for nearby face)
  blobW = (int) (0.22 * width);
  blobH = (int) (0.4 * height);
  // change to square
  blobH = blobW;

  numPixelsX = width;
  numPixelsY = height;
  myMovieColors = new color[numPixelsX * numPixelsY];
  bw = new float[numPixelsX][numPixelsY];
  sums = new float[numPixelsX][numPixelsY];
  correl = new float[numPixelsX][numPixelsY];
  row = new float[numPixelsX];
    
  time = millis();
  img = loadImage("painting.jpg"); //load an image
  
  myPort = new Serial(this, "/dev/tty.usbmodem141301", 9600);
  myPort.bufferUntil('\n'); //button code
}

void draw()
{
  if(!videoready) return;

  findcorrelation(blobW,blobH, 0,numPixelsX, 0,numPixelsY);  // preprocessing
    
  background(0);
  image(mircam, 0,0);
  
  if(showmode > 0)
  for (int j = 0; j < numPixelsY; j++) {
    for (int i = 0; i < numPixelsX; i++) {
      /**/
      if(showmode == 1) {
        image(img, 0, 0, 320,240);
        image(mircam, 0, 0, 80,60);
      }
      else if(showmode == 2) {
        background( 255, 255, 255);
        image(mircam, 0, 0, 80,60);
      }
      point(i,j);
    }
  }

  /** code to show the blob shape
  if(xcr > 0) {
    fill(255,255,50,100);
    ellipse(xcr,ycr, 10,10);
    stroke(255,255,50);
    noFill();
    beginShape();
    vertex(xcr-blobW/2, ycr-blobH/2);
    vertex(xcr-blobW/2, ycr+blobH/2);
    vertex(xcr+blobW/2, ycr+blobH/2);
    vertex(xcr+blobW/2, ycr-blobH/2);
    endShape(CLOSE);
    noStroke();
    calibratesize = true;
   }
  **/
  
  videoready = false;
  
  // drawing app
  //if(keyPressed && keyCode==SHIFT) addpoint(xcr, ycr);
  //drawstroke();
  
  
  if(drawModeOn){
     text("Drawmode on", 120, 120);
     strokes.get(currentStrokeIndex).addpoint(xcr, ycr);
   }
   
   if(currentStrokeIndex > -1) {
     drawstroke();
   }
   

   
  
}

void serialEvent (Serial myPort){
  String buttonMessage = myPort.readStringUntil('\n');
  println(buttonMessage);
  
  if(buttonMessage.contains("on")) {
    println("drawmode on");
    drawModeOn = true;
  }
  else if (buttonMessage.contains("off")) {
    println("drawmode off");
    drawModeOn = false;
  }

}

void mousePressed()
{
  if(showmode > 0) return;
  // store the color of pointed pixel as a new search reference
  else {
    //Create new Stroke and set color
    currentStrokeIndex++;
    strokes.add(currentStrokeIndex, new Stroke());
    strokes.get(currentStrokeIndex).setColor(myMovieColors[mouseY*numPixelsX + mouseX]);
    
    println("new Stroke created with index: " + currentStrokeIndex);

    
    samplecolor = myMovieColors[mouseY*numPixelsX + mouseX];
  }
}

void keyPressed()
{
  if(key == '0') showmode = 0;
  if(key == '1') showmode = 1;
  if(key == '2') showmode = 2;
  //if(key == 'z') saveFrame("dump-####.jpg");
  if(key == 'n') strokes.get(currentStrokeIndex).resetstroke();
  //if(key == 'n') resetstroke();
}

/**   this is for drawing **/
public class Stroke {
   PVector stroke[] = new PVector[100000];
   int N = 0;  // number of points in the stroke
   
   color strokeColor = color(0,0,0); 
   
  public void resetstroke() {
      N = 0;
    }

  public void addpoint(int newx, int newy) {
    if(N == 100000) return;
    stroke[N] = new PVector(newx,newy);
    N++;
  }
  
  public void setColor(color newColor) {
    strokeColor = newColor;
  }
  
  public int getN() {
    return N;
  }
  
  public PVector[] getStroke() {
    return stroke;
  }
  
  public color getColor() {
    return strokeColor;
  }
}

ArrayList<Stroke> strokes = new ArrayList<Stroke>();
int currentStrokeIndex = -1;

void drawstroke() {
    for(int y = 0; y <= currentStrokeIndex; y++) {
      Stroke currentStrokeToDraw = strokes.get(y);
      
      if(currentStrokeToDraw.getN()==0) return;
    
      stroke(currentStrokeToDraw.getColor());
      strokeWeight(10);
      smooth();
    
      for(int i=0;i<currentStrokeToDraw.getN();i++) {
      line(currentStrokeToDraw.getStroke()[i].x, currentStrokeToDraw.getStroke()[i].y, currentStrokeToDraw.getStroke()[i].x, currentStrokeToDraw.getStroke()[i].y);
      }
    }
    
}

/*PVector stroke[] = new PVector[100000];
int N = 0;  // number of points in the stroke

void resetstroke()
{
  N = 0;
}

void addpoint(int newx, int newy)
{
  if(N == 100000) return;
  stroke[N] = new PVector(newx,newy);
  N++;
}

void drawstroke()
{
  if(N==0) return;
  
  stroke(samplecolor);
  strokeWeight(10);
  smooth();
  
  for(int i=0;i<N;i++) {
  line(stroke[i].x, stroke[i].y, stroke[i].x, stroke[i].y);
  }
}*/

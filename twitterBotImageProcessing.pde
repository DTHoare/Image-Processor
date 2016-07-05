//set up globals
ImageProcessor imageProcessor;
ImageCreator imageCreator;
PImage img;
color purple = #7523c1;
color pastelBlue = #99deff;
int randomSeed;
int noiseSeed;

void setup() {
  //load image and set up window
  //PImage img = loadImage("refImage2.jpg");
  imageCreator = new ImageCreator(1024,512);
  img = imageCreator.noiseSquares();
  imageProcessor = new ImageProcessor(img);
  surface.setSize(imageProcessor.baseImage.width, imageProcessor.baseImage.height);
  //only drawing a static image
  //surface.setsize only works at the end of setup()
  //noLoop();
  
  //define a random seed that can be saved
  //this allows duplicate textures to be made
  randomSeed = (int) random(0,pow(2,30));
  noiseSeed = (int) random(0,pow(2,30));
}

void draw() {
  //image(imageProcessor.renderThreeToneFabric(),0,0);
  //image(imageProcessor.renderBrightnessContours(),0,0);
  //image(imageProcessor.linenTexture(purple,255),0,0);
  //image(imageProcessor.fade(imageProcessor.baseImage),0,0);
  
  
  //imageProcessor.setNewImage(imageProcessor.renderBrightnessContours());
  //image(imageProcessor.renderThreeToneFabric(),0,0);
  randomSeed(randomSeed);
  noiseSeed(noiseSeed);
  img = imageCreator.noiseSquares();
  
  imageProcessor.setNewImage(img);
  imageProcessor.setNewImage(imageProcessor.renderBrightnessContours());
  PImage image = imageProcessor.increaseSaturation();
  imageProcessor.setNewImage(image);
  image = imageProcessor.adjustHue();
  
  int pixelSize = 10;
  int xPixels = floor(width/pixelSize) - 2;
  int yPixels = floor(height/pixelSize) - 2;
  image = imageProcessor.pixelate(xPixels,yPixels,pixelSize);
  imageMode(CENTER);
  background(0);
  image(image,width/2,height/2);
  
  //image(imageCreator.noiseSquares(),0,0);
  
  //saveFrame("image###.png");
}
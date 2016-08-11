/* -----------------------------------------------------------------------------
Globals
----------------------------------------------------------------------------- */ 
ImageProcessor imageProcessor;
ImageCreator imageCreator;
PImage img;
color purple = #7523c1;
color pastelBlue = #99deff;
int randomSeed;
int noiseSeed;

/* -----------------------------------------------------------------------------
Setup
----------------------------------------------------------------------------- */ 

void setup() {
  //load image and set up window
  //PImage img = loadImage("waterfall2.jpg");
  imageCreator = new ImageCreator(1024,512);
  PImage img = imageCreator.noiseSquares();
  //img = imageCreator.noiseSquares();
  imageProcessor = new ImageProcessor(img);
  surface.setSize(imageProcessor.baseImage.width, imageProcessor.baseImage.height);
  //only drawing a static image
  //surface.setsize only works at the end of setup()
  noLoop();
  
  //define a random seed that can be saved
  //this allows duplicate textures to be made
  randomSeed = (int) random(0,pow(2,30));
  noiseSeed = (int) random(0,pow(2,30));
}

/* -----------------------------------------------------------------------------
Draw
----------------------------------------------------------------------------- */ 

void draw() {
  //image(imageProcessor.renderThreeToneFabric(),0,0);
  //image(imageProcessor.renderBrightnessContours(),0,0);
  //image(imageProcessor.linenTexture(purple,255),0,0);
  //image(imageProcessor.fade(imageProcessor.baseImage),0,0);
  
  
  //imageProcessor.setNewImage(imageProcessor.renderBrightnessContours());
  //image(imageProcessor.renderThreeToneFabric(),0,0);
  
  abstractPixelGenerative();
  //rainbow();
  //abstractPixelPhoto();
  //abstractContourPhoto();
  
  //image(imageCreator.noiseSquares(),0,0);
  
  save("image.png");
  //saveFrame("image###.png");
  exit();
}

/* -----------------------------------------------------------------------------
Image generation options
----------------------------------------------------------------------------- */ 

void abstractPixelGenerative() {
  //set same starting point
  //animation controlled by frame number
  randomSeed(randomSeed);
  noiseSeed(noiseSeed);
  
  //create image
  PImage img = imageCreator.noiseSquares();
  imageProcessor.setNewImage(img);
  
  //process into colours
  imageProcessor.setNewImage(imageProcessor.renderVividContours());
  if(random(0,1) > 0.2) {
    img= imageProcessor.twoToneHue();
    imageProcessor.setNewImageNoResize(img);
  }
  
  //zoom into center and pixelate
  int pixelSize = (int)random(2,6);
  int xPixels = floor(width/pixelSize) - 2;
  int yPixels = floor(height/pixelSize) - 2;
  img = imageProcessor.pixelateZoom(xPixels,yPixels,pixelSize);
  imageProcessor.setNewImageNoResize(img);
  imageMode(CENTER);
  background(0);
  image(imageProcessor.baseImage,width/2,height/2);
}

void rainbow() {
  PImage img = imageCreator.rainbow();
  image(img,0,0);
}

/* -----------------------------------------------------------------------------
Image processing options
----------------------------------------------------------------------------- */ 

void abstractPixelPhoto() {
  //process into colours
  PImage image = imageProcessor.gammaCorrection(0.2);
  imageProcessor.setNewImage(image);
  image = imageProcessor.renderVividContours();
  imageProcessor.baseImage.filter(BLUR, 16);
  image = imageProcessor.increaseSaturation();
  imageProcessor.setNewImage(image);
  image = imageProcessor.adjustHue();
  imageProcessor.setNewImage(image);
  
  //pixelate
  int pixelSize = 5;
  image = imageProcessor.pixelateAllAverage(pixelSize);
  imageProcessor.setNewImage(image);
  image = imageProcessor.renderBrightnessContours();
  image(image,0,0);
}

void abstractContourPhoto() {
  PImage image = imageProcessor.gammaCorrection(1.4);
  imageProcessor.setNewImage(image);
  image = imageProcessor.renderVividContours();
  image(image,0,0);
}

/* -----------------------------------------------------------------------------
Sigmoid function.
Needs better documentation. Its basically magic
----------------------------------------------------------------------------- */ 

float periodicSigmoid(float magnitude, float transitionSpeed, float period, float v) {
  float x;
  x = magnitude;
  x /= (1+exp(-transitionSpeed*((v%period)-period/2)));
  return x;
}
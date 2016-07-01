//set up globals
ImageProcessor imageProcessor;
color purple = #7523c1;
color pastelBlue = #99deff;
int randomSeed;

void setup() {
  //load image and set up window
  PImage img = loadImage("refImage4.jpg");
  imageProcessor = new ImageProcessor(img);
  surface.setSize(imageProcessor.baseImage.width, imageProcessor.baseImage.height);
  //only drawing a static image
  //surface.setsize only works at the end of setup()
  noLoop();
  
  //define a random seed that can be saved
  //this allows duplicate textures to be made
  randomSeed = (int) random(0,pow(2,30));
}

void draw() {
  //image(imageProcessor.renderThreeToneFabric(),0,0);
  image(imageProcessor.renderBrightnessContours(),0,0);
  //image(imageProcessor.linenTexture(purple,255),0,0);
  //image(imageProcessor.fade(imageProcessor.baseImage),0,0);
  
  save("image.png");
}
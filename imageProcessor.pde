class ImageProcessor {
  PImage baseImage;
  
  ImageProcessor(PImage baseImage_) {
    baseImage = baseImage_.copy();
    resizeImage();
  }
  
  //a psychodelic style filter
  //applies a blur 
  //then creates contours with different hues by using modulo arithmetic based on brightness
  PImage renderBrightnessContours() {
    //
    colorMode(HSB);
    PImage img = baseImage;
    //contours look nicer on less busy images
    img.filter(BLUR,4);
    img.loadPixels();
    for(int x = 0; x < img.width; x++) {
      for(int y = 0; y < img.height; y++) {
        //choose selection critera for contour to edit
        if(brightness(img.pixels[img.width*y + x]) % 10 < 5) {
          //get pixel properties to modify
          float h = hue(img.pixels[img.width*y + x]);
          float s = saturation(img.pixels[img.width*y + x]);
          float b = brightness(img.pixels[img.width*y + x]);

          img.pixels[img.width*y + x] = color((h+120)%255,255-s,255-b);
        }
        //rest of the image left as is
        
      }
    }
    img.updatePixels();
    return(img);
  }
  
  //renders in two opposite colours
  //backcolors of textures cancel in netural tones
  PImage renderTwoBaseFabric() {
    PImage lightTexture = linenTexture(purple, 255);
    PImage darkTexture = linenTexture(purple,0);
    PImage filter = baseImage.copy();
    filter.filter(GRAY);
    darkTexture.mask(filter);
    filter.filter(INVERT);
    lightTexture.mask(filter);
    
    PGraphics g = createGraphics(baseImage.width, baseImage.height);
    g.beginDraw();
    g.background(255);
    g.image(lightTexture,0,0);
    g.image(darkTexture,0,0);
    g.endDraw();
    
    PImage img = g.get();
    return(img);
  }
  
  //creates one colour for most of image
  //overlays a second colour on darker areas
  PImage renderTwoToneFabric() {
    PImage lightTexture = linenTexture(purple, 255);
    PImage darkTexture = linenTexture(0,255);
    PImage filter = baseImage.copy();
    filter.filter(INVERT);
    filter.filter(GRAY);
    lightTexture.mask(filter);
    //filter.filter(THRESHOLD,0.8);
    PImage filterDark = fade2(filter, 0.7);
    darkTexture.mask(filterDark);
    
    PGraphics g = createGraphics(baseImage.width, baseImage.height);
    g.beginDraw();
    g.background(255);
    g.blendMode(MULTIPLY);
    g.image(lightTexture,0,0);
    g.image(darkTexture,0,0);
    g.endDraw();
    
    PImage img = g.get();
    return(img);
  }
  
    //two tone fabric but with light section two
  PImage renderThreeToneFabric() {
    PImage lightTexture = linenTexture(pastelBlue,122);
    PImage midTexture = linenTexture(purple, 192);
    PImage darkTexture = linenTexture(0,192);
    PImage filter = baseImage.copy();
    
    PImage filterLight = fade2(filter,0.6);
    lightTexture.mask(filterLight);
    
    filter.filter(INVERT);
    filter.filter(GRAY);
    midTexture.mask(filter);
    
    PImage filterDark = fade2(filter, 0.6);
    darkTexture.mask(filterDark);
    
    PGraphics g = createGraphics(baseImage.width, baseImage.height);
    g.beginDraw();
    g.background(255);
    g.blendMode(MULTIPLY);
    g.image(midTexture,0,0);
    g.image(lightTexture,0,0);
    g.image(darkTexture,0,0);
    g.endDraw();
    
    PImage img = g.get();
    return(img);
  }
  
  //resize an image to fit 512*1024
  //image keeps its aspect ratio
  void resizeImage() {
    float w = baseImage.width;
    float h = baseImage.height;
    float ratio;
    
    if (w > 2*h) {
      ratio = w / 1024;
    } else {
      ratio = h / 512;
    }
    baseImage.resize(int(w/ratio), int(h/ratio));
  }
  
  //creates a linen like texture
  PImage linenTexture(color foreColour, color backColour) {
    PGraphics g = createGraphics(baseImage.width, baseImage.height);
    randomSeed(randomSeed);
    g.beginDraw();
    g.background(backColour);
    g.noFill();
    for(int i = 0; i<18855; i++) {
      if(floor(random(0,2)) == 0) {
        g.stroke(backColour, 22);
      } else {
        g.stroke(foreColour, 22);
      }
      g.ellipse(random(0,g.width), random(0,g.height),
        random(0,400), random(0,400));
      g.rectMode(CENTER);
      g.pushMatrix();
      g.translate(random(0,g.width), random(0,g.height));
      g.rotate(random(-PI/22, PI/22));
      g.rect(0,0,random(0,g.width), random(0,g.height));
      g.popMatrix();
    }
    g.endDraw();
    
    return(g);
  }
  
  //applies a polynomial fade
  PImage fade(PImage img_) {
    PImage img= img_.copy();
    img.loadPixels();
    for(int x = 0; x < img.width; x++) {
      for(int y = 0; y < img.height; y++) {
        color col = img.pixels[y*img.width + x];
        int r = int(255*pow(red(col)/255,3));
        int g = int(255*pow(green(col)/255,3));
        int b = int(255*pow(blue(col)/255,3));
        img.pixels[y*img.width + x] = color(r,g,b);
      }
    }
    img.updatePixels();
    return(img);
  }
  
  //applies a sigmoid fade centered around the threshold
  PImage fade2(PImage img_, float threshold) {
    PImage img= img_.copy();
    threshold = 255 * threshold;
    img.loadPixels();
    for(int x = 0; x < img.width; x++) {
      for(int y = 0; y < img.height; y++) {
        color col = img.pixels[y*img.width + x];
        int r = int(255 / (1+exp(-0.1*(red(col)-threshold))));
        int g = int(255 / (1+exp(-0.1*(green(col)-threshold))));
        int b = int(255 / (1+exp(-0.1*(blue(col)-threshold))));
        img.pixels[y*img.width + x] = color(r,g,b);
      }
    }
    img.updatePixels();
    return(img);
  }
  
}
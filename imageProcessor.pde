class ImageProcessor {
  PImage baseImage;
  
  ImageProcessor(PImage baseImage_) {
    baseImage = baseImage_.copy();
    resizeImage();
  }
  
  void setNewImage(PImage newImage) {
    baseImage = newImage.copy();
    resizeImage();
  }
  
  //trippy combination:
  //-renderbrightnessContours
  //-increaseSaturation
  //-adjustHue
  PImage renderVividContours() {
    //this method keeps the base image intact
    PImage temp = baseImage.copy();
    setNewImage(renderBrightnessContours());
    setNewImage(increaseSaturation());
    setNewImage(adjustHue());
    PImage output = baseImage.copy();
    baseImage = temp.copy();
    return(output);
  }
  
  //pixelate based on average
  //treats the original image as a series of boxes
  //the average value of each of these boxes is calculated
  //the pixels in a new image are set to these values
  PImage pixelateAllAverage(int pixelSize) {
    //setup for pixel editing
    PImage img = baseImage.copy();
    img.loadPixels();
    baseImage.loadPixels();
    int baseX;
    int baseY;
    color col;
    int h, s, b = 0;
    int total;
    colorMode(HSB);
    
    for(int x = 0; x < img.width; x++) {
      for(int y = 0; y < img.height; y++) {
        //calculate pixel blocks
        baseX = floor(x/pixelSize) * pixelSize;
        baseY = floor(y/pixelSize) * pixelSize;
        
        //reset color
        h = 0;
        s = 0;
        b = 0;
        total = 0;
        
        //add up values of each pixel in the new section
        for(int innerX = baseX; innerX < baseX+pixelSize; innerX++) {
          for(int innerY = baseY; innerY < baseY+pixelSize; innerY++) {
            if(baseImage.pixels.length > innerY*baseImage.width + innerX) {
              h += hue(baseImage.pixels[innerY*baseImage.width + innerX]);
              s += saturation(baseImage.pixels[innerY*baseImage.width + innerX]);
              b += brightness(baseImage.pixels[innerY*baseImage.width + innerX]);
              total ++;
            }
            
          }
        }
        //normalise
        h /= total;
        s /= total;
        b /= total;
        
        col = color(h,s,b);
        
        //set color
        img.pixels[y*img.width + x] = col;
      }
    }
    
    return(img);
  }
  
  //pixelate an image by zooming
  //use odd values for xPixels and yPixels
  PImage pixelateZoom(int xPixels, int yPixels, int pixelSize) {
    PImage img = createImage(xPixels * pixelSize, yPixels * pixelSize, RGB);
    int midX = baseImage.width/2;
    int midY = baseImage.height/2;
    img.loadPixels();
    baseImage.loadPixels();
    int xStart = midX - (xPixels-1)/2;
    int yStart = midY - (yPixels-1)/2;
    int baseX;
    int baseY;
    color col;
    
    for(int x = 0; x < img.width; x++) {
      for(int y = 0; y < img.height; y++) {
        baseX = xStart + floor(x/pixelSize);
        baseY = yStart + floor(y/pixelSize);
        col = baseImage.pixels[baseY*baseImage.width + baseX];
        img.pixels[y*img.width + x] = col;
      }
    }
    
    img.updatePixels();
    baseImage.updatePixels();

    return(img);
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
        if(brightness(img.pixels[img.width*y + x]) % 10 > 6) {
          //get pixel properties to modify
          float h = hue(img.pixels[img.width*y + x]);
          float s = saturation(img.pixels[img.width*y + x]);
          float b = brightness(img.pixels[img.width*y + x]);

          img.pixels[img.width*y + x] = color(h,255-s,255-b);
        }
        //rest of the image left as is
        
      }
    }
    img.updatePixels();
    
    return(img);
  }
  
  //adds some saturation to an image
  PImage increaseSaturation() {
    colorMode(HSB);
    PImage img = baseImage.copy();
    img.loadPixels();
    for(int x = 0; x < img.width; x++) {
      for(int y = 0; y < img.height; y++) {
        //choose selection critera for contour to edit
          //get pixel properties to modify
          float h = hue(img.pixels[img.width*y + x]);
          float s = saturation(img.pixels[img.width*y + x]);
          float b = brightness(img.pixels[img.width*y + x]);

          img.pixels[img.width*y + x] = color(h,constrain(s+64,0,255),b);
      }
    }
    img.updatePixels();
    
    return(img);
  }
  
  //hue shifts an image by a random amount
  PImage adjustHue() {
    colorMode(HSB);
    PImage img = baseImage.copy();
    img.loadPixels();
    int hueOffset = (int)random(0,255);
    for(int x = 0; x < img.width; x++) {
      for(int y = 0; y < img.height; y++) {
        //choose selection critera for contour to edit
          //get pixel properties to modify
          float h = hue(img.pixels[img.width*y + x]);
          float s = saturation(img.pixels[img.width*y + x]);
          float b = brightness(img.pixels[img.width*y + x]);

          img.pixels[img.width*y + x] = color((h+hueOffset)%255,s,b);
      }
    }
    img.updatePixels();
    
    return(img);
  }
  
  //renders in two opposite colours
  //backcolors of textures cancel in netural tones
  PImage renderTwoBaseFabric() {
    PImage lightTexture = imageCreator.linenTexture(purple, 255, baseImage.width, baseImage.height);
    PImage darkTexture = imageCreator.linenTexture(purple,0, baseImage.width, baseImage.height);
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
    PImage lightTexture = imageCreator.linenTexture(purple, 255, baseImage.width, baseImage.height);
    PImage darkTexture = imageCreator.linenTexture(0,255, baseImage.width, baseImage.height);
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
    PImage lightTexture = imageCreator.linenTexture(pastelBlue,122, baseImage.width, baseImage.height);
    PImage midTexture = imageCreator.linenTexture(purple, 192, baseImage.width, baseImage.height);
    PImage darkTexture = imageCreator.linenTexture(0,192, baseImage.width, baseImage.height);
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
class ImageCreator {
  int w;
  int h;
  
  ImageCreator(int w_, int h_) {
    w = w_;
    h = h_;
  }
  
  /* -----------------------------------------------------------------------------
  Rainbow
  Draws a hue, with a hue adjustment algorithm
  For debugging color adjustments
  ----------------------------------------------------------------------------- */ 
  
  PImage rainbow() {
    noStroke();
    PImage img = createImage(w,h,HSB);
    colorMode(HSB);
    img.loadPixels();
    int hueOffset = (int)random(0,255);
    for(int x = 0; x < img.width; x++) {
      for(int y = 0; y < img.height; y++) {
        float h = 255/float(img.width) * x;
        float s = 255/float(img.height) * y;
        float b = 255;
        if(h > 128) {
            h = periodicSigmoid(255,0.012,128, (255-h));
        } else {
            h = periodicSigmoid(255,0.012,128, h);
        }
        h = (h + (hueOffset))%255;
        
          
        img.pixels[y*img.width + x] = color(h,s,b);
      }
    }
    img.updatePixels();
    
    return img;
  }
  
  /* -----------------------------------------------------------------------------
  noiseSquares
  Draws squares controlled by perlin noise in many colours
  Good basis for contour processing
  ----------------------------------------------------------------------------- */ 
  
  PImage noiseSquares() {
    noStroke();
    PGraphics img = createGraphics(w,h);
    img.beginDraw();
    img.background(255);
    img.colorMode(HSB);
    img.noStroke();
    //change order of mangitude of number of squares to change effect of processing
    //for generative abstract pixels:
    //300: dull not much
    //3000: pastel patterns
    //30000: darker more circular patterns
    for(int i = 0; i < 4000; i++) {
      img.fill(random(0,255),random(0,255),random(0,255));
      int x = (int)map(noise(325+i*0.01 +0.001*frameCount),0.2,0.8,0,img.width);
      int y = (int)map(noise(3532-i*0.01+0.001*frameCount),0.2,0.8,0,img.height);
      int size = (int)random(1,6);
      img.rect(x,y,size,size);
    }
    img.endDraw();
    return img;
  }
  
  /* -----------------------------------------------------------------------------
  linenTexture
  Creates a texture that looks akin to linen or other fabric
  ----------------------------------------------------------------------------- */ 

  PImage linenTexture(color foreColour, color backColour, int width_, int height_) {
    PGraphics g = createGraphics(width_, height_);
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
}
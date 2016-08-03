class ImageCreator {
  int w;
  int h;
  
  ImageCreator(int w_, int h_) {
    w = w_;
    h = h_;
  }
  
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
    for(int i = 0; i < 3000; i++) {
      img.fill(random(0,255),random(0,255),random(0,255));
      int x = (int)map(noise(325+i*0.01 +0.001*frameCount),0.2,0.8,0,img.width);
      int y = (int)map(noise(3532-i*0.01+0.001*frameCount),0.2,0.8,0,img.height);
      int size = (int)random(1,5);
      img.rect(x,y,size,size);
    }
    img.endDraw();
    return img;
  }
  
    //creates a linen like texture
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
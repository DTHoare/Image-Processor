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
}
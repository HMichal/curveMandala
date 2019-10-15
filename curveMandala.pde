
// Michal Huller 22.02.2015
// Drawing Mandala
// revised on 30.06.2019

/**
 * 
 * KEYS
 * y                   : toogle symmetry
 * s                   : save image as png
 * n                   : new image
 * r                   : start recording PDF
 * e                   : end recording PDF and save
 * w                   : toogle background black or white
 * l                   : toogle lines
 * m                   : toogle Mandala
 * t                   : toogle transparent 
 * 1-2                 : 1 - decrease pen width and 2 - increase
 * 3-4                 : 3 - decrease number petals and 4 - increase
 * space               : new noise seed
 * backspace           : clear screen
 * s                   : save png
 * c                   : change color in the current pallette
 * p                   : toggle Flower of life on/off
 */

float agentsAlpha = 90, strokeW = 3;
int drawMode = 1;
color bg = 0;
PImage scrShot;
PGraphics buf;
// color pallette
color [][]tablePens = {
  {#F98866, #FF420E, #80BD9E, #89DA59, #FFFFFF}, 
  {#98DBC6, #5BC8AC, #E6D72A, #F18D9E, #FFFFFF}, 
  {#F4CC70, #DE7A22, #20948b, #6AB187, #FFFFFF}, 
  {#F1F1F2, #BCBABE, #A1D6E2, #1995AD, #FFFFFF}, 
  {#9A9EAB, #5D535E, #EC96A4, #DFE166, #FFFFFF}, 
  {#eb8a44, #f9dc24, #4b7447, #8eba43, #ffffff}, 
  {#f52549, #fa6775, #ffd64d, #9bc01c, #ffffff}, 
  {#34888C, #7CAA2D, #F5E356, #CB6318, #FFFFFF}, 
  {#258039, #F5BE41, #31A9B8, #CF3721, #FFFFFF}, 
  {#EE693F, #F69454, #FCFDFE, #739F3D, #F68454}, 
  {#F70025, #F7EFE2, #F25C00, #F9A603, #FFFFFF}, 
  {#A1BE95, #E2DFA2, #92AAC7, #ED5752, #FFFFFF}, 
  {#4897D8, #FFDB5C, #FA6E59, #F8A055, #FFFFFF}, 
  {#00293c, #1e656d, #f1f3ce, #f62a00, #f2ee7e}, 
  {#626d71, #cdcdc0, #ddbc95, #b38867, #ffffff}, 
  {#258039, #f5be41, #31a9b8, #cf3721, #212117}, 
  {#b9d9c3, #752a07, #fbcb7b, #eb5e30, #ffffff}, 
  {#1e1f26, #283655, #4d648d, #d0e1f9, #e4ebfa}, 
  {#a1be95, #e2dfa2, #92aac7, #ed5752, #ffffff}, 
  {#4897d8, #ffdb5c, #fa6e59, #f8a055, #ffffff}, 
  {#af4425, #662e1c, #ebdcb2, #c9a66b, #ffffff}, 
  {#c1e1dc, #ffccac, #fbf190, #fdd475, #ffffff}, 
  {#2e2300, #6e6702, #c05805, #db9501, #8598b6}, 
  {#faaf08, #fa812f, #fa4032, #fef3e2, #96bd83}, 
  {#f4ec6a, #bbcf4a, #e73f0b, #a11f0c, #929c32}, 
  {#fef2e4, #fd974f, #c60000, #805a3b, #acb70c}, 
  {#f77604, #b8d20b, #f56c57, #231b12, #df1a00}, 
  {#7f152e, #d61800, #edae01, #e94f08, #718700}, 
  {#f47d4a, #e1315b, #ffec5c, #008dcb, #ffffff}, 
  {#a4cabc, #eab364, #b2473e, #acbd78, #36845b}, 
  {#a5c3cf, #f3d3b8, #e59d5c, #a99f3c, #807418}, 
  {#8c0004, #c8000a, #e8a735, #e2c499, #89774e}, 
  {#344d90, #5cc5ef, #ffb745, #e7552c, #fdf5d3}, 
  {#688b8a, #a0b084, #faefd4, #a57c65, #6e4c49}, 
  {#882426, #cdbea7, #323030, #c29545, #6a5924}, 
  {#ffbebd, #fcfcfa, #337bae, #1a405f, #8ccf00}, 
  {#81715e, #faae3d, #e38533, #e4535e, #c82a6f}, 
  {#061283, #fd3c3c, #ffb74c, #138d90, #ffffff}, 
  {#b3dbc1, #fe0000, #fef6f6, #67baca, #e8003f}, 
  {#fe9c8f, #feb2a8, #fec8c1, #fad9c1, #f9caa7}, 
  {#96ceb4, #ffeead, #ff6f69, #ffcc5c, #88d8b0}, 
  {#461220, #8c2f39, #b23a48, #fcb9b2, #fed0bb}, 
  {#faa257, #ff8c61, #ce6a85, #985277, #5c374c}
};
PVector []crPoints;
int crNo = 0;
color []bottom2top = new color[4];
float []wBot2top = new float[4];
int transColor;
boolean transp = false;
boolean pen = true;
boolean fromPIC = true;
boolean toDraw = false;
boolean circles = false;
boolean drawPerch = false;
boolean thread = true;

int slices = 12;
color picolor = 0;
PVector []nek;
float factor=1;
int pal = 0;
int pix;

void setup() {
  size(700, 700); //(1200,676); //(1280,1024); //(900, 506); //size(1280,800,P3D);//16:9
  background(bg);
  smooth();

  //textFont(createFont("Comic Neue Angular Bold Oblique", 16), 24);
  textFont(createFont("URW Gothic L Book Oblique", 16), 24);

  frameRate(20);
  nek = new PVector[4];
  for (int i=0; i<4; i++)
    nek[i] = new PVector(0, 0);

  buf = createGraphics(1600, 1600);
  factor = float(buf.width)/width;
  //noLoop();
  strokeCap(ROUND);
  crPoints = new PVector[100];
  for (int ix = 0; ix < crPoints.length; ix++) {
    crPoints[ix] = new PVector(0, 0);
  }
  initit();
}

void initit() {  
  buf.beginDraw();
  buf.background(bg);
  background(bg);
  if (circles) 
    drawPerch = true;
  buf.endDraw();

  pal = (pal + 1) % tablePens.length;
  pix = 0;
  picolor = tablePens[pal][pix];
  bottom2top = new color[4];
  wBot2top = new float[4];
  if (transp) {
    transColor = 90;
  } else {
    transColor = 240;
  }
  SetThreadValues();
}

void draw() { 
  noFill();
  buf.noFill();
  buf.beginDraw();
  /////////////// Mandala //////////////
  if (toDraw) {
    if (crNo >= crPoints.length -4) {
      DrawCurve();
    } else if (crNo == 0) {
      crPoints[crNo].x = pmouseX - width/2;
      crPoints[crNo].y = pmouseY - height/2;
    } else {
      crPoints[crNo].x = mouseX - width/2;
      crPoints[crNo].y = mouseY - height/2;
    }
    crNo++;
  }
}

void DrawCurve() {
  int fast = slices;
  if (crNo > 1) {
    crPoints[crNo].x = crPoints[1].x;
    crPoints[crNo].y = crPoints[1].y;
    crNo++;
    crPoints[crNo].x = crPoints[0].x;
    crPoints[crNo].y = crPoints[0].y;
    crNo++;
    pushMatrix();
    translate(width/2, height/2);

    buf.pushMatrix();
    buf.translate(buf.width/2, buf.height/2);

    for (int ll = 0; ll < fast; ll++) {
      int till = 1;
      if (thread) till = bottom2top.length;

      /////////////// mirror //////////////////
      if (ll % 2 == 1) {   
        for (int ic=0; ic < till; ic++) {
          stroke(bottom2top[ic]);
          strokeWeight(wBot2top[ic]);
          buf.stroke(bottom2top[ic]);
          buf.strokeWeight(wBot2top[ic] *factor);
          beginShape();
          for (int ix = 0; ix < crNo; ix++) {
            PVector mirC = PVector.fromAngle(TWO_PI/slices - crPoints[ix].heading());
            mirC.setMag(crPoints[ix].mag());
            curveVertex(mirC.x, 
              mirC.y);
          }
          endShape();

          /*
          PVector []mirbuf = new PVector[4]; // mirror points of buf
           for (int i=0; i<4; i++) {
           mirbuf[i] = PVector.fromAngle(TWO_PI/slices - slbuf[i].heading());
           mirbuf[i].setMag(slbuf[i].mag());
           }
           buf.curve(mirbuf[0].x, mirbuf[0].y, mirbuf[1].x, mirbuf[1].y, 
           mirbuf[2].x, mirbuf[2].y, mirbuf[3].x, mirbuf[3].y);
           }*/
        }
      } else {
        for (int ic=0; ic < till; ic++) {
          stroke(bottom2top[ic]);
          strokeWeight(wBot2top[ic]);
          buf.stroke(bottom2top[ic]);
          buf.strokeWeight(wBot2top[ic] *factor);

          beginShape();
          for (int ix = 0; ix < crNo; ix++) {
            curveVertex(crPoints[ix].x, 
              crPoints[ix].y);
          }
          endShape();
          /*
          buf.curve(slbuf[0].x, slbuf[0].y, slbuf[1].x, slbuf[1].y, 
           slbuf[2].x, slbuf[2].y, 
           slbuf[3].x, slbuf[3].y);*/
        }
      }
      rotate(TWO_PI/fast);
      buf.rotate(TWO_PI/fast);
    }
    popMatrix();
    buf.popMatrix();
    buf.endDraw();
    crNo = 0;
  }
}

void keyReleased() {
  if (key == 'n' || key == 'N') {
    initit();
  }

  if (key == 's' || key == 'S') {

    if (bg == 0) fill(255);
    else fill(0);
    text("M.H.", 30, height - 30);
    noFill();

    int numR = int(random(5000));
    String fname="kal_" + year() + month() + day() + "_" + frameCount +"_" + numR + ".png";
    String bufSave = "h"+fname;
    scrShot=get(0, 0, width, height);
    scrShot.save("snapshot/" + fname);
    buf.save("snapshot/" + bufSave);
  }
  if (key == 't' || key =='T') {
    transp = !transp;
    if (transp) {
      transColor = 90;
    } else {
      transColor = 240;
    }
    DrawCurve();
    SetThreadValues();
  }
  if (key == '1') {
    strokeW -= 0.3;
    if (strokeW < 0.3) strokeW = 0.3;
  }
  if (key == '2') {
    strokeW += 0.3;
    if (strokeW > 50) strokeW -= 0.3;
  }
  if (key == '3') {
    slices -= 2;
    if (slices < 6) slices = 6;
  }
  if (key == '4') {
    slices += 2;
    if (slices > 36) slices = 36;
  }

  if (key == 'w' || key =='W') {
    bg = 255 - bg;
    background(bg);
    buf.beginDraw();
    buf.background(bg);
  }
  if (key == 'c' || key =='C') {
    pix = (pix + 1) % tablePens[0].length;
    picolor = tablePens[pal][pix];
    DrawCurve();
    SetThreadValues();
  }
  if (key == 'p' || key =='P') {
    buf.beginDraw();
    makefl();
  }
  if (key == 'r' || key =='R') {
    thread = !thread;
  }
}

void mouseDragged() {
  toDraw = true;
}

void mouseReleased() { 
  toDraw = false;
  DrawCurve();
}

void makefl() {
  float koter = width/3;
  int till = 1;

  if (thread) till = bottom2top.length;
  pushMatrix();
  buf.pushMatrix();
  translate(width/2, height/2);
  buf.translate(buf.width/2, buf.height/2);
  for (int ic=0; ic < till; ic++) {
    stroke(bottom2top[ic]);
    strokeWeight(wBot2top[ic]);
    buf.stroke(bottom2top[ic]);
    buf.strokeWeight(wBot2top[ic] *factor);
    ellipse(0, 0, koter, koter);
    buf.ellipse(0, 0, koter* factor, koter*factor);
  }

  for (int j=0; j<3; j++) {
    for (int i=0; i < 6; i++) {
      for (int ic=0; ic < till; ic++) {
        stroke(bottom2top[ic]);
        strokeWeight(wBot2top[ic]);
        buf.stroke(bottom2top[ic]);
        buf.strokeWeight(wBot2top[ic] *factor);
        if (j == 0) {
          ellipse(0, -0.5*koter, koter, koter);
          buf.ellipse(0, -0.5*koter*factor, koter*factor, koter*factor);
        }
        if (j == 1) {
          ellipse(0, -koter, koter, koter);
          buf.ellipse(0, -koter*factor, koter*factor, koter*factor);
        }
        if (j == 2) {
          ellipse(0, -sqrt(3)*koter/2, koter, koter);
          buf.ellipse(0, -sqrt(3)*koter*factor/2, koter*factor, koter*factor);
        }
      }
      rotate(TWO_PI/6);
      buf.rotate(TWO_PI/6);
    }
    if (j%2 == 1) {
      rotate(TWO_PI/12);
      buf.rotate(TWO_PI/12);
    }
  }
  for (int ic=0; ic < till; ic++) {
    stroke(bottom2top[ic]);
    strokeWeight(wBot2top[ic]);
    buf.stroke(bottom2top[ic]);
    buf.strokeWeight(wBot2top[ic] *factor);
    ellipse(0, 0, 3*koter, 3*koter);
    buf.ellipse(0, 0, 3*koter*factor, 3*koter*factor);
  }

  popMatrix();
  buf.popMatrix();
}

void SetThreadValues() {
  for (int ic=0; ic < bottom2top.length; ic++) {
    float cInc = 0.75 + ic*0.1;
    if (thread) {
      bottom2top[ic] = color(red(picolor) * cInc, 
        green(picolor) * cInc, 
        blue(picolor) * cInc, 
        transColor);
      wBot2top[ic] = strokeW * (1.7 - ic*0.55);
    } else {
      bottom2top[ic] = color(picolor, transColor);
      wBot2top[ic] = strokeW;
    }
  }
}

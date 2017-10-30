// Base code for Cae 2017 Project 3 on Animation Aesthetics

// variables to control display
boolean showConstruction=false; // show construction edges and circles
boolean showControlFrames=true;  // show start and end poses
boolean showStrobeFrames=false; // shows 5 frames of animation
boolean computingBlendRadii=true; // toggles whether blend radii are computed or adjusted with mouse ('b' or 'd' with vertical mouse moves)
boolean keyFrames=false;

// Variables that control the shape
float g = 350;            // ground height measured downward from top of canvas
float x0 = 160, x1 = 850; // initial & final coordinate of disk center 
float y0 = 200;           // initial & final vertical coordinate of disk center above ground (y is up)
float x = x0, y = y0;     // current coordinates of disk center 
float r0 = 50;            // initial & final disk radius
float r = r0;             // current disk radius
float b0 = 100, d0 = 130;   // initial & final values of the width of bottom of dress (on both sides of x)
float b = b0, d = d0;     // current values of the width of bottom of dress (on both sides of x)
float _p = b0, _q = d0;     // global values of the radii of the left and right arcs of the dress (user edited)
float cx=x0, cy=y0;
String emotion = "excited";
float lscale = 1.0, rscale = 1.0;        //scaling in the x direction
float v=0,v0=0;          //velocity along x
int numFrames = 100;
int currFrame = 0;
float timeStep=1/(float)numFrames;
int maxkf=100,numkf=2;
keyframe[] kf = new keyframe[maxkf];
float kfx=x0, kfy=y0, kfd=d0, kfb=b0, kfr=r0, kfls=1, kfrs=1, kfxv=0, kfyv=0;
int pickedkf=1;

// Animation
boolean animating = false; // animation status: running/stopped
float t=0.5;               // current animaiton time

// snapping a picture
import processing.pdf.*;    // to save screen shots as PDFs
boolean snapPic=false;
String PicturesOutputPath="data/PDFimages";
int pictureCounter=0;
//void snapPicture() {saveFrame("PICTURES/P"+nf(pictureCounter++,3)+".jpg"); }

// Filming
boolean filming=false;  // when true frames are captured in FRAMES for a movie
int frameCounter=0;     // count of frames captured (used for naming the image files)
boolean change=false;   // true when the user has presed a key or moved the mouse


void setup()              // run once
  {
  size(1000, 400, P2D); 
  frameRate(30);        // draws new frame 30 times a second
    int n = 7;
    for(int i=0; i<n; i++) println("i="+i);
    kf[0] = K(0,x0,y0,d0,b0,r0);
    kf[1] = K(numFrames,x1,y0,d0,b0,r0);
    numkf = 2;
  }
 
void draw()             // loops forever
  {
  if(snapPic) beginRecord(PDF,PicturesOutputPath+"/P"+nf(pictureCounter++,3)+".pdf"); // start recording for PDF image capture
  if(animating) computeParametersForAnimationTime(t);
  background(255);      // erase canvas at each frame
  stroke(0);            // change drawing color to black
  line(0, g, width, g); // draws gound
  noStroke(); 
  if(showControlFrames) 
  {
    fill(0,255,255); 
    paintShape(x0,y0,r0,b0,d0); 
    fill(255,0,255); 
    if(emotion == "sad") 
      paintShape(x1,y0-r0,r0,2.5*b0,d0);
    else
      paintShape(x1,y0,r0,b0,d0);
  }
  if(showStrobeFrames) 
  {
    float xx=x, yy=y, rr=r, bb=b, dd=d;
    int n = 7;
    for(int j=0; j<n; j++)
      {
      fill(255-(200.*j)/n,(200.*j)/n,155); 
      float tt = (float)j / (n-1); // println("j="+j+", t="+t);
      computeParametersForAnimationTime(tt);
      paintShape(x,y,r,b,d); 
      }
    println();
    x=xx; y=yy; r=rr; b=bb; d=dd;
  }
  if(keyFrames)
  {
    for(int i=0; i<numkf; i++)
    {
      fill(255-(200.*i)/numkf,(200.*i)/numkf,155);
      paintShape(kf[i]);
      if (i==pickedkf) { fill(0,0,0,50); stroke(0); paintShape(kf[i]); noStroke();}
    }
  }
  fill(0); paintShape(x,y,r,b,d); // displays current shape
  if(showConstruction) {noFill(); showConstruction(x,y,r,b,d);} // displays blend construction lines and circles
  showGUI(); // shows mouse location and key pressed
  textSize(20);
  text("Frame number : " + currFrame + " / " + numFrames, 10, 30); 
  if(snapPic) {endRecord(); snapPic=false;} // end saving a .pdf of the screen
  if(filming && (animating || change)) saveFrame("FRAMES/F"+nf(frameCounter++,4)+".tif"); // saves a movie frame 
  if(animating) {
    if (!keyFrames) 
    {
      if(emotion=="lazy") {if (t < 0.25 || t > 0.75) timeStep=0.005; else timeStep=0.0025;} else timeStep=0.01; t+=timeStep; currFrame++; if(t>=1) {t=1; animating=false;}
    }
    else
    {
      timeStep = 1/(float)numFrames;  t += timeStep;  if (t>=1) {t=1; animating=false;} println("time is " + t); currFrame++;
    }
  } // increments timing and stops when animation is complete
  change=false; // reset to avoid rendering movie frames for which nothing changes
  }

void keyPressed()
  {
  if(key=='`') snapPic=true; // to snap an image of the canvas and save as zoomable a PDF
  if(key=='~') filming=!filming;  // filming on/off capture frames into folder FRAMES 
  if(key=='.') computingBlendRadii=!computingBlendRadii; // toggles computing radii automatically
  if(key=='f') showControlFrames=!showControlFrames;
  if(key=='c') showConstruction=!showConstruction;
  if(key=='s') showStrobeFrames=!showStrobeFrames;
  if(key=='k') keyFrames=!keyFrames;
  if(key=='i') {if(keyFrames) {insertFrameAt(kf, currFrame);} }
  if(key=='a') {animating=true; t=0; currFrame=0;}  // start animation
  if(key=='1') {emotion = "excited";}  // excited
  if(key=='2') {emotion = "sad";}  // sad
  if(key=='3') {emotion = "lazy";}  // lazy
  change=true; // reset to render movie frames for which something changes
  }
  
void mouseMoved() // press and hold the key you want and then move the mouse (do not press any mouse button)
{
  if(keyPressed)
  {
    if (!keyFrames)
    {
      if(key=='r') r+=mouseX-pmouseX;
      if(key=='x') {x+=mouseX-pmouseX; y-=mouseY-pmouseY;}
      if(key=='b') {b-=mouseX-pmouseX; _p-=mouseY-pmouseY;}
      if(key=='d') {d+=mouseX-pmouseX; _q-=mouseY-pmouseY;}
    }
  }
  change=true; // reset to render movie frames for which something changes
  
  pickedkf = pickClosestKeyframeX(kf,mouseX);
}

void mouseDragged()
{
  if(keyPressed)
  {
    if (keyFrames)
    {
      if(key=='r') kf[pickedkf].r+=mouseX-pmouseX;
      if(key=='x') {kf[pickedkf].x+=mouseX-pmouseX; kf[pickedkf].y-=mouseY-pmouseY;}
      if(key=='b') {kf[pickedkf].b-=mouseX-pmouseX;}
      if(key=='d') {kf[pickedkf].d+=mouseX-pmouseX;}
      if(key=='m') {currFrame+=int((mouseX-pmouseX)*(float)numFrames/(float)1000); currFrame=min(max(currFrame,0),numFrames);}
    }
  }
}

// display shape defined by the 5 parameters (and by _p and _q when these are not to be recomputed automatically
void paintShape(float x, float y, float r, float b, float d)
{
  float p=_p, q=_q; // use gobal values (user controlled) in case we do not want to recompute them automatically
  if(computingBlendRadii)
    {
    p=blendRadius(b,y,r);
    q=blendRadius(d,y,r);
    }

  int n = 30; // number of samples
  
  beginShape(); // starts drawing shape
 
    // sampling the left arc
    float u0=-PI/2, u1 = atan2(y-p,b); 
    float du = (u1-u0)/(n-1);
    float v0=-PI/2, v1 = atan2(y-q,d); 
    float dv = (v1-v0)/(n-1),xarc;
    
    for (int i=0; i<n; i++) // loop to sample let arc
      {
      float s=u0+du*i;
      xarc = x-b+p*cos(s);
      vertex(x + (xarc-x)*lscale,g-p-p*sin(s));
      }
    
    
    for (float i=u1;i<v1+2*PI;i+=(v1+2*PI-u1)/n)
    {
      xarc = x+r*cos(i);
      if (x<xarc)
        vertex(x+ (xarc-x)*rscale,g-y+r*sin(i));
      else
        vertex(x+ (xarc-x)*lscale,g-y+r*sin(i));
    }

    // sampling the right arc
    for (int i=n-1; i>=0; i--) // loop to sample let arc
      {
      float s=v0+dv*i;
      xarc = x+d-q*cos(s);
      vertex(x+(xarc-x)*rscale,g-q-q*sin(s));
      }

  endShape(CLOSE);  // Closes the shape 
  
  //ellipse(x,g-y,r*2,2*r);  // draw disk
}

void paintShape(keyframe k)
{
  float p1=blendRadius(k.b,k.y,k.r);
  float q1=blendRadius(k.d,k.y,k.r);

  int n = 30; // number of samples
  
  beginShape(); // starts drawing shape
 
    // sampling the left arc
    float u0=-PI/2, u1 = atan2(k.y-p1,k.b); 
    float du = (u1-u0)/(n-1);
    float v0=-PI/2, v1 = atan2(k.y-q1,k.d); 
    float dv = (v1-v0)/(n-1),xarc;
    println("u1 is " + u1 + " and v1 is " + v1);
    for (int i=0; i<n; i++) // loop to sample let arc
    {
      float s=u0+du*i;
      xarc = k.x-k.b+p1*cos(s);
      vertex(k.x + (xarc-k.x)*k.lscale,g-p1-p1*sin(s));
    }
    
    
    for (float i=u1;i<v1+2*PI;i+=(v1+2*PI-u1)/n)
    {
      xarc = k.x+k.r*cos(i);
      if (k.x<xarc)
        vertex(k.x+ (xarc-k.x)*k.rscale,g-k.y+k.r*sin(i));
      else
        vertex(k.x+ (xarc-k.x)*k.lscale,g-k.y+k.r*sin(i));
    }

    // sampling the right arc
    for (int i=n-1; i>=0; i--) // loop to sample let arc
    {
      float s=v0+dv*i;
      xarc = k.x+k.d-q1*cos(s);
      vertex(k.x+(xarc-k.x)*k.rscale,g-q1-q1*sin(s));
    }

  endShape(CLOSE);  // Closes the shape 
}

// shows construction lines for shape defined by the 5 parameters (and by _p and _q when these are not to be recomputed automatically
void showConstruction(float x, float y, float r, float b, float d) 
  {
  // compute blend radii
  float p=_p, q=_q; // use gobal values (user controlled) in case we do not want to recompute them automatically
  if(computingBlendRadii)
    {
    p=blendRadius(b,y,r);
    q=blendRadius(d,y,r);
    }
  
  strokeWeight(2);  
  // draw left arc
  stroke(200,0,0);      // change line  color to red
  line(x-b,g,x-b,g-p);  // draw vertical edge to center of left circle
  line(x-b,g-p,x,g-y);  // draw diagonal edge from center of left circle to center of disk
  ellipse(x-b,g-p,p*2,p*2);  // draw left circle

  // draw right arc
  stroke(0,150,0);      // change line color to darker green
  line(x+d,g,x+d,g-q);  // draw vertical edge to center of right circle
  line(x+d,g-q,x,g-y);  // draw diagonal edge from center of right circle to center of disk
  ellipse(x+d,g-q,q*2,q*2);  // draw left circle
  }
  
// show Mouse and key pressed
void showGUI()
  {
  noFill(); stroke(155,155,0);
  if(mousePressed) strokeWeight(3); else strokeWeight(1);
  ellipse(mouseX,mouseY,30,30);
  if(keyPressed) {fill(155,155,0); strokeWeight(2); text(key,mouseX-6,mouseY);}
  strokeWeight(1);
  }
  
//*********** TO BE PROVIDED BY STUDENTS    
// computes current values of parameters x, y, r, b, d for animation parameter t
// so as to produce a smooth and aesthetically pleasing animation
// that conveys a specific emotion/enthusiasm of the moving shape
void computeParametersForAnimationTime(float t) // computes parameters x, y, r, b, d for current t value
{
  if (!keyFrames)
  {
    float xold = x-cx,xscale=0;
    if (t > 0.25 && t < 0.75)
    {
      float t1 = (t-0.25)/0.5;
      if(emotion == "excited")
      {
        //center of (locus of center)
        cx = x0 + t1*(x1-x0);
        cy = y0 - r0;
        x = cx + r0*sin(8*PI*t1);
        y = cy + r0*cos(8*PI*t1);
        b = b0;
        d = d0;
        //b = b0 + b0*0.8*sqrt(sin(PI*t));
        //d = d0 - d0*0.4*sqrt(sin(PI*t));
      }
      else if(emotion == "sad")
      {
        x = x0 + t1*(x1-x0);
        y = y0 - r0*sin(PI*t1/2);
        b = b0 + 1.5*t1*b0;
        d = d0;
      }
      else if(emotion == "lazy")
      {
        cx = x0 + t1*(x1-x0);
        cy = y0 - r0/2;
        x = cx + r0*sin(10*PI*t1);
        y = cy + r0/2*cos(10*PI*t1);
        b = b0;
        d = d0;
      }
    }
      
    if (t <= 0.25)
    {
      b=b0;
      d=d0;
      y=y0;
      x = LERP(0,LERP(0,x0,0.125,x0-80,t),0.25,LERP(0.125,x0-80,0.25,x0,t),t);
    }
    else if (t >= 0.75)
    {
      x = LERP(0.75,LERP(0.75,x1,0.87,x1+80,t),1,LERP(0.87,x1+80,1,x1,t),t);
    }
    else
    {
      xscale = 1;
    }
    v = (x-cx-xold);
    v = min(abs(v),7)*v/abs(v);
    xscale = 1-abs(v)/13;
    if (emotion!="lazy" && t >= 0.25 && t <= 0.75) xscale = 1;
    lscale = v<0?xscale:1;
    rscale=v>0?xscale:1;
  }
  else
  {
    for (int i=0;i<numkf-1;i++)
    {
      if (currFrame >= kf[i].pos && currFrame < kf[i+1].pos)
      {
        float param = (float)(currFrame-kf[i].pos)/(float)(kf[i+1].pos-kf[i].pos);
        x = LERP(kf[i].x,kf[i+1].x,param);
        y = LERP(kf[i].y,kf[i+1].y,param);
        r = LERP(kf[i].r,kf[i+1].r,param);
        d = LERP(kf[i].d,kf[i+1].d,param);
        b = LERP(kf[i].b,kf[i+1].b,param);
      }
    }
  }
}
  
float LERP(float x1, float y1, float x2, float y2, float t)
{
  return y1 + (y2-y1)*(t-x1)/(x2-x1);
}

float LERP(float y1, float y2, float t)
{
  return LERP(0,y1,1,y2,t);
}

//*********** TO BE PROVIDED BY STUDENTS  
// compute blend radius tangent to x-axis at point (0,0) and circle of center (b,y) and radius r   
float blendRadius(float b, float y, float r) 
  {
  return (y*y + b*b - r*r)/(2*(y+r));
  }
  
//**********************KEYFRAME MANIPULATION
int pickClosestKeyframeX(keyframe[] kf, float x0)
{
  int p = 0;
  for (int i=0;i<numkf;i++)
  {
    if(abs(x0-kf[i].x) < abs(x0-kf[p].x))
    {
      p=i;
    }
  }
  return p;
}

void insertFrameAt(keyframe[] kf, int f)
{
  int m = 0;
  for(int i=0; i<numkf;i++)
  {
    if (kf[i].pos > f)
    {
      m = i;
      break;
    }
  }
  keyframe k = interpolate(kf[m-1],kf[m],currFrame);
  for (int i=numkf;i>m;i--)
  {
    kf[i] = kf[i-1];
  }
  kf[m] = k;
  numkf++;
  println("aa");
}

keyframe interpolate(keyframe k1, keyframe k2, int f)
{
  float t = (float)(f-k1.pos)/(float)(k2.pos-k1.pos);
  return K(f, LERP(k1.x,k2.x,t), LERP(k1.y,k2.y,t), LERP(k1.d,k2.d,t), LERP(k1.b,k2.b,t), LERP(k1.r,k2.r,t));
}
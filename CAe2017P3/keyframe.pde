public class keyframe
{
  int pos=0;
  float x = 0.;
  float y = 0.;
  float d=d0;
  float b=b0;
  float r=r0;
  float lscale=1.;
  float rscale=1.;
  float xvel=0.;
  float yvel=0.;
  
  void set(int pos, float x1, float y1, float d1, float b1, float r1, float lscale1, float rscale1, float xvel1, float yvel1)
  {
    this.pos=pos;
    this.x=x1;
    this.y=y1;
    this.d=d1;
    this.b=b1;
    this.r=r1;
    this.lscale=lscale1;
    this.rscale=rscale1;
    this.xvel=xvel1;
    this.yvel=yvel1;
  }
  
  void set(int pos, float x1, float y1, float d1, float b1, float r1)
  {
    set(pos,x1,y1,d1,b1,r1,1.,1.,0.,0.);
  }
}

keyframe K(int pos, float x1, float y1, float d1, float b1, float r1)
{
  keyframe k = new keyframe();
  k.set(pos, x1,y1,d1,b1,r1);
  return k;
}

keyframe K(int pos, float x1, float y1, float d1, float b1, float r1, float lscale, float rscale)
{
  keyframe k = new keyframe();
  k.set(pos, x1,y1,d1,b1,r1,lscale,rscale,0.,0.);
  return k;
}

public class slider
{
  float start=0,end=1;
  float x,y,w=120;
  String title="";
  float curr=0.1;
  
  void set(float s, float e, float x1, float y1, float w1, String str)
  {
    this.start=s;
    this.end=e;
    this.x=x1;
    this.y=y1;
    this.w=w1;
    this.title=str;
  }
  
  boolean isInside(float xx, float yy)
  {
    if(xx>this.x && xx<this.x+w && yy>this.y-15 && yy<this.y+15) {return true;}
    return false;
  }
  
  void draw()
  {
    textSize(12);
    text(this.title,this.x+w+45,this.y+12);
    text(nfc(this.start,2),this.x-30,this.y+12);
    text(nfc(this.end,2),this.x+w+5,this.y+12);
    text(nfc(this.curr,2),LERP(this.x,this.x+this.w,this.curr),this.y+24);
    stroke(0,0,0);
    fill(255,255,255);
    rect(this.x,this.y,this.w,12);
    fill(0,0,0);
    rect(LERP(this.x,this.x+this.w,this.curr),this.y,10,12);
    noStroke();
  }
}
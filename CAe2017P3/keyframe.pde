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
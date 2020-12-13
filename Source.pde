//Base source class that renders a frame into a PGraphics buffer
public abstract class Source
{
  PGraphics frameBuffer;
  
  int wid, hei;
  
  float amp, spd, col;
  
  protected Source(int w, int h, PGraphics buffer)
  {
    wid = w;
    hei = h;
    
    frameBuffer = buffer;
    
    amp = 0.0; 
    spd = 0.0;
    col = 0.0;
  }
  
  protected abstract void initialize();                                //Run for internal setup
  protected abstract void update(float nAmp, float nSpd, float nCol);  //Update control variables to change render output
  protected abstract void render();                                    //Run to render a frame based on specifications
}

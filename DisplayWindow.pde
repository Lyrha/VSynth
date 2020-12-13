public class DisplayWindow extends PApplet
{
  PGraphics frameBuffer;

  PFont font;
  
  int scrWid;
  int scrHei;
  
  int preset;
  
  int bgFill;
  int bgAlpha;
  
  Wave wave;
  
  //Reference to the top level Java window; needed to close this window
  java.awt.Frame frame;
  
  DisplayWindow(int wid, int hei)
  {      
    scrWid = wid;
    scrHei = hei;
    
    preset = 1;
    
    bgFill = 0;
    bgAlpha = 0;
  }
  /*
  PSurface initSurface()
  {

    PSurface surface = super.initSurface();
    
    processing.awt.PSurfaceAWT awtSurface = (processing.awt.PSurfaceAWT) surface;
    
    processing.awt.PSurfaceAWT.SmoothCanvas smoothCanvas = (processing.awt.PSurfaceAWT.SmoothCanvas) awtSurface.getNative();
    frame = smoothCanvas.getFrame();
    
    frame.getInsets().set(0,0,0,0);
    frame.setBounds(0,0,scrWid,scrHei);
    frame.setSize(scrWid,scrHei);
    frame.setResizable(true);
    frame.setVisible(true);
    
    surface.setResizable(true);
    surface.setSize(scrWid,scrHei);
    
    return surface;
  }  */
 
  void settings()
  {     
    size(scrWid,scrHei,P3D);          
  }
  
  void setup()
  {    
    surface.setResizable(true);
    surface.setSize(scrWid,scrHei);
       
    frameBuffer = createGraphics(scrWid, scrHei, P3D);

    background(0);
    
    font = createFont("LiquidCrystal-ExBold.otf",40);
    
    wave = new Wave(
    scrWid,scrHei,frameBuffer,
    50.0,new PVector(0,scrHei/2,0),new PVector(scrWid,scrHei,0),new PVector(100,100,0),               
    new PVector(0,0,0), new PVector(0,0,0), new PVector(0,0,0) ,                      
    new PVector(0.01,0.01,0.01),                                                            
    WaveType.SAWWAV, new PVector(0,100,0), new PVector(0,0.5,0), WaveType.SINWAV, new PVector(0,0,0),new PVector(0,1,0), DivType.EXPDIV, new PVector(0,0,0), new PVector(2.0,2.0,2.0), 
    1,3,1,100,color(255,0,0,255),color(255,255,25,255), GradientType.LIN);                                 
  }

  void draw()
  {    
    render();
  }
  
  void render()
  {
    resizeBuffer();
    
    frameBuffer.beginDraw();
    frameBuffer.background(bgFill,bgAlpha);
    frameBuffer.fill(255,0,0);
    frameBuffer.textFont(font,40);
    frameBuffer.textSize(30);
    frameBuffer.text(frameRate,20,40);
    frameBuffer.endDraw();
    
    wave.render();
    //particle.render();

    background(0);
    image(frameBuffer,0,0);
  }
  
  void resizeBuffer()
  {
    if(frameBuffer.width != scrWid || frameBuffer.height != scrHei)
    { 
      frameBuffer = createGraphics(scrWid, scrHei, P3D);
      wave.frameBuffer = frameBuffer;
      
      println("resized");
    }
  }
  
  void keyPressed()
  {
    boolean isDigit = (key=='1'|| key=='2'|| key=='3'|| key=='4'|| key=='5'|| key=='6'|| key=='7'|| key=='8'|| key=='9'|| key=='0');
    if(isDigit)
    {
      //Character.getNumericValue(key);
    }
  }
  
  public void setGeometry(int x, int y, int wid, int hei)
  {
    scrWid = wid;
    scrHei = hei;
    
    surface.setLocation(x,y);
    surface.setSize(scrWid,scrHei);
  }
}

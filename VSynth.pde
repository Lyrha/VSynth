import java.awt.Frame;
import java.awt.BorderLayout;
import java.awt.GraphicsEnvironment;
import java.awt.GraphicsDevice;
import java.awt.GraphicsConfiguration;
import java.awt.Rectangle;

import java.util.*;
import javafx.util.*;

import java.awt.HeadlessException;
import controlP5.*;

ControlP5 cp5;

DisplayWindow display;

GraphicsEnvironment graphicsEnvironment = GraphicsEnvironment.getLocalGraphicsEnvironment();
GraphicsDevice[] screens = graphicsEnvironment.getScreenDevices();

int numScreens = screens.length;

String scrName;

int scrID;

int x;
int y;
int scrW;
int scrH;

float p1, p2 = 0;

void initDisplayWindow()
{
  for(int i = 0; i < numScreens; i++)
  {
    x = screens[i].getDefaultConfiguration().getBounds().x;
    y = screens[i].getDefaultConfiguration().getBounds().y;
    scrW = screens[i].getDefaultConfiguration().getBounds().width;
    scrH = screens[i].getDefaultConfiguration().getBounds().height;
    
    if(scrW != 0 && scrH != 0)
    {
      scrID = i;
      break;
    }
  }
}

void setDisplayWindow(int ID, int w, int h)
{
  String displayID = Integer.toString(ID+1);
  
  final String[] displayArgs = {
  "--display=" + displayID,
  "--location="+String.valueOf(x)+","+String.valueOf(y),
  "--present",
  "--sketch-path=" + sketchPath(""),
  "Display",
  String.valueOf(w),String.valueOf(h)
  };

  try
  {
    display = new DisplayWindow(w,h);
    runSketch(displayArgs,display);
  }
  catch(Exception e)
  {
  }
}

void settings()
{
  size(1280,720,P3D);
}

void setup()
{
  background(0);
  
  initDisplayWindow();
  setDisplayWindow(scrID,scrW,scrH);
  
  cp5 = new ControlP5(this);
              
  cp5.addSlider("SX").setPosition(20,20).setSize(60,10).setRange(0,scrW).setValue(0);
  cp5.addSlider("SY").setPosition(20,40).setSize(60,10).setRange(0,scrH).setValue(scrH/2);
  cp5.addSlider("SZ").setPosition(20,60).setSize(60,10).setRange(-1000,1000).setValue(0);
  
  cp5.addSlider("IX").setPosition(100,20).setSize(60,10).setRange(0,scrW/2).setValue(0);
  cp5.addSlider("IY").setPosition(100,40).setSize(60,10).setRange(0,scrH/2).setValue(20);
  cp5.addSlider("IZ").setPosition(100,60).setSize(60,10).setRange(0,100).setValue(0);
  
  cp5.addSlider("EX").setPosition(180,20).setSize(60,10).setRange(0,scrW).setValue(scrW);
  cp5.addSlider("EY").setPosition(180,40).setSize(60,10).setRange(0,scrH).setValue(scrH);
  cp5.addSlider("EZ").setPosition(180,60).setSize(60,10).setRange(-1000,1000).setValue(0);
  
  cp5.addSlider("SRZ").setPosition(20,100).setSize(60,10).setRange(-3,3).setValue(0);
  
  cp5.addSlider("IRZ").setPosition(100,100).setSize(60,10).setRange(-0.1,0.1).setValue(0);
 
  cp5.addSlider("ERZ").setPosition(180,100).setSize(60,10).setRange(-3,3).setValue(0);

  cp5.addSlider("NSclX").setPosition(20,180).setSize(60,10).setRange(0.01,1).setValue(0.01);
  cp5.addSlider("NSclY").setPosition(20,200).setSize(60,10).setRange(0.01,1).setValue(0.05);
  cp5.addSlider("NSclZ").setPosition(20,220).setSize(60,10).setRange(0.01,1).setValue(0.01);

  cp5.addSlider("WaveAmpX").setPosition(20,260).setSize(60,10).setRange(0,100).setValue(0);
  cp5.addSlider("WaveAmpY").setPosition(20,280).setSize(60,10).setRange(0,100).setValue(100);
  cp5.addSlider("WaveAmpZ").setPosition(20,300).setSize(60,10).setRange(0,100).setValue(0);
  
  cp5.addSlider("WaveFrqX").setPosition(180,260).setSize(60,10).setRange(0,100).setValue(0);
  cp5.addSlider("WaveFrqY").setPosition(180,280).setSize(60,10).setRange(0,100).setValue(100);
  cp5.addSlider("WaveFrqZ").setPosition(180,300).setSize(60,10).setRange(0,100).setValue(0);
  
  cp5.addSlider("NWaveAmpX").setPosition(20,340).setSize(60,10).setRange(0,25).setValue(0);
  cp5.addSlider("NWaveAmpY").setPosition(20,360).setSize(60,10).setRange(0,25).setValue(0);
  cp5.addSlider("NWaveAmpZ").setPosition(20,380).setSize(60,10).setRange(0,25).setValue(0);
  
  cp5.addSlider("NWaveFrqX").setPosition(180,340).setSize(60,10).setRange(0,25).setValue(0);
  cp5.addSlider("NWaveFrqY").setPosition(180,360).setSize(60,10).setRange(0,25).setValue(1);
  cp5.addSlider("NWaveFrqZ").setPosition(180,380).setSize(60,10).setRange(0,25).setValue(0);
  
  cp5.addSlider("WaveDivStartX").setPosition(20,420).setSize(60,10).setRange(0,100).setValue(0);
  cp5.addSlider("WaveDivStartY").setPosition(20,440).setSize(60,10).setRange(0,100).setValue(0);
  cp5.addSlider("WaveDivStartZ").setPosition(20,460).setSize(60,10).setRange(0,100).setValue(0);
  
  cp5.addSlider("WaveDivEndX").setPosition(20,500).setSize(60,10).setRange(0,100).setValue(0);
  cp5.addSlider("WaveDivEndY").setPosition(20,520).setSize(60,10).setRange(0,100).setValue(0);
  cp5.addSlider("WaveDivEndZ").setPosition(20,540).setSize(60,10).setRange(0,100).setValue(0);

  cp5.addSlider("NumGrp").setPosition(20,580).setSize(60,10).setRange(1,10).setValue(1);
  cp5.addSlider("GrpDen").setPosition(20,600).setSize(60,10).setRange(1,15).setValue(3);
  cp5.addSlider("GrpDet").setPosition(20,620).setSize(60,10).setRange(1,scrW/2).setValue(1);
  cp5.addSlider("GrpColVar").setPosition(20,640).setSize(60,10).setRange(0,100).setValue(100);
  
  cp5.addSlider("GrpR1").setPosition(180,580).setSize(60,10).setRange(0,255).setValue(255);
  cp5.addSlider("GrpG1").setPosition(180,600).setSize(60,10).setRange(0,255).setValue(0);
  cp5.addSlider("GrpB1").setPosition(180,620).setSize(60,10).setRange(0,255).setValue(0);
  
  cp5.addSlider("GrpR2").setPosition(340,580).setSize(60,10).setRange(0,255).setValue(0);
  cp5.addSlider("GrpG2").setPosition(340,600).setSize(60,10).setRange(0,255).setValue(255);
  cp5.addSlider("GrpB2").setPosition(340,620).setSize(60,10).setRange(0,255).setValue(0);
}

void draw()
{
  background(0);
}

void SetScreen()
{  
  int i = screens.length - 1;
      
  GraphicsConfiguration screenConfig = screens[i].getDefaultConfiguration();
  Rectangle bounds = screenConfig.getBounds();
      
  int x = bounds.getLocation().x;
  int y = bounds.getLocation().y;
  int wid = bounds.width;
  int hei = bounds.height;
      
  display.setGeometry(x,y,wid,hei);
  scrID = i;
}

void SX(float value)
{
  display.wave.startPoint.x = value;
}

void SY(float value)
{
  display.wave.startPoint.y = value;
}

void SZ(float value)
{
  display.wave.startPoint.z = value;
}

void IX(float value)
{
  display.wave.pointInc.x = value;
}

void IY(float value)
{
  display.wave.pointInc.y = value;
}

void IZ(float value)
{
  display.wave.pointInc.z = value;
}

void EX(float value)
{
  display.wave.endPoint.x = value;
}

void EY(float value)
{
  display.wave.endPoint.y = value;
}

void EZ(float value)
{
  display.wave.endPoint.z = value;
}

void SRZ(float value)
{
  display.wave.startRot.z = value;
}

void IRZ(float value)
{
  display.wave.rotInc.z = value;
}

void ERZ(float value)
{
  display.wave.endRot.z = value;
}

void NSclX(float value)
{
  display.wave.noiseScale.x = value;
}

void NSclY(float value)
{
  display.wave.noiseScale.y = value;
}

void NSclZ(float value)
{
  display.wave.noiseScale.z = value;
}

void WaveAmpX(float value)
{
  display.wave.waveAmp.x = value;
}

void WaveAmpY(float value)
{
  display.wave.waveAmp.y = value;
}

void WaveAmpZ(float value)
{
  display.wave.waveAmp.z = value;
}

void WaveFrqX(float value)
{
  display.wave.waveFrq.x = value;
}

void WaveFrqY(float value)
{
  display.wave.waveFrq.y = value;
}

void WaveFrqZ(float value)
{
  display.wave.waveFrq.z = value;
}

void NWaveAmpX(float value)
{
  display.wave.waveNoiseAmp.x = value;
}

void NWaveAmpY(float value)
{
  display.wave.waveNoiseAmp.y = value;
}

void NWaveAmpZ(float value)
{
  display.wave.waveNoiseAmp.z = value;
}

void NWaveFrqX(float value)
{
  display.wave.waveNoiseFrq.x = value;
}

void NWaveFrqY(float value)
{
  display.wave.waveNoiseFrq.y = value;
}

void NWaveFrqZ(float value)
{
  display.wave.waveNoiseFrq.z = value;
}

void WaveDivStartX(float value)
{
  display.wave.waveDivStart.x = value;
}

void WaveDivStartY(float value)
{
  display.wave.waveDivStart.y = value;
}

void WaveDivStartZ(float value)
{
  display.wave.waveDivStart.z = value;
}

void WaveDivEndX(float value)
{
  display.wave.waveDivEnd.x = value;
}

void WaveDivEndY(float value)
{
  display.wave.waveDivEnd.y = value;
}

void WaveDivEndZ(float value)
{
  display.wave.waveDivEnd.z = value;
}

void NumGrp(float value)
{
  display.wave.numGroup = int(value);
}

void GrpDen(float value)
{
  display.wave.groupDensity = int(value);
}
  
void GrpDet(float value)
{
  display.wave.groupDetail = int(value);
}

void GrpColVar(float value)
{
  display.wave.groupColVar = int(value);
}
  
void GrpR1(float value)
{
  color currCol = display.wave.groupColGrad1;
  
  display.wave.groupColGrad1 = color(value,green(currCol),blue(currCol));
}

void GrpG1(float value)
{
  color currCol = display.wave.groupColGrad1;
  
  display.wave.groupColGrad1 = color(red(currCol),value,blue(currCol));
}


void GrpB1(float value)
{
  color currCol = display.wave.groupColGrad1;
  
  display.wave.groupColGrad1 = color(red(currCol),green(currCol),value);
}

void GrpR2(float value)
{
  color currCol = display.wave.groupColGrad2;
  
  display.wave.groupColGrad2 = color(value,green(currCol),blue(currCol));
}

void GrpG2(float value)
{
  color currCol = display.wave.groupColGrad2;
  
  display.wave.groupColGrad2 = color(red(currCol),value,blue(currCol));
}


void GrpB2(float value)
{
  color currCol = display.wave.groupColGrad2;
  
  display.wave.groupColGrad2 = color(red(currCol),green(currCol),value);
}

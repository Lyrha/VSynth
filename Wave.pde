static enum WaveType {SINWAV,SQRWAV,TRIWAV,SAWWAV};
static enum DivType {LOGDIV,EXPDIV};
static enum GradientType {LIN,SIN,EXP};

//ISSUES: WAVE LIFE
//        COLOR GRADIENT FLASH
//        LIGHTS
public class Wave extends Source
{
  WaveType waveType;      //Wave type 
  WaveType noiseWaveType; //Noise wave type
  
  DivType divType;        //Wave diversion type
  
  float life;            //Life of wave
  
  PVector startPoint;    //Start point of first wave group (X,Y,Z)
  PVector endPoint;      //End point of first wave group (X,Y,Z)
  PVector pointInc;      //Amount of coordinate variation starting from first wave group (X,Y,Z)
  
  PVector startRot;      //Start rotation of first wave group (X,Y,Z)
  PVector endRot;        //End rotation of first wave group (X,Y,Z)
  PVector rotInc;        //Amount of rotation variation starting from first group (X,Y,Z)
  
  PVector noiseScale;    //Perlin noise scale (X,Y,Z)
  
  PVector waveAmp;       //Wave main amplitude (X,Y,Z)
  PVector waveFrq;       //Wave main frequency (X,Y,Z)
  
  PVector waveNoiseAmp;  //Wave noise amplitude (X,Y,Z)
  PVector waveNoiseFrq;  //Wave noise frequency (X,Y,Z)
  
  PVector waveDivStart;  //Wave diversion degree of group at start point (X,Y,Z)
  PVector waveDivEnd;    //Wave diversion degree of group at end point (X,Y,Z) 
  
  int numGroup;          //Number of groups in the wave
  int groupDensity;      //Number of waves per group
  int groupDetail;       //Wave detail; number of points per wave
  int groupColVar;       //Wave color variation amount in a group
  
  GradientType gradientType;
  
  color groupColGrad1;   //First color of the group color gradient
  color groupColGrad2;   //Second color of the group color gradient
    
  public Wave(int nWid, int nHei, PGraphics nBuffer, 
              float nLife, PVector nStartPoint, PVector nEndPoint, PVector nPointInc, 
              PVector nStartRot, PVector nEndRot, PVector nRotInc,
              PVector nNoiseScale,
              WaveType nWaveType, PVector nWaveAmp, PVector nWaveFrq, WaveType nNoiseWaveType, PVector nWaveNoiseAmp, PVector nWaveNoiseFrq, DivType nDivType, PVector nWaveDivStart, PVector nWaveDivEnd,
              int nNumGroup, int nGroupDensity, int nGroupDetail, int nGroupColVar, color nGroupColGrad1, color nGroupColGrad2, GradientType nGradientType)
  {
    super(nWid,nHei,nBuffer);
    
    life = nLife;
    
    startPoint = nStartPoint;
    endPoint = nEndPoint;
    pointInc = nPointInc;   
    
    startRot = nStartRot;
    endRot = nEndRot;
    rotInc = nRotInc;
    
    noiseScale = nNoiseScale;
    
    waveType = nWaveType;
    
    waveAmp = nWaveAmp; 
    waveFrq = nWaveFrq;
    
    noiseWaveType = nNoiseWaveType;
    
    waveNoiseAmp = nWaveNoiseAmp;
    waveNoiseFrq = nWaveNoiseFrq;
    
    divType = nDivType;
    
    waveDivStart = nWaveDivStart;
    waveDivEnd = nWaveDivEnd;
  
    numGroup = nNumGroup;
    groupDensity = nGroupDensity;
    groupDetail = nGroupDetail;
    groupColVar = nGroupColVar;
  
    groupColGrad1 = nGroupColGrad1;  
    groupColGrad2 = nGroupColGrad2;
    
    gradientType = nGradientType;
  }
  
  public void initialize()
  {
  }
  
  public void update(float kA, float kC, float ks)
  {
  }
  
  public void render()
  {

    PVector groupStartPoint = new PVector(startPoint.x,startPoint.y,startPoint.z);
    PVector groupEndPoint = new PVector(endPoint.x,endPoint.y,endPoint.z);

    frameBuffer.beginDraw();
    for(int i = 0; i < numGroup; i++)
    {
      //Calculate wave group start position
      groupStartPoint.x = startPoint.x + i*pointInc.x;  
      groupStartPoint.y = startPoint.y + i*pointInc.y;
      groupStartPoint.z = startPoint.z + i*pointInc.z;
      
      groupEndPoint.x = endPoint.x + i*pointInc.x;
      groupEndPoint.y = endPoint.y + i*pointInc.y;
      groupEndPoint.z = endPoint.z + i*pointInc.z;
      
      frameBuffer.pushMatrix();  //<group transform>
      
      frameBuffer.translate(groupStartPoint.x,groupStartPoint.y,groupStartPoint.z);
      
      //Rotate to wave group rotation
      frameBuffer.rotate(startRot.x + i*rotInc.x,1,0,0);
      frameBuffer.rotate(startRot.y + i*rotInc.y,0,1,0);
      frameBuffer.rotate(startRot.z + i*rotInc.z,0,0,1);
      
      for(int j = 0; j < groupDensity; j++)
      {
        //NEW 
        float maxWaveLife = life*numGroup*groupDensity;
        float waveLife = map((i+1)*(j+1),1,maxWaveLife,0,255);
        
        frameBuffer.pushMatrix();  //<wave rotation>
              
        //Rotate to individual wave rotation
        frameBuffer.rotate(map(j,0,groupDensity,startRot.x,endRot.x),1,0,0);
        frameBuffer.rotate(map(j,0,groupDensity,startRot.y,endRot.y),0,1,0);
        frameBuffer.rotate(map(j,0,groupDensity,startRot.z,endRot.z),0,0,1);
        
        frameBuffer.beginShape();   
        frameBuffer.noFill();
        frameBuffer.strokeWeight(3);
        
        frameBuffer.stroke(groupColGrad1);
        
        for(int k = int(groupStartPoint.x); k < groupEndPoint.x; k += groupDetail)
        { 
          frameBuffer.stroke(getGradient(waveLife,map(k,groupStartPoint.x,groupEndPoint.x,0,1),groupColGrad1,groupColGrad2));

          frameBuffer.curveVertex(
          k,                                         
          getWaveValue(waveType,waveAmp.y,waveFrq.y,map(k,groupStartPoint.x,groupEndPoint.x,0,1))*          
          (1 + getNoiseValue(j,waveNoiseAmp.y,waveNoiseFrq.y,map(k,groupStartPoint.x,groupEndPoint.x,0,1))) + 
          getDivValue(j,map(k,groupStartPoint.x,groupEndPoint.x,0,1)),            
          0                                           
          );
        }
        frameBuffer.endShape();
        frameBuffer.popMatrix();  //</wave rotation>
      }
      frameBuffer.popMatrix();  //</group transform>
    }
    frameBuffer.endDraw();
  }
  
  public void setWaveType(WaveType type)
  {
    waveType = type;
  }
  
  public void setDivType(DivType type)
  {
    divType = type;
  }
  
  public void setGradientType(GradientType type)
  {
    gradientType = type;
  }
  
  protected float getWaveValue(WaveType type, float a, float f, float x)  //x:[0,1]
  {
    float value;
    
    switch(type)
    {
      case SINWAV:  
      value = a*sin(f*TWO_PI*x);
      break;
      case SQRWAV:
      value = a*sign(sin(f*TWO_PI*x));
      break;
      case TRIWAV:  
      value = (2.0f*a/PI)*asin(sin(f*TWO_PI*x));
      break;
      case SAWWAV:
      value = (2.0f*a/PI)*atan(cot(f*TWO_PI*x));
      break;
      default:      
      value = 0.0;
      break;
    }
    return value;
  }
  
  protected float getNoiseValue(int waveNumber, float a, float f, float x)  //x:[0,1]
  {
    float value = (waveNumber+1)*getWaveValue(noiseWaveType,a,f,x)*noise(x*noiseScale.x,noiseScale.y,noiseScale.z);
    return value;
  }
  
  protected float getDivValue(int waveNumber, float x)  //x:[0,1]
  {
    float value;
    
    float maxStartDiv;
    float maxEndDiv;
    
    float startDiv;
    float endDiv;
    
    switch(divType)
    {
      case LOGDIV:
      maxStartDiv = clippedLog(x,waveAmp.y*waveAmp.y);
      maxEndDiv = clippedLog(-(x-1),waveAmp.y*waveAmp.y);
      break;
      case EXPDIV: 
      maxStartDiv = waveAmp.y*waveAmp.y*pow(x-0.5,2);
      maxEndDiv = maxStartDiv;
      break;
      default:
      maxStartDiv = 0;
      maxEndDiv = 0;
      break;
    }
    
    //Start divergence
    startDiv = map(waveNumber,0,groupDensity,-1,1)*map(x,0,1,waveDivStart.y,0)*maxStartDiv;
    
    //End divergence
    endDiv = map(waveNumber,0,groupDensity,-1,1)*map(x,0,1,0,waveDivEnd.y)*maxEndDiv;
    
    value = startDiv + endDiv;
    return value;
  }
  
  protected color getGradient(float waveLife, float gradValue, color col1, color col2)  //gradValue:[0,1]
  {
    color col;
    
    //Use bit shifting to get RGBA 
    switch(gradientType)
    {
      case LIN:
      col = lerpColor(col1,col2,gradValue);
      break;
      case SIN:
      float sinValue = sin(TWO_PI*gradValue); 
      col = color(//RGBA
      map(sinValue,0,1,col1>>24,col2>>24),  
      map(sinValue,0,1,col1>>16,col2>>16),
      map(sinValue,0,1,col1>>8,col2>>8),
      map(sinValue,0,1,col1&0xFF,col2&0xFF)
      );
      break;
      case EXP:
      float expValue = pow(gradValue,2); 
      col = color(//RGBA
      map(expValue,0,1,col1>>24,col2>>24),  
      map(expValue,0,1,col1>>16,col2>>16),
      map(expValue,0,1,col1>>8,col2>>8),
      map(expValue,0,1,col1&0xFF,col2&0xFF)
      );
      break;
      default:
      col = color(255,255,255,255);
      break;
    }
    return col;
  }
  
  protected float clippedLog(float x, float max)
  {
    float value = max;
    if(x != 0)
      value = log(x);
    
    return value;
  }
  
  protected float cot(float x)
  {
    float value = cos(x)/sin(x);
    return value;
  }
  
  protected float sign(float x)
  {
    float value = (x==0)?(0.0):((x<0.0)?(-1.0):(1.0));
    return value;
  }
}

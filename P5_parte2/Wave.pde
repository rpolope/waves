//////////////////////////////////
//                              //
//      CLASS  WAVE             //           
//                              //
//////////////////////////////////
abstract class Wave
{
  protected PVector tmp;
  
  protected float A,  //Amplitud
                  C,  //Velocidad de propagación
                  W,  //Frecuancia angular
                  Q,  //Factor que controla la inclinación de la cresta de la onda Gerstner
                  phi,//Fase
                  L,  //Longitud de la onda
                  live_time, //Tiempo que la onda puede estar activa
                  time; //Tiempo en el que se creó la onda
  protected PVector D; //Dirección o centro de la ola
  protected boolean isDead; //Variable para indicar si la onda ha concluido su tiempo de vida
  
  //Constructor
  public Wave(float _a, PVector _srcDir, float _L, float _C, float _time){
    
    L = _L;
    tmp = new PVector(0,0,0);
    C = _C;
    A = _a;
    D = _srcDir.copy();
    W = PI * 2 / L;
    time = _time;
    Q = PI * 2*A/L * C;  // Cresta ola
    
    live_time = 1;
    isDead = false;
    phi = C * W;
  }
  
  //Método abstracto para obtener la variación en la posición
  abstract PVector getVariation(float x, float y, float z, float _time);
  
  //Método abstracto para comprobar si la onda ha completado su tiempo de vida  
   public boolean isDead(){
    
    if(_simulatedTime - this.time > live_time)
      isDead = true;
  
    return isDead;
  }
}

/////////////////////////////////////////////
//                                       ////
//      CLASS DIRECTIONAL WAVE           ////           
//                                       ////
/////////////////////////////////////////////

class DirectionalWave extends Wave
{
  public DirectionalWave(float _a, PVector _srcDir, float _L, float _C, float _time){
    super(_a, _srcDir, _L, _C, _time);
    D.normalize();
  }
  
  public PVector getVariation(float x, float y, float z, float time)
  {
    PVector p = new PVector(x,y,z);
    
    
    tmp.x = x;
    tmp.y = y;
    tmp.z = A * sin(W * (PVector.dot(D,p) + C * time));
    
    return tmp;
  }
  
}

/////////////////////////////////////////////
//                                       ////
//      CLASS RADIAL WAVE                ////           
//                                       ////
/////////////////////////////////////////////

class RadialWave extends Wave
{
  public RadialWave(float _a, PVector _srcDir, float _L, float _C, float _time){
    super(_a, _srcDir, _L, _C, _time);
  }
  
  public PVector getVariation(float x, float y, float z, float time)
  { 
    
    float dist = D.dist(new PVector(x,y,z));
    
    //float Ac = A*(75/dist);
    
    tmp.x = x;
    tmp.y = y;
    tmp.z = A * sin(W * (dist - C * time));

    return tmp;
  }
  
}

/////////////////////////////////////////////
//                                       ////
//      CLASS GERSTNER WAVE              ////           
//                                       ////
/////////////////////////////////////////////

class GerstnerWave extends Wave
{
  public GerstnerWave(float _a, PVector _srcDir, float _L, float _C, float _time){
    super(_a, _srcDir, _L, _C, _time);
    D.normalize();
  }
  
  public PVector getVariation(float x, float y, float z, float time)
  {
    
    PVector p = new PVector(x,y,z);
    
    tmp.x = p.x + Q * A * D.x * cos(W * PVector.dot(D, p) + C * time);
    tmp.y = p.y + Q * A * D.y * cos(W * PVector.dot(D, p) + C * time);
    tmp.z = A * sin(W * PVector.dot(D, p) + C * time);
    
    return tmp;
  }
  
}

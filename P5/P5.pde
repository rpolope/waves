/***********************************
/
/ Practica 5 Simulación - Ondas
/ Parte 1:
/ Autores: Víctor Monteagudo Zomeño,
/          Rafael Polope Contreras
/
/**********************************/


import peasy.*;

final float NEAR = 0.01;   // Camera near distance (m)
final float FAR = 100000.0;   // Camera far distance (m)  
final float FOV = 60;   // Field of view (º)
final int _MAP_SIZE = 500;
final int _MAP_CELL_SIZE = 2;
final float SURFACE_POS_X = - _MAP_SIZE/2;   // Position of the water in the X axis (m)
final float SURFACE_POS_Y = - _MAP_SIZE/2;  // Position of the water in the Y axis (m)
//final float SURFACE_POS_X = 0;   // Position of the water in the X axis (m)
//final float SURFACE_POS_Y = 0;  // Position of the water in the Y axis (m)
final float SURFACE_POS_Z = 0.0;                     // Position of the water in the Z axis (m)
final float SIM_STEP = 0.1;

float AMPLITUDE = 3;                               //Wave´s amplitude (m)
float WAVELENGHT = 13;                               //Disntance between wave points in the same phase (m)
float PROP_VELOCITY = 1;                             //Wave´s velocity (m/s)              
float time;
boolean texture = true;
 
PeasyCam _camera;   // mouse-driven 3D camera 
PImage img;

Wave wave;
HeightMap map;

void setup()
{
  size(800,600,P3D);
  
  //Cargamos la imagen de la textura
  img = loadImage("water.jpg");
   
    
  //Inicializamos las varibales y creamos el entorno 3D
  time = 0;
  _camera = new PeasyCam(this, 500);
  _camera.lookAt(0, 0, 0);
  float aspect = float(width)/float(height);  
  perspective((FOV*PI)/180, aspect, NEAR, FAR);
  
  map = new HeightMap(_MAP_SIZE, _MAP_CELL_SIZE);
  
}

/**************************************************
/ Función para crear los textos de las instrucciones
***************************************************/
void drawTextos(){

  textSize(30);
  fill(0);
  
  pushMatrix();
  rotateX(-PI/2);
  text("d -> Directional, r-> Radial, g-> Gerstner", -_MAP_SIZE/2 , -130 ,-_MAP_SIZE/2 - 50);
  
  textSize(20);
  
  text("a -> + Amplitude  |  s-> - Ampltiude ", -_MAP_SIZE/2 , -100 ,-_MAP_SIZE/2 - 50);
  text("h -> + Velocity   |  j-> - Velocity ", -_MAP_SIZE/2 , -70 ,-_MAP_SIZE/2 - 50);
  text("k -> + WaveLength |  l-> - WaveLength ", -_MAP_SIZE/2 , -40 ,-_MAP_SIZE/2 - 50);
  text("q -> + Q  |  w-> - Q ", -_MAP_SIZE/2 +400, -70 ,-_MAP_SIZE/2 - 50);
  text("t ->  texture/no texture | p -> reset", -_MAP_SIZE/2, -15 ,-_MAP_SIZE/2 - 50);
  
  //rotateX(PI/2);
  popMatrix();
}

void draw(){
  
  background(255);
  
  drawTextos();
  //drawCoordAxis();
  map.run();
  time += SIM_STEP;
}

/**************************************************
/ Función para crear los ejes de coordenadas
***************************************************/
void drawCoordAxis(){
  
  strokeWeight(3);
  stroke(255,0,0);
  line(0,0,0,50,0,0);
  
  stroke(0,255,0);
  line(0,0,0,0,50,0);
  
  stroke(0,0,255);
  line(0,0,0,0,0,50);

}

/******************************************************
/ Esta función se llama cada vez que se pulsa una tecla
/ Sirve para crear las ondas, borrarlas o modificar sus 
/ valores.
*******************************************************/
void keyPressed(){
  
  
  switch(key){
    
    case 'D':
    case 'd':
          wave = new DirectionalWave(AMPLITUDE, new PVector(random(0,1),random(0,1), 0), WAVELENGHT, PROP_VELOCITY);
          map.waves.add(wave);
          break;
        
    case 'R':
    case 'r':
          wave = new RadialWave(AMPLITUDE, new PVector(0,0,0), WAVELENGHT, PROP_VELOCITY);
          map.waves.add(wave);
          break;
        
    case 'G':
    case 'g':
          wave = new GerstnerWave(AMPLITUDE, new PVector(random(0,1),random(0,1), 0), WAVELENGHT, PROP_VELOCITY);
          map.waves.add(wave);
          break;
          
    case 'P':
    case 'p':
         map.waves = new ArrayList<Wave>();
         map.initNodes(SURFACE_POS_Z);
         break;
    
    case 'A':
    case 'a': 
          map.waves.get(0).A++;
          break;
          
    case 'S':
    case 's': 
          map.waves.get(0).A--;
          break;
          
    case 'H':
    case 'h': 
          map.waves.get(0).C++;
          break;
          
    case 'J':
    case 'j': 
          map.waves.get(0).C--;
          break;   
          
    case 'K':
    case 'k': 
          map.waves.get(0).L++;
          break;
          
    case 'L':
    case 'l': 
          map.waves.get(0).L--;
          break;        
    
    case 'Q':
    case 'q': 
          map.waves.get(0).Q+= 0.1;
          break;

    case 'W':
    case 'w': 
          map.waves.get(0).Q-=0.1;
          break;
          
    case 'T':
    case 't': 
          texture = !texture;
          break;
           
  }  
}

/***********************************
/
/ Practica 5 Simulación - Ondas
/ Parte 2:
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
final float SURFACE_POS_Z = 0.0;                     // Position of the water in the Z axis (m)
final float SIM_STEP = 0.1;

float AMPLITUDE = 1.5;                               //Wave´s amplitude (m)
float WAVELENGHT = 30;                               //Disntance between wave points in the same phase (m)
float PROP_VELOCITY = 2;                             //Wave´s velocity (m/s)        

float _simulatedTime = 0.0;   // Simulated time (s)

boolean texture = true;
 
PeasyCam _camera;   // mouse-driven 3D camera 
PImage img;

Wave wave;
HeightMap map;

void setup()
{
  size(800,600,P3D);
  //Cargamos la imagen de la textura
  img = loadImage("charco.jpg");
  
  //Inicializamos las varibales y creamos el entorno 3D
  _simulatedTime = 0;
  _camera = new PeasyCam(this, 500);
  _camera.lookAt(0, 0, 0);
  float aspect = float(width)/float(height);  
  perspective((FOV*PI)/180, aspect, NEAR, FAR);
  
  map = new HeightMap(_MAP_SIZE, _MAP_CELL_SIZE);
  
}


void draw(){
  
  background(255);
  
  lights();
  smooth();
  
  map.run();
  _simulatedTime += SIM_STEP;
  
  BreakUpWaves();
  CreateWaves();
 
}

/******************************************************
/ Función para generar las olas de las gotas de lluvia
******************************************************/

void CreateWaves(){

  Wave wave = new RadialWave(AMPLITUDE, new PVector(random(- _MAP_SIZE/2, _MAP_SIZE/2),random(- _MAP_SIZE/2, _MAP_SIZE/2),0), WAVELENGHT, PROP_VELOCITY, _simulatedTime);
  
  //Si no hay olas se añade sin restricciones
  if(map.waves.size() == 0) 
    map.waves.add(wave);
    
  //Si ya hay olas, se comprueba si el tiempo de la primera ola ha superado el mínimo
  //tiempo esperado para añadir la siguiente ola, siempre que no sobrepase un número 
  //limitado de ondas en el array
  else if(_simulatedTime - map.waves.get(0).time > 0.1+random(0.2) && map.waves.size() < 10){
    map.waves.add(wave); 
  }
     
   
}

/******************************************************
/ Función para eliminar las olas de las gotas de lluvia
/ una vez han llegado a su máximo de tiempo
******************************************************/
void BreakUpWaves(){
  
  if(map.waves.size() > 0 && map.waves.get(0).isDead()){
    map.waves.remove(0);
  }
  
}

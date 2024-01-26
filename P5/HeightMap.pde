//////////////////////////////////
//                              //
//      CLASS  HEIGHTMAP        //           
//                              //
//////////////////////////////////

class HeightMap{
 
  PVector[][] _nodes; //Array de nodos
  
  ArrayList<Wave> waves = new ArrayList<Wave>();//Array de olas
  
  int map_size; //Tamaño del heightmap
  int map_cell_size; //Tamaño de la celda del mapa
  int _numNodesX; // número de nodo en x
  int _numNodesY; // número de nodo en y
  
  
  //Constructor
  HeightMap(int _map_size, int _map_cell_size){
    
    map_size = _map_size;
    map_cell_size = _map_cell_size;
    _numNodesX = _map_size/_map_cell_size;
    _numNodesY = _map_size/_map_cell_size;

    _nodes = new PVector[_numNodesX][_numNodesY];
    
    initNodes(SURFACE_POS_Z);
  }
  
  /**************************************************
  / Método para inicializar la posición de los nodos
  ***************************************************/

   void initNodes(float surfacePosZ){
     
     for(int i = 0; i<_numNodesX; i++){
       for(int j = 0; j<_numNodesY; j++){
         _nodes[i][j] = new PVector(SURFACE_POS_X + i*map_cell_size, SURFACE_POS_Y + j*map_cell_size,surfacePosZ);
       }
     }
   }
   
  /**********************************************************
  / Método para dibujar la malla con un wireframe; sin textura
  **********************************************************/
 
  void drawWithWireframe()
  {
    stroke(0,0,255);

    for (int i = 0; i < _numNodesX -1; i++) 
      for(int j = 0; j < _numNodesY -1; j++){
      
        line(_nodes[i][j].x, _nodes[i][j].y, _nodes[i][j].z, _nodes[i+1][j].x, _nodes[i+1][j].y, _nodes[i+1][j].z);
        line(_nodes[i][j].x, _nodes[i][j].y, _nodes[i][j].z, _nodes[i][j+1].x, _nodes[i][j+1].y, _nodes[i][j+1].z);
        line(_nodes[i][j].x, _nodes[i][j].y, _nodes[i][j].z, _nodes[i+1][j+1].x, _nodes[i+1][j+1].y, _nodes[i+1][j+1].z);
        line(_nodes[i][j+1].x, _nodes[i][j+1].y, _nodes[i][j+1].z, _nodes[i+1][j].x, _nodes[i+1][j].y, _nodes[i+1][j].z);
      }
      
    for(int i = 0; i < _numNodesX -1; i++){
      
      line(_nodes[i][int(_numNodesY)-1].x, _nodes[i][int(_numNodesY)-1].y, _nodes[i][int(_numNodesY)-1].z,
           _nodes[i+1][int(_numNodesY)-1].x, _nodes[i+1][int(_numNodesY)-1].y, _nodes[i+1][int(_numNodesY)-1].z);
    }
    
    for(int j = 0; j < _numNodesY -1; j++){
      
      line(_nodes[int(_numNodesX )-1][j].x, _nodes[int(_numNodesX )-1][j].y, _nodes[int(_numNodesX )-1][j].z,
           _nodes[int(_numNodesX )-1][j+1].x, _nodes[int(_numNodesX )-1][j+1].y, _nodes[int(_numNodesX )-1][j+1].z);
    }
  }
  
  
  /******************************************
  / Método para dibujar la malla con textura
  ******************************************/
 
  void drawWithTexture()
  {
    int i, j;
    //fill(150,150,150);
    noStroke();
    //texture(img);
    for (j = 0; j < _numNodesY - 1; j++)
    {
      beginShape(QUAD_STRIP);
      texture(img); 
      for (i = 0; i < _numNodesX; i++)
      {
        if ((_nodes[i][j] != null) && (_nodes[i][j+1] != null))
        {
          PVector pos1 = new PVector(_nodes[i][j].x, _nodes[i][j].y, _nodes[i][j].z);
          PVector pos2 = new PVector(_nodes[i][j+1].x,_nodes[i][j+1].y, _nodes[i][j+1].z);

          vertex(pos1.x, pos1.y, pos1.z, img.width/_numNodesX*i, img.height/_numNodesY*j);
          vertex(pos2.x, pos2.y, pos2.z, img.width/_numNodesX*i, img.height/_numNodesY*(j+1));
        }
      }
      endShape();
    }
  }
  
  /************************************************************
  / Método principla de la clase: sirve para actualizar la malla.
  / En caso de haber olas, va actualizando la posición de todos
  / los nodos de la malla en función de su posición y el tiempo
  / de simulación.
  ************************************************************/
 
  void CreateWaves(){
    
    if(wave == null)
      return;
      
    else{
      PVector newPos;
      for(int i = 0; i < _numNodesX; i++)
        for(int j = 0; j < _numNodesY; j++){
          _nodes[i][j] = new PVector(SURFACE_POS_X + i*map_cell_size, SURFACE_POS_Y + j*map_cell_size,0);
          for (Wave wave: waves){
            
            newPos = wave.getVariation(_nodes[i][j].x, _nodes[i][j].y, _nodes[i][j].z, time); 

              _nodes[i][j].x = newPos.x;
              _nodes[i][j].y = newPos.y;
              _nodes[i][j].z += newPos.z;
            
          }
        }
    }
  }
  
  /************************************************************
  / Método general que engloba a los de dibujado y el principal
  ************************************************************/
 
  void run(){
    
    if(texture)
      drawWithTexture();
    else
     drawWithWireframe();
     
    CreateWaves();
  }
}

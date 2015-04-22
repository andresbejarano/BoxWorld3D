import processing.opengl.*;

  
  
  /* Constantes de interpretacion del escenario */
  private static final int CELL_EMPTY = 0, CELL_WALL = 1, CELL_BOX = 2, CELL_PORTAL = 3, CELL_PLAYER = 4;
  
  /* Mundo */
  private int[][] mainWorld = {{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, 
                           {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
                           {1, 0, 2, 0, 0, 0, 0, 0, 2, 0, 1}, 
                           {1, 0, 0, 1, 1, 1, 1, 1, 0, 0, 1}, 
                           {1, 0, 0, 0, 1, 3, 1, 0, 0, 0, 1}, 
                           {1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1}, 
                           {1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1}, 
                           {1, 0, 0, 2, 0, 0, 0, 2, 0, 0, 1}, 
                           {1, 1, 0, 0, 0, 4, 0, 0, 0, 1, 1}, 
                           {1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1}, 
                           {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}};
  
  /* Copia del mundo */
  private int[][] world;
  
  /* Variables del jugador */
  private int iPosition;
  private int jPosition;
  private float playerYawAngle;
  private int numBoxes;
  private int boxCount;
  
  /* Variables del escenario */
  private int boxSize;
  private float portalRollRotation;
  private float portalRollRotationStep;
  
  /* Texturas */
  private PImage wallTexture;
  private PImage boxTexture;
  private PImage portalTexture;
  private PImage playerTexture;
  private PImage winTexture;
  
  void setup() {
    size(600, 600, OPENGL);
    imageMode(CENTER);
    noCursor();
    
    playerYawAngle = 0;
    boxSize = (width / mainWorld.length) - 4;
    portalRollRotation = 0;
    portalRollRotationStep = PI / 50;
    copyWorld();
    boxCount = 0;
    numBoxes = countBoxes();
    
    wallTexture = loadImage("bricktexture.jpeg");
    boxTexture = loadImage("boxtexture.jpg");
    portalTexture = loadImage("vortextexture.png");
    playerTexture = loadImage("obiwan.jpg");
    winTexture = loadImage("win.png");
  }
  
  void draw() {
    background(255);
    
    for(int i = 0; i < world.length; i += 1) {
      for(int j = 0;j < world[i].length; j += 1) {
        
        switch(world[i][j]) {
        case CELL_WALL:
          drawBox((j + 1) * boxSize, (i + 1) * boxSize, 0, boxSize, wallTexture);
          break;
        case CELL_BOX:
          drawBox((j + 1) * boxSize, (i + 1) * boxSize, 0, boxSize, boxTexture);
          break;
        case CELL_PORTAL:
          drawPortal((j + 1) * boxSize, (i + 1) * boxSize, -boxSize, boxSize);
          break;
        case CELL_PLAYER:
          iPosition = i;
          jPosition = j;
          drawPlayer((j + 1) * boxSize, (i + 1) * boxSize, 0, boxSize);
          break;
        }
      }
    }
    
    if(boxCount == numBoxes) {
      drawWin(width / 2, height / 2, boxSize);
    }
  }
  
  void keyPressed() {
    if(key == CODED) {
      if(keyCode == UP) {
        playerYawAngle = PI;
        if(world[iPosition - 1][jPosition] == CELL_EMPTY) {
          world[iPosition - 1][jPosition] = CELL_PLAYER;
          world[iPosition][jPosition] = CELL_EMPTY;
        }
        else if(world[iPosition - 1][jPosition] == CELL_BOX && world[iPosition - 2][jPosition] == CELL_EMPTY) {
          world[iPosition - 2][jPosition] = CELL_BOX;
          world[iPosition - 1][jPosition] = CELL_PLAYER;
          world[iPosition][jPosition] = CELL_EMPTY;
        }
        else if(world[iPosition - 1][jPosition] == CELL_BOX && world[iPosition - 2][jPosition] == CELL_PORTAL) {
          world[iPosition - 1][jPosition] = CELL_PLAYER;
          world[iPosition][jPosition] = CELL_EMPTY;
          boxCount += 1;
        }
      }
      else if(keyCode == DOWN) {
        playerYawAngle = 0;
        if(world[iPosition + 1][jPosition] == CELL_EMPTY) {
          world[iPosition + 1][jPosition] = CELL_PLAYER;
          world[iPosition][jPosition] = CELL_EMPTY;
        }
        else if(world[iPosition + 1][jPosition] == CELL_BOX && world[iPosition + 2][jPosition] == CELL_EMPTY) {
          world[iPosition + 2][jPosition] = CELL_BOX;
          world[iPosition + 1][jPosition] = CELL_PLAYER;
          world[iPosition][jPosition] = CELL_EMPTY;
        }
        else if(world[iPosition + 1][jPosition] == CELL_BOX && world[iPosition + 2][jPosition] == CELL_PORTAL) {
          world[iPosition + 1][jPosition] = CELL_PLAYER;
          world[iPosition][jPosition] = CELL_EMPTY;
          boxCount += 1;
        }
      }
      else if(keyCode == LEFT) {
        playerYawAngle = -HALF_PI;
        if(world[iPosition][jPosition - 1] == CELL_EMPTY) {
          world[iPosition][jPosition - 1] = CELL_PLAYER;
          world[iPosition][jPosition] = CELL_EMPTY;
        }
        else if(world[iPosition][jPosition - 1] == CELL_BOX && world[iPosition][jPosition - 2] == CELL_EMPTY) {
          world[iPosition][jPosition - 2] = CELL_BOX;
          world[iPosition][jPosition - 1] = CELL_PLAYER;
          world[iPosition][jPosition] = CELL_EMPTY;
        }
        else if(world[iPosition][jPosition - 1] == CELL_BOX && world[iPosition][jPosition - 2] == CELL_PORTAL) {
          world[iPosition][jPosition - 1] = CELL_PLAYER;
          world[iPosition][jPosition] = CELL_EMPTY;
          boxCount += 1;
        }
      }
      else if(keyCode == RIGHT) {
        playerYawAngle = HALF_PI;
        if(world[iPosition][jPosition + 1] == CELL_EMPTY) {
          world[iPosition][jPosition + 1] = CELL_PLAYER;
          world[iPosition][jPosition] = CELL_EMPTY;
        }
        else if(world[iPosition][jPosition + 1] == CELL_BOX && world[iPosition][jPosition + 2] == CELL_EMPTY) {
          world[iPosition][jPosition + 2] = CELL_BOX;
          world[iPosition][jPosition + 1] = CELL_PLAYER;
          world[iPosition][jPosition] = CELL_EMPTY;
        }
        else if(world[iPosition][jPosition + 1] == CELL_BOX && world[iPosition][jPosition + 2] == CELL_PORTAL) {
          world[iPosition][jPosition + 1] = CELL_PLAYER;
          world[iPosition][jPosition] = CELL_EMPTY;
          boxCount += 1;
        }
      }
    }
    else if(key == 'r') {
      boxCount = 0;
      copyWorld();
      playerYawAngle = 0;
    }
  }
  
  /**
   * 
   */
  void copyWorld() {
    world = new int[mainWorld.length][mainWorld[0].length];
    for(int i = 0; i < mainWorld.length; i += 1) {
      for(int j = 0; j < mainWorld[i].length; j += 1) {
        world[i][j] = mainWorld[i][j];
      }
    }
  }
  
  /**
   * 
   * @return
   */
  int countBoxes() {
    int count = 0;
    for(int i = 0; i < mainWorld.length; i += 1) {
      for(int j = 0; j < mainWorld[i].length; j += 1) {
        if(mainWorld[i][j] == CELL_BOX) {
          count += 1;
        }
      }
    }
    return count;
  }
  
  /**
   * 
   * @param x
   * @param y
   * @param z
   * @param size
   * @param texture
   */
  void drawBox(float x, float y, float z, int size, PImage texture) {
    float segment = size / 2;
    noStroke();
    pushMatrix();
    translate(x, y, z);
    beginShape(QUADS);
    texture(texture);
    
    //Front
    vertex(-segment, -segment,  segment, 0, 0);
    vertex( segment, -segment,  segment, texture.width, 0);
    vertex( segment,  segment,  segment, texture.width, texture.height);
    vertex(-segment,  segment,  segment, 0, texture.height);
    
    //Back
    vertex( segment, -segment, -segment, 0, 0);
    vertex(-segment, -segment, -segment, texture.width, 0);
    vertex(-segment,  segment, -segment, texture.width, texture.height);
    vertex( segment,  segment, -segment, 0, texture.height);
    
    //Left
    vertex(-segment, -segment, -segment, 0, 0);
    vertex(-segment, -segment,  segment, texture.width, 0);
    vertex(-segment,  segment,  segment, texture.width, texture.height);
    vertex(-segment,  segment, -segment, 0, texture.height);
    
    //Right
    vertex( segment, -segment,  segment, 0, 0);
    vertex( segment, -segment, -segment, texture.width, 0);
    vertex( segment,  segment, -segment, texture.width, texture.height);
    vertex( segment,  segment,  segment, 0, texture.height);
    
    //Up
    vertex(-segment, -segment, -segment, 0, 0);
    vertex( segment, -segment, -segment, texture.width, 0);
    vertex( segment, -segment,  segment, texture.width, texture.height);
    vertex(-segment, -segment,  segment, 0, texture.height);
    
    //Down
    vertex(-segment,  segment,  segment, 0, 0);
    vertex( segment,  segment,  segment, texture.width, 0);
    vertex( segment,  segment, -segment, texture.width, texture.height);
    vertex(-segment,  segment, -segment, 0, texture.height);
    
    endShape();
    popMatrix();
    
  }
  
  /**
   * 
   * @param x
   * @param y
   * @param z
   * @param size
   */
  void drawPlayer(float x, float y, float z, int size) {
    float segment = size / 2;
    noStroke();
    pushMatrix();
    translate(x, y, z);
    rotateY(playerYawAngle);
    beginShape(QUADS);
    texture(playerTexture);
    
    //Front
    vertex(-segment, -segment,  segment, 362, 199);
    vertex( segment, -segment,  segment, 523, 199);
    vertex( segment,  segment,  segment, 523, 311);
    vertex(-segment,  segment,  segment, 362, 311);
    
    //Back
    vertex( segment, -segment, -segment, 34, 199);
    vertex(-segment, -segment, -segment, 195, 199);
    vertex(-segment,  segment, -segment, 195, 311);
    vertex( segment,  segment, -segment, 34, 311);
    
    //Left
    vertex(-segment, -segment, -segment, 198, 199);
    vertex(-segment, -segment,  segment, 359, 199);
    vertex(-segment,  segment,  segment, 359, 311);
    vertex(-segment,  segment, -segment, 198, 311);
    
    //Right
    vertex( segment, -segment,  segment, 526, 199);
    vertex( segment, -segment, -segment, 687, 199);
    vertex( segment,  segment, -segment, 687, 311);
    vertex( segment,  segment,  segment, 526, 311);
    
    //Up
    vertex(-segment, -segment, -segment, 362, 35);
    vertex( segment, -segment, -segment, 523, 35);
    vertex( segment, -segment,  segment, 523, 196);
    vertex(-segment, -segment,  segment, 362, 196);
    
    //Down
    vertex(-segment,  segment,  segment, 362, 313);
    vertex( segment,  segment,  segment, 523, 313);
    vertex( segment,  segment, -segment, 523, 475);
    vertex(-segment,  segment, -segment, 362, 475);
    
    endShape();
    popMatrix();
  }
  
  /**
   * 
   * @param x
   * @param y
   * @param z
   * @param size
   */
  void drawPortal(float x, float y, float z, float size) {
    float value = portalRollRotation + portalRollRotationStep;
    portalRollRotation = (value < TWO_PI) ? value : TWO_PI - value;
    pushMatrix();
    translate(x, y, z);
    scale(0.25f);
    rotateZ(portalRollRotation);
    image(portalTexture, 0, 0);
    popMatrix();
  }
  
  /**
   * 
   * @param x
   * @param y
   * @param z
   */
  void drawWin(float x, float y, float z) {
    pushMatrix();
    translate(x, y, z);
    image(winTexture, 0, 0);
    popMatrix();
  }
  


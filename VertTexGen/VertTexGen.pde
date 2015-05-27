import saito.objloader.*;

void setup () {
  
  OBJModel obj = new OBJModel(this);
  obj.disableMaterial();
  
  // set obj filename here .
  obj.load("HumanFace.obj");
  
  int vertexCount = obj.getVertexCount();
  int faceCount = obj.getFaceCount();
  
  // set output texture size here.
  int textureSize = 256;  
  
  int maxCount = textureSize * textureSize;    
  float step = max((float)vertexCount / maxCount, 1.0);
  
  PVector minP = new PVector(Float.MAX_VALUE, Float.MAX_VALUE, Float.MAX_VALUE);
  PVector maxP = new PVector(Float.MIN_VALUE, Float.MIN_VALUE, Float.MIN_VALUE);

  PVector[] vertices = new PVector[maxCount];
  int index = 0;
  
  for(int i = 0; i < vertexCount && index < maxCount; i += step) {
    PVector p = obj.getVertex(i);
    bounds(p, maxP, minP);
    vertices[index++] = p;
  }
  
  PVector range = PVector.sub(maxP, minP);
  float maxLength = max(range.x, max(range.y, range.z));
  PVector offset = new PVector(range.x - maxLength, range.y - maxLength, range.z - maxLength);
  offset.mult(0.5f);
  offset.div(maxLength);
  
  for(int i = 0, n = index; i < n; i++) {
    PVector p = vertices[i];
    p.sub(minP);
    p.div(maxLength);
    p.sub(offset);
    vertices[i] = p;
  }
  println(range);
  
  size(textureSize, textureSize);
  texturize(textureSize, index, vertices);
  saveFrame("vertices.png");
}

void bounds (PVector p, PVector maxP, PVector minP) {
    if(p.x < minP.x) {
      minP.x = p.x;
    } 
    if(p.y < minP.y) {
      minP.y = p.y;
    } 
    if(p.z < minP.z) {
      minP.z = p.z;
    } 
    if(p.x > maxP.x) {
      maxP.x = p.x;
    } 
    if(p.y > maxP.y) {
      maxP.y = p.y;
    } 
    if(p.z > maxP.z) {
      maxP.z = p.z;
    }
}

void texturize (int textureSize, int index, PVector[] vertices) {

  noStroke();
  
  for(int y = 0; y < textureSize; y++) {
    for(int x = 0; x < textureSize; x++) {
      int idx = y * textureSize + x;
      PVector p = vertices[idx % index];
      if(p != null) {
        fill(color(p.x * 255.0f, p.y * 255.0f, p.z * 255.0f, 255));
      } else {
        fill(color(0, 0, 0, 0));
      }     
      rect(x, y, 1, 1);
    }
  }

}

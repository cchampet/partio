/*
PARTIO SOFTWARE
Copyright 2010 Disney Enterprises, Inc. All rights reserved

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

* Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in
the documentation and/or other materials provided with the
distribution.

* The names "Disney", "Walt Disney Pictures", "Walt Disney Animation
Studios" or the names of its contributors may NOT be used to
endorse or promote products derived from this software without
specific prior written permission from Walt Disney Pictures.

Disclaimer: THIS SOFTWARE IS PROVIDED BY WALT DISNEY PICTURES AND
CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,
BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE, NONINFRINGEMENT AND TITLE ARE DISCLAIMED.
IN NO EVENT SHALL WALT DISNEY PICTURES, THE COPYRIGHT HOLDER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND BASED ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.
*/

#include <iostream>
#include <cmath>
#include <string>
#include <sstream>
#include <vector>
#include <stdlib.h>
#include <sys/stat.h>
#if defined(__DARWIN__) || defined(__APPLE__)
#include <GLUT/glut.h>
#else
#include <GL/glut.h>
#endif
#include <float.h>

#include <Partio.h>
#include "Camera.h"
using namespace Partio;
using namespace std;

// global vars
ParticlesData* particles;
Camera camera;
ParticleAttribute positionAttr;
ParticleAttribute colorAttr;
ParticleAttribute alphaAttr;
double fov;
double pointSize;
double brightness;
bool useColor;
bool useAlpha;
int numPoints;
string  particleFile;
bool sourceChanged;
int frameNumberOGL;
bool frameForwardPressed;
bool frameBackwardPressed;
bool brightnessUpPressed;
bool brightnessDownPressed;
GLuint PreviousClock;
GLint gFramesPerSecond;
bool* keyStates;
bool frameMissing;
string loadError;


void restorePerspectiveProjection();
void setOrthographicProjection();
void renderBitmapString( float x,float y,float z,void *font,char *string);
static void render();
void  reloadParticleFile(int direction);
static void mouseFunc(int button,int state,int x,int y);
static void motionFunc(int x,int y);
static void processNormalKeys(unsigned char key, int x, int y);
static void processNormalUpKeys(unsigned char key, int x, int y);
static void processSpecialKeys(int key, int x, int y);
static void processSpecialUpKeys(int key, int x, int y);
void idle();
void FPS(void);

int main(int argc,char *argv[]);









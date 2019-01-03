/***
 *      ____  ____   ___    _    
 *     |  _ \|___ \ / _ \  / \   
 *     | |_) | __) | | | |/ _ \  
 *     |  _ < / __/| |_| / ___ \ 
 *     |_| \_\_____|\___/_/   \_\
 *    Interface par Routin Jocelyn
 *      Année Scolaire 2014-2015 
 *          Terminale STI2D
 *
 */

import processing.serial.*;
Serial XBee;

/* VARIABLES SYSTEMES */
String version = "1.0.1"; // Version de l'interface
int langid; // Variable permettant de retenir le choix de langue de l'utilisateur
int favmode; // Variable permettant de retenir le type de mode favori de l'utilisateur
boolean debug = true; // Si cette valeur est sur vraie, aucune information ne sera envoyée par les modules XBee. Pour contrôler le robot, il faut donc le mettre sur false

/* VARIABLES UTILISEES DANS TOUS LES MODES (OU PRESQUE) */
int mode = 0; // Valeur du mode; 0-Menu; 1-Châssis; 2-Bras
int oldmode; // Permet de retenir le mode précédent
int mouse_state = 0; // Variable permettant de retenir l'état de la souris
PImage imgtick; // Initialise l'image "tick"

/* VARIABLES UTILISEES DANS LE MODE 1 */
boolean M1_circle_pressed = false; // Retourne vrai si la souris est pressée sur le cercle, sinon faux
boolean M1_circle_over = false; // Retourne vrai si la souris est sur le cercle, sinon faux
boolean M1_rect_pressed = false; // Retourne vrai si la souris est pressée sur le rectangle, sinon faux
boolean M1_rect_over = false; // Retourne vrai si la souris est sur le rectangle, sinon faux
float M1_cirang_vout, M1_ciraan_vout; // Valeurs des angles (circle angle/arcangle)
int M1_recspe_value; // Vitesse des moteurs à la sortie du rectangle
int angle; // Valeur de l'angle
int speed; // Valeur de la vitesse
PVector M1_cirvec_origin = new PVector(100, 0); // Créé un vecteur d'une longueur 100 à partir du centre du cercle
PVector M1_cirvec_mouse = new PVector(mouseX, mouseY); // Créé un vecteur du centre du cercle vers la position de la souris
PVector M1_recvec_origin = new PVector(0, 0); // Créé un vecteur en bas à gauche du rectangle
PVector M1_recvec_mouse = new PVector(0, 0); // Créé un rectangle en bas à gauche du rectangle qui suivra la position y de la souris
int angle_b1 = 0; // Retient une partie de la valeur de l'angle du cercle
int angle_b2 = 0; // Retient l'autre partie de la valeur de l'angle du cercle

/* VARIABLES UTILISEES DANS LE MODE 2 */
boolean M2_rect1_pressed = false; // Retourne vrai si la souris est pressée sur le rectangle, sinon faux
boolean M2_rect1_over = false; // Retourne vrai si la souris est sur le rectangle, sinon faux
boolean M2_rect2_pressed = false; // Retourne vrai si la souris est pressée sur le rectangle, sinon faux
boolean M2_rect2_over = false; // Retourne vrai si la souris est sur le rectangle, sinon faux
boolean M2_rect3_pressed = false; // Retourne vrai si la souris est pressée sur le rectangle, sinon faux
boolean M2_rect3_over = false; // Retourne vrai si la souris est sur le rectangle, sinon faux
boolean M2_rect4_pressed = false; // Retourne vrai si la souris est pressée sur le rectangle, sinon faux
boolean M2_rect4_over = false; // Retourne vrai si la souris est sur le rectangle, sinon faux
boolean M2_rect5_pressed = false; // Retourne vrai si la souris est pressée sur le rectangle, sinon faux
boolean M2_rect5_over = false; // Retourne vrai si la souris est sur le rectangle, sinon faux
boolean M2_rect6_pressed = false; // Retourne vrai si la souris est pressée sur le rectangle, sinon faux
boolean M2_rect6_over = false; // Retourne vrai si la souris est sur le rectangle, sinon faux
int M2_recse1_value; // Vitesse des moteurs à la sortie du rectangle
int M2_recse2_value; // Vitesse des moteurs à la sortie du rectangle
int M2_recse3_value; // Vitesse des moteurs à la sortie du rectangle
int M2_recse4_value; // Vitesse des moteurs à la sortie du rectangle
int M2_recse5_value; // Vitesse des moteurs à la sortie du rectangle
int M2_recse6_value; // Vitesse des moteurs à la sortie du rectangle
PVector M2_rec1vec_origin = new PVector(0, 0); // Créé un vecteur en bas à gauche du rectangle
PVector M2_rec1vec_mouse = new PVector(0, 0); // Créé un rectangle en bas à gauche du rectangle qui suivra la position y de la souris
PVector M2_rec2vec_origin = new PVector(0, 0); // Créé un vecteur en bas à gauche du rectangle
PVector M2_rec2vec_mouse = new PVector(0, 0); // Créé un rectangle en bas à gauche du rectangle qui suivra la position y de la souris
PVector M2_rec3vec_origin = new PVector(0, 0); // Créé un vecteur en bas à gauche du rectangle
PVector M2_rec3vec_mouse = new PVector(0, 0); // Créé un rectangle en bas à gauche du rectangle qui suivra la position y de la souris
PVector M2_rec4vec_origin = new PVector(0, 0); // Créé un vecteur en bas à gauche du rectangle
PVector M2_rec4vec_mouse = new PVector(0, 0); // Créé un rectangle en bas à gauche du rectangle qui suivra la position y de la souris
PVector M2_rec5vec_origin = new PVector(0, 0); // Créé un vecteur en bas à gauche du rectangle
PVector M2_rec5vec_mouse = new PVector(0, 0); // Créé un rectangle en bas à gauche du rectangle qui suivra la position y de la souris
PVector M2_rec6vec_origin = new PVector(0, 0); // Créé un vecteur en bas à gauche du rectangle
PVector M2_rec6vec_mouse = new PVector(0, 0); // Créé un rectangle en bas à gauche du rectangle qui suivra la position y de la souris
int servo1 = 90; // Position en degré du servomoteur 1
int servo2 = 20; // Position en degré du servomoteur 1
int servo3 = 30; // Position en degré du servomoteur 1
int servo4 = 180; // Position en degré du servomoteur 1
int servo5 = 90; // Position en degré du servomoteur 1
int servo6 = 20; // Position en degré du servomoteur 1
int servoid = 0; // Position en degré du servomoteur 1
PImage M2_imgarm; // Initialise l'image du bras présent dans le mode de contrôle du bras

String[][] lang = { // Tableau à deux dimensions permettant d'assurer la traduction de l'interface dans plusieurs langues
  {
  }
  , 
  {
    "FRANCAIS", 
    "Bienvenue sur l'interface du R2OA", 
    "Veuillez choisir un mode :", 
    "     Contrôle du \n         châssis", 
    "     Contrôle du \n           bras", 
    "Options", 
    "Contrôle du châssis", 
    "Passer au contrôle du bras", 
    "Mode \n simplifié", 
    "0 %", 
    "50 %", 
    "100 %", 
    "Course", 
    "Déploiement", 
    "  Contrôle du bras", 
    "Passer au contrôle du châssis", 
    "Mode \n avancé", 
    "1 & 2", 
    "3", 
    "4", 
    "5 & 6", 
    "Veuillez choisir un \n     servomoteur", 
    "Servo.1", 
    "Servo.2", 
    "Servo.3", 
    "Servo.4", 
    "Servo.5", 
    "Servo.6", 
    "Vitesse maximale", 
    "Vitesse moyenne", 
    "Vitesse nulle", 
    "Configuration de l'interface", 
    "Choisissez votre langue :", 
    "Français", 
    "Anglais", 
    "Choisissez votre type de mode par défaut :", 
    "Mode avancé", 
    "Mode simplifié", 
    "Sauvegarder"
  }
  , 
  {
    "ENGLISH", 
    "Welcome at the interface of R2OA", 
    "   Please choose a mode:", 
    "     Chassis    \n           control", 
    "      Arm    \n           control", 
    "Options", 
    "   Chassis control", 
    "   Switch to arm control", 
    "Simpl. \n mode", 
    "0 %", 
    "50 %", 
    "100 %", 
    "Run", 
    "Deployment", 
    "     Arm control", 
    "Switch to chassis control", 
    "Adv. \n mode", 
    "1 & 2", 
    "3", 
    "4", 
    "5 & 6", 
    "Please choose a \n     servo-motor", 
    "Servo.1", 
    "Servo.2", 
    "Servo.3", 
    "Servo.4", 
    "Servo.5", 
    "Servo.6", 
    "Maximum speed", 
    "Medium speed", 
    "Null speed", 
    "    Interface configuration", 
    "Choose your language:", 
    "French", 
    "English", 
    "     Choose your default mode type:", 
    "Adv. mode", 
    "Simpl. mode", 
    "      Save"
  }
};


void setup() { // Procédure setup

  if (!debug) {
    XBee = new Serial(this, Serial.list()[0], 9600); // On créé une liaison avec XBee
  }
  size(600, 400); // Largeur et Hauteur de la fenêtre
  smooth(); // Affine les bordures
  strokeWeight(3); // Épaisseur des bordures de l'interface

  imgtick = loadImage("tick.png"); // On initialise l'image qui se trouve dans \data
  M2_imgarm = loadImage("arm.png"); // On initialise l'image qui se trouve dans \data

  String[] load = loadStrings("config.r2oa"); // Permet de charger le fichier de configuration
  if (load == null) { // Si le fichier de configuration n'existe pas ...
    mode = 5; // Le mode est défini sur 5 (configuration de l'interface)
    langid = 1; // La langue par défaut est le français
    favmode = 0; // Le mode favori sera à choisir
  } else { // Sinon ...
    langid = int(load[0]); // La première ligne du fichier de configuration correspond à l'identifiant de la langue
    favmode = int(load[1]); // La seconde ligne du fichier de configuration correspond à l'identifiant du mode favori
  }
}


void draw() { // Procédure draw

  update(mouseX, mouseY); // Appelle la procédure update qui met à jour la postition de la souris
  background(180); // Définit la couleur de fond de la fenêtre

  if (mode == 0) { // Si le mode est 0...
    interface_choose(); // ...on affiche le menu
  }

  if (mode == 1) { // Si le mode est 1...
    interface_chassis_advanced(); // ...on affiche la gestion avancée du châssis
  }

  if (mode == 2) { // Si le mode est 2...
    interface_arm_advanced(); // ...on affiche la gestion avancée du bras
  }

  if (mode == 3) { // Si le mode est 3...
    interface_chassis_simple(); // ...on affiche la gestion simplifiée du châssis
  }

  if (mode == 4) { // Si le mode est 4...
    interface_arm_simple(); // ...on affiche la gestion simplifiée du bras
  }

  if (mode == 5) { // Si le mode est 5...
    interface_config(); // ...on affiche la page de configuration de l'interface
  }
}


void interface_choose() { // Procédure interface_choose (menu de démarrage de l'interface)

  fill(0); // On définit la couleur sur noir
  textSize(30); // On modifie la police de caractère à 40px
  text(lang[langid][1], 50, 60); // On affiche un texte
  textSize(20); // On modifie la police de caractère à 40px
  text(lang[langid][2], 170, 120); // On affiche un texte
  textSize(12); // On modifie la police de caractère à 12px
  text(version, 10, 390); // On affiche un texte

  button_rect(190, 150, 200, 75, true, lang[langid][3], 10, 30, 20, 24); // On affiche un bouton
  button_rect(190, 250, 200, 75, true, lang[langid][4], 10, 30, 20, 25); // On affiche un bouton

  button_rect(515, 370, 80, 25, false, lang[langid][5], 15, 16, 12, 18); // On affiche un bouton
}


void interface_chassis_advanced() { // Procédure interface_chassis_advanced (contrôle avancé du châssis)

  title(lang[langid][6]); // On affiche un titre

  button_arc(300, 0, 900, 100, 0, PI, 0, 0, 600, 50, lang[langid][7], 135, 30, 25, 2); // On affiche un bouton
  button_arc(0, 400, 200, 100, -PI/2, 0, 0, 350, 100, 400, lang[langid][8], 8, 23, 14, 3); // On affiche un bouton

  button_tri(473, 360, 553, 320, 553, 360, 473, 320, 553, 360, lang[langid][9], 50, 35, 14, 9); // On affiche un bouton
  button_tri(473, 260, 553, 220, 553, 300, 473, 220, 553, 300, lang[langid][10], 40, 45, 14, 10); // On affiche un bouton
  button_tri(473, 160, 553, 160, 553, 200, 473, 160, 553, 200, lang[langid][11], 35, 15, 14, 11); // On affiche un bouton

  button_rect(15, 140, 125, 30, true, lang[langid][12], 25, 20, 12, 12); // On affiche un bouton
  button_rect(15, 180, 125, 30, true, lang[langid][13], 25, 20, 12, 13); // On affiche un bouton

  button_rect(515, 370, 80, 25, false, lang[langid][5], 15, 16, 12, 18); // On affiche un bouton

  if ( (servo1 == 90) && (servo2 == 20) && (servo3 == 30) && (servo4 == 180) && (servo5 == 90) && (servo6 == 20) ) {
    noTint();
    image(imgtick, 20, 147);
  } else if ( (servo1 == 95) && (servo2 == 160) && (servo3 == 50) && (servo4 == 90) && (servo5 == 100) && (servo6 == 110) ) {
    noTint();
    image(imgtick, 20, 187);
  } else {
  }

  if (M1_circle_over && !M1_circle_pressed) { // Si le cercle est survolé et qu'il n'est pas pressé
    fill(230); // On définit la couleur du cercle
    ellipse(260, 260, 200, 200); // On créé/actualise le cercle
  } else if (!M1_circle_over && !M1_circle_pressed) { // Si le cercle n'est pas survolé et n'est pas pressé
    fill(255); // On définit la couleur du cercle
    ellipse(260, 260, 200, 200); // On créé/actualise le cercle
  }
  if (M1_circle_pressed) { // Si le cercle est pressé par la souris
    fill(210); // On définit la couleur du cercle
    ellipse(260, 260, 200, 200); // On créé/actualise le cercle
  }
  fill(255); // On définit la couleur en blanc
  translate(260, 260); // On translate les coordonnées de la fenêtre par rapport aux coordonnées du cercle (l'origine est le centre de la fenêtre)
  ellipse(0, 0, 40, 40); // On trace un cercle dans le cercle permettant l'affichage de l'angle entre les deux vecteurs
  line(20*cos(-M1_ciraan_vout), 20*sin(-M1_ciraan_vout), 100*cos(-M1_ciraan_vout), 100*sin(-M1_ciraan_vout)); // On trace une ligne qui se situe par rapport au curseur
  translate(-260, -260); // On translate l'origine de la fenêtre
  fill(0); // On définit la couleur en noir
  if (angle < 10) { // Si la valeur arrondie en degrées de l'angle entre les deux vecteurs est inférieure à 10
    text("00", 247, 265); // On affiche 00
    text(angle, 263, 265); // On affiche la valeur arrondie de l'angle
    text("°", 272, 265); // On affiche le symbole degré
  } else if (angle < 100) { // Si la valeur arrondie en degrées de l'angle entre les deux vecteurs est inférieure à 100
    text("0", 247.5, 265); // On affiche 0
    text(angle, 255, 265); // On affiche la valeur arrondie de l'angle
    text("°", 272, 265); // On affiche le symbole degré
  } else if (angle >= 100) { // Si la valeur arrondie en degrées de l'angle entre les deux vecteurs est supérieure ou égale à 100
    text(angle, 247.5, 265); // On affiche la valeur arrondie de l'angle
    text("°", 272, 265); // On affiche le symbole degré
  }

  if (M1_rect_over && !M1_rect_pressed) { // Si le rectangle est survolé et qu'il n'est pas pressé
    fill(230); // On définit la couleur du rectangle
    rect(420, 160, 50, 200); // On créé/actualise le rectangle
  } else if (!M1_rect_over && !M1_rect_pressed) { // Si le rectangle n'est pas survolé et n'est pas pressé
    fill(255); // On définit la couleur du rectangle
    rect(420, 160, 50, 200); // On créé/actualise le rectangle
  }
  if (M1_rect_pressed) { // Si le rectangle est pressé par la souris
    fill(210); // On définit la couleur du rectangle
    rect(420, 160, 50, 200); // On créé/actualise le rectangle
  }
  fill(120); // On définit la couleur du rectangle
  translate(420, 360); // On translate l'origine de la fenêtre
  rect(0, 0, 50, map(speed, 0, 100, 0, -200)); // On trace le rectangle
  translate(-420, -360); // On translate l'origine de la fenêtre
  fill(255); // On définit la couleur de l'arc de cercle
  arc(445, 159, 50, 50, -PI, 0);
  fill(0); // On définit la couleur en noir
  if (speed < 10) { // Si la vitesse est inférieure à 10
    text(speed, 445, 155); // On affiche la vitesse
    text("%", 455, 155); // On affiche le symbole pourcent
  } else if (speed < 100) { // Si la vitesse est inférieure à 100
    text(speed, 438, 155); // On affiche la vitesse
    text("%", 455, 155); // On affiche le symbole pourcent
  } else if (speed == 100) { // Si la vitesse est égale à 100
    text(speed, 431, 155); // On affiche la vitesse
    text("%", 455, 155); // On affiche le symbole pourcent
  }
}


void interface_arm_advanced() { // Procédure interface_arm_advanced (contrôle avancé du bras)

  title(lang[langid][14]); // On affiche un titre
  noTint();
  image(M2_imgarm, 110, 75);

  button_arc(300, 0, 900, 100, 0, PI, 0, 0, 600, 50, lang[langid][15], 135, 30, 25, 1); // On affiche un bouton
  // button_arc(0, 400, 200, 100, -PI/2, 0, 0, 350, 100, 400, lang[langid][8], 8, 23, 14, 4); Désactivé car le mode simple pour le bras n'existe finalement pas

  button_rect(15, 140, 125, 30, true, lang[langid][12], 25, 20, 12, 12); // On affiche un bouton
  button_rect(15, 180, 125, 30, true, lang[langid][13], 25, 20, 12, 13); // On affiche un bouton

  button_rect(515, 370, 80, 25, false, lang[langid][5], 15, 16, 12, 18); // On affiche un bouton

  if ( (servo1 == 90) && (servo2 == 20) && (servo3 == 30) && (servo4 == 180) && (servo5 == 90) && (servo6 == 20) ) {
    noTint();
    image(imgtick, 20, 147);
  } else if ( (servo1 == 95) && (servo2 == 160) && (servo3 == 50) && (servo4 == 90) && (servo5 == 100) && (servo6 == 110) ) {
    noTint();
    image(imgtick, 20, 187);
  } else {
  }

  button_rect(142, 334, 47, 27, false, lang[langid][17], 6, 20, 15, 5); // On affiche un bouton
  button_rect(145, 244, 47, 27, false, lang[langid][18], 20, 20, 15, 6); // On affiche un bouton
  button_rect(172, 187, 47, 27, false, lang[langid][19], 20, 20, 15, 7); // On affiche un bouton
  button_rect(227, 157, 47, 27, false, lang[langid][20], 6, 20, 15, 8); // On affiche un bouton

  switch(servoid) {
  case 0 :
    textSize(20); // On modifie la police de caractère à 20px
    text(lang[langid][21], 350, 230); // On affiche un texte
    break;
  case 1 :
    // SERVO 1
    textSize(12); // On modifie la police de caractère à 12px
    text(lang[langid][22], 355, 380); // On affiche un texte
    if (M2_rect1_over && !M2_rect1_pressed) { // Si le rectangle est survolé et qu'il n'est pas pressé
      fill(230); // On définit la couleur du rectangle
      rect(350, 160, 50, 200); // On créé/actualise le rectangle
    } else if (!M2_rect1_over && !M2_rect1_pressed) { // Si le rectangle n'est pas survolé et n'est pas pressé
      fill(250); // On définit la couleur du rectangle
      rect(350, 160, 50, 200); // On créé/actualise le rectangle
    }
    if (M2_rect1_pressed) { // Si le rectangle est pressé par la souris
      fill(210); // On définit la couleur du rectangle
      rect(350, 160, 50, 200); // On créé/actualise le rectangle
    }
    fill(255); // On définit la couleur de l'arc de cercle
    arc(375, 159, 50, 50, -PI, 0);
    fill(0); // On définit la couleur en noir
    if (servo1 < 10) {
      text(servo1, 375, 155);
      text("°", 385, 155);
    } else if (servo1 < 100) {
      text(servo1, 368, 155);
      text("°", 385, 155);
    } else if (servo1 >= 100) {
      text(servo1, 361, 155);
      text("°", 385, 155);
    }
    translate(350, 360); // On translate l'origine de la fenêtre
    fill(120); // On définit la couleur du rectangle
    rect(0, 0, 50, map(servo1, 0, 180, 0, -200)); // On trace le rectangle
    fill(0); // On définit la couleur en noir
    translate(-350, -360); // On translate l'origine de la fenêtre
    // SERVO 2
    text(lang[langid][23], 455, 380);
    if (M2_rect2_over && !M2_rect2_pressed) { // Si le rectangle est survolé et qu'il n'est pas pressé
      fill(230); // On définit la couleur du rectangle
      rect(450, 160, 50, 200); // On créé/actualise le rectangle
    } else if (!M2_rect2_over && !M2_rect2_pressed) { // Si le rectangle n'est pas survolé et n'est pas pressé
      fill(250); // On définit la couleur du rectangle
      rect(450, 160, 50, 200); // On créé/actualise le rectangle
    }
    if (M2_rect2_pressed) { // Si le rectangle est pressé par la souris
      fill(210); // On définit la couleur du rectangle
      rect(450, 160, 50, 200); // On créé/actualise le rectangle
    }
    fill(255); // On définit la couleur de l'arc de cercle
    arc(475, 159, 50, 50, -PI, 0);
    fill(0); // On définit la couleur en noir
    if (servo2 < 10) {
      text(servo2, 475, 155);
      text("°", 485, 155);
    } else if (servo2 < 100) {
      text(servo2, 468, 155);
      text("°", 485, 155);
    } else if (servo2 >= 100) {
      text(servo2, 461, 155);
      text("°", 485, 155);
    }
    translate(450, 360); // On translate l'origine de la fenêtre
    fill(120); // On définit la couleur du rectangle
    rect(0, 0, 50, map(servo2, 0, 180, 0, -200)); // On trace le rectangle
    fill(0); // On définit la couleur en noir
    translate(-450, -360); // On translate l'origine de la fenêtre
    break;
  case 2 :
    // SERVO 3
    textSize(12); // On modifie la police de caractère à 12px
    text(lang[langid][24], 405, 380);
    if (M2_rect3_over && !M2_rect3_pressed) { // Si le rectangle est survolé et qu'il n'est pas pressé
      fill(230); // On définit la couleur du rectangle
      rect(400, 160, 50, 200); // On créé/actualise le rectangle
    } else if (!M2_rect3_over && !M2_rect3_pressed) { // Si le rectangle n'est pas survolé et n'est pas pressé
      fill(250); // On définit la couleur du rectangle
      rect(400, 160, 50, 200); // On créé/actualise le rectangle
    }
    if (M2_rect3_pressed) { // Si le rectangle est pressé par la souris
      fill(210); // On définit la couleur du rectangle
      rect(400, 160, 50, 200); // On créé/actualise le rectangle
    }
    fill(255); // On définit la couleur de l'arc de cercle
    arc(425, 159, 50, 50, -PI, 0);
    fill(0); // On définit la couleur en noir
    if (servo3 < 10) {
      text(servo3, 425, 155);
      text("°", 435, 155);
    } else if (servo3 < 100) {
      text(servo3, 418, 155);
      text("°", 435, 155);
    } else if (servo3 >= 100) {
      text(servo3, 411, 155);
      text("°", 435, 155);
    }
    translate(400, 360); // On translate l'origine de la fenêtre
    fill(120); // On définit la couleur du rectangle
    rect(0, 0, 50, map(servo3, 0, 180, 0, -200)); // On trace le rectangle
    fill(0); // On définit la couleur en noir
    translate(-400, -360); // On translate l'origine de la fenêtre
    break;
  case 3 :
    // SERVO 4
    textSize(12); // On modifie la police de caractère à 12px
    text(lang[langid][25], 405, 380);
    if (M2_rect4_over && !M2_rect4_pressed) { // Si le rectangle est survolé et qu'il n'est pas pressé
      fill(230); // On définit la couleur du rectangle
      rect(400, 160, 50, 200); // On créé/actualise le rectangle
    } else if (!M2_rect4_over && !M2_rect4_pressed) { // Si le rectangle n'est pas survolé et n'est pas pressé
      fill(250); // On définit la couleur du rectangle
      rect(400, 160, 50, 200); // On créé/actualise le rectangle
    }
    if (M2_rect4_pressed) { // Si le rectangle est pressé par la souris
      fill(210); // On définit la couleur du rectangle
      rect(400, 160, 50, 200); // On créé/actualise le rectangle
    }
    fill(255); // On définit la couleur de l'arc de cercle
    arc(425, 159, 50, 50, -PI, 0);
    fill(0); // On définit la couleur en noir
    if (servo4 < 10) {
      text(servo4, 425, 155);
      text("°", 435, 155);
    } else if (servo4 < 100) {
      text(servo4, 418, 155);
      text("°", 435, 155);
    } else if (servo4 >= 100) {
      text(servo4, 411, 155);
      text("°", 435, 155);
    }
    translate(400, 360); // On translate l'origine de la fenêtre
    fill(120); // On définit la couleur du rectangle
    rect(0, 0, 50, map(servo4, 0, 180, 0, -200)); // On trace le rectangle
    fill(0); // On définit la couleur en noir
    translate(-400, -360); // On translate l'origine de la fenêtre
    break;
  case 4 :
    // SERVO 5
    textSize(12); // On modifie la police de caractère à 12px
    text(lang[langid][26], 355, 380);
    if (M2_rect5_over && !M2_rect5_pressed) { // Si le rectangle est survolé et qu'il n'est pas pressé
      fill(230); // On définit la couleur du rectangle
      rect(350, 160, 50, 200); // On créé/actualise le rectangle
    } else if (!M2_rect5_over && !M2_rect5_pressed) { // Si le rectangle n'est pas survolé et n'est pas pressé
      fill(250); // On définit la couleur du rectangle
      rect(350, 160, 50, 200); // On créé/actualise le rectangle
    }
    if (M2_rect5_pressed) { // Si le rectangle est pressé par la souris
      fill(210); // On définit la couleur du rectangle
      rect(350, 160, 50, 200); // On créé/actualise le rectangle
    }
    fill(255); // On définit la couleur de l'arc de cercle
    arc(375, 159, 50, 50, -PI, 0);
    fill(0); // On définit la couleur en noir
    if (servo5 < 10) {
      text(servo5, 375, 155);
      text("°", 385, 155);
    } else if (servo5 < 100) {
      text(servo5, 368, 155);
      text("°", 385, 155);
    } else if (servo5 >= 100) {
      text(servo5, 361, 155);
      text("°", 385, 155);
    }
    translate(350, 360); // On translate l'origine de la fenêtre
    fill(120); // On définit la couleur du rectangle
    rect(0, 0, 50, map(servo5, 20, 160, 0, -200)); // On trace le rectangle
    fill(0); // On définit la couleur en noir
    translate(-350, -360); // On translate l'origine de la fenêtre
    // SERVO 6
    text(lang[langid][27], 455, 380);
    if (M2_rect6_over && !M2_rect6_pressed) { // Si le rectangle est survolé et qu'il n'est pas pressé
      fill(230); // On définit la couleur du rectangle
      rect(450, 160, 50, 200); // On créé/actualise le rectangle
    } else if (!M2_rect6_over && !M2_rect6_pressed) { // Si le rectangle n'est pas survolé et n'est pas pressé
      fill(250); // On définit la couleur du rectangle
      rect(450, 160, 50, 200); // On créé/actualise le rectangle
    }
    if (M2_rect6_pressed) { // Si le rectangle est pressé par la souris
      fill(210); // On définit la couleur du rectangle
      rect(450, 160, 50, 200); // On créé/actualise le rectangle
    }
    fill(255); // On définit la couleur de l'arc de cercle
    arc(475, 159, 50, 50, -PI, 0);
    fill(0); // On définit la couleur en noir
    if (servo6 < 10) {
      text(servo6, 475, 155);
      text("°", 485, 155);
    } else if (servo6 < 100) {
      text(servo6, 468, 155);
      text("°", 485, 155);
    } else if (servo6 >= 100) {
      text(servo6, 461, 155);
      text("°", 485, 155);
    }
    translate(450, 360); // On translate l'origine de la fenêtre
    fill(120); // On définit la couleur du rectangle
    rect(0, 0, 50, map(servo6, 20, 160, 0, -200)); // On trace le rectangle
    fill(0); // On définit la couleur en noir
    translate(-450, -360); // On translate l'origine de la fenêtre
    break;
  }
}

void interface_chassis_simple() { // Procédure interface_chassis_simple (contrôle du châssis simple)

  title(lang[langid][6]); // On affiche un titre

  button_arc(300, 0, 900, 100, 0, PI, 0, 0, 600, 50, lang[langid][7], 135, 30, 25, 4); // On affiche un bouton
  button_arc(0, 400, 200, 100, -PI/2, 0, 0, 350, 100, 400, lang[langid][16], 8, 23, 14, 1); // On affiche un bouton
  fill(0);
  rect(220, 220, 60, 60);

  button_rect(15, 140, 125, 30, true, lang[langid][12], 25, 20, 12, 12); // On affiche un bouton
  button_rect(15, 180, 125, 30, true, lang[langid][13], 25, 20, 12, 13); // On affiche un bouton

  button_rect(515, 370, 80, 25, false, lang[langid][5], 15, 16, 12, 18); // On affiche un bouton

  if ( (servo1 == 90) && (servo2 == 20) && (servo3 == 30) && (servo4 == 180) && (servo5 == 90) && (servo6 == 20) ) {
    noTint();
    image(imgtick, 20, 147);
  } else if ( (servo1 == 95) && (servo2 == 160) && (servo3 == 50) && (servo4 == 90) && (servo5 == 100) && (servo6 == 110) ) {
    noTint();
    image(imgtick, 20, 187);
  } else {
  }

  button_tri(250, 170, 220, 220, 280, 220, 220, 170, 280, 220, "", 0, 0, 0, 14); // On affiche un bouton
  button_tri(330, 250, 280, 220, 280, 280, 280, 220, 330, 280, "", 0, 0, 0, 15); // On affiche un bouton
  button_tri(250, 330, 220, 280, 280, 280, 220, 280, 280, 330, "", 0, 0, 0, 16); // On affiche un bouton
  button_tri(170, 250, 220, 220, 220, 280, 170, 220, 220, 280, "", 0, 0, 0, 17); // On affiche un bouton

  button_rect(400, 180, 150, 30, true, lang[langid][28], 30, 20, 12, 11); // On affiche un bouton
  button_rect(400, 230, 150, 30, true, lang[langid][29], 30, 20, 12, 10); // On affiche un bouton
  button_rect(400, 280, 150, 30, true, lang[langid][30], 30, 20, 12, 9); // On affiche un bouton

  if (speed == 100) {
    noTint();
    image(imgtick, 410, 187);
  } else if (speed == 50) {
    noTint();
    image(imgtick, 410, 237);
  } else if (speed == 0) {
    noTint();
    image(imgtick, 410, 287);
  } else {
  }
}


void interface_arm_simple() { // ANNULÉ car n'avait aucun intérêt - Une redirection se fait sur l'autre contrôle

interface_arm_advanced();

/*  title(lang[langid][14]);

  button_arc(300, 0, 900, 100, 0, PI, 0, 0, 600, 50, lang[langid][15], 135, 30, 25, 3);
  button_arc(0, 400, 200, 100, -PI/2, 0, 0, 350, 100, 400, lang[langid][16], 8, 23, 14, 2);

  button_rect(15, 140, 125, 30, true, lang[langid][12], 25, 20, 12, 12);
  button_rect(15, 180, 125, 30, true, lang[langid][13], 25, 20, 12, 13);

  button_rect(515, 370, 80, 25, false, lang[langid][5], 15, 16, 12, 18);

  if ( (servo1 == 90) && (servo2 == 20) && (servo3 == 30) && (servo4 == 180) && (servo5 == 90) && (servo6 == 20) ) {
    noTint();
    image(imgtick, 20, 147);
  } else if ( (servo1 == 95) && (servo2 == 160) && (servo3 == 50) && (servo4 == 90) && (servo5 == 100) && (servo6 == 110) ) {
    noTint();
    image(imgtick, 20, 187);
  } else {
  }*/
}

void interface_config() { // Procédure interface_config (configuration de l'interface)
  textSize(30); // On modifie la police à 30px
  text(lang[langid][31], 100, 50); // On affiche un texte

  textSize(20); // On modifie la police à 20px
  text(lang[langid][32], 170, 110); // On affiche un texte
  button_rect(240, 130, 100, 30, true, lang[langid][33], 25, 20, 12, 19); // On affiche un bouton
  button_rect(240, 170, 100, 30, true, lang[langid][34], 25, 20, 12, 20); // On affiche un bouton

  textSize(20); // On modifie la police à 20px
  text(lang[langid][35], 100, 240); // On affiche un texte
  button_rect(230, 260, 120, 30, true, lang[langid][36], 25, 20, 12, 21); // On affiche un bouton
  button_rect(230, 300, 120, 30, true, lang[langid][37], 25, 20, 12, 22); // On affiche un bouton

  if ((langid == 0) || (favmode == 0)) {
  } else {
    button_rect(410, 340, 180, 50, true, lang[langid][38], 30, 30, 20, 23); // On affiche un bouton
  }

  if (langid == 1) {
    noTint();
    image(imgtick, 245, 136);
  } else if (langid == 2) {
    noTint();
    image(imgtick, 245, 176);
  } else {
  }

  if (favmode == 1) {
    noTint();
    image(imgtick, 235, 266);
  } else if (favmode == 2) {
    noTint();
    image(imgtick, 235, 306);
  } else {
  }
}


void update(int x, int y) { // Si un élément est en collision avec le curseur, on lui retourne la valeur vraie

  if (mode == 1) { // Pour le mode 1
    if (overCircle(260, 260, 200)) {
      M1_circle_over = true; // Retourne vrai si on survole le cercle
    } else if (overRect(420, 160, 50, 200)) {
      M1_rect_over = true; // Retourne vrai si on survole le rectangle
    } else {
      M1_circle_over = M1_rect_over = false; // Retourne faux si on ne survole pas d'élément
    }
  }

  if (mode == 2) { //Pour le mode 2
    if (servoid == 1) {
      if (overRect(350, 160, 50, 200)) {
        M2_rect1_over = true; // Retourne vrai si on survole le rectangle
      } else if (overRect(450, 160, 50, 200)) {
        M2_rect2_over = true; // Retourne vrai si on survole le rectangle
      } else {
        M2_rect1_over = M2_rect2_over = false; // Retourne faux si on ne survole pas d'élément
      }
    }
    if (servoid == 2) {
      if (overRect(400, 160, 50, 200)) {
        M2_rect3_over = true; // Retourne vrai si on survole le rectangle
      } else {
        M2_rect3_over = false; // Retourne faux si on ne survole pas d'élément
      }
    }
    if (servoid == 3) {
      if (overRect(400, 160, 50, 200)) {
        M2_rect4_over = true; // Retourne vrai si on survole le rectangle
      } else {
        M2_rect4_over = false; // Retourne faux si on ne survole pas d'élément
      }
    }
    if (servoid == 4) {
      if (overRect(350, 160, 50, 200)) {
        M2_rect5_over = true; // Retourne vrai si on survole le rectangle
      } else if (overRect(450, 160, 50, 200)) {
        M2_rect6_over = true; // Retourne vrai si on survole le rectangle
      } else {
        M2_rect5_over = M2_rect6_over = false; // Retourne faux si on ne survole pas d'élément
      }
    }
  }
}


boolean overCircle(int x, int y, int diameter) { // On vérifie si les coordonnées du cercle est en collision avec le curseur

    float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    return true; // Si la souris survole le cercle, on retourne vrai
  } else {
    return false; // Sinon, on retourne faux
  }
}

boolean overRect(int x, int y, int width, int height) { // On vérifie si les coordonnées du rectangle est en collision avec le curseur

  if (mouseX >= x && mouseX <= x+width && 
    mouseY >= y && mouseY <= y+height) {
    return true; // Si la souris survole le rectangle, on retourne vrai
  } else {
    return false; // Sinon, on retourne faux
  }
}

void mousePressed() { // Si on clique avec la souris
  mouse_state = 1;
  if (debug == true) {
    println("IDM=" + mode + " | MST = " + mouse_state);
  }
}


void mouseDragged() { // A chaque fois que la souris se déplace
  if (mouse_state != 2) {
    mouse_state = 3;
  }
  if (mouse_state == 3) {

    if (mode == 1) { // Mode 1
      if ((M1_circle_over) && (!M1_rect_pressed)) {
        M1_circle_pressed = true;
      }
      if (M1_circle_pressed) {
        M1_cirvec_mouse.set(mouseX-260, mouseY-260, 0);
        M1_cirang_vout = PVector.angleBetween(M1_cirvec_origin, M1_cirvec_mouse);
        if (M1_cirvec_mouse.y <= M1_cirvec_origin.y) { 
          M1_ciraan_vout = M1_cirang_vout;
        } else { 
          M1_ciraan_vout = M1_cirang_vout + 2*(PI-M1_cirang_vout);
        }
        angle = round(degrees(M1_ciraan_vout));

        if (angle <= 255) {
          angle_b1 = angle;
          angle_b2 = 0;
        } else {
          angle_b1 = 255;
          angle_b2 = angle - 255;
        }

        send(2, angle_b2, angle_b1);
      }

      if ((M1_rect_over) && (!M1_circle_pressed)) {
        M1_rect_pressed = true;
      }
      if (M1_rect_pressed) {
        M1_recvec_mouse.set(0, mouseY-360, 0);
        M1_recspe_value = int(M1_recvec_origin.dist(M1_recvec_mouse));
        if (M1_recvec_mouse.y <= -200) {
          M1_recspe_value = 200;
          M1_recvec_mouse.set(0, -200, 0);
        } else if (M1_recvec_mouse.y >= 0) {
          M1_recspe_value = 0;
          M1_recvec_mouse.set(0, 0, 0);
        }
        speed = M1_recspe_value/2;

        send(1, 0, speed);
      }
    }

    if (mode == 2) { // Mode 2
      if ((M2_rect1_over) && (!M2_rect2_pressed) && (!M2_rect3_pressed) && (!M2_rect4_pressed) && (!M2_rect5_pressed) && (!M2_rect6_pressed)) {
        M2_rect1_pressed = true;
      }
      if (M2_rect1_pressed) {
        M2_rec1vec_mouse.set(0, mouseY-360, 0);
        M2_recse1_value = int(M2_rec1vec_origin.dist(M2_rec1vec_mouse));
        if (M2_rec1vec_mouse.y <= -200) {
          M2_recse1_value = 200;
          M2_rec1vec_mouse.set(0, -200, 0);
        } else if (M2_rec1vec_mouse.y >= 0) {
          M2_recse1_value = 0;
          M2_rec1vec_mouse.set(0, 0, 0);
        }
        servo1 = round(M2_recse1_value * 0.9);

        send(3, 0, servo1);
      }

      if ((M2_rect2_over) && (!M2_rect1_pressed) && (!M2_rect3_pressed) && (!M2_rect4_pressed) && (!M2_rect5_pressed) && (!M2_rect6_pressed)) {
        M2_rect2_pressed = true;
      }
      if (M2_rect2_pressed) {
        M2_rec2vec_mouse.set(0, mouseY-360, 0);
        M2_recse2_value = int(M2_rec2vec_origin.dist(M2_rec2vec_mouse));
        if (M2_rec2vec_mouse.y <= -200) {
          M2_recse2_value = 200;
          M2_rec2vec_mouse.set(0, -200, 0);
        } else if (M2_rec2vec_mouse.y >= 0) {
          M2_recse2_value = 0;
          M2_rec2vec_mouse.set(0, 0, 0);
        }
        servo2 = round(M2_recse2_value * 0.9);

        send(4, 0, servo2);
      }

      if ((M2_rect3_over) && (!M2_rect1_pressed) && (!M2_rect2_pressed) && (!M2_rect4_pressed) && (!M2_rect5_pressed) && (!M2_rect6_pressed)) {
        M2_rect3_pressed = true;
      }
      if (M2_rect3_pressed) {
        M2_rec3vec_mouse.set(0, mouseY-360, 0);
        M2_recse3_value = int(M2_rec3vec_origin.dist(M2_rec3vec_mouse));
        if (M2_rec3vec_mouse.y <= -200) {
          M2_recse3_value = 200;
          M2_rec3vec_mouse.set(0, -200, 0);
        } else if (M2_rec3vec_mouse.y >= 0) {
          M2_recse3_value = 0;
          M2_rec3vec_mouse.set(0, 0, 0);
        }
        servo3 = round(M2_recse3_value * 0.9);

        send(5, 0, servo3);
      }

      if ((M2_rect4_over) && (!M2_rect1_pressed) && (!M2_rect2_pressed) && (!M2_rect3_pressed) && (!M2_rect5_pressed) && (!M2_rect6_pressed)) {
        M2_rect4_pressed = true;
      }
      if (M2_rect4_pressed) {
        M2_rec4vec_mouse.set(0, mouseY-360, 0);
        M2_recse4_value = int(M2_rec4vec_origin.dist(M2_rec4vec_mouse));
        if (M2_rec4vec_mouse.y <= -200) {
          M2_recse4_value = 200;
          M2_rec4vec_mouse.set(0, -200, 0);
        } else if (M2_rec4vec_mouse.y >= 0) {
          M2_recse4_value = 0;
          M2_rec4vec_mouse.set(0, 0, 0);
        }
        servo4 = round(M2_recse4_value * 0.9);

        send(6, 0, servo4);
      }

      if ((M2_rect5_over) && (!M2_rect1_pressed) && (!M2_rect2_pressed) && (!M2_rect3_pressed)  && (!M2_rect4_pressed) && (!M2_rect6_pressed)) {
        M2_rect5_pressed = true;
      }
      if (M2_rect5_pressed) {
        M2_rec5vec_mouse.set(0, mouseY-360, 0);
        M2_recse5_value = int(M2_rec5vec_origin.dist(M2_rec5vec_mouse));
        if (M2_rec5vec_mouse.y <= -200) {
          M2_recse5_value = 200;
          M2_rec5vec_mouse.set(0, -200, 0);
        } else if (M2_rec5vec_mouse.y >= 0) {
          M2_recse5_value = 0;
          M2_rec5vec_mouse.set(0, 0, 0);
        }
        servo5 = round(map(M2_recse5_value, 0, 200, 20, 160));

        send(7, 0, servo5);
      }

      if ((M2_rect6_over) && (!M2_rect1_pressed) && (!M2_rect2_pressed) && (!M2_rect3_pressed)  && (!M2_rect4_pressed) && (!M2_rect5_pressed)) {
        M2_rect6_pressed = true;
      }
      if (M2_rect6_pressed) {
        M2_rec6vec_mouse.set(0, mouseY-360, 0);
        M2_recse6_value = int(M2_rec6vec_origin.dist(M2_rec6vec_mouse));
        if (M2_rec6vec_mouse.y <= -200) {
          M2_recse6_value = 200;
          M2_rec6vec_mouse.set(0, -200, 0);
        } else if (M2_rec6vec_mouse.y >= 0) {
          M2_recse6_value = 0;
          M2_rec6vec_mouse.set(0, 0, 0);
        }
        servo6 = round(map(M2_recse6_value, 0, 200, 20, 160));

        send(8, 0, servo6);
      }
    }
  }
}


void mouseReleased() {
  mouse_state = 0;
  if (mode == 1) {
    M1_circle_pressed = M1_rect_pressed = false;
  }

  if (mode == 2) {
    M2_rect1_pressed = M2_rect2_pressed = M2_rect3_pressed = M2_rect4_pressed = M2_rect5_pressed = M2_rect6_pressed = false;
  }

  send(0, 0, 0);
  send(0, 0, 0);
  send(0, 0, 0);
  send(0, 0, 0);
}

void button_rect(int x, int y, int width, int height, boolean bordercir, String text, int tx, int ty, int tsize, int action) {

  boolean hover = false;

  if (mouseX >= x && mouseX <= x + width && mouseY >= y && mouseY <= y + height) {
    hover = true;
  } else {
    hover = false;
  }
  if ((hover) && (mouse_state == 0)) {
    fill(230);
    if (bordercir) {
      rect(x, y, width, height, 10, 10, 10, 10);
    } else {
      rect(x, y, width, height);
    }
    fill(0);
    textSize(tsize);
    text(text, x + tx, y + ty);
  } else {
    fill(255);
    if (bordercir) {
      rect(x, y, width, height, 10, 10, 10, 10);
    } else {
      rect(x, y, width, height);
    }
    fill(0);
    textSize(tsize);
    text(text, x + tx, y + ty);
  }
  button_action(hover, action);
}


void button_arc(int x, int y, int width, int height, float start_angle, float stop_angle, int xch, int ych, int xcb, int ycb, String text, int tx, int ty, int tsize, int action) {

  boolean hover = false;

  if (mouseX >= xch && mouseX <= xcb && mouseY >= ych && mouseY <= ycb) {
    hover = true;
  } else {
    hover = false;
  }
  if ((hover) && (mouse_state == 0)) {
    fill(230);
    arc(x, y, width, height, start_angle, stop_angle);
    textSize(tsize);
    fill(0);
    text(text, xch + tx, ych + ty);
  } else {
    fill(255);
    arc(x, y, width, height, start_angle, stop_angle);
    textSize(tsize);
    fill(0);
    text(text, xch + tx, ych + ty);
  }
  button_action(hover, action);
}

void button_tri(int xp1, int yp1, int xp2, int yp2, int xp3, int yp3, int xch, int ych, int xcb, int ycb, String text, int tx, int ty, int tsize, int action) {

  boolean hover = false;

  if (mouseX >= xch && mouseX <= xcb && mouseY >= ych && mouseY <= ycb) {
    hover = true;
  } else {
    hover = false;
  }
  if ((hover) && (mouse_state == 0)) {
    fill(230);
    triangle(xp1, yp1, xp2, yp2, xp3, yp3);
    textSize(tsize);
    fill(0);
    text(text, xch + tx, ych + ty);
  } else {
    fill(255);
    triangle(xp1, yp1, xp2, yp2, xp3, yp3);
    textSize(tsize);
    fill(0);
    text(text, xch + tx, ych + ty);
  }
  button_action(hover, action);
}

void button_action(boolean hover, int action) {
  if ((hover) && (mouse_state == 1)) {
    mouse_state = 2;
    switch(action) {
    case 1 :
      mode = 1;
      break;
    case 2 :
      mode = 2;
      break;
    case 3 :
      mode = 3;
      break;
    case 4:
      mode = 4;
      break;
    case 5 :
      servoid = 1;
      break;
    case 6 :
      servoid = 2;
      break;
    case 7 :
      servoid = 3;
      break;
    case 8 :
      servoid = 4;
      break;
    case 9 :
      speed = 0;
      send(1, 0, speed);
      break;
    case 10 :
      speed = 50;
      send(1, 0, speed);
      break;
    case 11 :
      speed = 100;
      send(1, 0, speed);
      break;
    case 12:
      servo1 = 90;
      servo2 = 20;
      servo3 = 30;
      servo4 = 180;
      servo5 = 90;
      servo6 = 20;
      send(4, 0, servo2);
      delay(350);
      send(5, 0, servo3);
      send(3, 0, servo1);
      send(7, 0, servo5);
      send(8, 0, servo6);
      send(6, 0, servo4);
      break;
    case 13 :
      servo1 = 95;
      servo2 = 160;
      servo3 = 50;
      servo4 = 90;
      servo5 = 100;
      servo6 = 110;
      send(6, 0, servo4);
      send(5, 0, servo3);
      send(3, 0, servo1);
      send(4, 0, servo2);
      send(7, 0, servo5);
      send(8, 0, servo6);
      break;
    case 14:
      send(2, 0, 90);
      break;
    case 15:
      send(2, 0, 0);
      break;
    case 16:
      send(2, 15, 255);
      break;
    case 17:
      send(2, 0, 180);
      break;
    case 18:
      oldmode = mode;
      mode = 5;
      break;
    case 19:
      langid = 1;
      break;
    case 20:
      langid = 2;
      break;
    case 21:
      favmode = 1;
      break;
    case 22:
      favmode = 2;
      break;
    case 23:
      String[] config = {
        str(langid), str(favmode)
        };
        saveStrings("config.r2oa", config);
      mode = oldmode;
      break;
    case 24:
      if (favmode == 1) {
        mode = 1;
      } else if (favmode == 2) {
        mode = 3;
      } else {
        mode = 5;
      }
      break;
    case 25:
      if (favmode == 1) {
        mode = 2;
      } else if (favmode == 2) {
        mode = 4;
      } else {
        mode = 5;
      }
      break;
    }
  }
}

void send(int idc, int b2, int b1) {
  int[] data = { 
    idc, b2, b1
  };
  int checksum = 255 - ((83 + data[0] + data[1] + data[2]) & 255);
  byte[] out = { 
    byte(126), byte(0), byte(8), byte(1), byte(1), byte(80), byte(1), byte(0), byte(data[0]), byte(data[1]), byte(data[2]), byte(checksum)
    };
    println("IDC=" + data[0] + " | B2=" + data[1] + " | B1=" + data[2]);
  if (!debug) {
    XBee.write(out);
  }
}

void title(String title) {
  fill(0); // On définit la couleur sur noir
  textSize(40); // On modifie la police de caractère à 40px
  text(title, 110, 100); // On affiche un texte
  textSize(12); // On modifie la police de caractère à 12px
}

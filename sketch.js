let img;
function preload() {
  img = loadImage('images/home.png');
}
function setup() {
createCanvas(450,650);
  image(img, 0, 0);
}
package application;

public class Kart extends Sprite {
    private int lives;           
    private final double startX; 
    private final double startY; 
    private static final int STEP = 10; //distance move per key press

    public Kart(double x, double y, String imagePath) {
        super(x, y, imagePath);
        this.startX = x;
        this.startY = y;
        this.lives = 3; //total lives
    }

    //getter and setter for lives
    public int getLives() {
        return lives;
    }

    public void setLives(int lives) {
        this.lives = lives;
    }

    public void loseLife() {
        if (lives > 0) {
            lives--;
            resetPosition(); //reset kart position to its starting point
        }
    }

    public void resetPosition() {
        this.xPos = startX;
        this.yPos = startY;
    }

    //check if no more lives
    public boolean isGameOver() {
        return lives <= 0;
    }

    //movement methods
    public void moveUp() {
        if (yPos - height > 0) { 
            yPos -= STEP;
        }
    }

    public void moveDown() {
        if (yPos + height < Game.WINDOW_HEIGHT - 95) { 
            yPos += STEP;
        }
    }

    public void moveLeft() {
        if (xPos > 0) { 
            xPos -= STEP;
        }
    }

    public void moveRight() {
        xPos += STEP; //move right, when the kart reaches the right side, it will go back to the left side
    }

}

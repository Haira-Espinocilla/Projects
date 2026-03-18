package application;

import java.util.Random;

public class Pedestrian extends Sprite {
    private final Random random = new Random();

    public Pedestrian(double x, double y, String imagePath) {
        super(x, y, imagePath);
    }

    public void moveRandomly() {
        yPos += random.nextInt(15); // Move downward (increase yPos)
        
        if (yPos > Game.WINDOW_HEIGHT) {
            yPos = -height; 
            double minX = Game.WINDOW_WIDTH / 4.0; // 1/4 of the screen width
            double maxX = Game.WINDOW_WIDTH - width; // right edge-pedestrian width
            xPos = minX + random.nextDouble() * (maxX - minX); 
        }
    }
}

package application;

import javafx.scene.canvas.GraphicsContext;
import javafx.scene.image.Image;
import javafx.geometry.Rectangle2D;

public class Sprite {
    protected Image image;
    protected double xPos, yPos;
    protected double width, height;

    public Sprite(double xPos, double yPos, String imagePath) {
        this.xPos = xPos;
        this.yPos = yPos;
        this.loadImage(imagePath);
    }

    private void loadImage(String imagePath) {
        try {
            //scale the image during loading
            double desiredWidth = 200;  
            double desiredHeight = 200; 
            this.image = new Image(imagePath, desiredWidth, desiredHeight, false, true);

            //update width and height
            this.width = this.image.getWidth();
            this.height = this.image.getHeight();
        } catch (Exception e) {
            System.err.println("Error loading image: " + imagePath);
            e.printStackTrace();
        }
    }


    public void render(GraphicsContext gc) {
        gc.drawImage(this.image, this.xPos, this.yPos, this.width, this.height); // Specify width and height
    }


    public boolean intersects(Sprite other) {
        Rectangle2D thisBounds = new Rectangle2D(xPos, yPos, width, height);
        Rectangle2D otherBounds = new Rectangle2D(other.xPos, other.yPos, other.width, other.height);
        return thisBounds.intersects(otherBounds);
    }

    public void setX(double x) {
        this.xPos = x;
    }

    public void setY(double y) {
        this.yPos = y;
    }

    public double getX() {
        return xPos;
    }

    public double getY() {
        return yPos;
    }

    public double getWidth() {
        return width;
    }

    public double getHeight() {
        return height;
    }
    
    public void setWidth(double width) {
        this.width = width;
    }

    public void setHeight(double height) {
        this.height = height;
    }

}

package application;

import javafx.animation.KeyFrame;
import javafx.animation.KeyValue;
import javafx.animation.Timeline;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.util.Duration;

public class Sprite {
    private ImageView spriteView;
    private Image idleImage;
    private Image runImage;
    private Image jumpImage;
    private Image fallImage;
    private Image attackImage;
    private Image blockImage;
    private boolean isJumping = false;

    public Sprite(String character) {
        idleImage = new Image(character + "Idle.gif");
        runImage = new Image(character + "Running.gif");
        jumpImage = new Image(character + "Jump.gif");
        fallImage = new Image(character + "Fall.gif");
        attackImage = new Image(character + "Attack1.gif");
        blockImage = new Image(character + "Block.gif");
                
        spriteView = new ImageView(idleImage);
        spriteView.setFitWidth(300); 
        spriteView.setFitHeight(250); 
    }

    public ImageView getSpriteView() {
        return spriteView;
    }

    public void setAnimation(String action) {
        switch (action.toLowerCase()) {
            case "run":
                spriteView.setImage(runImage);
                break;
            case "jump":
                spriteView.setImage(jumpImage);
                break;
            case "fall":
                spriteView.setImage(fallImage);
                break;
            case "attack":
                spriteView.setImage(attackImage);
                break;
            case "block":
            	//spriteView.setImage(null);
            	spriteView.setImage(blockImage);
            	break;
            default:
                spriteView.setImage(idleImage);
                break;
        }
    }


    public boolean isJumping() {
        return isJumping;
    }

    public void startJump() {
        isJumping = true;
        setAnimation("jump");

        double initialY = spriteView.getLayoutY();
        double jumpHeight = 200; 
        double jumpDuration = 350; 

        //ascend
        Timeline ascend = new Timeline(
                new KeyFrame(Duration.millis(jumpDuration),
                        new KeyValue(spriteView.layoutYProperty(), initialY - jumpHeight))
        );

        //descend
        Timeline descend = new Timeline(
                new KeyFrame(Duration.millis(jumpDuration),
                        new KeyValue(spriteView.layoutYProperty(), initialY))
        );

        ascend.setOnFinished(event -> {
            setAnimation("fall");
            descend.play();
        });

        descend.setOnFinished(event -> {
            isJumping = false;
            setAnimation("idle");
        });

        ascend.play();
    }
   

    public void setJumping(boolean isJumping) {
        this.isJumping = isJumping;
    }

}
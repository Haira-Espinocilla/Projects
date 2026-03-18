package application;

import javafx.animation.AnimationTimer;
import javafx.geometry.Bounds;
import javafx.scene.Scene;
import javafx.scene.control.ProgressBar;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.input.KeyCode;
import javafx.scene.layout.Pane;
import javafx.scene.paint.Color;
import javafx.scene.text.Font;
import javafx.scene.text.Text;
import javafx.stage.Stage;

public class GameTimer extends AnimationTimer {
    private String player1;
    private String player2;
    private Scene gameScene;
    private Sprite player1Sprite;
    private Sprite player2Sprite;
    private ProgressBar player1HealthBar;
    private ProgressBar player2HealthBar;
    private Text player1HealthText;
    private Text player2HealthText;
    private Text stopwatchText;
    private Stage stage;
    private Image heroIcon;
    private ImageView progressView;

    private boolean player1MovingLeft = false;
    private boolean player1MovingRight = false;
    private boolean player2MovingLeft = false;
    private boolean player2MovingRight = false;
    private boolean player1Attacking = false;
    private boolean player2Attacking = false;
    private boolean player1Blocking = false;
    private boolean player2Blocking = false;

    private double player1Health = 100;
    private double player2Health = 100;
    
    private boolean player1HasHit = false;
    private boolean player2HasHit = false;

    private double elapsedTime = 0;
    // Stats for players
    private final int player1Attack;
    private final int player1Defense;
    private final int player2Attack;
    private final int player2Defense;

    public GameTimer(String player1, String player2, Stage stage) {
    	this.stage = stage;
        this.player1 = charColor(player1);
        this.player2 = charColor(player2);
        
        if (this.player1.equals("Red")) {
            player1Attack = 50;
            player1Defense = 20;
        } else if (this.player1.equals("Blue")) {
            player1Attack = 40;
            player1Defense = 25;
        } else {
            player1Attack = 30;
            player1Defense = 30;
        }

        if (this.player2.equals("Red")) {
            player2Attack = 50;
            player2Defense = 20;
        } else if (this.player2.equals("Blue")) {
            player2Attack = 40;
            player2Defense = 25;
        } else {
            player2Attack = 30;
            player2Defense = 30;
        }

        Pane pane = new Pane();
        this.gameScene = new Scene(pane, 1000, 650);

        Image bgImage = new Image("GameProperBG.png", 1000, 650, false, false);
        ImageView bgView = new ImageView(bgImage);
        pane.getChildren().add(bgView);
        
        // hero icons
        if(this.player1.equals("Blue") && this.player2.equals("Red")) {
        	 this.heroIcon = new Image("AquashardVsCrimson.png",1000,650,false,false);
        }else if(this.player1.equals("Blue") && this.player2.equals("Green")) {
        	 this.heroIcon = new Image("AquashardVsVerdant.png",1000,650,false,false);
        }else if(this.player1.equals("Red") && this.player2.equals("Blue")) {
        	 this.heroIcon = new Image("CrimsonVsAquashard.png",1000,650,false,false);
        }else if(this.player1.equals("Red") && this.player2.equals("Green")) {
        	 this.heroIcon = new Image("CrimsonVsVerdant.png",1000,650,false,false);
        }else if(this.player1.equals("Green") && this.player2.equals("Blue")) {
        	 this.heroIcon = new Image("VerdantVsAquashard.png",1000,650,false,false);
        }else if(this.player1.equals("Green") && this.player2.equals("Red")) {
        	 this.heroIcon = new Image("VerdantVsCrimson.png",1000,650,false,false);
        }
        this.progressView = new ImageView(heroIcon);
        // ----------

        player1Sprite = new Sprite(this.player1);
        player2Sprite = new Sprite(this.player2);

        // Initialize health bars
        player1HealthBar = new ProgressBar(1);
        player1HealthBar.setLayoutX(165);
        player1HealthBar.setLayoutY(71);
        player1HealthBar.setPrefHeight(40);
        player1HealthBar.setPrefWidth(300);

        player2HealthBar = new ProgressBar(1);
        player2HealthBar.setLayoutX(540);
        player2HealthBar.setLayoutY(60);
        player2HealthBar.setPrefHeight(40);
        player2HealthBar.setPrefWidth(300);

        // Initialize health text
        /*
          player1HealthText = new Text("Player 1");
        player1HealthText.setFont(Font.font(20));
        player1HealthText.setFill(Color.WHITE);
        //player1HealthText.setFont(Font.FontWeight(BOLD));
        player1HealthText.setLayoutX(50);
        player1HealthText.setLayoutY(25);

        player2HealthText = new Text("Player 2");
        player2HealthText.setFont(Font.font(20));
        player2HealthText.setFill(Color.WHITE);
        player2HealthText.setLayoutX(869);
        player2HealthText.setLayoutY(25);
         */
       
        
        stopwatchText = new Text("Time: 0");
        stopwatchText.setFont(Font.font(20));
        stopwatchText.setFill(Color.WHITE);
        stopwatchText.setLayoutX(450);
        stopwatchText.setLayoutY(25);
        
        // Initial positions
        player1Sprite.getSpriteView().setLayoutX(50);
        player1Sprite.getSpriteView().setLayoutY(350);
        player2Sprite.getSpriteView().setLayoutX(700);
        player2Sprite.getSpriteView().setLayoutY(350);

        // Add sprites and health bars to the pane
        pane.getChildren().addAll(
                player1Sprite.getSpriteView(), player2Sprite.getSpriteView(),
                player1HealthBar, player2HealthBar,progressView, 
                stopwatchText
        );

        gameScene.setOnKeyPressed(event -> handleKeyPressed(event.getCode()));
        gameScene.setOnKeyReleased(event -> handleKeyReleased(event.getCode()));
    }

    private String charColor(String characterName) {
        switch (characterName) {
            case "Crimson Edge": return "Red";
            case "Aquashard": return "Blue";
            case "Verdant Slash": return "Green";
            default: throw new IllegalArgumentException("Unknown: " + characterName);
        }
    }

    public void setStage(Stage stage) {
        stage.setScene(this.gameScene);
        stage.show();
        start();
    }

    @Override
    public void handle(long now) {
        double spriteWidth = player1Sprite.getSpriteView().getFitWidth();
        double sceneWidth = 1000;
        
        elapsedTime += 1.0/60.0;
        stopwatchText.setText("Time: " + String.format("%.1f", elapsedTime));

        // Player 1 movement and actions
        if (player1Blocking) {
            player1Sprite.setAnimation("block"); // Execute block animation
        } else if (player1Attacking) {
            player1Sprite.setAnimation("attack"); // Execute attack animation
        } else if (player1MovingLeft) {
            double newX = player1Sprite.getSpriteView().getLayoutX() - 5;
            if (newX >= 0) {
                player1Sprite.getSpriteView().setLayoutX(newX);
                player1Sprite.getSpriteView().setScaleX(-1); // Face left
                player1Sprite.setAnimation("run"); // Execute run animation
            }
        } else if (player1MovingRight) {
            double newX = player1Sprite.getSpriteView().getLayoutX() + 5;
            if (newX <= sceneWidth - spriteWidth) {
                player1Sprite.getSpriteView().setLayoutX(newX);
                player1Sprite.getSpriteView().setScaleX(1); // Face right
                player1Sprite.setAnimation("run"); // Execute run animation
            }
        } else if (!player1Sprite.isJumping()) {
            player1Sprite.setAnimation("idle"); // Default idle animation
        }

        // Player 2 movement and actions
        if (player2Blocking) {
            player2Sprite.setAnimation("block"); // Execute block animation
        } else if (player2Attacking) {
            player2Sprite.setAnimation("attack"); // Execute attack animation
        } else if (player2MovingLeft) {
            double newX = player2Sprite.getSpriteView().getLayoutX() - 5;
            if (newX >= 0) {
                player2Sprite.getSpriteView().setLayoutX(newX);
                player2Sprite.getSpriteView().setScaleX(-1); // Face left
                player2Sprite.setAnimation("run"); // Execute run animation
            }
        } else if (player2MovingRight) {
            double newX = player2Sprite.getSpriteView().getLayoutX() + 5;
            if (newX <= sceneWidth - spriteWidth) {
                player2Sprite.getSpriteView().setLayoutX(newX);
                player2Sprite.getSpriteView().setScaleX(1); // Face right
                player2Sprite.setAnimation("run"); // Execute run animation
            }
        } else if (!player2Sprite.isJumping()) {
            player2Sprite.setAnimation("idle"); // Default idle animation
        }

        // Calculate Bounds
        Bounds player1Bounds = player1Sprite.getSpriteView().getBoundsInParent();
        Bounds player2Bounds = player2Sprite.getSpriteView().getBoundsInParent();

        // Player 1 attacking logic
        if (player1Attacking && player1Bounds.intersects(player2Bounds) && !player1HasHit) {
            if (!player2Blocking) { // Only apply damage if not blocking
                double damage = Math.max(0, player1Attack - player2Defense);
                player2Health = Math.max(player2Health - damage, 0);
                updateHealthBars();
                System.out.println("Player 1 hit Player 2! Damage: " + damage + ", Player 2 Health: " + player2Health);
            } else {
                System.out.println("Player 1's attack was blocked by Player 2!");
            }
            player1HasHit = true;
        }

        // Player 2 attacking logic
        if (player2Attacking && player2Bounds.intersects(player1Bounds) && !player2HasHit) {
            if (!player1Blocking) { // Only apply damage if not blocking
                double damage = Math.max(0, player2Attack - player1Defense);
                player1Health = Math.max(player1Health - damage, 0);
                updateHealthBars();
                System.out.println("Player 2 hit Player 1! Damage: " + damage + ", Player 1 Health: " + player1Health);
            } else {
                System.out.println("Player 2's attack was blocked by Player 1!");
            }
            player2HasHit = true;
        }

        // Check for game over
        if (player1Health <= 0) {
            stop();
            VictoryScreen winner = new VictoryScreen(player2,2);
        	winner.setStage(this.stage);
        }
        if (player2Health <= 0) {

            stop();
            VictoryScreen winner = new VictoryScreen(player1,1);
        	winner.setStage(this.stage);
        }
    }



    private void updateHealthBars() {
        player1HealthBar.setProgress(player1Health / 100.0);
        player2HealthBar.setProgress(player2Health / 100.0);

        player1HealthText.setText("Player 1 HP: " + (int) player1Health);
        player2HealthText.setText("Player 2 HP: " + (int) player2Health);

        System.out.println("Updated Health Bars: Player 1 HP: " + player1Health + ", Player 2 HP: " + player2Health);
    }


    private void handleKeyPressed(KeyCode code) {
        // Player 1 controls
        if (code == KeyCode.A) player1MovingLeft = true;
        if (code == KeyCode.D) player1MovingRight = true;
        if (code == KeyCode.W && !player1Sprite.isJumping()) player1Sprite.startJump();
        if (code == KeyCode.F) player1Attacking = true;
        if (code == KeyCode.S) player1Blocking = true;

        // Player 2 controls
        if (code == KeyCode.J) player2MovingLeft = true;
        if (code == KeyCode.L) player2MovingRight = true;
        if (code == KeyCode.I && !player2Sprite.isJumping()) player2Sprite.startJump();
        if (code == KeyCode.P) player2Attacking = true;
        if (code == KeyCode.K) player2Blocking = true;
    }

    private void handleKeyReleased(KeyCode code) {
        // Player 1 controls
        if (code == KeyCode.A) player1MovingLeft = false;
        if (code == KeyCode.D) player1MovingRight = false;
        if (code == KeyCode.F) {
            player1Attacking = false;
            player1HasHit = false; // Reset hit state
        }
        if (code == KeyCode.S) player1Blocking = false;

        // Player 2 controls
        if (code == KeyCode.J) player2MovingLeft = false;
        if (code == KeyCode.L) player2MovingRight = false;
        if (code == KeyCode.P) {
            player2Attacking = false;
            player2HasHit = false; // Reset hit state
        }
        if (code == KeyCode.K) player2Blocking = false;
    }

}
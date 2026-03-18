package application;

import javafx.animation.AnimationTimer;
import javafx.animation.KeyFrame;
import javafx.animation.PauseTransition;
import javafx.animation.Timeline;
import javafx.scene.canvas.GraphicsContext;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.layout.StackPane;
import javafx.stage.Stage;
import javafx.util.Duration;

import java.util.Set;

public class GameTimer extends AnimationTimer {
    private final GraphicsContext gc;
    private final Kart myKart, yourKart;
    private final Pedestrian pedestrian1, pedestrian2;

    private final Stage stage;
    private final StackPane rootLayout;

    private final Image heartImage;
    private final Image gameOverPlayer1;
    private final Image gameOverPlayer2;
    private final Image gameOverDraw;
    private final Image backButtonImage;

    private boolean gameOver = false;

    private final Set<javafx.scene.input.KeyCode> activeKeys;
    private int countdownTime = 120; // 2 minutes
    private Timeline timer;

    public GameTimer(GraphicsContext gc, Kart myKart, Kart yourKart, Pedestrian pedestrian1, Pedestrian pedestrian2, Stage stage, Set<javafx.scene.input.KeyCode> activeKeys, StackPane rootLayout) {
        this.gc = gc;
        this.myKart = myKart;
        this.yourKart = yourKart;
        this.pedestrian1 = pedestrian1;
        this.pedestrian2 = pedestrian2;
        this.stage = stage;
        this.activeKeys = activeKeys;
        this.rootLayout = rootLayout;

        // Load images
        this.heartImage = new Image("heart.png", 30, 30, false, true);
        this.gameOverPlayer1 = new Image("player1.png", 1100, 800, false, true);
        this.gameOverPlayer2 = new Image("player2.png", 1100, 800, false, true);
        this.gameOverDraw = new Image("player1and2.png", 1100, 800, false, true);
        this.backButtonImage = new Image("backB.png", 500, 300, false, true);

        initializeTimer();
    }

    private void initializeTimer() {
        //countdown timer
        timer = new Timeline(new KeyFrame(Duration.seconds(1), e -> {
            if (countdownTime > 0) {
                countdownTime--;
            } else {
                gameOver = true;
                stop();
                pauseBeforeGameOver();
            }}));
        timer.setCycleCount(Timeline.INDEFINITE);
    }

    @Override
    public void start() {
        super.start();
        timer.play();
    }

    @Override
    public void handle(long now) {
        if (gameOver) {
            return; //game is over
        }

        gc.clearRect(0, 0, Game.WINDOW_WIDTH, Game.WINDOW_HEIGHT);

        //to process active keys
        activeKeys();

        //render game elements
        myKart.render(gc);
        yourKart.render(gc);
        pedestrian1.moveRandomly();
        pedestrian2.moveRandomly();
        pedestrian1.render(gc);
        pedestrian2.render(gc);

        //render lives and timer
        renderLives();
        renderTimer();

        //check collisions
        checkCollisions();
    }

    private void renderLives() {
        //render lives player 1
        for (int i = 0; i < myKart.getLives(); i++) {
            gc.drawImage(heartImage, 10 + (i * 40), 10);
        }

        //render lives player 2
        for (int i = 0; i < yourKart.getLives(); i++) {
            gc.drawImage(heartImage, Game.WINDOW_WIDTH - 40 - (i * 40), 10);
        }
    }

    private void renderTimer() {
        if (gameOver) {
            return;
        }

        int minutes = countdownTime / 60;
        int seconds = countdownTime % 60;

        String timeString = String.format("%02d:%02d", minutes, seconds);

        gc.setFill(javafx.scene.paint.Color.WHITE);
        gc.setFont(javafx.scene.text.Font.font("Verdana", 40));
        gc.fillText(timeString, (Game.WINDOW_WIDTH / 2) - 50, 50);
    }

    private void checkCollisions() {
        //kart collisions with pedestrians
        if (myKart.intersects(pedestrian1) || myKart.intersects(pedestrian2)) {
            myKart.loseLife();
            if (myKart.isGameOver()) {
                forceRender();
                stop();
                pauseBeforeGameOver();
                return;
            }
        }

        if (yourKart.intersects(pedestrian1) || yourKart.intersects(pedestrian2)) {
            yourKart.loseLife();
            if (yourKart.isGameOver()) {
                forceRender();
                stop();
                pauseBeforeGameOver();
                return;
            }
        }
    }

    private void forceRender() {
        //to make sure all hearts disappear if a player loses all its lives
        gc.clearRect(0, 0, Game.WINDOW_WIDTH, Game.WINDOW_HEIGHT);
        myKart.render(gc);
        yourKart.render(gc);
        pedestrian1.render(gc);
        pedestrian2.render(gc);
        renderLives();
    }

    private void pauseBeforeGameOver() {
        //to make it look cool: pause effect before displaying game over
        PauseTransition pause = new PauseTransition(Duration.millis(900));
        pause.setOnFinished(event -> showGameOverScreen());
        pause.play();
    }

    private void showGameOverScreen() {
        gameOver = true;

        stop(); //stop timer when game is over
        timer.stop();

        //to determine which game over png should it use
        Image gameOverImage;
        if (myKart.getLives() > yourKart.getLives()) {
            gameOverImage = gameOverPlayer1; //player 1 wins
        } else if (yourKart.getLives() > myKart.getLives()) {
            gameOverImage = gameOverPlayer2; //player 2 wins
        } else {
            gameOverImage = gameOverDraw; //both win
        }

        //game over image view
        ImageView gameOverImageView = new ImageView(gameOverImage);
        gameOverImageView.setTranslateY(35); 

        //clickable back png
        ImageView backButtonView = new ImageView(backButtonImage);
        backButtonView.setTranslateY(200); 
        backButtonView.setOnMouseClicked(e -> goToSplashScreen());

        //layer elements on top 
        rootLayout.getChildren().addAll(gameOverImageView, backButtonView);
    }

    private void goToSplashScreen() {
        SplashScreen splashScreen = new SplashScreen(stage);
        splashScreen.show();
    }

    private void activeKeys() {
        //all kart moves
        if (activeKeys.contains(javafx.scene.input.KeyCode.W)) myKart.moveUp();
        if (activeKeys.contains(javafx.scene.input.KeyCode.A)) myKart.moveLeft();
        if (activeKeys.contains(javafx.scene.input.KeyCode.S)) myKart.moveDown();
        if (activeKeys.contains(javafx.scene.input.KeyCode.D)) myKart.moveRight();

        if (activeKeys.contains(javafx.scene.input.KeyCode.UP)) yourKart.moveUp();
        if (activeKeys.contains(javafx.scene.input.KeyCode.LEFT)) yourKart.moveLeft();
        if (activeKeys.contains(javafx.scene.input.KeyCode.DOWN)) yourKart.moveDown();
        if (activeKeys.contains(javafx.scene.input.KeyCode.RIGHT)) yourKart.moveRight();
        
        handleKartWrapping(myKart);
        handleKartWrapping(yourKart);
    }
    
    private void handleKartWrapping(Kart kart) {
        //used when the kart exceeds beyond the right side of the screen
        if (kart.getX() > Game.WINDOW_WIDTH) {
            kart.setX(-kart.getWidth());
        }
        else if (kart.getX() + kart.getWidth() < 0) {
            kart.setX(Game.WINDOW_WIDTH);
        }
    }
    
    
}

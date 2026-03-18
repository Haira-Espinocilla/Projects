package application;

import javafx.scene.Scene;
import javafx.scene.canvas.Canvas;
import javafx.scene.canvas.GraphicsContext;
import javafx.scene.image.Image;
import javafx.scene.input.KeyCode;
import javafx.scene.layout.*;
import javafx.stage.Stage;

import java.util.HashSet;
import java.util.Set;

public class Game {
    private final Stage stage;
    private Scene gameScene;
    private StackPane root; 
    private Canvas canvas;

    public static final int WINDOW_WIDTH = 1500;
    public static final int WINDOW_HEIGHT = 800;

    private Kart myKart, yourKart;
    private Pedestrian pedestrian1, pedestrian2;

    private Image heartImage; 

    //to track currently pressed keys
    private final Set<KeyCode> activeKeys = new HashSet<>();

    public Game(Stage stage) {
        this.stage = stage;
        this.root = new StackPane(); //layering
        this.gameScene = new Scene(root, WINDOW_WIDTH, WINDOW_HEIGHT);
        this.canvas = new Canvas(WINDOW_WIDTH, WINDOW_HEIGHT);

        //bg image
        Image backgroundImage = new Image("gameBG.png");
        BackgroundImage bgImage = new BackgroundImage(backgroundImage, BackgroundRepeat.NO_REPEAT, BackgroundRepeat.NO_REPEAT, BackgroundPosition.CENTER, new BackgroundSize(BackgroundSize.AUTO, BackgroundSize.AUTO, false, false, true, true));
        root.setBackground(new Background(bgImage));

        //canvas for drawing game elements
        root.getChildren().add(canvas);

        //load heart image
        heartImage = new Image("heart.png", 50, 50, false, true);
    }

    public void start() {
        GraphicsContext gc = canvas.getGraphicsContext2D();
        
        
        //initialize karts
        myKart = new Kart(0, 100, "car1.png");
        myKart.setWidth(220);  
        myKart.setHeight(100); 

        yourKart = new Kart(0, 400, "car2.png");
        yourKart.setWidth(220);
        yourKart.setHeight(100);


        //initialize pedestrians
        pedestrian1 = new Pedestrian(500, Game.WINDOW_HEIGHT + 50, "girl1.png");
        pedestrian2 = new Pedestrian(700, Game.WINDOW_HEIGHT + 50, "girl2.png");

        //game timer
        GameTimer timer = new GameTimer(gc, myKart, yourKart, pedestrian1, pedestrian2, stage, activeKeys, root);
        timer.start();

        //key event handler
        gameScene.setOnKeyPressed(event -> activeKeys.add(event.getCode()));
        gameScene.setOnKeyReleased(event -> activeKeys.remove(event.getCode()));

        stage.setScene(gameScene);
        stage.show();
    }
}

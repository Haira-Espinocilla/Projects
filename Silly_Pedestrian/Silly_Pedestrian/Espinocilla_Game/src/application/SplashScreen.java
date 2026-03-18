package application;

import javafx.scene.Scene;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.layout.*;
import javafx.stage.Stage;

public class SplashScreen {
    private final Stage stage;

    public SplashScreen(Stage stage) {
        this.stage = stage;
    }

    public void show() {
        Pane layout = new Pane();
        layout.setPrefSize(1500, 800);

        //to load bg image in splash screen
        Image backgroundImage = new Image("titlepage.png");
        BackgroundImage bgImage = new BackgroundImage(backgroundImage, BackgroundRepeat.NO_REPEAT, BackgroundRepeat.NO_REPEAT, BackgroundPosition.CENTER,new BackgroundSize(BackgroundSize.AUTO, BackgroundSize.AUTO, false, false, true, true));
        layout.setBackground(new Background(bgImage));

        //for clickable pngs, manually adjust their positions
        
        //start button
        ImageView startPNG = createClickableImage("startB.png", e -> startGame());
        
        startPNG.setLayoutX(600); 
        startPNG.setLayoutY(300); 

        //instruction button
        ImageView instructionsPNG = createClickableImage("instructB.png", e -> showInstructions());
        instructionsPNG.setFitWidth(700); 
        instructionsPNG.setFitHeight(400); 
        instructionsPNG.setLayoutX(400); 
        instructionsPNG.setLayoutY(290); 

        //aboutDev button
        ImageView aboutPNG = createClickableImage("devB.png", e -> showAbout());
        aboutPNG.setFitWidth(1000); 
        aboutPNG.setFitHeight(500); 
        aboutPNG.setLayoutX(300); 
        aboutPNG.setLayoutY(330); 

        //exit button
        ImageView exitPNG = createClickableImage("exitB.png", e -> stage.close());
        exitPNG.setFitWidth(500); 
        exitPNG.setFitHeight(500);
        exitPNG.setLayoutX(500);
        exitPNG.setLayoutY(550);

        //add all ImageViews to the pane
        layout.getChildren().addAll(startPNG, instructionsPNG, aboutPNG, exitPNG);

        //create scene
        Scene scene = new Scene(layout, 1500, 800);
        stage.setTitle("Silly Pedestrian");
        stage.setScene(scene);
        stage.show();
    }

    private ImageView createClickableImage(String imagePath, javafx.event.EventHandler<javafx.scene.input.MouseEvent> onClick) {
        //load image
        Image image = new Image(imagePath);
        ImageView imageView = new ImageView(image);

        //to adjust size
        imageView.setFitWidth(300);
        imageView.setPreserveRatio(true);

        //click event handler
        imageView.setOnMouseClicked(onClick);

        //to make it cool: hover effect
        imageView.setOnMouseEntered(e -> imageView.setOpacity(0.8));
        imageView.setOnMouseExited(e -> imageView.setOpacity(1.0)); 

        return imageView;
    }

    private void startGame() {
        Game game = new Game(stage);
        game.start();
    }

    private void showInstructions() {
        //create new pane for instructions
        Pane instructionsLayout = new Pane();

        //bg image
        Image instructionsBackground = new Image("instructions.png");
        BackgroundImage instructionsBgImage = new BackgroundImage(instructionsBackground, BackgroundRepeat.NO_REPEAT, BackgroundRepeat.NO_REPEAT, BackgroundPosition.CENTER, new BackgroundSize(BackgroundSize.AUTO, BackgroundSize.AUTO, false, false, true, true));
        instructionsLayout.setBackground(new Background(instructionsBgImage));

        //clickable back png 
        ImageView backPNG = createClickableImage("backB.png", e -> show()); 
        backPNG.setLayoutX(1010); //adjust position
        backPNG.setLayoutY(600);

        instructionsLayout.getChildren().add(backPNG);

        //new scene for instructions
        Scene instructionsScene = new Scene(instructionsLayout, 1500, 800);
        stage.setScene(instructionsScene);
    }

    private void showAbout() {
        //create new pane for about the developer
        Pane aboutLayout = new Pane();

        //bg image
        Image aboutBackground = new Image("aboutDev.png");
        BackgroundImage aboutBgImage = new BackgroundImage(aboutBackground, BackgroundRepeat.NO_REPEAT, BackgroundRepeat.NO_REPEAT, BackgroundPosition.CENTER, new BackgroundSize(BackgroundSize.AUTO, BackgroundSize.AUTO, false, false, true, true));
        aboutLayout.setBackground(new Background(aboutBgImage));

        //clickable back png
        ImageView backPNG = createClickableImage("backB.png", e -> show());
        backPNG.setLayoutX(1010); // adjust position
        backPNG.setLayoutY(600);

        aboutLayout.getChildren().add(backPNG);

        //new scene for about developer
        Scene aboutScene = new Scene(aboutLayout, 1500, 800);
        stage.setScene(aboutScene);
    }
}

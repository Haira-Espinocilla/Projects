/***********************************************************
* //Exercise 8: GUI II
*
* @author Espinocilla, Haira Marie D.
* @created_date 11/19/2024
*
*
***********************************************************/


package main;

import application.SplashScreen;
import javafx.application.Application;
import javafx.stage.Stage;

public class Main extends Application {
    public static void main(String[] args) {
        launch(args);
    }

    @Override
    public void start(Stage stage) {
        SplashScreen splashScreen = new SplashScreen(stage);
        splashScreen.show();
    }
}
package application;

import javafx.scene.Scene;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.layout.Pane;
import javafx.stage.Stage;

public class VictoryScreen {
	private Scene scene;
	private Pane pane;
	private GameButton button;
	
	// for About Developers Screen
	private Image victoryScreen;
	private ImageView victoryScreenView; 
	
	VictoryScreen(String hero, int player){
		if(hero.equals("Blue") && player == 1) {
			this.victoryScreen = new Image("Player1VictoryAquashard.png",1000,650,false,false);
		}else if(hero.equals("Green") && player == 1) {
			this.victoryScreen = new Image("Player1VictoryVerdant.png",1000,650,false,false);
		}else if(hero.equals("Red")&& player == 1) {
			this.victoryScreen = new Image("Player1VictoryCrimson.png",1000,650,false,false);
		}else if(hero.equals("Blue") && player == 2 || hero.equals("Aquashard") && player == 2) {
			this.victoryScreen = new Image("Player2VictoryAquashard.png",1000,650,false,false);
		}else if(hero.equals("Green") && player == 2) {
			this.victoryScreen = new Image("Player2VictoryVerdant.png",1000,650,false,false);
		}else if(hero.equals("Red")&& player == 2) {
			this.victoryScreen = new Image("Player2VictoryCrimson.png",1000,650,false,false);
		}
		this.victoryScreenView= new ImageView(victoryScreen);
		this.pane = new Pane();
		this.scene = new Scene(this.pane,1000,650);
		this.button = new GameButton(4);
	};
	
	public void setStage(Stage stage) {
		this.pane.getChildren().add(victoryScreenView);
		this.button.getReturnButton(4, this.pane, stage, 25, 570);
		
		stage.setScene(scene);
		stage.show();
		
	}
}

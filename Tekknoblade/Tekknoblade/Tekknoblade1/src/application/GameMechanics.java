package application;

import javafx.scene.Scene;
import javafx.stage.Stage;
import javafx.scene.layout.Pane;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;

public class GameMechanics {
	private Scene scene;
	private Pane pane;
	
	// for About Developers Screen
	private Image mechScreen = new Image("GameMechanicsBG.png",1000,650, false, false);
	private ImageView mechScreenView = new ImageView(mechScreen);
	
	GameMechanics(){
		this.pane = new Pane();
		this.scene = new Scene(this.pane,1000,650);
	};
	
	public void setStage(Stage stage) {
		GameButton button = new GameButton(4);
		this.pane.getChildren().add(mechScreenView);
		button.getReturnButton(4, this.pane, stage, 25, 570);
		
		
		stage.setScene(scene);
		stage.show();
		
	}
}

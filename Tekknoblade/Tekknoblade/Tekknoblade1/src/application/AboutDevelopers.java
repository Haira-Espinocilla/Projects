package application;

import javafx.scene.Scene;
import javafx.stage.Stage;
import javafx.scene.layout.Pane;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;

public class AboutDevelopers {
	private Scene scene;
	private Pane pane;
	
	// for About Developers Screen
	private Image devScreen = new Image("AboutDevelopersScreen.png",1000,650, false, false);
	private ImageView devScreenView = new ImageView(devScreen);
	
	
	AboutDevelopers(){
		this.pane = new Pane();
		this.scene = new Scene(this.pane,1000,650);
	};
	
	public void setStage(Stage stage) {
		GameButton button = new GameButton(4);
		this.pane.getChildren().add(devScreenView);
		button.getReturnButton(4, this.pane, stage, 400, 490);
		
		
		stage.setScene(scene);
		stage.show();
		
	}
}

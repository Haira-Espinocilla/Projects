package application;

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.layout.Pane;
import javafx.scene.media.Media;
import javafx.scene.media.MediaPlayer;


public class MainMenu {
	private Scene menuScene;
	private final Image background = new Image("TekknobladeBG.gif", 1000, 650, false, false);
	private ImageView bgView = new ImageView(background);
	private static Pane pane;
	
	MainMenu(){ // constructor for the class
		pane = new Pane();
		this.menuScene = new Scene(pane, 1000, 650);
		music();
	}
	
	protected void music() {
		Media music = new Media(getClass().getResource("/TekknonladeBGMusic.mp3").toExternalForm());
		MediaPlayer player = new MediaPlayer(music);
		player.setCycleCount(MediaPlayer.INDEFINITE);
		player.play();
	}
	
	public void setStage(Stage stage) {
		
		music();
		
		// add bg to pane
		pane.getChildren().add(this.bgView);
		
		// start button 
		GameButton strt = new GameButton(1);
		strt.getReturnButton(1, pane, stage, 450, 450);
		
		// game mechanics button
		GameButton mech = new GameButton(2);
		mech.getReturnButton(2, pane, stage, 371, 500);
		
		// about developers button
		GameButton dev = new GameButton(3);
		dev.getReturnButton(3, pane, stage, 352, 550);
		
		stage.setScene(this.menuScene); // set the scene to passed stage
		stage.show(); // display stage
	}
}

package application;

import javafx.stage.Stage;
import javafx.scene.layout.Pane;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.event.EventHandler;
import javafx.scene.input.MouseEvent;

public class GameButton {
	
	private ImageView ButtonView;
	// id = 1 (start button)
	private Image startButton = new Image("StartUnclicked.png");
	// id = 2 (game mechanics)
	private Image mechButton = new Image("GameMechanicsUnclicked.png");
	// id = 3 (about developers)
	private Image devButton = new Image("AboutDevelopersUnclicked.png");
	// id = 4 (return button)
	private Image returnButton = new Image("ReturnButton.png",163,58,false,false);
	
	// for hover effect
	private Image hoverEffect = new Image("HoverButtonEffect.png",152,73,false,false);
	private ImageView hoverView;
	
	GameButton(int id){
		if(id == 1) {
			this.ButtonView = new ImageView(startButton);
		}else if(id == 2) {
			this.ButtonView = new ImageView(mechButton);
		}else if(id == 3) {
			this.ButtonView = new ImageView(devButton);
		}else if(id == 4) {
			this.ButtonView = new ImageView(returnButton);
		}
		this.hoverView  = new ImageView(hoverEffect);
	}
	
	public void getReturnButton(int id, Pane pane, Stage stage, int X, int Y) {
		if(id != 4) {
			pane.getChildren().add(this.hoverView);
			this.hoverView.setLayoutX(417);
			this.hoverView.setVisible(false);
		}
		
		
		this.ButtonView.setLayoutX(X);
		this.ButtonView.setLayoutY(Y);
		//pane.getChildren().add(this.ButtonView);
		  //adding hover effects
		  this.ButtonView.setOnMouseEntered(event -> {
			  
			  if(id == 1) {// start
				  this.hoverView.setLayoutY(427);  
			  }else if(id == 2) { // mechanism
				  this.hoverView.setLayoutY(479);  
			  }else if(id == 3) {
				  this.hoverView.setLayoutY(530);  
			  }
			  this.hoverView.setVisible(true);
			  this.ButtonView.setScaleX(1.1); //papalakihin si button
			  this.ButtonView.setScaleY(1.1);
			  this.ButtonView.setOpacity(0.8); //set yung opacity 
		  });

		  this.ButtonView.setOnMouseExited(event -> {
			  this.hoverView.setVisible(false);
			  this.ButtonView.setScaleX(1.0); //reset to orig size
			  this.ButtonView.setScaleY(1.0);
			  this.ButtonView.setOpacity(1.0); //reset yung full opacity
		  });

		if(id == 1) { // start button
			//newly added: start with player 1 character selection first
			this.ButtonView.setOnMouseClicked(new EventHandler<MouseEvent>() {

				@Override
				public void handle(MouseEvent event) {
					// TODO Auto-generated method stub
					CharacterSelection selection = new CharacterSelection(); 
					selection.showPlayer1Selection(stage); 
				}
				
			});
	        
		}else if(id == 2) { // game mechanics button
			// Create Mechanics instance and set stage
			this.ButtonView.setOnMouseClicked(new EventHandler<MouseEvent>() {

				@Override
				public void handle(MouseEvent event) {
					// TODO Auto-generated method stub
					GameMechanics mech = new GameMechanics();
					mech.setStage(stage);
				}
				
			});
		}else if(id == 3) { // about developers button
			this.ButtonView.setOnMouseClicked(new EventHandler<MouseEvent>() {
				@Override
				public void handle(MouseEvent event) {
					// TODO Auto-generated method stub
					AboutDevelopers dev = new AboutDevelopers();
					dev.setStage(stage);
				}
			});
			
		}else if(id == 4) { // return button
			this.ButtonView.setOnMouseClicked(new EventHandler<MouseEvent>() {
				public void handle(MouseEvent event) {
					MainMenu menu = new MainMenu();
					menu.setStage(stage);
				}
			});
			
		}
		pane.getChildren().add(this.ButtonView);
		
		
		
	}
}

package application;

import javafx.scene.Scene;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.layout.Pane;
import javafx.stage.Stage;

//kulang pa ng: character stats to be displayed

public class CharacterSelection {
private String player1Choice = null;
private String player2Choice = null;

public void showPlayer1Selection(Stage stage) {
  Pane pane = new Pane();
  Scene scene = new Scene(pane, 1000, 650);

  //background image
  Image bgImage = new Image("Player1CharacterSelectionBG.png", 1000, 650, false, false); //palitan nalang yung URL if ever
  ImageView bgView = new ImageView(bgImage);
  pane.getChildren().add(bgView);
  
//confirm button for player 1, pwedeng palitan nlang din with clickable confirm png button
  Image confirmImage = new Image("LockButton.png", 56, 24, false, false); // Replace with your PNG
  ImageView confirmButton = new ImageView(confirmImage);
  confirmButton.setLayoutX(-920);
  confirmButton.setLayoutY(-603);

  //adding hover effects
  confirmButton.setOnMouseEntered(event -> {
      confirmButton.setScaleX(1.1); //papalakihin si button
      confirmButton.setScaleY(1.1);
      confirmButton.setOpacity(0.8); //set yung opacity 
  });

  confirmButton.setOnMouseExited(event -> {
      confirmButton.setScaleX(1.0); //reset to orig size
      confirmButton.setScaleY(1.0);
      confirmButton.setOpacity(1.0); //reset yung full opacity
  });


  confirmButton.setOnMouseClicked(event -> {
      if (player1Choice != null) {
          showPlayer2Selection(stage); //proceed na kay player 2
      }
  });

  //adding confirm button sa pane
  pane.getChildren().add(confirmButton);
  
  
  // heroes and frames

  Image redImage = new Image("RedIdle.gif", 490, 380, false, false);
  Image blueImage = new Image("BlueIdle.gif", 585, 360, false, false);
  Image greenImage = new Image("GreenIdle.gif", 460, 260, false, false);
  Image redFrame = new Image("CrimsonEdgeFrameUnclicked.png",246, 483, false, false);
  Image blueFrame = new Image("AquashardFrameUnclicked.png",246, 483, false, false);
  Image greenFrame = new Image("VerdantSlashFrameUnclicked.png",246, 483, false, false);

  ImageView redView = new ImageView(redImage);
  redView.setLayoutX(-30);
  redView.setLayoutY(210);

  ImageView redFrameView = new ImageView(redFrame);
  redFrameView.setLayoutX(90);
  redFrameView.setLayoutY(100);
  
  ImageView blueView = new ImageView(blueImage);
  blueView.setLayoutX(210);
  blueView.setLayoutY(210);
  
  ImageView blueFrameView = new ImageView(blueFrame);
  blueFrameView.setLayoutX(380);
  blueFrameView.setLayoutY(100);

  ImageView greenView = new ImageView(greenImage);
  greenView.setLayoutX(560);
  greenView.setLayoutY(260);
  
  ImageView greenFrameView = new ImageView(greenFrame);
  greenFrameView.setLayoutX(670);
  greenFrameView.setLayoutY(100);
  
  pane.getChildren().add(blueFrameView);
  pane.getChildren().add(redFrameView);
  pane.getChildren().add(greenFrameView);
 
  // add hover Images
  Image redHover = new Image("CrimsonEdgeFrameHover.png",246,483, false, false);
  Image blueHover = new Image("AquashardFrameHover.png",246,483, false, false);
  Image greenHover = new Image("VerdantSlashFrameHover.png",246,483, false, false);
  
  // add character descriptions
  Image redDescription = new Image("CrimsonEdgeDescription.png",944,127,false,false);
  Image blueDescription = new Image("AquashardDescription.png",944,127,false,false);
  Image greenDescription = new Image("VerdantSlashDescription.png",944,127,false,false);
  
  ImageView redHoverView = new ImageView(redHover);
  redHoverView.setLayoutX(90);
  redHoverView.setLayoutY(100);
  pane.getChildren().add(redHoverView);
  redHoverView.setVisible(false);
  
  ImageView blueHoverView = new ImageView(blueHover);
  blueHoverView.setLayoutX(380);
  blueHoverView.setLayoutY(100);
  pane.getChildren().add(blueHoverView);
  blueHoverView.setVisible(false);
  
  ImageView greenHoverView = new ImageView(greenHover);
  greenHoverView.setLayoutX(670);
  greenHoverView.setLayoutY(100);
  pane.getChildren().add(greenHoverView);
  greenHoverView.setVisible(false);
  
  ImageView redDescView = new ImageView(redDescription);
  redDescView.setLayoutX(30);
  redDescView.setLayoutY(496);
  pane.getChildren().add(redDescView);
  redDescView.setVisible(false);
  
  ImageView blueDescView = new ImageView(blueDescription);
  blueDescView.setLayoutX(30);
  blueDescView.setLayoutY(496);
  pane.getChildren().add(blueDescView);
  blueDescView.setVisible(false);
  
  ImageView greenDescView = new ImageView(greenDescription);
  greenDescView.setLayoutX(30);
  greenDescView.setLayoutY(496);
  pane.getChildren().add(greenDescView);
  greenDescView.setVisible(false);
  
  //hovering for red hero
  redView.setOnMouseEntered(event -> {
	  redHoverView.setVisible(true);
	  redDescView.setVisible(true);
	  confirmButton.setLayoutX(920);
	  confirmButton.setLayoutY(603);
  });
  redView.setOnMouseExited(event -> {
	 redHoverView.setVisible(false);
	 redDescView.setVisible(false);
  });

  //hovering for blue hero
  blueView.setOnMouseEntered(event -> {
	  blueHoverView.setVisible(true);
	  blueDescView.setVisible(true);
	  confirmButton.setLayoutX(920);
	  confirmButton.setLayoutY(603);
  });
  blueView.setOnMouseExited(event -> {
	  blueHoverView.setVisible(false);
	  blueDescView.setVisible(false);
  });

  //hovering for green hero
  greenView.setOnMouseEntered(event -> {
	  greenHoverView.setVisible(true);
	  greenDescView.setVisible(true);
	  confirmButton.setLayoutX(920);
	  confirmButton.setLayoutY(603);
  });
  greenView.setOnMouseExited(event -> {
	  greenHoverView.setVisible(false);
	  greenDescView.setVisible(false);
  });

  //character selection for player 1
  
  // for selected icon 
  Image selectedIcon = new Image("SelectedIcon.png",93,87,false,false);
  ImageView selectedView = new ImageView(selectedIcon);
  selectedView.setLayoutX(-200);
  selectedView.setLayoutY(-200);
  pane.getChildren().add(selectedView);
  
  
  redView.setOnMouseClicked(event -> {
    player1Choice = "Crimson Edge";
   
    selectedView.setLayoutX(166);
    selectedView.setLayoutY(110);
  });

  blueView.setOnMouseClicked(event -> {
    player1Choice = "Aquashard";
    
    selectedView.setLayoutX(460);
    selectedView.setLayoutY(110);
  });

  greenView.setOnMouseClicked(event -> {
    player1Choice = "Verdant Slash";
    
    // for selected icon
    selectedView.setLayoutX(748);
    selectedView.setLayoutY(110);
  });
  
  pane.getChildren().addAll(redView, blueView, greenView);
  

  

  stage.setScene(scene);
  stage.show();
}

//player 2---------------------------------------------------------------------------------
public void showPlayer2Selection(Stage stage) {
	Pane pane = new Pane();
	  Scene scene = new Scene(pane, 1000, 650);

	  //background image
	  Image bgImage = new Image("Player2CharacterSelectionBG.png", 1000, 650, false, false); //palitan nalang yung URL if ever
	  ImageView bgView = new ImageView(bgImage);
	  pane.getChildren().add(bgView);
	  
	//confirm button for player 1, pwedeng palitan nlang din with clickable confirm png button
	  Image confirmImage = new Image("LockButton.png", 56, 24, false, false); // Replace with your PNG
	  ImageView confirmButton = new ImageView(confirmImage);
	  confirmButton.setLayoutX(-920);
	  confirmButton.setLayoutY(-603);

	  //adding hover effects
	  confirmButton.setOnMouseEntered(event -> {
	      confirmButton.setScaleX(1.1); //papalakihin si button
	      confirmButton.setScaleY(1.1);
	      confirmButton.setOpacity(0.8); //set yung opacity 
	  });

	  confirmButton.setOnMouseExited(event -> {
	      confirmButton.setScaleX(1.0); //reset to orig size
	      confirmButton.setScaleY(1.0);
	      confirmButton.setOpacity(1.0); //reset yung full opacity
	  });

  confirmButton.setOnMouseClicked(event -> {
    if (player2Choice != null) {
            GameTimer game = new GameTimer(player1Choice, player2Choice, stage); //proceed na sa game
            game.setStage(stage);
        }
  });
  
	/*
	 * confirmButton.setOnMouseClicked(event -> { if (player2Choice != null) {
	 * GameTimer game = new GameTimer(player1Choice, player2Choice);
	 * game.setStage(stage); } } );
	 */
  
//adding confirm button sa pane
  pane.getChildren().add(confirmButton);
  
  
  // heroes and frames

 Image redImage = new Image("RedIdle.gif", 490, 380, false, false);
 Image blueImage = new Image("BlueIdle.gif", 585, 360, false, false);
 Image greenImage = new Image("GreenIdle.gif", 460, 260, false, false);
 Image redFrame = new Image("CrimsonEdgeFrameUnclicked.png",246, 483, false, false);
 Image blueFrame = new Image("AquashardFrameUnclicked.png",246, 483, false, false);
 Image greenFrame = new Image("VerdantSlashFrameUnclicked.png",246, 483, false, false);

 ImageView redView = new ImageView(redImage);
 redView.setLayoutX(-30);
 redView.setLayoutY(210);

 ImageView redFrameView = new ImageView(redFrame);
 redFrameView.setLayoutX(90);
 redFrameView.setLayoutY(100);
 
 ImageView blueView = new ImageView(blueImage);
 blueView.setLayoutX(210);
 blueView.setLayoutY(210);
 
 ImageView blueFrameView = new ImageView(blueFrame);
 blueFrameView.setLayoutX(380);
 blueFrameView.setLayoutY(100);

 ImageView greenView = new ImageView(greenImage);
 greenView.setLayoutX(560);
 greenView.setLayoutY(260);
  
  ImageView greenFrameView = new ImageView(greenFrame);
  greenFrameView.setLayoutX(670);
  greenFrameView.setLayoutY(100);
  
  pane.getChildren().add(blueFrameView);
  pane.getChildren().add(redFrameView);
  pane.getChildren().add(greenFrameView);
 
  // add hover Images
  Image redHover = new Image("CrimsonEdgeFrameHover.png",246,483, false, false);
  Image blueHover = new Image("AquashardFrameHover.png",246,483, false, false);
  Image greenHover = new Image("VerdantSlashFrameHover.png",246,483, false, false);
  
  // add character descriptions
  Image redDescription = new Image("CrimsonEdgeDescription.png",944,127,false,false);
  Image blueDescription = new Image("AquashardDescription.png",944,127,false,false);
  Image greenDescription = new Image("VerdantSlashDescription.png",944,127,false,false);
  
  ImageView redHoverView = new ImageView(redHover);
  redHoverView.setLayoutX(90);
  redHoverView.setLayoutY(100);
  pane.getChildren().add(redHoverView);
  redHoverView.setVisible(false);
  
  ImageView blueHoverView = new ImageView(blueHover);
  blueHoverView.setLayoutX(380);
  blueHoverView.setLayoutY(100);
  pane.getChildren().add(blueHoverView);
  blueHoverView.setVisible(false);
  
  ImageView greenHoverView = new ImageView(greenHover);
  greenHoverView.setLayoutX(670);
  greenHoverView.setLayoutY(100);
  pane.getChildren().add(greenHoverView);
  greenHoverView.setVisible(false);
  
  ImageView redDescView = new ImageView(redDescription);
  redDescView.setLayoutX(30);
  redDescView.setLayoutY(496);
  pane.getChildren().add(redDescView);
  redDescView.setVisible(false);
  
  ImageView blueDescView = new ImageView(blueDescription);
  blueDescView.setLayoutX(30);
  blueDescView.setLayoutY(496);
  pane.getChildren().add(blueDescView);
  blueDescView.setVisible(false);
  
  ImageView greenDescView = new ImageView(greenDescription);
  greenDescView.setLayoutX(30);
  greenDescView.setLayoutY(496);
  pane.getChildren().add(greenDescView);
  greenDescView.setVisible(false);
  
  // for "hero selected" images
  Image redSelected = new Image("CrimsonAlreadySelected.png",944,127,false,false);
  ImageView redSelectedView = new ImageView(redSelected);
  redSelectedView.setLayoutX(30);
  redSelectedView.setLayoutY(496);
  pane.getChildren().add(redSelectedView);
  redSelectedView.setVisible(false);
  
  Image blueSelected = new Image("AquashardAlreadySelected.png",944,127,false,false);
  ImageView blueSelectedView = new ImageView(blueSelected);
  blueSelectedView.setLayoutX(30);
  blueSelectedView.setLayoutY(496);
  pane.getChildren().add(blueSelectedView);
  blueSelectedView.setVisible(false);
  
  Image greenSelected = new Image("VerdantAlreadySelected.png",944,127,false,false);
  ImageView greenSelectedView = new ImageView(greenSelected);
  greenSelectedView.setLayoutX(30);
  greenSelectedView.setLayoutY(496);
  pane.getChildren().add(greenSelectedView);
  greenSelectedView.setVisible(false);
  
  //hovering for red hero
  redView.setOnMouseEntered(event -> {
	  if ("Crimson Edge".equals(player1Choice)) {
		  redSelectedView.setVisible(true);
	  }else {
		  redDescView.setVisible(true);
	  }
	  redHoverView.setVisible(true);
	  
  });
  redView.setOnMouseExited(event -> {
	  if ("Crimson Edge".equals(player1Choice)) {
		  redSelectedView.setVisible(false);
	  }else {
		  redDescView.setVisible(false);
	  }
	 redHoverView.setVisible(false);
  });

  //hovering for blue hero
  blueView.setOnMouseEntered(event -> {
	  if ("Aquashard".equals(player1Choice)) {
		  blueSelectedView.setVisible(true);
	  }else {
		  blueDescView.setVisible(true);
	  }
	  blueHoverView.setVisible(true);
  });
  blueView.setOnMouseExited(event -> {
	  if ("Aquashard".equals(player1Choice)) {
		  blueSelectedView.setVisible(false);
	  }else {
		  blueDescView.setVisible(false);
	  }
	  blueHoverView.setVisible(false);
  });

  //hovering for green hero
  greenView.setOnMouseEntered(event -> {
	  if ("Verdant Slash".equals(player1Choice)) {
		  greenSelectedView.setVisible(true);
	  }else {
		  greenDescView.setVisible(true);
	  }
	  greenHoverView.setVisible(true);
  });
  greenView.setOnMouseExited(event -> {
	  if ("Verdant Slash".equals(player1Choice)) {
		  greenSelectedView.setVisible(false);
	  }else {
		  greenDescView.setVisible(false);
	  }
	  greenHoverView.setVisible(false);
  });

  //character selection for player 2
  
  // for selected icon 
  Image selectedIcon = new Image("SelectedIcon.png",93,87,false,false);
  ImageView selectedView = new ImageView(selectedIcon);
  selectedView.setLayoutX(-200);
  selectedView.setLayoutY(-200);
  pane.getChildren().add(selectedView);
  
  
  redView.setOnMouseClicked(event -> {
    player2Choice = "Crimson Edge";
   
    // for confirmation button
    confirmButton.setLayoutX(920);
	confirmButton.setLayoutY(603);
    
    // for selected icon
    selectedView.setLayoutX(166);
    selectedView.setLayoutY(110);
  });

  blueView.setOnMouseClicked(event -> {
    player2Choice = "Aquashard";
    
 // for confirmation button
    confirmButton.setLayoutX(920);
	confirmButton.setLayoutY(603);
    
    selectedView.setLayoutX(460);
    selectedView.setLayoutY(110);
  });

  greenView.setOnMouseClicked(event -> {
    player2Choice = "Verdant Slash";
    
 // for confirmation button
    confirmButton.setLayoutX(920);
	confirmButton.setLayoutY(603);
    
    // for selected icon
    selectedView.setLayoutX(748);
    selectedView.setLayoutY(110);
  });
  
  pane.getChildren().addAll(redView, blueView, greenView);
  
  //para hindi magkapareho si player 1 and 2 ng character
  redView.setOnMouseClicked(event -> {
      if (!"Crimson Edge".equals(player1Choice)) {
          player2Choice = "Crimson Edge";
          confirmButton.setLayoutX(920);
          confirmButton.setLayoutY(603);
          selectedView.setLayoutX(166);
          selectedView.setLayoutY(110);
      }
  });

  blueView.setOnMouseClicked(event -> {
      if (!"Aquashard".equals(player1Choice)) {
          player2Choice = "Aquashard";
          confirmButton.setLayoutX(920);
          confirmButton.setLayoutY(603);
          selectedView.setLayoutX(460);
          selectedView.setLayoutY(110);
      } 
  });

  greenView.setOnMouseClicked(event -> {
      if (!"Verdant Slash".equals(player1Choice)) {
          player2Choice = "Verdant Slash";
          confirmButton.setLayoutX(920);
          confirmButton.setLayoutY(603);
          selectedView.setLayoutX(748);
          selectedView.setLayoutY(110);
      } 
  });
  

  stage.setScene(scene);
  stage.show();
}


}
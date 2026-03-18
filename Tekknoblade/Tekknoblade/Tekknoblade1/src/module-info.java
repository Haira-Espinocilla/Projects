module Blackeye {
	requires javafx.controls;
	requires java.desktop;
	requires javafx.media;
	
	opens application to javafx.graphics, javafx.fxml;
}

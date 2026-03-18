module espinocilla07 {
    requires javafx.controls;
    requires javafx.graphics;

    opens application to javafx.graphics, javafx.fxml; 
    opens main to javafx.graphics, javafx.fxml;  
}

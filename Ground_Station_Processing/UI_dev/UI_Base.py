from PyQt6.QtWidgets import QApplication, QWidget, QPushButton, QLabel, QFrame
from PyQt6.QtCore import QTimer
import sys
 
# Function to be executed when the Terminate button is clicked
def Temp_Terminate():
    """
    Initializes the termination process.
    Toggles the state of termination and updates the UI accordingly.
    """
    global state_terminate

    if state_terminate == 0:
        state_terminate = 1
        # T.B: Update visuals of button
        terminate_button.setStyleSheet("background-color: #EB8686; border: 2px solid #E66868; color: black; font-family: Cristagrotesk; font-weight: bold;")
        terminate_button.setText("CANCEL TERMINATE")
        
        # IT.B: Update visuals of button
        Imm_terminate_button.setGeometry(loc_width, loc_height + (button_height + button_diff), button_width, button_height)
        Imm_terminate_button.show()
        
        # FP.B: Update button location
        flight_map_button.move(loc_width, loc_height + 2 * (button_height + button_diff))  # Move Flight Map Button down
        countdown_label.move(loc_width, loc_height + 3 * (button_height + button_diff))  # Move Countdown Label down
        
        # Update IT.B, C.F, & C.C
        start_countdown()
    else:
        state_terminate = 0
        # T.B: Update visuals of button
        terminate_button.setStyleSheet("background-color: #E66868; border: 2px solid #EB8686; color: black; font-family: Cristagrotesk; font-weight: bold;")
        terminate_button.setText("TERMINATE FLIGHT")
        
        # IT.B: Update visuals of button
        Imm_terminate_button.hide()
        
        # FP.B: Update button location
        flight_map_button.move(loc_width, loc_height + button_height + button_diff)  # Move Flight Map Button back to its original position
        countdown_label.move(loc_width, loc_height + 2 * (button_height + button_diff))  # Move Countdown Label back to its original position
        
        # Update IT.B, C.F, & C.C
        state_terminate = 0
        reset_countdown()
        
def Immediate_func():
    '''

    Termination function call goes here

    '''
    
    print("FLIGHT HAS BEEN TERMINATED")
    timer.stop()
    reset_countdown
    countdown_label.setText("FLIGHT TERMINATED")
    countdown_label.show()
    Post_Termination()

def Post_Termination():
    '''
    Description: Inorder to prevent loop holes where a user can send multimple terminate singnals,
                 all buttons associated with file termination must be rendered mute/inert. There
                 are currently only 2 functions that meet this criteria:
                    - "Imm_terminate_button"
                    - "terminate_button"
    '''
    # IT.B: Make null/inert
    Imm_terminate_button.setStyleSheet("background-color: #D3D3D3; border: 2px solid #63666A; color: black; font-family: Cristagrotesk;")
    Imm_terminate_button.setText("FLIGHT TERMINATED")
    Imm_terminate_button.clicked.disconnect()
    
    # T.B: Make null/inert
    terminate_button.setStyleSheet("background-color: #D3D3D3; border: 2px solid #63666A; color: black; font-family: Cristagrotesk;")
    terminate_button.setText("FLIGHT TERMINATED")
    terminate_button.clicked.disconnect()


    
'''
Function Type [_countdown]: Initiates the countdown timer and all related settings. It also sets up a global 
variable that may be accessed by other functions without needing to continuously pass the 
value back and forth. This is fine since only two functions are reviewing this variable, and 
we don't need to worry about any race conditions for such little data.
'''

def start_countdown():
    global countdown_time
    countdown_time = 20
    countdown_label.setText(f"Flight will terminate in \n \t {countdown_time} seconds")
    countdown_label.show()
    timer.start(1000)

def update_countdown():
    '''
    update_countdown: Updates the countdown timer, then Decrements the countdown time and updates the
    label, & Stops the timer when the countdown reaches zero.
    '''
    global countdown_time
    countdown_time -= 1
    if countdown_time <= 0:
        '''
        Termination function call goes here
        '''
        print("FLIGHT HAS BEEN TERMINATED")
        countdown_label.setText("FLIGHT TERMINATED")
        timer.stop()
        Post_Termination()
    else:
        countdown_label.setText(f"Flight will terminate in \n \t {countdown_time} seconds")

def reset_countdown():
    """
    Resets the termination process.
    Hides the countdown label and stops the timer.
    """
    countdown_label.hide()
    timer.stop()
def Readyness_Check():
    global Setti_Ready
    if Setti_Ready == 0:
        Setti_Ready = 1
        Sett_Diag_button.setStyleSheet("background-color: #81ecec; border: 3px solid #0984e3; color: black; font-family: Cristagrotesk; font-weight: bold;")
        Sett_Diag_button.setText("Hide")
        IRID_Diag_button.show()
        Aurd_Diag_button.show()
        Supp_box.show()

    else:
        Setti_Ready = 0
        Sett_Diag_button.setStyleSheet("background-color: #0984e3; border: 3px solid #81ecec; color: white; font-family: Cristagrotesk; font-weight: bold;")
        Sett_Diag_button.setText("Diagnostics\nSettings")
        IRID_Diag_button.hide()
        Aurd_Diag_button.hide()
        Supp_box.hide()

def audr_diag():
    
    print("other")
    
def IRID_diag():
    print("other")
    
'''  [Init]  '''
# Create the application
app = QApplication(sys.argv)
state_terminate = 0
countdown_time = 20
Setti_Ready = 0

# Check current computer environment
screen = app.primaryScreen()
size = screen.size()

# Create the main window
window = QWidget()
window.setWindowTitle("Simple PyQt6 App")
window.resize(size.width(), size.height())



'''  [Button Settings]  '''
# Button size
button_width_ratio = 0.075
button_height_ratio = 0.05
button_width = round(size.width() * button_width_ratio)
button_height = round(size.height() * button_height_ratio)

# Button location & standard values
button_diff = 25
loc_width = size.width() - button_width - button_diff
loc_height = button_diff



'''  [General Settings]  '''
# Background: Colored Box with Border
line_thick = 5
box_width = round(button_width+button_diff)
box_height = round(button_height*2)




'''_________________________________________________________________________________________________________________________________
    [Background Elements]
        - Color blocks
        - Outlines
        - Lights/color signals
'''


'''  [Full Background]  '''
Background_box = QFrame(window)
Background_box.setGeometry(0, 0, size.width(),size.height())
Background_box.setStyleSheet("background-color:  #202020;")  # Set the border color


'''____[Visual Controls Background]____'''
colored_box_frame = QFrame(window)
colored_box_frame.setGeometry(size.width() - (button_diff-line_thick)-box_width, line_thick, box_width + 10, size.width() - 20)
colored_box_frame.setStyleSheet("background-color: #2d3436; border: 5px solid #636e72 ")  # Set the border color
'''  [Visual Controls Background]  '''
colored_box_frame = QFrame(window)
colored_box_frame.setGeometry(size.width() - (button_diff-line_thick)-box_width, line_thick, box_width + 10, size.width() - 20)
colored_box_frame.setStyleSheet("background-color: #2d3436; border: 5px solid #636e72 ")  # Set the border color

'''____[TERMINATE Button Init]____'''
terminate_button = QPushButton("TERMINATE FLIGHT", window)
terminate_button.setGeometry(loc_width, loc_height, button_width, button_height)
terminate_button.setStyleSheet("background-color: #E66868; border: 2px solid #EB8686; color: black; font-family: Cristagrotesk; font-weight: bold;")
terminate_button.clicked.connect(Temp_Terminate)

'''T.B.I--SUB____[IMMEDIATE Button Init]____'''
Imm_terminate_button = QPushButton("TERMINATE NOW", window)
Imm_terminate_button.setGeometry(loc_width, loc_height + (button_height + button_diff), button_width, button_height)
Imm_terminate_button.setStyleSheet("background-color: red; color: white; border: 2px solid black; font-family: Cristagrotesk; font-weight: bold;")
Imm_terminate_button.hide()  # Keep it hidden initially
Imm_terminate_button.clicked.connect(Immediate_func)

'''T.B.I--SUB____[Countdown Settings]____'''
countdown_label = QLabel(window)
countdown_label.setGeometry(loc_width, loc_height + 2 * (button_height + button_diff), button_width, button_height)
countdown_label.setStyleSheet(" font-family: Cristagrotesk; font-weight: bold;") 
countdown_label.hide()

'''____[FLIGHT PATH Button Init]_____'''
flight_map_button = QPushButton("Flight Path", window)
flight_map_button.setGeometry(loc_width, loc_height + button_height + button_diff, button_width, button_height)
flight_map_button.setStyleSheet("background-color: blue; color: white; font-family: Cristagrotesk; font-weight: bold;")

'''____[READY CHECKS Button Init]____'''
Sett_Diag_button = QPushButton("Diagnostics\nSettings", window)
Sett_Diag_button.setGeometry(loc_width, loc_height + 4*(button_height + button_diff), button_width, button_height)
Sett_Diag_button.setStyleSheet("background-color: #0984e3; border: 3px solid #81ecec; color: white; font-family: Cristagrotesk; font-weight: bold;")
Sett_Diag_button.clicked.connect(Readyness_Check)

'''RC.B.I--SUB____[Audrino Diagnostics Button Init]____'''
Aurd_Diag_button = QPushButton("Audrino\nDiagnostics", window)
Aurd_Diag_button.setGeometry(loc_width, loc_height + 5*(button_height + button_diff), round(button_width*0.8), round(button_height*0.8))
Aurd_Diag_button.setStyleSheet("background-color: #74b9ff; border: 3px solid #0984e3; color: black; font-family: Cristagrotesk; font-weight: bold;")
Aurd_Diag_button.clicked.connect(audr_diag)
Aurd_Diag_button.hide()

'''RC.B.I--SUB____[Audrino Diagnostics Button Init]____'''
IRID_Diag_button = QPushButton("IRID\nDiagnostics", window)
IRID_Diag_button.setGeometry(loc_width, loc_height + 6*(button_height + button_diff), round(button_width*0.8), round(button_height*0.8))
IRID_Diag_button.setStyleSheet("background-color: #fab1a0; border: 3px solid #0984e3; color: black; font-family: Cristagrotesk; font-weight: bold;")
IRID_Diag_button.clicked.connect(IRID_diag)
IRID_Diag_button.hide()

'''RC.B.I--SUB____[Visual Aid Block Init]____'''
Supp_box = QFrame(window)
Supp_box.setGeometry(loc_width, loc_height + 4*(button_height + button_diff), round(button_width*0.05),round(3.72*button_height))
Supp_box.setStyleSheet("background-color:  #0984e3;")  # Set the border color
Supp_box.hide()

# Timer
timer = QTimer()
timer.timeout.connect(update_countdown)

# Show the window
window.show()

# Execute the application's main loop
sys.exit(app.exec())

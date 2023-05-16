# ElectricFieldLines
Visualization of electric field lines (no physical units used, but accurate in principle).

The red particles are protons and the blue ones are electrons. They are animated a bit to show how the field changes when they move. The field strength is emphasized with the color and thickness of the field lines. The direction of the field lines is not shown.

WARNING: This was a quick project of mine, so it isn't documented and pretty messy. Please do yourself a favour and don't look at the code unless you're prepared for... an adventure.

## Usage
This was written in [Processing](https://processing.org) which makes it easy to draw something to the screen. The code should just run by opening any file from the ElectricField folder in the Processing editor and pressing the play button. 

You can rotate the camera by holding the left mouse button and moving the mouse. If you leave the camera alone for a bit, it will rotate automatically. You can zoom using the mouse wheel. Pressing 'p' will pause or unpause the animation. When paused, you can use the right arrow key to skip forward a single frame. You can toggle the coordinate system by pressing 'c'.

You can change the number of field lines coming out of each particle at the top of ElectricField.pde with the numFieldLinesPerParticle variable.

## Cool images (these look way worse than in the actual program)
![frame6213](https://github.com/JulianBohne/ElectricFieldLines/assets/57051885/b8f27877-97b0-46ac-927e-fbe33cbc3c24)

Here's an older work in progress image:
![frame2675](https://github.com/JulianBohne/ElectricFieldLines/assets/57051885/cb3e14b7-a9ea-4397-b5e7-1000db2aef75)

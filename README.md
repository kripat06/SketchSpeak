### Intro
SketchSpeak was built with collaboration of a member of our community with cerebral palsy. I built the user interface, emoji converter, and worked on the machine learning model.

### Demo Video [External Link]
[![SketchSpeak Demo YouTube Video](https://img.youtube.com/vi/HyeBxo6yo9c/1.jpg)](https://youtu.be/HyeBxo6yo9c)

### Details
The model used in SketchSpeak was trained off of Google's Quick Draw! dataset, as well as our codesigner's drawings. The images are downscaled during training and runtime for faster detection speed. UIKit is used for the UI design, and the prediction code utilizes the ```drawingView``` view to extract images to make inferences on.

### Currently in Development
Team is working on using NLP to create sentences based on the word that is selected.

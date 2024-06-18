# Design of a Mass-Spring-Damper System Controller for Position Control Using a Neural Network
In this project, an attempt is made to control a single degree of freedom mass-spring-damper dynamic system, which was previously modeled using a neural network. The designed controller is also a neural network. All simulations are performed in the MATLAB/Simulink environment. The controller training is generally unsupervised, with neural network weights chosen randomly. However, for time efficiency, an On-Off controller was initially used, and this controller was trained using supervised learning. Subsequently, unsupervised learning began. As a result, the neural network successfully optimized the control of the system.
 ### The Dynamics of the system under study is as follows:
 

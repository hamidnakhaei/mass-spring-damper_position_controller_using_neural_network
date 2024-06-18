# Design of a Mass-Spring-Damper System Controller for Position Control Using a Neural Network
## You can find the full report uploaded in this repository
In this project, an attempt is made to control a single degree of freedom mass-spring-damper dynamic system, which was previously modeled using a neural network. The designed controller is also a neural network. All simulations are performed in the MATLAB/Simulink environment. The controller training is generally unsupervised, with neural network weights chosen randomly. However, for time efficiency, an On-Off controller was initially used, and this controller was trained using supervised learning. Subsequently, unsupervised learning began. As a result, the neural network successfully optimized the control of the system.
 ### The Dynamics of the system under study is as follows:
 Fig/1.png
 $$m\ddot{x}\left( t \right) + kx \left( t \right) + b \dot{x} \left( t \right) = F \left( t \right)$$

$$K = 24 \quad \frac{\mathrm{N}}{\mathrm{m}}; \quad \quad b = 8 \quad \frac{\mathrm{N.s}}{\mathrm{m}}; \quad \quad m = 25 \quad \mathrm{kg}; \quad \quad F = 120 \quad \mathrm{N} \nonumber$$

###  Neural Network Used for Modeling the Dynamic Behavior of the System
Fig/fig.3

The neural network is able to successfully be trained with a sawtooth wave input and be tested with a square wave input. In this paper, a neural network is used to control the system. The training of the neural network controller is unsupervised, meaning no specific and predetermined data exists as input and desired output for the network to learn from. However, for time-saving and to guide the unsupervised learning process, the neural network was initially trained with an On-Off controller in a supervised manner. Then, the unsupervised learning process started to achieve the ideal controller.

### Controller Neural Network and the Dynamic Model Neural Network
Fig/fig.4
The goal of this project is to train the controller neural network.
###  System and Controller Circuit Simulated in Simulink
Fig/fig.6
Figures 29 to 32 show the position, velocity, acceleration, and force of the system before and after unsupervised training.
Fig/fig.29
Fig/fig.30
Fig/fig.31
Fig/fig.32

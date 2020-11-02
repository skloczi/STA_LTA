# STA_LTA
STA/LTA algorithm for extracting transient and stationary part of the signal


Based on the synthetic signal (delta function)
Introduced transient: different amplitude deltas

For testing I chose 4 delta functions:
1. without any transient introduced (F1)
2. with simple transient (F2)
3. with more complex transient (F3)
4. with added noise (F4)

[F4 - function with transient and introduced noise]

Evaluation of the efficiency of the set up parameters based on:
  - percentage of transient detected
  - ture ture detection of transient
  - weighted average of two mentioned above parameters
  

Paramaters to be set:
- short term average STA
- long term average LTA
- threshold
- pre and post event time PEM

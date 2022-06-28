import matplotlib.pyplot as plt
import numpy as np

x = np.arange(0,4*np.pi,0.1)   # start,stop,step
y = 100*np.sin(x)

for i in y:
    print("y[%i] = %d", i, int(y[i]))

plt.plot(x,y)
plt.show()
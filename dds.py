import numpy as np
import matplotlib.pyplot as plt

sim_time = 64
time = np.linspace(0,1,sim_time)
dotNum = 64
amp = 32767
x = np.linspace(0,np.pi/2,dotNum)
sine = amp*np.sin(x)
cosine = amp*np.cos(x)
sin_out = np.empty([sim_time,1], dtype=np.int16)
cos_out = np.empty([sim_time,1], dtype=np.int16)

def gen_lut() :
    z = []
    i = 0

    f1 = open("sine_lut.txt", "a")
    f1.truncate(0)
    f2 = open("cosine_lut.txt", "a")
    f2.truncate(0)

    print("\n sine lut \n")
    for elem in sine:
        f1.write("%X \n" % int(elem))
        z.append(hex(int(elem)))
        i = i + 1

    print("\n cosine lut \n")
    for elem in cosine:
        f2.write("%X \n" % int(elem))
        z.append(hex(int(elem)))
        i = i + 1

    f1.close()
    f2.close()

def DDS(phase_st, phase_inc):
    phase_acc = phase_st
    n = 0
    state = 0

    for t in time:
        n = n + 1
        match state:
            case 0:
                phase_acc = phase_acc + phase_inc
                sin_out[n] = int(sine[phase_acc])
                cos_out[n] = int(cosine[phase_acc])
                if phase_acc == np.pi/2 :
                    state = 1
            case 1:
                phase_acc = phase_acc - phase_inc
                sin_out[n] = int(sine[phase_acc])
                cos_out[n] = int(cosine[phase_acc])
                if phase_acc == 0 :
                    state = 2
            case 2:
                phase_acc = phase_acc + phase_inc
                sin_out[n] = int(sine[phase_acc])
                cos_out[n] = int(cosine[phase_acc])
                if phase_acc == np.pi/2 :
                    state = 3
            case 3:
                phase_acc = phase_acc - phase_inc
                sin_out[n] = int(sine[phase_acc])
                cos_out[n] = int(cosine[phase_acc])
                if phase_acc == 0 :
                    state = 0


    # for t in time:
    #     if phase_acc + phase_inc < dotNum :
    #         phase_acc = phase_acc + phase_inc
    #         sin_out[n] = int(sine[phase_acc])
    #         cos_out[n] = int(cosine[phase_acc])
    #     else:
    #         phase_acc = dotNum - phase_acc
    #         sin_out[n] = int(sine[phase_acc])
    #         cos_out[n] = int(cosine[phase_acc])
    #     n = n + 1
    plt.plot(sin_out)
    plt.plot(cos_out)
    plt.show()

gen_lut()
DDS(0,np.pi/16)


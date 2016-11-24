import scipy.io as spio
def loadMat(filepath=[], filename = 1024):
    filepathname = filepath + filename
    print filepathname
    mat = spio.loadmat(filepathname)
    # flexorLengthThisGamma = mat['flexorLengthThisGamma'] # array
    # newTrialThisGamma = mat['newTrialThisGamma'] # array
    flexorLengthThisGamma = mat['flexorLengthThisGamma']
    GdArray = mat['GdArray']
    GsArray = mat['GsArray']
    cortical = mat['cortical']
    vel = mat['vel']
    #            pipeInData = gen_tri()

    # return [flexorLengthThisGamma, newTrialThisGamma, GdArray ,GsArray]
    return [flexorLengthThisGamma, GdArray ,GsArray, cortical, vel]

if __name__ == '__main__':

    [flexorLengthThisGamma, newTrialThisGamma, GdArray ,GsArray, cortical, vel] = loadMat(filepathname)
    print flexorLengthThisGamma, len(flexorLengthThisGamma)
    print newTrialThisGamma, len(newTrialThisGamma)
    print GdArray, len(GdArray)

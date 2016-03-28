import scipy.io as spio
def loadMat(filename = 1024):
    mat = spio.loadmat(filename)
    flexorLengthThisGamma = mat['flexorLengthThisGamma'] # array
    newTrialThisGamma = mat['newTrialThisGamma'] # array
    GdArray = mat['GdArray']
    GsArray = mat['GsArray']
    #            pipeInData = gen_tri()

    return [flexorLengthThisGamma, newTrialThisGamma, GdArray ,GsArray]

if __name__ == '__main__':

    [flexorLengthThisGamma, newTrialThisGamma, GdArray ,GsArray] = loadMat('C:\Users\wonjsohn\Dropbox\BBDL_data\slicedOutput\slicedTrials_1_0_0_1.mat')
    print flexorLengthThisGamma, len(flexorLengthThisGamma)
    print newTrialThisGamma, len(newTrialThisGamma)
    print GdArray, len(GdArray)
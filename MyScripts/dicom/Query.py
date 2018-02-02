"""
Query/Retrieve SCU AE example.

This demonstrates a simple application entity that support the Patient
Root Find and Move SOP Classes as SCU. In order to receive retrieved
datasets, this application entity must support the CT Image Storage
SOP Class as SCP as well. For this example to work, there must be an
SCP listening on the specified host and port.

For help on usage,
python qrscu.py -h
"""

import argparse
from netdicom.applicationentity import AE
from netdicom.SOPclass import *
from dicom.dataset import Dataset, FileDataset
from dicom.UID import ExplicitVRLittleEndian, ImplicitVRLittleEndian, \
    ExplicitVRBigEndian
import netdicom
# netdicom.debug(True)
import tempfile
import urllib
import os

import ImportDicomFiles
# parse commandline
parser = argparse.ArgumentParser(description='storage SCU example')
parser.add_argument('remotehost', default="192.168.195.3")
parser.add_argument('remoteport', type=int, default = 2350)
parser.add_argument('searchstring', default = "12491939")
parser.add_argument('-p', help='local server port', type=int, default=11112)
parser.add_argument('-aet', help='calling AE title', default='SmartIris')
parser.add_argument('-aec', help='called AE title', default='SC20')
parser.add_argument('-implicit', action='store_true',
                    help='negociate implicit transfer syntax only',
                    default=False)
parser.add_argument('-explicit', action='store_true',
                    help='negociate explicit transfer syntax only',
                    default=False)

args = parser.parse_args()

if args.implicit:
    ts = [ImplicitVRLittleEndian]
elif args.explicit:
    ts = [ExplicitVRLittleEndian]
else:
    ts = [
        ExplicitVRLittleEndian,
        ImplicitVRLittleEndian,
        ExplicitVRBigEndian
    ]

# call back


def OnAssociateResponse(association):
    print("Association response received")


def OnAssociateRequest(association):
    print("Association resquested")
    return True


def OnReceiveStore(SOPClass, DS):
    print("Received C-STORE", DS.PatientName)
    try:
        # do something with dataset. For instance, store it.
        file_meta = Dataset()
        file_meta.MediaStorageSOPClassUID = '1.2.840.10008.5.1.4.1.1.2'
        # !! Need valid UID here
        file_meta.MediaStorageSOPInstanceUID = "1.2.3"
        # !!! Need valid UIDs here
        file_meta.ImplementationClassUID = "1.2.3.4"
        filename = '%s/%s.dcm' % (tempfile.gettempdir(), DS.SOPInstanceUID)
        ds = FileDataset(filename, {},
                         file_meta=file_meta, preamble="\0" * 128)
        ds.update(DS)
        #ds.is_little_endian = True
        #ds.is_implicit_VR = True
        ds.save_as(filename)
        print("File %s written" % filename)
    except:
        pass
    # must return appropriate status
    return SOPClass.Success


# create application entity
MyAE = AE(args.aet, args.p, [PatientRootFindSOPClass,
                             PatientRootMoveSOPClass,
                             VerificationSOPClass], [StorageSOPClass], ts)
MyAE.OnAssociateResponse = OnAssociateResponse
MyAE.OnAssociateRequest = OnAssociateRequest
MyAE.OnReceiveStore = OnReceiveStore
MyAE.start()


# remote application entity
RemoteAE = dict(Address=args.remotehost, Port=args.remoteport, AET=args.aec)

# create association with remote AE
print("Request association")
assoc = MyAE.RequestAssociation(RemoteAE)


# perform a DICOM ECHO
print("DICOM Echo ... ")
st = assoc.VerificationSOPClass.SCU(1)
print('done with status "%s"' % st)

print("DICOM FindSCU ... ")
d = Dataset()
d.PatientsName = "*"
d.QueryRetrieveLevel = "IMAGE"
d.AccessionNumber = args.searchstring
st = assoc.PatientRootFindSOPClass.SCU(d, 1)
print('done with status "%s"' % st)

# print st.StudyInstanceUID
tempPatientID = ""
i = 0
for ss in st:
    try:
        if not os.path.isdir("./Dicom/%(ID)s" % {'ID':ss[1].PatientID}):
            {
                os.makedirs("./Dicom/%(ID)s" % {'ID':ss[1].PatientID})    

            }
        if not os.path.isdir("./Dicom/%(ID)s/%(AccNo)s" % {'ID':ss[1].PatientID, 'AccNo':ss[1].AccessionNumber}):
            {
                os.makedirs("./Dicom/%(ID)s/%(AccNo)s" % {'ID':ss[1].PatientID, 'AccNo':ss[1].AccessionNumber})
            } 

        # print ss
        tempPatientID = ss[1].PatientID
        # print ss[1].StudyInstanceUID
        string = "http://192.168.220.1:9190/dcm4jboss-wado/?requestType=WADO&contentType=application/dicom&studyUID="+ss[1].StudyInstanceUID+"&seriesUID="+ss[1].SeriesInstanceUID + "&objectUID=" + ss[1].SOPInstanceUID
        # testfile = urllib.URLopener()
        urllib.urlretrieve(string, "./Dicom/%(ID)s/%(AccNo)s/%(AccNo)s-%(no)d.dcm" % {'ID':ss[1].PatientID, 'AccNo':ss[1].AccessionNumber, 'no':i})
    except AttributeError:
        pass
    i += 1

# ImportDicomFiles.FindFiles("./Dicom/%(ID)s" % {'ID':tempPatientID})



print("Release association")
assoc.Release(0)

# done
MyAE.Quit()
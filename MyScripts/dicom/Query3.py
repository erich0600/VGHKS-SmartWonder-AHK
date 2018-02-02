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
from pynetdicom3 import AE
from pynetdicom3 import QueryRetrieveSOPClassList
from pydicom.dataset import Dataset
from dicom.UID import ExplicitVRLittleEndian, ImplicitVRLittleEndian, \
    ExplicitVRBigEndian
# import netdicom
import pynetdicom3
# netdicom.debug(True)
import tempfile
import urllib
import urllib.request
import os

import ImportDicomFiles
# parse commandline
parser = argparse.ArgumentParser(description='storage SCU example')
# parser.add_argument('remotehost', default="192.168.195.3")
# parser.add_argument('remoteport', type=int, default = 2350)
parser.add_argument('searchstring', default = "")
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



ae = AE(ae_title='SmartIris', port=11112,scu_sop_class=QueryRetrieveSOPClassList)

# Try and associate with the peer AE
#   Returns the Association thread
print('Requesting Association with the peer')
assoc = ae.associate("192.168.220.1", 4568, ae_title='SC20')
tempPatientID = ""
i = 0
if assoc.is_established:
    print('Association accepted by the peer')

    # Creat a new DICOM dataset with the attributes to match against
    #   In this case match any patient's name at the PATIENT query
    #   level. See PS3.4 Annex C.6 for the complete list of possible
    #   attributes and query levels.
    dataset = Dataset()
    dataset.PatientName = '*'
    dataset.QueryRetrieveLevel = "IMAGE"
    dataset.AccessionNumber = args.searchstring

    # Send a DIMSE C-FIND request to the peer
    #   query_model is the Query/Retrieve Information Model to use
    #   and is one of 'W', 'P', 'S', 'O'
    #       'W' - Modality Worklist (1.2.840.10008.5.1.4.31)
    #       'P' - Patient Root (1.2.840.10008.5.1.4.1.2.1.1)
    #       'S' - Study Root (1.2.840.10008.5.1.4.1.2.2.1)
    #       'O' - Patient/Study Only (1.2.840.10008.5.1.4.1.2.3.1)
    responses = assoc.send_c_find(dataset, query_model='P')
    

    for (status, dataset) in responses:
        
        # While status is pending we should get the matching datasets
        if status == 'Pending':
            print(dataset)
        elif status == 'Success':
            print('C-FIND finished, releasing the association')
        elif status == 'Cancel':
            print('C-FIND cancelled, releasing the association')
        elif status == 'Failure':
            print('C-FIND failed, releasing the association')
 
        try:

            if not os.path.isdir("./Dicom/%(ID)s" % {'ID':dataset.PatientID}):
                {
                    os.makedirs("./Dicom/%(ID)s" % {'ID':dataset.PatientID})    

                }
            if not os.path.isdir("./Dicom/%(ID)s/%(AccNo)s" % {'ID':dataset.PatientID, 'AccNo':dataset.AccessionNumber}):
                {
                    os.makedirs("./Dicom/%(ID)s/%(AccNo)s" % {'ID':dataset.PatientID, 'AccNo':dataset.AccessionNumber})
                } 

            # print ss
            tempPatientID = dataset.PatientID
            # print dataset.StudyInstanceUID
            string = "http://192.168.220.1:9190/dcm4jboss-wado/?requestType=WADO&contentType=application/dicom&studyUID="+dataset.StudyInstanceUID+"&seriesUID="+dataset.SeriesInstanceUID + "&objectUID=" + dataset.SOPInstanceUID
            # testfile = urllib.URLopener()            
            # print(string)
            with urllib.request.urlopen(string) as response, open("./Dicom/%(ID)s/%(AccNo)s/%(AccNo)s-%(no)d.dcm" % {'ID':dataset.PatientID, 'AccNo':dataset.AccessionNumber, 'no':i}, 'wb+') as out_file:
                data = response.read() # a `bytes` object
                out_file.write(data)
            # urllib.request.urlretrieve(string, "./Dicom/%(ID)s/%(AccNo)s/%(AccNo)s-%(no)d.dcm" % {'ID':dataset.PatientID, 'AccNo':dataset.AccessionNumber, 'no':i})
        except AttributeError:
            pass
        i += 1


# ImportDicomFiles.FindFiles(".\Dicom\%(ID)s" % {'ID':tempPatientID})

print("Release association")
assoc.release()
# done
# MyAE.Quit()
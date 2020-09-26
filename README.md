# EllipsoidVolume is a OsiriX ROI plugin.

The aim of this small plugin is to speedup the radiologist routine when measuring organs like uterus, prostate, bladder etc, automaticaly calculating it's volume.

## Functional Requirements

Application must:
- allow user to create three ROIs (Anteroposterior diameter; Longitudinal diameter; Transverse diameter), automatically setting its name and color.
- show each diameter measurement updated in real time.
- calculate the volume based on:
    * prolate ellipsoid volume formula;
    * cavalieri method volume estimation;
- allow user to copy results to the pasteboard.


## Help Needed

This is my first code. I work as a radiologist and this small project is my first exercise learning Objective-C. There are several parts of this implementation that needs criticisms. I would be glad to receive some feedback because I have no contact with other developers other than OsiriX-Dev malling list.

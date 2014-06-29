Dot52 is a OsiriX ROI plugin.

The aim of this small plugin is to speedup the radiologist routine when measuring organs like uterus, prostate, bladder etc.

#Functional Requirements

Application must:
- allow user to create three ROIs (Anteroposterior diameter; Longitudinal diameter; Transverse diameter), automatically setting its name and color.
- show each diameter measurement updated in real time.
- calculate the volume based on:
    * prolate ellipsoid volume formula;
    * cavalieri method volume estimation;
- allow user to copy results to the pasteboard.


#Development Context

This is my first code. I work as a radiologist and this small project is my first exercise learning Objective-C. There are several parts of this implementation that needs criticisms. I would be glad to receive some feedback because I have no contact with other developers other than OsiriX-Dev malling list.

#My Current Challenges

- I need to understand who is responsible to release this plugin when its window is closed.
- Implement a way to allow user to configure a custom text (containing the measurements and volume) to be copied. I’m thinking about a NSTokenField that hold free text and tokens that represents AP x LON x TRV diameters and VOL.
- Implement a way to allow user to persist this this custom text setting. I’m thinking about using Core Data to write a plist file.

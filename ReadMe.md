2D Truss Analysis script for MATlab
===================================

This is a rough draft of a 2D truss analysis script.  

To Install: Download the .zip of the entire folder, and extract to a computer that has matlab installed.

To run: make sure your current directory is set to the loaction of the file _TrussGui.m_ and in the command prompt run:

       TrussGui

A pop up will ask you for the dimensions of your truss, in order to create the grid that will be used.

1) Add Members
	Draw the truss by clicking on the "Add Members" button.  Each member can be drawn by clicking two points on the grid.  Note: The total number of members must be equal to 1/2 the number of joints minus 3. Failure to comply will result in an instable or indeterminate truss, and will result in errors.
<<<<<<< HEAD
Retrace a member to delete it.
=======

Retrace a member to delete it.

>>>>>>> origin/master
When finished adding all members, click the "return" key.

2) Add Supports
	Click the "Add Supports" button, and the script will ask you first to choose the loaction of the pin support and next to determine the location of the roller support.  Currently, the roller support will only provide a vertical reaction.

3) Add Loads
	Add loads to the truss by clicking on the "Add Loads" button.  A popup will ask for the x and y component of the force applied to that joint.  

To edit a load, click on the joint again.

When finished adding all loads, click the "return" key.

4) Analyze
	Click "Analyze" to compute the loads in each member. Members in Tension will appear blue, and have positive values, members in compression will appear red and have negative values. Zero-force members will be black. 

5) Iterate - at any time you can change your confiurguation by clicking the approprate button.




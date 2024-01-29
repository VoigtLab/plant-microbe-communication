// Root fluorescent mean pixel intensity (MPI)
// threshold image to identify roots
// create mask
// quantify MPI of original image
// used to remove roi from prior runs
// will trigger an error if there is not an ROI in the manager before running (can add arbitrary roi to fix)
roiManager("Deselect");
roiManager("Delete");

// assign unique image id to each open image
setBatchMode(true);
imgArray = newArray(nImages);
for (i=0; i<nImages; i++) {
  selectImage(i+1);
  imgArray[i] = getImageID();
}
Array.print(imgArray);
prevNumResults = nResults;

// threshold, mask, and measure
for (i=0; i< imgArray.length; i++) {
  selectImage(imgArray[i]);
  filename = getTitle();
  run("Duplicate...", " ");
  run("Gaussian Blur...", "sigma=2");
  setAutoThreshold("Otsu dark");
  getThreshold(lower,upper);
  setThreshold(lower,upper);
  run("Convert to Mask");
  run("Create Selection");
  roiManager("Add");
  roiManager("Select", i);
  roiManager("Rename", filename);
  selectImage(imgArray[i]);
  roiManager("Select", i);
  run("Measure");
  setResult("File", prevNumResults+i, filename);
}
String.copyResults();

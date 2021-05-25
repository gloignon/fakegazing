# fakegazing
Simulated eye tracking recording to test automated analysis methods

We simulated data mimicking the format and some features of a recording produced by the Tobii Pro Glasses 2 mobile eye tracker. The simulated subjective video was produced with PowerPoint software then edited with Gimp. It consists of 22 slides grouped into eight disturbing events (e.g. sensor hidden by hand). The slides are shown for one second each, forming a video with a total duration of 22 seconds. The visual stimulus appearing in the video imitates an item from a reading comprehension test (i.e. item stem, question, choices).

![image](https://user-images.githubusercontent.com/12416756/119512100-04717380-bd41-11eb-8542-69a81a8bb3ff.png)

The video frame rate is 25 frames per second and the format is 1920 by 1080 pixels, which reproduces the specifications of the Tobii Pro 2 camera. The spherical distortion introduced by the camera lens was also emulated; we obtained by trial and error the parameters that minimized the spherical distortion of the camera images, and then applied the inverse transformation to the simulation images. The result mimics the deformation imposed by the Tobii Pro Glasses 2 lens.

The eye-tracking data associated with this video mimics a participant scanning two points in the visual stimulus: the middle of the letter "a" that begins the third line and the point following the letter C in the response choices. The recording simulates a pose gaze alternating between these two targets (500 ms per target), testing Mobile Gaze Mapping (see https://github.com/jeffmacinnes/mobileGazeMapping ) for coordinates located at the periphery and toward the center of the image. Due to the animations, the exact location of the targets varies between slides and was manually annotated. In the reference image coordinate system, these points should always correspond to positions (37, 157) and (511, 289).

Again, to mimic the Tobii Pro Glasses 2 device, the simulated oculometric recordings were clocked at 50 Hz while the video is clocked at 25 Hz. Each video frame is therefore associated with two data points, for a total of 1100 observations. The structure of the simulated oculometric recordings reproduces the format required by Mobile Gaze Mapping : a data point corresponds to a line containing a timestamp (in milliseconds elapsed since the beginning of the recording), the number of the corresponding video frame, and the Cartesian coordinates indicating the position of the gaze in the video.


clear;
clc;



v.path = '../data/MyDsets/Videos/';
v.fname = 'PNRtopWalkthrough1';
v.format = '.mp4';

t.path = '../data/MyDsets/';

tic
vidToImgFolder(v, t);
toc
